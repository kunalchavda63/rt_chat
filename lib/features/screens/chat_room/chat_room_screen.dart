import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/features/onboarding/auth_sevice/suth_service.dart';
import 'package:rt_chat/features/screens/chat/chat_service.dart';
import 'package:rt_chat/features/screens/provider/provider.dart';

import '../../../core/models/src/user_model/user_model.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String receiverEmail;
  final String receiverId;
  final String displayName;
   ChatRoomScreen({
    super.key,
    required this.receiverEmail,
    required this.receiverId, required this.displayName,
  });

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();
  final ScrollController _scrollController = ScrollController();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverId,
        _messageController.text.trim(),
      );
      _messageController.clear();

      // Scroll to bottom
      Future.delayed(Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0, // since reverse: true, 0 is bottom
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomWidgets.customAppBar(
        leading: CustomWidgets.customCircleBackButton().padLeft(25.r),
        title: Row(
          children: [
            CustomWidgets.customCircleIcon(
              iconSize: 25.r,
              iconData: Icons.person_outline,
              iconColor: AppColors.hex2824,
            ).padRight(20.r),
            CustomWidgets.customText(
                data:widget.displayName,style: BaseStyle.s17w400.c(AppColors.hex2824)),
            Spacer(),
            CustomWidgets.customPopUpMenuBtm(
              borderRadius: BorderRadius.circular(200),
              boxColor: AppColors.hex2824.withAlpha(100),
              items: [
                'Mute Notification',
                'Group Info'
              ],
              onSelected: (v){},
              icon: Icon(Icons.drag_indicator_rounded,color: AppColors.hex2824)
            )
          ],
        )
      ),
      body: _buildMessageList(),
      bottomNavigationBar: CustomWidgets.customContainer(
        h: 60.r,
        color: AppColors.transparent,
        child: Row(
          children: [
            Expanded(
              child: CustomWidgets.customTextField(
                controller:_messageController,
                hintText: 'Type a Message',

                style: BaseStyle.s17w400.line(1),
                hintStyle: BaseStyle.s17w400.line(1),
                padding: EdgeInsets.symmetric(horizontal: 10.r),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r),borderSide: BorderSide(color: AppColors.hex2824,width:1)),

              ).padH(10.r),
            ),
            CustomWidgets.customCircleIcon(
              onTap: (){
                final user = UserModel(
                  uid: widget.receiverId,
                  email: widget.receiverEmail,
                  displayName: widget.displayName, password: '',
                );

                sendMessage();
                ref.read(recentUsersProvider.notifier).addOrMoveToTop(user);
              },
              h: 35.r,
              w: 35.r,
              bgColor: AppColors.hex2824,
              iconColor: AppColors.hexEeeb,
              iconData: Icons.send
            ).padRight(20.r)
          ],
        )
      ).padBottom(MediaQuery.of(context).viewPadding.bottom+MediaQuery.of(context).viewInsets.bottom+30.r),
    );
  }

  Widget _buildMessageList(){
    final sendId = _authService.currentUser?.uid;

    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverId, sendId),
        builder:(context,snapshot){
          if(snapshot.hasError){
            return const Text('Error');
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator();
          }
          return ListView(

            children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;


    final currentUserId = _authService.currentUser?.uid;
    final isMe = data['senderEmail'] == currentUserId;

    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.r, vertical: 5.r),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isMe ? AppColors.hex2824 : AppColors.hex2824.withAlpha(50),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          data['message'] ?? '',
          style: BaseStyle.s17w400.c(isMe?AppColors.hexEeeb:AppColors.hex2824),
        ),
      ),
    );
  }
}

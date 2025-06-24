import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rt_chat/core/app_ui/app_ui.dart';
import 'package:rt_chat/core/utilities/utils.dart';
import 'package:rt_chat/features/onboarding/auth_sevice/suth_service.dart';
import 'package:rt_chat/features/screens/chat/chat_service.dart';
import 'package:rt_chat/features/screens/provider/provider.dart';

import '../../../core/models/src/user_model/user_model.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String receiverEmail;
  final String receiverId;
  final String displayName;
   const ChatRoomScreen({
    super.key,
    required this.receiverEmail,
    required this.receiverId,
     required this.displayName,
  });

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  late Size size;
  late ThemeData theme;

  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();
  final ScrollController _scrollController = ScrollController();


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    theme = Theme.of(context);
    setStatusBarLightStyle();
  }


  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        ref: ref,
        receiver:UserModel(
            email: widget.receiverEmail,
            password: '',
            uid: widget.receiverId,

        ),
        message: _messageController.text.trim(),
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

      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,

      appBar: CustomWidgets.customAppBar(
        bgColor: theme.scaffoldBackgroundColor,
        bottomOpacity: 0,

        scrollUnderElevation: 0,
        leading: CustomWidgets.customCircleBackButton(
          color: theme.primaryColor
        ).padLeft(25.r),
        title: Row(
          children: [
            CustomWidgets.customCircleIcon(
              iconSize: 20.r,
              bgColor: theme.focusColor,
              border: Border.all(color: theme.primaryColor),
              iconData: Icons.person_outline,
              iconColor: theme.primaryColor,
            ).padRight(20.r),
            CustomWidgets.customText(
                data:widget.displayName,style: BaseStyle.s17w400.c(theme.primaryColor)),
            Spacer(),
            CustomWidgets.customPopUpMenuBtm(
              borderRadius: BorderRadius.circular(200),
              boxColor: theme.scaffoldBackgroundColor.withAlpha(100),
              items: [
                AppStrings.newGroup,
                AppStrings.newGroup
              ],
              onSelected: (v){},
              icon: Icon(Icons.drag_indicator_rounded,color: theme.primaryColor)
            )
          ],
        )
      ),
      body: _buildMessageList(),
      bottomNavigationBar: CustomWidgets.customContainer(
        color: theme.primaryColor.withAlpha(10),
        child: CustomWidgets.customContainer(
          child: Row(
            children: [
              Expanded(
                child: CustomWidgets.customTextField(
                  controller:_messageController,
                  hintText: AppStrings.typeAMessage,
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
      ),
    );
  }

  Widget _buildMessageList(){
    final sendId = _authService.currentUser?.uid;

    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverId, sendId!),
        builder:(context,snapshot){
          if(snapshot.hasError){
            return const Text('Error');
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator();
          }
          return ListView(
            reverse: true,
            controller: _scrollController,
            children:
              snapshot.data!.docs.reversed.map((doc) => _buildMessageItem(doc)).toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    final currentUserId = _authService.currentUser?.uid;
    final isMe = data['senderID'] == currentUserId;

    final Timestamp? timestamp = data['timestamp'] as Timestamp?;
    final String formattedTime = formatTimestamp(timestamp);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: size.width/2,
          minWidth: 20

        ),
        margin: EdgeInsets.symmetric(horizontal: 10.r, vertical: 5.r),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          border: Border.all(color: isMe ? theme.primaryColor : theme.scaffoldBackgroundColor),
          color: isMe ? theme.scaffoldBackgroundColor : theme.primaryColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
          children: [
            Text(
              data['message'] ?? '',
              style: BaseStyle.s17w400.c(
                isMe ? theme.primaryColor : theme.scaffoldBackgroundColor,
              ),
            ),
            SizedBox(height: 4.r),
            Text(
              formattedTime,
              style: BaseStyle.s11w700.c(
                isMe ? theme.primaryColor.withOpacity(0.6) : theme.scaffoldBackgroundColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


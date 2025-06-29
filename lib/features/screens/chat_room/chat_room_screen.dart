// 📦 Imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../bloc/chat_user_bloc/chat_bloc.dart';
import '../../../core/app_ui/app_ui.dart';
import '../../../core/models/src/user_model/user_model.dart';
import '../../../core/utilities/utils.dart';

class ChatRoomScreen extends StatefulWidget {
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
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late Size size;
  late ThemeData theme;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    theme = Theme.of(context);
    setStatusBarLightStyle();

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      context.read<ChatBloc>().add(
        LoadMessages(receiverId: widget.receiverId, senderId: userId),
      );
    }
  }

  void sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      final user = UserModel(
        uid: widget.receiverId,
        email: widget.receiverEmail,
        displayName: widget.displayName,
        password: '',
      );

      context.read<ChatBloc>().add(
        SendMessage(message: text, receiver: user),
      );
      _messageController.clear();

      await Future.delayed(const Duration(milliseconds: 100));
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

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
        leading: CustomWidgets.customCircleBackButton(color: theme.primaryColor).padLeft(25.r),
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
              data: widget.displayName,
              style: BaseStyle.s17w400.c(theme.primaryColor),
            ),
            const Spacer(),
            CustomWidgets.customPopUpMenuBtm(
              borderRadius: BorderRadius.circular(200),
              boxColor: theme.scaffoldBackgroundColor.withAlpha(100),
              items: const ['New Group', 'Settings'],
              onSelected: (v) {},
              icon: Icon(Icons.drag_indicator_rounded, color: theme.primaryColor),
            )
          ],
        ),
      ),
      body: _buildMessageList(),
      bottomNavigationBar: CustomWidgets.customContainer(
        color: theme.primaryColor.withAlpha(10),
        child: CustomWidgets.customContainer(
          child: Row(
            children: [
              Expanded(
                child: CustomWidgets.customTextField(
                  controller: _messageController,
                  hintText: 'Type a message',
                  style: BaseStyle.s17w400.line(1),
                  hintStyle: BaseStyle.s17w400.line(1),
                  padding: EdgeInsets.symmetric(horizontal: 10.r),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: AppColors.hex2824, width: 1),
                  ),
                ).padH(10.r),
              ),
              CustomWidgets.customCircleIcon(
                onTap: sendMessage,
                h: 35.r,
                w: 35.r,
                bgColor: AppColors.hex2824,
                iconColor: AppColors.hexEeeb,
                iconData: Icons.send,
              ).padRight(20.r),
            ],
          ),
        ).padBottom(MediaQuery.of(context).viewPadding.bottom + MediaQuery.of(context).viewInsets.bottom + 30.r),
      ),
    );
  }

  Widget _buildMessageList() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChatLoaded) {
          final docs = state.messages;
          return ListView(
            reverse: true,
            controller: _scrollController,
            children: docs.reversed.map((doc) => _buildMessageItem(doc)).toList(),
          );
        } else if (state is ChatError) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isMe = data['senderID'] == currentUserId;
    final Timestamp? timestamp = data['timestamp'] as Timestamp?;
    final String formattedTime = formatTimestamp(timestamp);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: CustomWidgets.customContainer(
        constraints: BoxConstraints(maxWidth: size.width / 2, minWidth: 50),
        margin: EdgeInsets.symmetric(horizontal: 10.r, vertical: 5.r),
        padding: EdgeInsets.all(12.r),
        border: Border.all(color: isMe ? theme.primaryColor : theme.scaffoldBackgroundColor),
        color: isMe ? theme.scaffoldBackgroundColor : theme.primaryColor,
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            CustomWidgets.customText(
              data: data['message'] ?? '',
              style: BaseStyle.s17w400.c(isMe ? theme.primaryColor : theme.scaffoldBackgroundColor),
            ),
            SizedBox(height: 4.r),
            CustomWidgets.customText(
              data: formattedTime,
              style: BaseStyle.s11w700.c(
                isMe ? theme.primaryColor.withAlpha(100) : theme.scaffoldBackgroundColor.withAlpha(100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
part of 'chat_bloc.dart';



@immutable
abstract class ChatCardEvent {}

class LoadChatCardData extends ChatCardEvent {
  final String otherUserId;

  LoadChatCardData(this.otherUserId);
}
abstract class ChatEvent {}

class LoadMessages extends ChatEvent {
  final String receiverId;
  final String senderId;

  LoadMessages({required this.receiverId, required this.senderId});
}

class SendMessage extends ChatEvent {
  final String message;
  final UserModel receiver;

  SendMessage({required this.message, required this.receiver});
}



class DisposeChatCard extends ChatCardEvent {}

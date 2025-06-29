part of 'chat_bloc.dart';





abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<DocumentSnapshot> messages;

  ChatLoaded({required this.messages});
}

class ChatError extends ChatState {
  final String error;

  ChatError({required this.error});
}

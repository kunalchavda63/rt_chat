import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/models/src/user_model/user_model.dart';

import '../../core/app_ui/app_ui.dart';
import '../../features/screens/chat/chat_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService _chatService;
  final FirebaseAuth _auth;

  StreamSubscription? _subscription;

  ChatBloc(this._chatService, this._auth) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
  }

  Future<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    try {
      final stream = _chatService.getMessages(event.receiverId, event.senderId);

      await emit.forEach<QuerySnapshot>(
        stream,
        onData: (snapshot) => ChatLoaded(messages: snapshot.docs),
        onError: (error, _) => ChatError(error: error.toString()),
      );
    } catch (e) {
      emit(ChatError(error: e.toString()));
    }
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    try {
      final user = _auth.currentUser!;
      await _chatService.sendMessage(
        receiver: event.receiver,
        ref: null,
        message: event.message,
      );
    } catch (e) {
      emit(ChatError(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

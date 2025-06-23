import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_chat_state_model.freezed.dart';

@freezed
abstract class CustomChatStateModel with _$CustomChatStateModel {
  const factory CustomChatStateModel({
    required String lastMessage,
    required int messageCount,
    required int unreadCount,
  }) = _CustomChatStateModel;
}

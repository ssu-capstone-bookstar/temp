import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_application_1/domain/entities/chat/chat_message.dart';

part 'chatroom_state.freezed.dart';

@freezed
class ChatRoomState with _$ChatRoomState {
  const factory ChatRoomState({
    @Default([]) List<ChatMessage> messages,
    @Default(true) bool isLoading,
    String? errorMessage,
  }) = _ChatRoomState;
} 
import 'package:flutter_application_1/data/models/chat/chat_message_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chatroom_state.freezed.dart';

@freezed
class ChatRoomState with _$ChatRoomState {
  const factory ChatRoomState({
    @Default([]) List<ChatMessageDto> messages,
    @Default(true) bool isLoading,
    String? errorMessage,
  }) = _ChatRoomState;
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_dto.freezed.dart';
part 'chat_message_dto.g.dart';

@freezed
class ChatMessageDto with _$ChatMessageDto {
  const factory ChatMessageDto({
    required String messageId,
    required String senderId,
    String? senderName,
    required String content,
    @Default('text') String messageType,
    String? fileUrl,
    required DateTime createdAt,
    String? senderAvatar,
    @Default(false) bool isFromMe,
  }) = _ChatMessageDto;

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDtoFromJson(json);
}

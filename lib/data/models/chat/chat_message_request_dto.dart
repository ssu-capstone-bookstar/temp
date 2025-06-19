import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_request_dto.freezed.dart';
part 'chat_message_request_dto.g.dart';

@freezed
class ChatMessageRequestDto with _$ChatMessageRequestDto {
  const factory ChatMessageRequestDto({
    required String content,
    required String messageType,
    String? fileUrl,
  }) = _ChatMessageRequestDto;

  factory ChatMessageRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageRequestDtoFromJson(json);
} 
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room_dto.freezed.dart';
part 'chat_room_dto.g.dart';

@freezed
class ChatRoomDto with _$ChatRoomDto {
  const factory ChatRoomDto({
    required String id,
    required String name,
    required List<String> participantIds,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
  }) = _ChatRoomDto;

  factory ChatRoomDto.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomDtoFromJson(json);
}

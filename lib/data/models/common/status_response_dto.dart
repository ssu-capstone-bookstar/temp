import 'package:freezed_annotation/freezed_annotation.dart';

part 'status_response_dto.freezed.dart';
part 'status_response_dto.g.dart';

@freezed
class StatusResponseDto with _$StatusResponseDto {
  const factory StatusResponseDto({
    required String resultCode,
    required String resultMessage,
  }) = _StatusResponseDto;

  factory StatusResponseDto.fromJson(Map<String, dynamic> json) => _$StatusResponseDtoFromJson(json);
} 
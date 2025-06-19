import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_response_dto.freezed.dart';
part 'profile_response_dto.g.dart';

@freezed
class ProfileResponseDto with _$ProfileResponseDto {
  const factory ProfileResponseDto({
    required int memberId,
    required String nickName,
    required String profileImageUrl,
    required String introduction,
  }) = _ProfileResponseDto;

  factory ProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseDtoFromJson(json);
} 
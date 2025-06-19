import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_with_counts_dto.freezed.dart';
part 'profile_with_counts_dto.g.dart';

@freezed
class ProfileWithCountsDto with _$ProfileWithCountsDto {
  const factory ProfileWithCountsDto({
    required int memberId,
    required String nickName,
    required String profileImageUrl,
    required String introduction,
    required int followingCount,
    required int followerCount,
    required int diaryCount,
  }) = _ProfileWithCountsDto;

  factory ProfileWithCountsDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileWithCountsDtoFromJson(json);
} 
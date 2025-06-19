import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required int memberId,
    required String nickName,
    required String profileImageUrl,
    required String introduction,
    required int followingCount,
    required int followerCount,
    required int diaryCount,
  }) = _Profile;
} 
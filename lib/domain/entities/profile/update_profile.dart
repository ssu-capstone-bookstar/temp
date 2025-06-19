import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_profile.freezed.dart';

@freezed
class UpdateProfile with _$UpdateProfile {
  const factory UpdateProfile({
    String? nickName,
    String? profileImageUrl,
    String? introduction,
  }) = _UpdateProfile;
} 
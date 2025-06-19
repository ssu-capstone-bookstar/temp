import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_info.freezed.dart';

@freezed
class ProfileInfo with _$ProfileInfo {
  const factory ProfileInfo({
    required int memberId,
    required String nickName,
    required String profileImageUrl,
    required String introduction,
  }) = _ProfileInfo;
} 
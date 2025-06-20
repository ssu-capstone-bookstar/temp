import 'package:flutter_application_1/data/models/profile/profile_response_dto.dart';
import 'package:flutter_application_1/data/models/profile/profile_with_counts_dto.dart';
import 'package:flutter_application_1/data/models/profile/update_profile_request_dto.dart';

abstract class ProfileRepository {
  Future<ProfileWithCountsDto> getProfile(int memberId);
  Future<ProfileResponseDto> updateProfile(
      UpdateProfileRequestDto updateProfile, int memberId);
}

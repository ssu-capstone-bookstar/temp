import 'package:flutter_application_1/domain/entities/profile/profile.dart';
import 'package:flutter_application_1/domain/entities/profile/profile_info.dart';
import 'package:flutter_application_1/domain/entities/profile/update_profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile(int memberId);
  Future<ProfileInfo> updateProfile(UpdateProfile updateProfile, int memberId);
}

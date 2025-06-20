import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/di/dio_client.dart';
import 'package:flutter_application_1/data/models/common/api_response_dto.dart';
import 'package:flutter_application_1/data/models/profile/profile_response_dto.dart';
import 'package:flutter_application_1/data/models/profile/profile_with_counts_dto.dart';
import 'package:flutter_application_1/data/models/profile/update_profile_request_dto.dart';
import 'package:flutter_application_1/domain/repositories/profile/profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository_impl.g.dart';

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepositoryImpl(ref);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final Ref ref;

  ProfileRepositoryImpl(this.ref);

  Dio get _dio => ref.read(dioClientProvider);

  @override
  Future<ProfileWithCountsDto> getProfile(int memberId) async {
    try {
      final response = await _dio.get('/api/v2/profiles/$memberId');
      final apiResponse = ApiResponseDto<ProfileWithCountsDto>.fromJson(
        response.data,
        (json) => ProfileWithCountsDto.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.data!;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProfileResponseDto> updateProfile(
      UpdateProfileRequestDto updateProfile, int memberId) async {
    try {
      final requestDto = UpdateProfileRequestDto(
        nickName: updateProfile.nickName,
        introduction: updateProfile.introduction,
        profileImageUrl: updateProfile.profileImageUrl,
      );

      final response = await _dio.put(
        '/api/v2/profiles/me',
        data: requestDto.toJson(),
      );

      final apiResponse = ApiResponseDto<ProfileResponseDto>.fromJson(
        response.data,
        (json) => ProfileResponseDto.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.data!;
    } catch (e) {
      rethrow;
    }
  }
}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/di/dio_client.dart';
import 'package:flutter_application_1/data/models/auth/auth_response_dto.dart';
import 'package:flutter_application_1/data/models/auth/login_request_dto.dart';
import 'package:flutter_application_1/data/models/common/api_response_dto.dart';
import 'package:flutter_application_1/domain/repositories/auth/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository_impl.g.dart';

const String _AUTH_TOKENS_KEY = 'auth_tokens';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(ref, const FlutterSecureStorage());
}

class AuthRepositoryImpl implements AuthRepository {
  final Ref ref;
  final FlutterSecureStorage _storage;

  AuthRepositoryImpl(this.ref, this._storage);

  Dio get _dio => ref.read(dioClientProvider);

  @override
  Future<AuthResponseDto> login(LoginRequestDto requestDto) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/login',
        data: requestDto.toJson(),
      );

      final apiResponse = ApiResponseDto<AuthResponseDto>.fromJson(
        response.data,
        (json) => AuthResponseDto.fromJson(json as Map<String, dynamic>),
      );

      final authResponseDto = apiResponse.data!;
      await saveTokens(authResponseDto);
      return authResponseDto;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // TODO: 서버에 로그아웃 요청 (필요한 경우)
      // await _dio.post('/api/v1/auth/logout');
      await deleteTokens();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponseDto> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final apiResponse = ApiResponseDto<AuthResponseDto>.fromJson(
        response.data,
        (json) => AuthResponseDto.fromJson(json as Map<String, dynamic>),
      );

      final authResponseDto = apiResponse.data!;
      await saveTokens(authResponseDto);
      return authResponseDto;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveTokens(AuthResponseDto tokens) async {
    final jsonString = jsonEncode(tokens.toJson());
    await _storage.write(key: _AUTH_TOKENS_KEY, value: jsonString);
  }

  @override
  Future<AuthResponseDto?> getTokens() async {
    final jsonString = await _storage.read(key: _AUTH_TOKENS_KEY);
    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString);
        return AuthResponseDto.fromJson(json);
      } catch (e) {
        await deleteTokens();
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> deleteTokens() async {
    await _storage.delete(key: _AUTH_TOKENS_KEY);
  }

  @override
  Future<AuthResponseDto?> getCurrentUser() async {
    return getTokens();
  }
}

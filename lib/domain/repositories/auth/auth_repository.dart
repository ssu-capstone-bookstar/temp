import 'package:flutter_application_1/data/models/auth/auth_response_dto.dart';
import 'package:flutter_application_1/data/models/auth/login_request_dto.dart';

abstract class AuthRepository {
  /// 소셜 로그인
  Future<AuthResponseDto> login(LoginRequestDto request);

  /// 로그아웃
  Future<void> signOut();

  /// 현재 사용자 정보 가져오기
  Future<AuthResponseDto?> getCurrentUser();

  /// refreshToken을 이용해 accessToken을 갱신합니다.
  Future<AuthResponseDto> refreshToken(String refreshToken);

  Future<void> saveTokens(AuthResponseDto tokens);
  Future<AuthResponseDto?> getTokens();
  Future<void> deleteTokens();
}

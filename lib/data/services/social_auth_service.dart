import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_application_1/data/models/member/provider_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'social_auth_service.g.dart';

@riverpod
SocialAuthService socialAuthService(Ref ref) {
  return SocialAuthService();
}

class SocialAuthService {
  SocialAuthService();

  final Logger _logger = Logger();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Kakao 로그인
  Future<Map<String, dynamic>> signInWithKakao() async {
    try {
      _logger.i('Starting Kakao sign in...');

      // 카카오톡 설치 여부 확인 후 로그인 시도
      final bool isInstalled = await isKakaoTalkInstalled();
      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final idToken = token.idToken;

      // ID 토큰이 없는 경우, 카카오 개발자 콘솔에서 OpenID Connect 활성화 필요
      if (idToken == null) {
        throw Exception(
            'Failed to get ID token from Kakao. Please enable OpenID Connect for your app.');
      }

      final user = await UserApi.instance.me();
      _logger.i('Kakao sign in successful for user: ${user.id}');

      return {
        'providerType': ProviderType.kakao,
        'idToken': idToken,
        'email': user.kakaoAccount?.email,
        'displayName': user.kakaoAccount?.profile?.nickname,
        'photoUrl': user.kakaoAccount?.profile?.profileImageUrl,
      };
    } catch (e) {
      _logger.e('Kakao sign in failed: $e');
      rethrow;
    }
  }

  /// Google 로그인
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      _logger.i('Starting Google sign in...');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Failed to get ID token from Google');
      }

      _logger.i('Google sign in successful for user: ${googleUser.email}');

      return {
        'providerType': ProviderType.google,
        'idToken': idToken,
        'email': googleUser.email,
        'displayName': googleUser.displayName,
        'photoUrl': googleUser.photoUrl,
      };
    } catch (e) {
      _logger.e('Google sign in failed: $e');
      rethrow;
    }
  }

  /// Apple 로그인
  Future<Map<String, dynamic>> signInWithApple() async {
    try {
      _logger.i('Starting Apple sign in...');

      // Apple 로그인 요청
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.bookstar.app', // 실제 클라이언트 ID로 변경
          redirectUri: Uri.parse(
              'https://your-backend.com/callbacks/sign_in_with_apple'),
        ),
        nonce: _generateNonce(),
      );

      if (credential.identityToken == null) {
        throw Exception('Failed to get identity token from Apple');
      }

      _logger
          .i('Apple sign in successful for user: ${credential.userIdentifier}');

      return {
        'providerType': ProviderType.apple,
        'idToken': credential.identityToken!,
        'email': credential.email,
        'displayName':
            '${credential.givenName ?? ''} ${credential.familyName ?? ''}'
                .trim(),
        'userIdentifier': credential.userIdentifier,
      };
    } catch (e) {
      _logger.e('Apple sign in failed: $e');
      rethrow;
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _logger.i('Social auth sign out successful');
    } catch (e) {
      _logger.e('Social auth sign out failed: $e');
      rethrow;
    }
  }

  /// 현재 로그인된 사용자 정보 가져오기
  Future<GoogleSignInAccount?> getCurrentUser() async {
    try {
      return await _googleSignIn.signInSilently();
    } catch (e) {
      _logger.e('Failed to get current user: $e');
      return null;
    }
  }

  /// Apple 로그인용 nonce 생성
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// SHA256 해시 생성 (Apple 로그인용)
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

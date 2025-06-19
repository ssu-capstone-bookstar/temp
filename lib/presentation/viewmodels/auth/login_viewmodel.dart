import 'package:flutter_application_1/data/models/auth/login_request_dto.dart';
import 'package:flutter_application_1/data/models/member/provider_type.dart';
import 'package:flutter_application_1/data/repositories/auth/auth_repository_impl.dart';
import 'package:flutter_application_1/data/services/social_auth_service.dart';
import 'package:flutter_application_1/domain/repositories/auth/auth_repository.dart';
import 'package:flutter_application_1/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:flutter_application_1/presentation/viewmodels/auth/state/login_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_viewmodel.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  late final AuthRepository _authRepository;
  late final SocialAuthService _socialAuthService;

  @override
  LoginState build() {
    _authRepository = ref.read(authRepositoryProvider);
    _socialAuthService = ref.read(socialAuthServiceProvider);
    return const LoginState.initial();
  }

  Future<void> login(ProviderType providerType) async {
    state = const LoginState.loading();
    try {
      final socialData = await _getSocialLoginData(providerType);
      if (socialData == null || socialData['idToken'] == null) {
        state = const LoginState.error('로그인이 취소되었습니다.');
        // 사용자가 명시적으로 취소한 경우 초기 상태로 되돌려 다시 시도할 수 있도록 함
        Future.delayed(const Duration(seconds: 1), () {
          if (state is LoginError) {
            state = const LoginState.initial();
          }
        });
        return;
      }

      final request = LoginRequestDto(
        providerType: providerType,
        idToken: socialData['idToken'],
      );

      //TODO : 엑세스 토큰 담도록 BEARER
      final authResponse = await _authRepository.login(request);
      await ref.read(authViewModelProvider.notifier).manualSignIn(authResponse);

      final prefs = await SharedPreferences.getInstance();
      final hasAgreed = prefs.getBool('hasAgreedToPolicy') ?? false;

      if (!hasAgreed) {
        state = const LoginState.needsPolicyAgreement();
      } else {
        state = const LoginState.success();
      }
    } catch (e) {
      state = LoginState.error('로그인에 실패했습니다: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>?> _getSocialLoginData(ProviderType providerType) {
    switch (providerType) {
      case ProviderType.google:
        return _socialAuthService.signInWithGoogle();
      case ProviderType.kakao:
        return _socialAuthService.signInWithKakao();
      case ProviderType.apple:
        return _socialAuthService.signInWithApple();
    }
  }

  Future<void> agreeToPolicy() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasAgreedToPolicy', true);
    state = const LoginState.success();
  }

  Future<void> disagreeToPolicy() async {
    // 로그아웃 처리
    await ref.read(authViewModelProvider.notifier).signOut();
    // 상태 초기화
    state = const LoginState.initial();
  }
}

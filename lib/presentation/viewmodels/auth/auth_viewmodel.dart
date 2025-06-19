import 'package:flutter_application_1/data/models/auth/auth_response_dto.dart';
import 'package:flutter_application_1/data/repositories/auth/auth_repository_impl.dart';
import 'package:flutter_application_1/domain/repositories/auth/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

/// 인증 상태를 전역적으로 관리하는 ViewModel
@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  late final AuthRepository _authRepository;

  @override
  Future<AuthResponseDto?> build() async {
    _authRepository = ref.read(authRepositoryProvider);
    // 앱 시작 시 저장소에서 토큰을 불러와 상태를 초기화합니다.
    return _authRepository.getTokens();
  }

  /// 로그인 성공 후 외부에서 직접 상태를 업데이트하기 위한 메서드
  Future<void> manualSignIn(AuthResponseDto tokens) async {
    state = AsyncData(tokens);
  }

  /// 로그아웃
  Future<void> signOut() async {
    await _authRepository.deleteTokens();
    state = const AsyncData(null);
  }

  /// 토큰 갱신
  Future<void> refreshToken() async {
    final currentTokens = state.value;
    if (currentTokens == null) return;

    try {
      final newTokens =
          await _authRepository.refreshToken(currentTokens.refreshToken);
      state = AsyncData(newTokens);
    } catch (e) {
      await signOut();
      rethrow;
    }
  }

  /// accessToken이 만료되었는지 확인
  bool get isAccessTokenExpired {
    final tokens = state.value;
    if (tokens == null) return true;

    return DateTime.now().isAfter(tokens.accessTokenExpiration);
  }

  /// refreshToken이 만료되었는지 확인
  bool get isRefreshTokenExpired {
    final tokens = state.value;
    if (tokens == null) return true;

    return DateTime.now().isAfter(tokens.refreshTokenExpiration);
  }

  /// 토큰이 곧 만료될 예정인지 확인 (5분 전)
  bool get isAccessTokenExpiringSoon {
    final tokens = state.value;
    if (tokens == null) return true;

    final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
    return fiveMinutesFromNow.isAfter(tokens.accessTokenExpiration);
  }

  /// 현재 사용자 ID 가져오기
  int? get currentUserId => state.value?.memberId;

  /// 현재 사용자 닉네임 가져오기
  String? get currentUserNickname => state.value?.nickName;

  /// 현재 사용자 프로필 이미지 가져오기
  String? get currentUserProfileImage => state.value?.profileImage;

  /// 로그인 상태 확인
  bool get isLoggedIn => state.value != null;

  /// 액세스 토큰 가져오기
  String? get accessToken => state.value?.accessToken;

  /// 액세스 토큰 만료시간
  DateTime? get accessTokenExpiration => state.value?.accessTokenExpiration;

  /// 리프레시 토큰 만료시간
  DateTime? get refreshTokenExpiration => state.value?.refreshTokenExpiration;
}

/// 인증 상태를 감시하는 Provider
@riverpod
bool isAuthenticated(Ref ref) {
  final authState = ref.watch(authViewModelProvider);
  return authState.maybeWhen(
    data: (tokens) => tokens != null,
    orElse: () => false,
  );
}

/// 현재 사용자 정보를 가져오는 Provider
@riverpod
AuthResponseDto? currentUser(Ref ref) {
  return ref.watch(authViewModelProvider).value;
}

/// 토큰 만료 상태를 감시하는 Provider
@riverpod
bool isTokenExpired(Ref ref) {
  final authViewModel = ref.watch(authViewModelProvider.notifier);
  return authViewModel.isAccessTokenExpired;
}

/// 토큰이 곧 만료될 예정인지 감시하는 Provider
@riverpod
bool isTokenExpiringSoon(Ref ref) {
  final authViewModel = ref.watch(authViewModelProvider.notifier);
  return authViewModel.isAccessTokenExpiringSoon;
}

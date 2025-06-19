import 'package:dio/dio.dart';
import 'package:flutter_application_1/data/repositories/auth/auth_repository_impl.dart';
import 'package:flutter_application_1/presentation/viewmodels/auth/auth_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

@riverpod
Dio dioClient(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://15.164.30.67:8080',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  dio.interceptors.add(CustomInterceptor(ref));

  return dio;
}

class CustomInterceptor extends Interceptor {
  final Ref _ref;

  CustomInterceptor(this._ref);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // 저장된 토큰을 가져와서 헤더에 추가
    final tokens = await _ref.read(authRepositoryProvider).getTokens();
    if (tokens != null) {
      options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러(토큰 만료)이고, 재시도 요청이 아닌 경우
    if (err.response?.statusCode == 401 &&
        err.requestOptions.extra['retry'] != true) {
      try {
        // 1. 저장된 토큰 가져오기
        final oldTokens = await _ref.read(authRepositoryProvider).getTokens();
        if (oldTokens == null) return handler.next(err);

        // 2. 토큰 갱신 요청
        final newTokens = await _ref
            .read(authRepositoryProvider)
            .refreshToken(oldTokens.refreshToken);

        // 3. 갱신된 토큰으로 원래 요청 재시도
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer ${newTokens.accessToken}';
        options.extra['retry'] = true; // 재시도 요청임을 표시

        final response = await _ref.read(dioClientProvider).fetch(options);
        return handler.resolve(response);
      } on DioException catch (e) {
        // 토큰 갱신 실패 시 (예: 리프레시 토큰 만료)
        // 로그아웃 처리
        await _ref.read(authViewModelProvider.notifier).signOut();
        return handler.next(e);
      }
    }
    super.onError(err, handler);
  }
}

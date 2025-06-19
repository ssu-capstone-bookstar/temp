import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/di/dio_client.dart';
import 'package:flutter_application_1/data/models/ably/ably_token_data.dart';
import 'package:flutter_application_1/data/models/common/api_response_dto.dart';
import 'package:flutter_application_1/domain/repositories/ably/ably_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ably_repository_impl.g.dart';

@riverpod
AblyRepository ablyRepository(Ref ref) {
  return AblyRepositoryImpl(ref);
}

class AblyRepositoryImpl implements AblyRepository {
  final Ref ref;

  AblyRepositoryImpl(this.ref);

  Dio get _dio => ref.read(dioClientProvider);

  @override
  Future<String> getAblyToken() async {
    try {
      final response = await _dio.post('/api/v2/ably/token');
      final apiResponse = ApiResponseDto.fromJson(
        response.data,
        (json) => AblyTokenData.fromJson(json as Map<String, dynamic>),
      );
      if (apiResponse.data?.token != null) {
        return apiResponse.data!.token;
      } else {
        throw Exception('Ably token not found in response');
      }
    } catch (e) {
      rethrow;
    }
  }
}

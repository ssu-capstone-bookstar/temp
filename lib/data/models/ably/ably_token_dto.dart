import 'package:freezed_annotation/freezed_annotation.dart';

part 'ably_token_dto.freezed.dart';
part 'ably_token_dto.g.dart';

// API 응답의 'data' 필드를 처리하기 위한 중첩 클래스
@freezed
class AblyTokenData with _$AblyTokenData {
  const factory AblyTokenData({
    required String token,
  }) = _AblyTokenData;

  factory AblyTokenData.fromJson(Map<String, dynamic> json) =>
      _$AblyTokenDataFromJson(json);
} 
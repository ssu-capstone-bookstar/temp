import 'package:freezed_annotation/freezed_annotation.dart';

part 'ably_token_data.freezed.dart';
part 'ably_token_data.g.dart';

@freezed
class AblyTokenData with _$AblyTokenData {
  const factory AblyTokenData({
    required String token,
  }) = _AblyTokenData;

  factory AblyTokenData.fromJson(Map<String, dynamic> json) =>
      _$AblyTokenDataFromJson(json);
} 
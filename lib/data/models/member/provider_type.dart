import 'package:freezed_annotation/freezed_annotation.dart';

enum ProviderType {
  @JsonValue('KAKAO')
  kakao,
  @JsonValue('APPLE')
  apple,
  @JsonValue('GOOGLE')
  google
}

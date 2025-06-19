import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum ProviderType {
  @JsonValue('KAKAO')
  kakao,
  @JsonValue('GOOGLE')
  google,
  @JsonValue('APPLE')
  apple,
  @JsonValue('EMAIL')
  email;
}

import 'package:flutter_application_1/data/models/member/provider_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request.freezed.dart';

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required ProviderType providerType,
    required String idToken,
  }) = _LoginRequest;
}

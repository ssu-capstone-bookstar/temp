import 'package:freezed_annotation/freezed_annotation.dart';

import 'status_response_dto.dart';

part 'api_response_dto.freezed.dart';
part 'api_response_dto.g.dart';

@Freezed(genericArgumentFactories: true)
class ApiResponseDto<T> with _$ApiResponseDto<T> {
  const factory ApiResponseDto({
    required StatusResponseDto statusResponse,
    T? data,
  }) = _ApiResponseDto<T>;

  factory ApiResponseDto.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ApiResponseDtoFromJson(json, fromJsonT);
}

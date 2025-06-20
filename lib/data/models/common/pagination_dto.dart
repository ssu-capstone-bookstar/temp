import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_dto.freezed.dart';
part 'pagination_dto.g.dart';

@Freezed(genericArgumentFactories: true)
class PaginationDto<T> with _$PaginationDto<T> {
  const factory PaginationDto({
    required List<T> data,
    required int nextCursor,
    required bool hasNext,
  }) = _PaginationDto<T>;

  factory PaginationDto.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$PaginationDtoFromJson(json, fromJsonT);
}

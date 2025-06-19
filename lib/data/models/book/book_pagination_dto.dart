import 'package:freezed_annotation/freezed_annotation.dart';

import 'book_model.dart';

part 'book_pagination_dto.freezed.dart';
part 'book_pagination_dto.g.dart';

@freezed
class BookPaginationDto with _$BookPaginationDto {
  const factory BookPaginationDto({
    required List<BookModel> books,
    required int nextCursor,
    required bool hasNext,
  }) = _BookPaginationDto;

  factory BookPaginationDto.fromJson(Map<String, dynamic> json) =>
      _$BookPaginationDtoFromJson(json);
}

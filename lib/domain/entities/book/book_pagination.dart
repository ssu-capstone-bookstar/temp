import 'package:flutter_application_1/domain/entities/book/book.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_pagination.freezed.dart';

@freezed
class BookPagination with _$BookPagination {
  const factory BookPagination({
    required List<Book> books,
    required int nextCursor,
    required bool hasNext,
  }) = _BookPagination;
}

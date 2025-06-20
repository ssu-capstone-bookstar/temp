import 'package:flutter_application_1/data/models/book/book_dto.dart';
import 'package:flutter_application_1/data/models/book/recommended_book_dto.dart';
import 'package:flutter_application_1/data/models/book/search_book_dto.dart';
import 'package:flutter_application_1/data/models/common/pagination_dto.dart';

abstract class BookRepository {
  Future<PaginationDto<SearchBookDto>> searchBooks({
    required String query,
    required int page,
  });

  Future<List<RecommendedBookDto>> getRecommendedBooks();

  Future<BookDto> getBookDetail({
    required int bookId,
  });
}

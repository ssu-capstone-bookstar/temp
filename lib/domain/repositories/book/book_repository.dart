import 'package:flutter_application_1/domain/entities/book/book.dart';
import 'package:flutter_application_1/domain/entities/book/book_pagination.dart';

abstract class BookRepository {
  Future<BookPagination> searchBooks({
    required String query,
    required int start,
  });

  Future<Book> getBookDetail({required int bookId});

  Future<List<Book>> getRecommendedBooks();
}

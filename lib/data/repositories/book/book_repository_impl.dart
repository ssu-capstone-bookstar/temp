import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/di/dio_client.dart';
import 'package:flutter_application_1/data/models/book/book_model.dart';
import 'package:flutter_application_1/data/models/book/book_pagination_dto.dart';
import 'package:flutter_application_1/data/models/common/api_response_dto.dart';
import 'package:flutter_application_1/domain/entities/book/book.dart';
import 'package:flutter_application_1/domain/entities/book/book_pagination.dart';
import 'package:flutter_application_1/domain/repositories/book/book_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_repository_impl.g.dart';

@riverpod
BookRepository bookRepository(Ref ref) {
  return BookRepositoryImpl(ref);
}

class BookRepositoryImpl implements BookRepository {
  final Ref ref;

  BookRepositoryImpl(this.ref);

  Dio get _dio => ref.read(dioClientProvider);

  @override
  Future<BookPagination> searchBooks({
    required String query,
    required int start,
  }) async {
    try {
      final response = await _dio.get(
        '/api/v1/search/books/aladin',
        queryParameters: {
          'query': query,
          'start': start,
        },
      );

      final responseDto = ApiResponseDto.fromJson(
        response.data,
        (json) => BookPaginationDto.fromJson(json as Map<String, dynamic>),
      );

      final bookModels = responseDto.data?.books ?? [];
      final nextCursor = responseDto.data?.nextCursor ?? -1;
      final hasNext = responseDto.data?.hasNext ?? false;

      // TODO
      // 데이터 레이어의 모델(BookModel)을 도메인 레이어의 엔티티(Book)로 변환합니다.
      final books = bookModels
          .map((model) => Book(
                id: model.id,
                title: model.title,
                imageUrl: model.imageUrl,
                publishedDate: model.publishedDate,
                author: model.author,
              ))
          .toList();

      return BookPagination(
        books: books,
        nextCursor: nextCursor,
        hasNext: hasNext,
      );
    } on DioException catch (e) {
      // Handle Dio-specific errors, e.g., network issues, timeouts
      throw Exception('Failed to load books: ${e.message}');
    } catch (e) {
      // Handle other unexpected errors
      throw Exception('An unexpected error occurred: $e');
    }
  }

  @override
  Future<Book> getBookDetail({required int bookId}) {
    // TODO: implement getBookDetail
    throw UnimplementedError();
  }

  @override
  Future<List<Book>> getRecommendedBooks() async {
    final response = await _dio.get('/api/v1/books/recommendation/ai');
    final apiResponse = ApiResponseDto<List<BookModel>>.fromJson(
      response.data,
      (json) => (json as List<dynamic>)
          .map((item) => BookModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
    final books =
        apiResponse.data!.map((bookModel) => bookModel.toEntity()).toList();
    return books;
  }
}

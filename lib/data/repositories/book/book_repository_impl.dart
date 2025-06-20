import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/di/dio_client.dart';
import 'package:flutter_application_1/data/models/book/book_dto.dart';
import 'package:flutter_application_1/data/models/book/recommended_book_dto.dart';
import 'package:flutter_application_1/data/models/book/search_book_dto.dart';
import 'package:flutter_application_1/data/models/common/api_response_dto.dart';
import 'package:flutter_application_1/data/models/common/pagination_dto.dart';
import 'package:flutter_application_1/domain/repositories/book/book_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_repository_impl.g.dart';

@riverpod
BookRepository bookRepository(Ref ref) {
  return BookRepositoryImpl(ref.read(dioClientProvider));
}

class BookRepositoryImpl implements BookRepository {
  final Dio _dio;

  BookRepositoryImpl(this._dio);

  @override
  Future<PaginationDto<SearchBookDto>> searchBooks(
      {required String query, required int page}) async {
    final response = await _dio.get(
      '/api/v1/search/books/aladin',
      queryParameters: {
        'query': query,
        'start': page,
      },
    );

    final apiResponse = ApiResponseDto<PaginationDto<SearchBookDto>>.fromJson(
      response.data,
      (json) => PaginationDto<SearchBookDto>.fromJson(
          json as Map<String, dynamic>,
          (bookJson) =>
              SearchBookDto.fromJson(bookJson as Map<String, dynamic>)),
    );

    return apiResponse.data!;
  }

  @override
  Future<List<RecommendedBookDto>> getRecommendedBooks() async {
    final response = await _dio.get('/api/v1/books/recommendation/ai');
    final apiResponse = ApiResponseDto<List<RecommendedBookDto>>.fromJson(
      response.data,
      (json) => (json as List<dynamic>)
          .map((item) =>
              RecommendedBookDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
    return apiResponse.data ?? [];
  }

  @override
  Future<BookDto> getBookDetail({required int bookId}) async {
    // TODO: implement getBookDetail
    throw UnimplementedError();
  }
}

import 'dart:async';
import 'package:flutter_application_1/data/models/book/book_overview_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_overview_viewmodel.g.dart';

@riverpod
Future<BookOverviewDto> bookOverview(BookOverviewRef ref, int bookId) async {
  // TODO: 실제로는 여기서 BookRepository를 사용하여 API를 호출합니다.
  // 예시를 위해 2초 후 가짜 데이터를 반환합니다.
  await Future.delayed(const Duration(seconds: 1));
  
  if (bookId == 999) {
    throw Exception('책 정보를 불러오는데 실패했습니다.');
  }

  return BookOverviewDto(
    id: bookId,
    title: '도서명 $bookId',
    publisher: '출판사',
    publishedDate: '2025. 05. 26',
    imageUrl: 'https://picsum.photos/id/$bookId/200/300',
    rating: 4.5,
    reviewCount: 130,
  );
} 
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';

@freezed
class Book with _$Book {
  const factory Book({
    required int id,
    int? aladingBookId,
    required String title,
    @Default('저자 정보 없음') String author,
    @Default('') String isbn,
    @Default('') String isbn13,
    @Default('미분류') String bookCategory,
    @Default('미분류') String categoryName,
    @Default('설명 없음') String description,
    @Default('알 수 없음') String publisher,
    @Default('출간일 정보 없음') String publishedDate,
    int? page,
    String? toc,
    required String imageUrl,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) = _Book;
}

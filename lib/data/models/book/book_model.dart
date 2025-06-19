import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/book/book.dart';

part 'book_model.freezed.dart';
part 'book_model.g.dart';

@freezed
class BookModel with _$BookModel {
  const factory BookModel({
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
  }) = _BookModel;

  factory BookModel.fromJson(Map<String, Object?> json) =>
      _$BookModelFromJson(json);

  const BookModel._();

  Book toEntity() {
    return Book(
      id: id,
      aladingBookId: aladingBookId,
      title: title,
      author: author,
      isbn: isbn,
      isbn13: isbn13,
      bookCategory: bookCategory,
      categoryName: categoryName,
      description: description,
      publisher: publisher,
      publishedDate: publishedDate,
      page: page,
      toc: toc,
      imageUrl: imageUrl,
      createdDate: createdDate,
      updatedDate: updatedDate,
    );
  }
}

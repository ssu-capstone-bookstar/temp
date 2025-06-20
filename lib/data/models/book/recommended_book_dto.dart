import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommended_book_dto.freezed.dart';
part 'recommended_book_dto.g.dart';

@freezed
class RecommendedBookDto with _$RecommendedBookDto {
  const factory RecommendedBookDto({
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
    @Default(false) bool isLiked, // 좋아요 상태
  }) = BookRecommendedBookDto;

  factory RecommendedBookDto.fromJson(Map<String, Object?> json) =>
      _$RecommendedBookDtoFromJson(json);
}

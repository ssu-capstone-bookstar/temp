import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_book_dto.freezed.dart';
part 'search_book_dto.g.dart';

@freezed
class SearchBookDto with _$SearchBookDto {
  const factory SearchBookDto({
    @JsonKey(name: 'bookId') required int id,
    required String title,
    @Default('') String author,
    @Default('') @JsonKey(name: 'pubDate') String publishedDate,
    @Default('') @JsonKey(name: 'bookCover') String imageUrl,
  }) = _SearchBookDto;

  factory SearchBookDto.fromJson(Map<String, Object?> json) =>
      _$SearchBookDtoFromJson(json);
}

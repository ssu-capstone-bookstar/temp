import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_overview_dto.freezed.dart';
part 'book_overview_dto.g.dart';

@freezed
class BookOverviewDto with _$BookOverviewDto {
  const factory BookOverviewDto({
    required int id,
    required String title,
    @Default('') String publisher,
    @Default('') String publishedDate,
    @Default('') String imageUrl,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
  }) = _BookOverviewDto;

  factory BookOverviewDto.fromJson(Map<String, Object?> json) =>
      _$BookOverviewDtoFromJson(json);
} 
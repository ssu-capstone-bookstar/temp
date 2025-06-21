import 'package:freezed_annotation/freezed_annotation.dart';

part 'related_post_dto.freezed.dart';
part 'related_post_dto.g.dart';

@freezed
class RelatedPostDto with _$RelatedPostDto {
  const factory RelatedPostDto({
    required int id,
    @Default('') String thumbnailUrl,
  }) = _RelatedPostDto;

  factory RelatedPostDto.fromJson(Map<String, Object?> json) =>
      _$RelatedPostDtoFromJson(json);
} 
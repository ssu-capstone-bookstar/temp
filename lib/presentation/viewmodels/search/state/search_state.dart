import 'package:flutter_application_1/data/models/book/search_book_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_state.freezed.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    @Default('') String query,
    @Default([]) List<SearchBookDto> books,
    @Default(1) int page,
    @Default(true) bool hasNext,
  }) = _SearchState;
}

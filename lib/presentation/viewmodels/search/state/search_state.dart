import 'package:flutter_application_1/domain/entities/book/book.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_state.freezed.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    @Default('') String query,
    @Default([]) List<Book> books,
    @Default(1) int cursor,
    @Default(true) bool hasNext,
  }) = _SearchState;
}

import 'package:flutter_application_1/data/repositories/book/book_repository_impl.dart';
import 'package:flutter_application_1/domain/repositories/book/book_repository.dart';
import 'package:flutter_application_1/presentation/viewmodels/search/state/search_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_books_usecase.g.dart';

@riverpod
SearchBooksUseCase searchBooksUseCase(Ref ref) {
  // ref를 사용해 Repository Provider를 읽어와서 주입해줍니다.
  final repository = ref.watch(bookRepositoryProvider);
  return SearchBooksUseCase(repository);
}

class SearchBooksUseCase {
  final BookRepository _bookRepository;
  SearchBooksUseCase(this._bookRepository);

  // UseCase의 execute 메소드를 더 강력하게 만듭니다.
  Future<SearchState> call({
    required String query,
    int start = 1,
    SearchState? previousState, // 이전 상태를 선택적으로 받습니다.
  }) async {
    // API 호출
    final result =
        await _bookRepository.searchBooks(query: query, start: start);

    // 이전 상태가 있고, 다음 페이지를 가져오는 경우 (페이지네이션)
    if (previousState != null) {
      return previousState.copyWith(
        books: [
          ...previousState.books,
          ...result.books
        ], // 리스트를 합치는 로직이 UseCase로 이동
        cursor: result.nextCursor,
        hasNext: result.hasNext,
      );
    }
    // 새로운 검색인 경우
    else {
      return SearchState(
        query: query,
        books: result.books,
        cursor: result.nextCursor,
        hasNext: result.hasNext,
      );
    }
  }
}

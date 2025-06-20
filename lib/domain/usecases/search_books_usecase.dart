import 'package:flutter_application_1/data/repositories/book/book_repository_impl.dart';
import 'package:flutter_application_1/domain/repositories/book/book_repository.dart';
import 'package:flutter_application_1/presentation/viewmodels/search/state/search_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_books_usecase.g.dart';

@riverpod
SearchBooksUseCase searchBooksUseCase(Ref ref) {
  final bookRepository = ref.watch(bookRepositoryProvider);
  return SearchBooksUseCase(bookRepository);
}

class SearchBooksUseCase {
  final BookRepository _bookRepository;

  SearchBooksUseCase(this._bookRepository);

  Future<SearchState> call({
    required String query,
    int page = 1,
    SearchState? previousState,
  }) async {
    final pagination = await _bookRepository.searchBooks(
      query: query,
      page: page,
    );
    final newBooks = pagination.data;
    final allBooks = (previousState?.books ?? []) + newBooks;

    return SearchState(
      query: query,
      books: allBooks,
      page: page,
      hasNext: pagination.hasNext,
    );
  }
}

import 'package:flutter_application_1/data/models/book/recommended_book_dto.dart';
import 'package:flutter_application_1/data/repositories/book/book_repository_impl.dart';
import 'package:flutter_application_1/domain/repositories/book/book_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_viewmodel.g.dart';

@riverpod
class MainViewModel extends _$MainViewModel {
  late final BookRepository _bookRepository;

  @override
  Future<List<RecommendedBookDto>> build() async {
    _bookRepository = ref.watch(bookRepositoryProvider);
    return _fetchRecommendedBooks();
  }

  Future<List<RecommendedBookDto>> _fetchRecommendedBooks() async {
    final result = await _bookRepository.getRecommendedBooks();
    return result;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchRecommendedBooks());
  }

  // TODO
  void toggleBookLike(int bookId) {}
}

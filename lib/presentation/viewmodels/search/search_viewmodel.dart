import 'package:flutter_application_1/domain/usecases/search_books_usecase.dart';
import 'package:flutter_application_1/presentation/viewmodels/search/state/search_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_viewmodel.g.dart';

@riverpod
class SearchViewModel extends _$SearchViewModel {
  late final SearchBooksUseCase _searchBooksUseCase;

  @override
  // ✅ 반환 타입이 Future<SearchState> 이므로,
  // 이 클래스는 AsyncNotifier<SearchState>가 됩니다.
  // build 메소드는 Future<SearchState>를 반환해야 합니다.
  Future<SearchState> build() async {
    // 의존하는 UseCase를 주입받습니다.
    _searchBooksUseCase = ref.read(searchBooksUseCaseProvider);
    // 초기 상태는 비어 있는 성공(data) 상태입니다.
    return const SearchState();
  }

  /// 첫 페이지 검색 또는 새로운 검색어 검색
  Future<void> searchBooks(String query) async {
    // 로딩 상태로 변경하고 UseCase를 호출합니다.
    state = const AsyncValue.loading();
    // guard는 UseCase의 성공/실패에 따라 state를 AsyncData/AsyncError로 자동 설정합니다.
    state = await AsyncValue.guard(() => _searchBooksUseCase(query: query));
  }

  /// 다음 페이지 검색 (무한 스크롤)
  Future<void> fetchNextPage() async {
    // 현재 데이터가 없거나 다음 페이지가 없으면 실행하지 않습니다.
    if (!state.hasValue || !state.value!.hasNext) {
      return;
    }

    final previousState = state.value!;

    // UseCase에 이전 상태와 필요한 정보를 넘겨 다음 상태를 요청합니다.
    state = await AsyncValue.guard(() => _searchBooksUseCase(
          query: previousState.query,
          start: previousState.cursor,
          previousState: previousState,
        ));
  }
}

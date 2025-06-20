import 'package:flutter_application_1/domain/usecases/search_books_usecase.dart';
import 'package:flutter_application_1/presentation/viewmodels/search/state/search_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_viewmodel.g.dart';

@riverpod
class SearchViewModel extends _$SearchViewModel {
  late final SearchBooksUseCase _searchBooksUseCase;

  // 다음 페이지를 로딩 중인지 나타내는 내부 플래그
  bool _isFetchingNextPage = false;

  // 외부에서 이 플래그 상태를 읽을 수 있도록 getter 제공
  bool get isFetchingNextPage => _isFetchingNextPage;

  @override
  Future<SearchState> build() async {
    _searchBooksUseCase = ref.read(searchBooksUseCaseProvider);
    return const SearchState();
  }

  /// 첫 페이지 검색 또는 새로운 검색어 검색
  Future<void> searchBooks(String query) async {
    // 새로운 검색 시작 시 로딩 상태로 변경
    state = const AsyncValue.loading();
    // 새로운 검색이므로 다음 페이지 로딩 플래그 초기화
    _isFetchingNextPage = false;

    // AsyncValue.guard를 사용하여 UseCase 호출의 성공/실패에 따라 state를 자동 설정
    // 기존 search_books_usecase의 인자가 맞는지 확인 필요 (query, page 등)
    try {
      final result = await _searchBooksUseCase.call(query: query, page: 1);
      state = AsyncValue.data(
        SearchState(
          query: query,
          books: result.books,
          page: 1,
          hasNext: result.hasNext,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 다음 페이지 검색 (무한 스크롤)
  Future<void> fetchNextPage() async {
    // 1. 이미 다음 페이지를 로딩 중이라면 중복 호출 방지
    // 2. 현재 상태가 데이터를 가지고 있지 않다면 (아직 검색 결과 없음) 호출 방지
    // 3. 더 이상 다음 페이지가 없다면 (hasNext가 false) 호출 방지
    if (_isFetchingNextPage || !state.hasValue || !state.value!.hasNext) {
      return;
    }

    // 다음 페이지 로딩 시작 플래그 설정
    _isFetchingNextPage = true;

    // 현재 상태에서 필요한 정보 추출
    final previousState = state.value!;
    final currentQuery = previousState.query;
    final nextPage = previousState.page + 1;
    final currentBooks = previousState.books; // 기존 책 목록

    try {
      // UseCase를 호출하여 다음 페이지 데이터 요청
      final result =
          await _searchBooksUseCase.call(query: currentQuery, page: nextPage);

      // 현재 ViewModel의 상태를 새로운 데이터로 업데이트 (기존 책 목록에 새 책 목록 추가)
      state = AsyncValue.data(
        previousState.copyWith(
          // copyWith를 사용하여 기존 SearchState 기반으로 업데이트
          books: [...currentBooks, ...result.books], // 기존 리스트와 새 리스트 병합
          page: nextPage,
          hasNext: result.hasNext,
        ),
      );
    } catch (e) {
      print('Error fetching next page: $e'); // 디버깅용 로그
    } finally {
      _isFetchingNextPage = false;
    }
  }
}

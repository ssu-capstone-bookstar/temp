import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/presentation/viewmodels/search/search_viewmodel.dart';
import 'package:flutter_application_1/presentation/widgets/search_grid_item.dart';
import 'package:flutter_application_1/presentation/widgets/search_input_bar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchScreen extends HookConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(searchViewModelProvider);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final scrollController = useScrollController();

    useEffect(() {
      void onScrollListener() {
        // ViewModel의 Notifier 인스턴스 (메서드 호출 위함)
        final searchNotifier = ref.read(searchViewModelProvider.notifier);
        // ViewModel의 현재 데이터 상태 (hasNext, books 등 확인 위함)
        final currentSearchState = ref.read(searchViewModelProvider);

        // 현재 스크롤 위치 및 데이터 상태 확인 후 다음 페이지 요청
        currentSearchState.whenOrNull(
          data: (data) {
            if (!scrollController.hasClients) return;

            // 로딩 임계값 설정 남은 픽셀이 200보다 작을 때
            // `extentAfter`는 뷰포트 이후에 남아있는 스크롤 가능한 픽셀의 양입니다.
            final bool isNearEnd = scrollController.position.extentAfter <
                200; // 뷰포트 이후 200픽셀 이하 남았을 때

            // 다음 페이지를 로드해야 하는 조건:
            // 1. 더 이상 데이터가 없는 경우가 아닐 때 (data.hasNext == true)
            // 2. 현재 다음 페이지를 로딩 중이 아닐 때 (!searchNotifier.isFetchingNextPage)
            // 3. 스크롤이 거의 끝에 도달했을 때 (isNearEnd)
            if (data.hasNext &&
                !searchNotifier.isFetchingNextPage &&
                isNearEnd) {
              print('Scrolled near end, fetching next page...'); // 디버깅용 로그
              searchNotifier.fetchNextPage();
            }
          },
          // 로딩 중이거나 에러 상태일 때는 추가적인 스크롤 요청을 하지 않습니다.
          // loading: () => print('Search is loading, skipping next page fetch.'),
          // error: (err, st) => print('Search is in error state, skipping next page fetch.'),
        );
      }

      scrollController.addListener(onScrollListener);
      return () {
        scrollController.removeListener(onScrollListener);
        scrollController.dispose();
      };
    }, [scrollController, ref]); // ref를 의존성에 추가하여 내부에서 read() 사용 가능

    return Scaffold(
      appBar: AppBar(
        title: const Text('도서 찾기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchInputBar(
              onSubmitted: (query) {
                if (scrollController.hasClients) {
                  scrollController.jumpTo(0); // 새 검색 시 스크롤 최상단으로
                }
                ref.read(searchViewModelProvider.notifier).searchBooks(query);
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: asyncState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(
                    child: Text('에러 발생: $error',
                        style: textTheme.bodyLarge
                            ?.copyWith(color: theme.colorScheme.error))),
                data: (data) {
                  if (data.books.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off,
                              size: 80, color: AppColors.onSurfaceVariant),
                          const SizedBox(height: 16),
                          Text(
                            data.query.isEmpty ? '도서를 검색해 보세요' : '검색 결과가 없습니다',
                            style: textTheme.headlineSmall
                                ?.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    // 다음 페이지가 있을 경우 로딩 인디케이터를 위한 공간(+1)을 추가
                    itemCount: data.books.length + (data.hasNext ? 1 : 0),
                    itemBuilder: (context, index) {
                      // 리스트의 마지막 항목일 때 (즉, 로딩 인디케이터 자리일 때)
                      if (index == data.books.length) {
                        if (!data.hasNext) {
                          return const SizedBox.shrink(); // 더 이상 로딩할 데이터가 없을 때
                        }
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final book = data.books[index];
                      return SearchGriditem(book: book);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

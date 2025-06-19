import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/viewmodels/search/search_viewmodel.dart';
import 'package:flutter_application_1/presentation/widgets/book_search_tile.dart';
import 'package:flutter_application_1/presentation/widgets/search_input_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // 스크롤이 거의 끝에 도달하면 다음 페이지를 요청합니다.
    if (_scrollController.position.extentAfter < 200) {
      // ✅ ViewModel의 메소드를 호출하는 부분은 동일합니다.
      ref.read(searchViewModelProvider.notifier).fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ ViewModel의 상태(AsyncValue)를 watch합니다.
    final asyncState = ref.watch(searchViewModelProvider);

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
                // 스크롤을 맨 위로 이동시킨 후 새로운 검색을 시작합니다.
                if (_scrollController.hasClients) {
                  _scrollController.jumpTo(0);
                }
                ref.read(searchViewModelProvider.notifier).searchBooks(query);
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              // ✅ 복잡한 if문 대신 asyncState.when을 사용하여 UI를 구성합니다.
              child: asyncState.when(
                // ✅ 로딩 상태일 때 UI
                loading: () => const Center(child: CircularProgressIndicator()),

                // ✅ 에러 상태일 때 UI
                error: (error, stackTrace) =>
                    Center(child: Text('에러 발생: $error')),

                // ✅ 데이터가 있을 때 UI
                data: (data) {
                  // data는 SearchState 객체입니다.
                  if (data.books.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            data.query.isEmpty ? '도서를 검색해 보세요' : '검색 결과가 없습니다',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  // 검색 결과 리스트
                  return ListView.builder(
                    controller: _scrollController,
                    // 다음 페이지가 있을 경우에만, 추가 로딩 인디케이터를 위한 공간(1)을 더합니다.
                    itemCount: data.books.length + (data.hasNext ? 1 : 0),
                    itemBuilder: (context, index) {
                      // 마지막 아이템 위치에 도달했고, 다음 페이지가 있다면 로딩 인디케이터를 표시합니다.
                      if (index == data.books.length) {
                        // isRefreshing은 pull-to-refresh 등에 사용되므로,
                        // 여기서는 hasNext로 판단하는 것이 더 명확할 수 있습니다.
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final book = data.books[index];
                      return BookSearchTile(book: book);
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

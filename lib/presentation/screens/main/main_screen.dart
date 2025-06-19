import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/viewmodels/main/main_viewmodel.dart';
import 'package:flutter_application_1/presentation/widgets/book_card.dart';
import 'package:flutter_application_1/presentation/widgets/common_app_bar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainScreen extends HookConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendedBooksAsync = ref.watch(mainViewModelProvider);
    final currentPage = useState(0.0);
    final currentIndex = useState(0);
    final pageController = usePageController(viewportFraction: 0.8);

    useEffect(() {
      void listener() {
        currentPage.value = pageController.page!;
      }

      pageController.addListener(listener);
      return () => pageController.removeListener(listener);
    }, [pageController]);

    return Scaffold(
      appBar: const CommonAppBar(title: '도서 찾기'),
      body: recommendedBooksAsync.when(
        data: (books) {
          if (books.isEmpty) {
            return const Center(child: Text('추천 도서가 없습니다.'));
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '도서를 검색해 보세요',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '오늘의 도서 추천',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 350,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: books.length,
                    onPageChanged: (index) {
                      currentIndex.value = index;
                    },
                    itemBuilder: (context, index) {
                      double scale = 1.0;
                      if (pageController.position.haveDimensions) {
                        scale = (currentPage.value - index).abs();
                        scale = (1 - (scale * 0.15)).clamp(0.85, 1.0);
                      }
                      final book = books[index];
                      return Transform.scale(
                        scale: scale,
                        child: BookCard(
                          title: book.title,
                          author: book.author,
                          coverImageUrl: book.imageUrl,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Text(
                        books[currentIndex.value].description,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.visibility_outlined),
                        label: const Text('바로 보기'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.purple,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          ref.read(mainViewModelProvider.notifier).refresh();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('다른 도서 보기'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('오류가 발생했습니다: $err')),
      ),
    );
  }
}

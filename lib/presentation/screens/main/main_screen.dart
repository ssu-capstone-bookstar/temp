import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/book/recommended_book_dto.dart';
import 'package:flutter_application_1/presentation/screens/search/search_screen.dart';
import 'package:flutter_application_1/presentation/viewmodels/main/main_viewmodel.dart';
import 'package:flutter_application_1/presentation/widgets/book_card.dart';
import 'package:flutter_application_1/presentation/widgets/common_app_bar.dart';
import 'package:flutter_application_1/presentation/widgets/search_input_bar.dart'; // SearchInputBar import
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MainScreen extends HookConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendedBooksAsync = ref.watch(mainViewModelProvider);

    // 검색바 탭 시 검색 화면으로 이동하는 함수
    void onSearchInputTap() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchScreen()),
      );
    }

    // BookCard에서 좋아요/카드 탭 이벤트 처리 함수들
    void handleBookCardTap(int bookId) {
      // TODO: BookDetailScreen으로 이동
      print('Book Card Tapped: $bookId');
    }

    void handleBookLikeToggle(int bookId) {
      ref.read(mainViewModelProvider.notifier).toggleBookLike(bookId);
    }

    return Scaffold(
      appBar: const CommonAppBar(title: '책픽 메인'), // 책픽 메인으로 변경
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: SearchInputBar(
                    readOnly: true, // MainScreen에서는 편집 불가, 탭만 가능
                    onTap: onSearchInputTap, // 탭 시 검색 화면으로 이동
                  ),
                ),
                const SizedBox(height: 16),
                _RecommendationSection(
                  books: books,
                  onBookCardTap: handleBookCardTap, // 콜백 전달
                  onBookLikeToggle: handleBookLikeToggle, // 콜백 전달
                ),
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

// 추천 도서 섹션 위젯 (HookConsumerWidget으로 상태를 구독하고 하위 위젯에 콜백 전달)
class _RecommendationSection extends HookConsumerWidget {
  const _RecommendationSection({
    required this.books,
    required this.onBookCardTap,
    required this.onBookLikeToggle,
  });

  final List<RecommendedBookDto> books; // Book Entity 리스트를 받습니다.
  final ValueChanged<int> onBookCardTap; // 카드 탭 콜백
  final ValueChanged<int> onBookLikeToggle; // 좋아요 토글 콜백

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // PageView의 현재 페이지를 추적하기 위한 useState 훅
    final currentPage = useState(0.0);
    final currentIndex = useState(0);
    final pageController = usePageController(viewportFraction: 0.8);

    // PageView 스크롤 리스너 (페이지 변화에 따라 UI 업데이트)
    useEffect(() {
      void listener() {
        if (pageController.hasClients && pageController.page != null) {
          currentPage.value = pageController.page!;
        }
      }

      pageController.addListener(listener);
      return () => pageController.removeListener(listener);
    }, [pageController]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '오늘의 도서 추천', // 이미지에 있는 텍스트
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 350, // BookCard의 높이를 고려하여 설정
          child: PageView.builder(
            controller: pageController,
            itemCount: books.length,
            onPageChanged: (index) {
              currentIndex.value = index; // 페이지 변경 시 현재 인덱스 업데이트
            },
            itemBuilder: (context, index) {
              double scale = 1.0;
              if (pageController.position.haveDimensions) {
                scale = (currentPage.value - index).abs();
                scale =
                    (1 - (scale * 0.15)).clamp(0.85, 1.0); // 중앙으로 갈수록 커지는 효과
              }
              final book = books[index]; // 현재 페이지의 책 데이터
              return Transform.scale(
                scale: scale,
                child: BookCard(
                  bookId: book.id,
                  title: book.title,
                  author: book.author,
                  coverImageUrl: book.imageUrl,
                  isLiked: book.isLiked, // ViewModel에서 받은 isLiked 상태 전달
                  onLikeToggle: onBookLikeToggle, // 좋아요 토글 콜백 전달
                  onTap: onBookCardTap, // 카드 탭 콜백 전달
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
                books[currentIndex.value].description, // 현재 선택된 책의 설명
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  onBookCardTap(
                      books[currentIndex.value].id); // '바로 보기' 버튼도 카드 탭 콜백 사용
                },
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
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

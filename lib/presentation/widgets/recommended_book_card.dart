import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';

class RecommendedBookCard extends StatelessWidget {
  final int bookId; // 책의 고유 ID 추가
  final String title;
  final String author;
  final String coverImageUrl;
  final bool isLiked; // 좋아요 상태 추가
  final ValueChanged<int> onLikeToggle; // 좋아요 토글 콜백 추가 (bookId 전달)
  final ValueChanged<int> onTap; // 카드 탭 콜백 추가 (bookId 전달)

  const RecommendedBookCard({
    super.key,
    required this.bookId, // bookId 필수
    required this.title,
    required this.author,
    required this.coverImageUrl,
    required this.isLiked, // isLiked 필수
    required this.onLikeToggle, // 콜백 필수
    required this.onTap, // 콜백 필수
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        // 전체 카드 탭을 위한 InkWell
        borderRadius: BorderRadius.circular(15.0),
        onTap: () => onTap(bookId), // 카드 탭 시 bookId와 함께 콜백 호출
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15.0)),
                child: Image.network(
                  coverImageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                        child: Icon(Icons.book,
                            size: 50, color: AppColors.onSurfaceVariant));
                  },
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      author,
                      style: textTheme.bodyMedium
                          ?.copyWith(color: AppColors.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // 좋아요 버튼은 항상 오른쪽 하단에 정렬
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        padding: EdgeInsets.zero, // 기본 패딩 제거
                        constraints: const BoxConstraints(), // 기본 제약 조건 제거
                        icon: Icon(
                          isLiked
                              ? Icons.favorite
                              : Icons.favorite_border, // isLiked 상태에 따라 아이콘 변경
                        ),
                        color: isLiked
                            ? theme.colorScheme.error
                            : AppColors
                                .onSurfaceVariant, // isLiked 상태에 따라 색상 변경
                        onPressed: () {
                          onLikeToggle(bookId); // 좋아요 토글 콜백 호출 (bookId 전달)
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

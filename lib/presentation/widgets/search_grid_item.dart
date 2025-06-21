import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/data/models/book/search_book_dto.dart';
import 'package:go_router/go_router.dart';

class SearchGriditem extends StatelessWidget {
  const SearchGriditem({super.key, required this.book});

  final SearchBookDto book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // 사용자의 탭(Tap)과 같은 상호작용에 반응
    return InkWell(
      onTap: () {
        context.go('/search/book/${book.id}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(4),
                // imageUrl이 빈 문자열이 아닐 때만 이미지를 로드합니다.
                image: book.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(book
                            .imageUrl), // 이제 book.imageUrl은 String이므로 !가 필요 없습니다.
                        fit: BoxFit.cover,
                      )
                    : null, // imageUrl이 비어있으면 이미지를 설정하지 않습니다.
              ),
              // imageUrl이 빈 문자열일 때 아이콘을 표시합니다.
              child: book.imageUrl.isEmpty
                  ? const Icon(Icons.book_outlined,
                      color: AppColors.onSurfaceVariant, size: 30)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${book.author} · ${book.publishedDate}',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/book/book.dart';
import 'package:go_router/go_router.dart';

class BookSearchTile extends StatelessWidget {
  const BookSearchTile({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.go('/book-pick/book/${book.id}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book cover placeholder
            Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
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
                      color: Colors.grey, size: 30)
                  : null, // 이미지가 있으면 child에 아무것도 표시하지 않습니다.
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title, // title도 @Default가 적용되었다면 null 걱정 없이 사용합니다.
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // author와 publishedDate도 이제 null이 아니므로 직접 사용 가능합니다.
                    // 만약 publishedDate가 빈 문자열이라면, 해당 부분을 조건부로 표시하는 것도 고려할 수 있습니다.
                    // 예를 들어: '${book.author}${book.publishedDate.isNotEmpty ? ' · ${book.publishedDate}' : ''}'
                    '${book.author} · ${book.publishedDate}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
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

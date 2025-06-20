import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';

class SearchResultDetailScreen extends StatelessWidget {
  const SearchResultDetailScreen({super.key, required this.bookId});

  final String bookId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('도서 상세 정보'),
      ),
      body: ListView(
        children: [
          // 1. Book Detail Header
          Container(
            padding: const EdgeInsets.all(16.0),
            height: 200, // Placeholder height
            child: Row(
              children: [
                // Book Cover
                Container(
                  width: 120,
                  color: theme.colorScheme.surface,
                  child: const Icon(Icons.book,
                      size: 60, color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(width: 16),
                // Book Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        bookId,
                        style: textTheme.titleLarge,
                      ),
                      Text('출판사',
                          style: textTheme.bodyMedium
                              ?.copyWith(color: AppColors.onSurfaceVariant)),
                      Text('2025. 05. 26',
                          style: textTheme.bodyMedium
                              ?.copyWith(color: AppColors.onSurfaceVariant)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: AppColors.rating, size: 20),
                          Text('4.5', style: textTheme.bodyMedium),
                          const SizedBox(width: 16),
                          const Icon(Icons.thumb_up_alt_outlined, size: 20),
                          Text('130', style: textTheme.bodyMedium),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          // 2. Related Posts Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '관련 게시물',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: 9, // Placeholder count
                  itemBuilder: (context, index) {
                    return Container(
                      color: theme.colorScheme.surface,
                      child: const Icon(Icons.photo_album,
                          color: AppColors.onSurfaceVariant),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

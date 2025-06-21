import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/data/models/book/book_overview_dto.dart';

class BookOverviewSection extends StatelessWidget {
  const BookOverviewSection({super.key, required this.book});

  final BookOverviewDto book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Book Cover
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: 100,
              height: 140,
              color: theme.colorScheme.surface,
              child: book.imageUrl.isNotEmpty
                  ? Image.network(
                      book.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.book, color: AppColors.onSurfaceVariant, size: 40),
                    )
                  : const Icon(Icons.book, color: AppColors.onSurfaceVariant, size: 40),
            ),
          ),
          const SizedBox(width: 16),
          // Book Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(book.title, style: textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(book.publisher, style: textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                Text(book.publishedDate, style: textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.rating, size: 20),
                    const SizedBox(width: 4),
                    Text(book.rating.toString(), style: textTheme.bodyMedium),
                    const SizedBox(width: 16),
                    const Icon(Icons.message_outlined, size: 20, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(book.reviewCount.toString(), style: textTheme.bodyMedium),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
} 
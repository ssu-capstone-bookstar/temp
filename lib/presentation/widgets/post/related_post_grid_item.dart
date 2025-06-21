import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/data/models/post/related_post_dto.dart';

class RelatedPostGridItem extends StatelessWidget {
  const RelatedPostGridItem({super.key, required this.post});

  final RelatedPostDto post;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(
        post.thumbnailUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Theme.of(context).colorScheme.surface,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Theme.of(context).colorScheme.surface,
            child: const Icon(Icons.photo, color: AppColors.onSurfaceVariant),
          );
        },
      ),
    );
  }
} 
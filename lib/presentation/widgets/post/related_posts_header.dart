import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';

class RelatedPostsHeader extends StatelessWidget {
  const RelatedPostsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('관련 게시물', style: textTheme.titleMedium),
          TextButton.icon(
            onPressed: () {
              // TODO: 정렬 옵션 변경 로직
            },
            icon: const Icon(Icons.sort, size: 16, color: AppColors.onSurfaceVariant),
            label: Text('인기순', style: textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
} 
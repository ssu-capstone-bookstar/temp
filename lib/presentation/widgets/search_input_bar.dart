// lib/presentation/widgets/search_input_bar.dart (또는 components/search_input_bar.dart)
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';

class SearchInputBar extends StatelessWidget {
  const SearchInputBar({
    super.key,
    this.enabled = true,
    this.readOnly = false, // 새로 추가: 읽기 전용 모드
    this.onSubmitted,
    this.onTap, // 새로 추가: TextField 탭 시 호출될 콜백
  });

  final bool enabled;
  final bool readOnly; // 텍스트 편집은 안되고 탭만 가능하게 할 때
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap; // 텍스트 필드 탭 이벤트

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      enabled: enabled,
      readOnly: readOnly, // 읽기 전용 설정
      onSubmitted: onSubmitted,
      onTap: onTap, // 탭 콜백 연결
      autofocus: enabled && !readOnly, // 읽기 전용일 때는 자동 포커스 방지
      decoration: InputDecoration(
        hintText: '도서를 검색해 보세요',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.onSurfaceVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:
              BorderSide(color: AppColors.onSurfaceVariant.withAlpha(128)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:
              BorderSide(color: AppColors.onSurfaceVariant.withAlpha(128)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        filled: !enabled || readOnly, // readOnly일 때도 채워진 색상 적용
        fillColor: theme.colorScheme.surface,
      ),
    );
  }
}

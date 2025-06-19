import 'package:flutter/material.dart';

class SearchInputBar extends StatelessWidget {
  const SearchInputBar({
    super.key,
    this.enabled = true,
    this.onSubmitted,
  });

  final bool enabled;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      onSubmitted: onSubmitted,
      autofocus: enabled,
      decoration: InputDecoration(
        hintText: '도서를 검색해 보세요',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        filled: !enabled,
        fillColor: Colors.grey[200],
      ),
    );
  }
}

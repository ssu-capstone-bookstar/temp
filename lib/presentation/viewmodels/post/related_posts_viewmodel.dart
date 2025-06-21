import 'dart:async';

import 'package:flutter_application_1/data/models/post/related_post_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'related_posts_viewmodel.g.dart';

@riverpod
class RelatedPostsViewModel extends _$RelatedPostsViewModel {
  int _page = 1;
  final int _perPage = 9;

  @override
  Future<List<RelatedPostDto>> build(int bookId) async {
    return _fetchPosts(bookId, 1);
  }

  Future<List<RelatedPostDto>> _fetchPosts(int bookId, int page) async {
    // TODO: 실제 API 호출 로직으로 교체
    await Future.delayed(const Duration(milliseconds: 800));

    // 마지막 페이지 테스트
    if (page > 3) {
      return [];
    }

    // 가짜 데이터 생성
    return List.generate(_perPage, (index) {
      final postId = (page - 1) * _perPage + index + 1;
      return RelatedPostDto(
        id: postId,
        thumbnailUrl: 'https://picsum.photos/id/${bookId + postId}/200',
      );
    });
  }

  Future<void> fetchNextPage() async {
    // 이미 로딩 중이면 중복 실행 방지
    // TODO : 이 로직 보고 검색 스크롤 바꾸자
    if (state.isLoading || state.isRefreshing) return;

    final bookId = 1;
    _page++;

    state = const AsyncValue.loading();
    try {
      final newPosts = await _fetchPosts(bookId, _page);
      final previousPosts = await future;
      state = AsyncData([...previousPosts, ...newPosts]);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}

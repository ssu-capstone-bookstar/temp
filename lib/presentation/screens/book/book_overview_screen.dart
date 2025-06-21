import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/viewmodels/book/book_overview_viewmodel.dart';
import 'package:flutter_application_1/presentation/viewmodels/post/related_posts_viewmodel.dart';
import 'package:flutter_application_1/presentation/widgets/book/book_overview_section.dart';
import 'package:flutter_application_1/presentation/widgets/post/related_post_grid_item.dart';
import 'package:flutter_application_1/presentation/widgets/post/related_posts_header.dart';
import 'package:flutter_application_1/presentation/widgets/search_input_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BookOverviewScreen extends ConsumerStatefulWidget {
  const BookOverviewScreen({super.key, required this.bookId});
  final int bookId;

  @override
  ConsumerState<BookOverviewScreen> createState() => _BookOverviewScreenState();
}

class _BookOverviewScreenState extends ConsumerState<BookOverviewScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 500) {
      ref
          .read(relatedPostsViewModelProvider(widget.bookId).notifier)
          .fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookState = ref.watch(bookOverviewProvider(widget.bookId));
    final postsState = ref.watch(relatedPostsViewModelProvider(widget.bookId));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SearchInputBar(
                readOnly: true,
                onTap: () {
                  context.push('/search');
                },
              ),
            ),
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 250,
                    flexibleSpace: FlexibleSpaceBar(
                      background: bookState.when(
                        data: (book) => BookOverviewSection(book: book),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, _) =>
                            Center(child: Text(error.toString())),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: RelatedPostsHeader()),
                  postsState.when(
                    data: (posts) => SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverGrid.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: posts.length,
                        itemBuilder: (context, index) =>
                            RelatedPostGridItem(post: posts[index]),
                      ),
                    ),
                    loading: () => const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator())),
                    error: (error, _) => SliverToBoxAdapter(
                        child: Center(child: Text(error.toString()))),
                  ),
                  // 다음 페이지 로딩 중 인디케이터
                  SliverToBoxAdapter(
                    child: postsState.isLoading &&
                            (postsState.value ?? []).isNotEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox.shrink(),
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

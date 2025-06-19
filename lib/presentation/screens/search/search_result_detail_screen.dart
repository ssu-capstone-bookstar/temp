import 'package:flutter/material.dart';

class SearchResultDetailScreen extends StatelessWidget {
  const SearchResultDetailScreen({super.key, required this.bookId});

  final String bookId;

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.grey[300],
                  child: const Icon(Icons.book, size: 60, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                // Book Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        bookId, // Using bookId as the title for now
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Text('출판사', style: TextStyle(color: Colors.grey)),
                      const Text('2025. 05. 26', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Text('4.5'),
                          SizedBox(width: 16),
                          Icon(Icons.thumb_up_alt_outlined, size: 20),
                          Text('130'),
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
                const Text(
                  '관련 게시물',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      color: Colors.grey[300],
                      child: const Icon(Icons.photo_album, color: Colors.grey),
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

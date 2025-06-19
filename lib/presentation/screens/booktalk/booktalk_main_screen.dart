import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookTalkMainScreen extends StatelessWidget {
  const BookTalkMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // "전체", "문학", "인문", "에세이" 등 탭의 개수
      child: Scaffold(
        appBar: AppBar(
          title: const Text('책톡'),
          bottom: const TabBar(
            isScrollable: true, // 탭이 많아지면 스크롤 가능하도록
            tabs: [
              Tab(text: '전체'),
              Tab(text: '문학'),
              Tab(text: '인문'),
              Tab(text: '에세이'),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // "정확한 채팅방" 섹션 타이틀
            const Text(
              '정확한 채팅방',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '내가 읽은 책에 대한 채팅방을 찾아보세요.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // 채팅방 목록 (임시 데이터)
            _buildChatRoomTile(context, '문학', '데미안', '123', '45'),
            _buildChatRoomTile(context, '인문', '사피엔스', '88', '12'),
            _buildChatRoomTile(context, '에세이', '여행의 이유', '205', '99+'),
          ],
        ),
      ),
    );
  }

  // 채팅방 타일 위젯 (임시)
  Widget _buildChatRoomTile(BuildContext context, String category, String title,
      String userCount, String messageCount) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: const Icon(Icons.book, size: 40),
        title: Text('[$category] $title'),
        subtitle: Row(
          children: [
            const Icon(Icons.person, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(userCount),
            const SizedBox(width: 16),
            const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(messageCount),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // 채팅방으로 이동하는 로직
          context.go('/book-talk/$title');
        },
      ),
    );
  }
}

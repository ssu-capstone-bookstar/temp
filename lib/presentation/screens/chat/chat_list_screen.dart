import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';
import 'package:flutter_application_1/data/models/chat/chat_room_dto.dart';
import 'package:flutter_application_1/presentation/viewmodels/chat/chat_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  // 임시 채팅방 데이터 (실제로는 API에서 가져와야 함)
  final List<ChatRoomDto> _chatRooms = [
    ChatRoomDto(
      id: 'general',
      name: '일반 채팅',
      participantIds: ['user1', 'user2', 'user3'],
      lastMessage: '안녕하세요!',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
    ),
    ChatRoomDto(
      id: 'random',
      name: '랜덤 채팅',
      participantIds: ['user1', 'user4', 'user5'],
      lastMessage: '오늘 날씨가 좋네요',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 0,
    ),
    ChatRoomDto(
      id: 'tech',
      name: '기술 토론',
      participantIds: ['user1', 'user6', 'user7', 'user8'],
      lastMessage: 'Flutter 개발에 대해 이야기해봐요',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 5,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // 채팅 서비스 초기화 (실제로는 로그인 후에 해야 함)
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      await ref.read(chatViewModelProvider.notifier).initializeChat(
            userId: 'user1',
            userName: '사용자1',
            userAvatar: null,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('채팅 초기화 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // 새 채팅방 생성 로직
              _showCreateChatDialog();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _chatRooms.length,
        itemBuilder: (context, index) {
          final room = _chatRooms[index];
          return _buildChatRoomItem(room);
        },
      ),
    );
  }

  Widget _buildChatRoomItem(ChatRoomDto room) {
    final timeFormat = DateFormat('MM/dd HH:mm');
    final lastMessageTime = room.lastMessageTime;
    final timeText =
        lastMessageTime != null ? timeFormat.format(lastMessageTime) : '';
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primary,
        child: Text(
          room.name[0].toUpperCase(),
          style: textTheme.titleMedium
              ?.copyWith(color: theme.colorScheme.onPrimary),
        ),
      ),
      title: Row(
        children: [
          Expanded(child: Text(room.name, style: textTheme.bodyLarge)),
          if (room.unreadCount != null && room.unreadCount! > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                room.unreadCount.toString(),
                style: textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onError),
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (room.lastMessage != null)
            Text(
              room.lastMessage!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                color: room.unreadCount != null && room.unreadCount! > 0
                    ? theme.colorScheme.onSurface
                    : AppColors.onSurfaceVariant,
                fontWeight: room.unreadCount != null && room.unreadCount! > 0
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          if (timeText.isNotEmpty)
            Text(
              timeText,
              style: textTheme.bodySmall,
            ),
        ],
      ),
      onTap: () {
        // 채팅 화면으로 이동
        context.push('/chat/${room.id}', extra: {
          'channelName': room.id,
          'channelTitle': room.name,
        });
      },
    );
  }

  void _showCreateChatDialog() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('새 채팅방 만들기', style: textTheme.titleLarge),
        content: const TextField(
          decoration: InputDecoration(
            labelText: '채팅방 이름',
            hintText: '채팅방 이름을 입력하세요',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('취소',
                style: textTheme.labelLarge
                    ?.copyWith(color: theme.colorScheme.primary)),
          ),
          ElevatedButton(
            onPressed: () {
              // 새 채팅방 생성 로직
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('새 채팅방이 생성되었습니다')),
              );
            },
            child: const Text('생성'),
          ),
        ],
      ),
    );
  }
}

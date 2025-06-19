import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/viewmodels/chatroom/chatroom_viewmodel.dart';
import 'package:flutter_application_1/presentation/viewmodels/chatroom/state/chatroom_state.dart';
import 'package:flutter_application_1/presentation/widgets/chat_bubble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  const ChatRoomScreen({super.key, required this.chatRoomId});
  final String chatRoomId;

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 화면이 로드될 때 ViewModel의 초기화 메소드를 호출합니다.
    Future.microtask(() =>
        ref.read(chatRoomViewModelProvider.notifier).init(widget.chatRoomId));
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final content = _textController.text.trim();
    if (content.isNotEmpty) {
      ref
          .read(chatRoomViewModelProvider.notifier)
          .sendMessage(content);
      _textController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatRoomViewModelProvider);
    final viewModel = ref.read(chatRoomViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('채팅방: ${widget.chatRoomId}'),
            Text(
              viewModel.isConnected ? '연결됨' : '연결 중...',
              style: TextStyle(
                fontSize: 12,
                color: viewModel.isConnected ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              viewModel.init(widget.chatRoomId);
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {/* 채팅 참여자 목록 화면으로 이동 */},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildBody(state),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildBody(ChatRoomState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('에러: ${state.errorMessage}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(chatRoomViewModelProvider.notifier).clearError();
                ref.read(chatRoomViewModelProvider.notifier).init(widget.chatRoomId);
              },
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }
    
    if (state.messages.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              '메시지를 보내 대화를 시작해보세요.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      controller: _scrollController,
      reverse: true, // 최신 메시지가 아래에 표시되도록
      padding: const EdgeInsets.all(8.0),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];
        return ChatBubble(
          message: message.content,
          isMe: message.isFromMe,
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Theme.of(context).cardColor,
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: '메시지를 입력하세요...',
                  border: InputBorder.none,
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

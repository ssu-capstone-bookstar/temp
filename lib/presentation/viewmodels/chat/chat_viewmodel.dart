import 'dart:async';

import 'package:flutter_application_1/data/models/chat/chat_message_dto.dart';
import 'package:flutter_application_1/data/repositories/chat/chat_repository_impl.dart';
import 'package:flutter_application_1/domain/repositories/chat/chat_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_viewmodel.g.dart';

@riverpod
class ChatViewModel extends _$ChatViewModel {
  late final ChatRepository _chatRepository;
  StreamSubscription<ChatMessageDto>? _messageSubscription;
  String? _currentChannel;

  @override
  Future<List<ChatMessageDto>> build() async {
    _chatRepository = ref.read(chatRepositoryProvider);
    return [];
  }

  /// 채팅 서비스 초기화
  Future<void> initializeChat({
    required String userId,
    required String userName,
    String? userAvatar,
  }) async {
    state = const AsyncLoading();

    try {
      await _chatRepository.initializeChat(
        userId: userId,
        userName: userName,
        userAvatar: userAvatar,
      );

      // 초기 상태를 빈 리스트로 설정
      state = const AsyncData([]);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  /// 채널 구독
  Future<void> subscribeToChannel(String channelName) async {
    if (_currentChannel == channelName) return;

    // 이전 구독 해제
    if (_messageSubscription != null) {
      _messageSubscription!.cancel();
      _chatRepository.unsubscribeFromChannel(_currentChannel!);
    }

    _currentChannel = channelName;

    try {
      // 메시지 히스토리 로드
      final history = await _chatRepository.getMessageHistory(channelName);

      // 채널 구독
      final messageStream = _chatRepository.subscribeToChannel(channelName);
      _messageSubscription = messageStream.listen((message) {
        _addMessage(message);
      });

      // 히스토리 메시지들로 상태 업데이트
      state = AsyncData(history);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  /// 메시지 전송
  Future<void> sendMessage(String content) async {
    if (_currentChannel == null || content.trim().isEmpty) return;

    try {
      await _chatRepository.sendMessage(_currentChannel!, content);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  /// 새 메시지 추가
  void _addMessage(ChatMessageDto message) {
    state.whenData((messages) {
      final updatedMessages = List<ChatMessageDto>.from(messages)..add(message);
      state = AsyncData(updatedMessages);
    });
  }

  /// 연결 상태 확인
  bool get isConnected => _chatRepository.isConnected;

  /// 현재 사용자 ID
  String? get currentUserId => _chatRepository.currentUserId;

  /// 현재 채널
  String? get currentChannel => _currentChannel;

  /// 메시지 목록
  List<ChatMessageDto> get messages {
    return state.when(
      data: (messages) => messages,
      loading: () => [],
      error: (_, __) => [],
    );
  }

  /// 로딩 상태
  bool get isLoading => state.isLoading;

  /// 에러 상태
  bool get hasError => state.hasError;

  /// 에러 메시지
  String? get errorMessage {
    return state.whenOrNull(
      error: (error, _) => error.toString(),
    );
  }
}

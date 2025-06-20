import 'dart:async';

import 'package:flutter_application_1/data/models/chat/chat_message_dto.dart';
import 'package:flutter_application_1/data/repositories/chat/chat_repository_impl.dart';
import 'package:flutter_application_1/domain/repositories/chat/chat_repository.dart';
import 'package:flutter_application_1/presentation/viewmodels/chatroom/state/chatroom_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chatroom_viewmodel.g.dart';

@riverpod
class ChatRoomViewModel extends _$ChatRoomViewModel {
  late final ChatRepository _chatRepository;
  StreamSubscription<ChatMessageDto>? _messageSubscription;
  String? _currentRoomId;

  @override
  ChatRoomState build() {
    _chatRepository = ref.read(chatRepositoryProvider);

    // Notifier가 소멸될 때 구독을 해제합니다.
    ref.onDispose(() {
      _messageSubscription?.cancel();
      if (_currentRoomId != null) {
        _chatRepository.unsubscribeFromChannel(_currentRoomId!);
      }
    });

    // 초기 상태
    return const ChatRoomState();
  }

  /// 채팅방 초기화 로직
  Future<void> init(String roomId) async {
    if (_currentRoomId == roomId) return; // 이미 같은 방에 있으면 무시

    state = const ChatRoomState(isLoading: true);

    try {
      // 이전 구독 해제
      if (_messageSubscription != null) {
        _messageSubscription!.cancel();
        if (_currentRoomId != null) {
          _chatRepository.unsubscribeFromChannel(_currentRoomId!);
        }
      }

      _currentRoomId = roomId;

      // 1. 이전 메시지 내역 불러오기
      final pastMessages = await _chatRepository.getMessageHistory(roomId);

      // 2. 실시간 메시지 구독 시작
      final messageStream = _chatRepository.subscribeToChannel(roomId);
      _messageSubscription = messageStream.listen((chatMessage) {
        // 새로운 메시지를 상태에 추가
        state = state.copyWith(
          messages: [chatMessage, ...state.messages],
          isLoading: false,
        );
      });

      // 3. 히스토리 메시지들을 상태에 설정
      state = state.copyWith(
        messages: pastMessages,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
        isLoading: false,
      );
    }
  }

  /// 메시지 전송 로직
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || _currentRoomId == null) return;

    try {
      // Repository를 통해 메시지 전송
      await _chatRepository.sendMessage(_currentRoomId!, content);
      // 성공적으로 보내면, Ably를 통해 다시 해당 메시지를 수신하게 되므로
      // UI에 직접 추가할 필요가 없습니다.
    } catch (e) {
      // 에러 처리
      state = state.copyWith(errorMessage: '메시지 전송 실패: $e');
    }
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// 로딩 상태 확인
  bool get isLoading => state.isLoading;

  /// 에러 메시지
  String? get errorMessage => state.errorMessage;

  /// 메시지 목록
  List<ChatMessageDto> get messages => state.messages;

  /// 현재 채팅방 ID
  String? get currentRoomId => _currentRoomId;

  /// 연결 상태 확인
  bool get isConnected => _chatRepository.isConnected;
}

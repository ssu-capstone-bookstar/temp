import 'package:flutter_application_1/data/models/chat/chat_message_dto.dart';

abstract class ChatRepository {
  /// 채팅 서비스 초기화
  Future<void> initializeChat({
    required String userId,
    required String userName,
    String? userAvatar,
  });

  /// 채널 구독
  Stream<ChatMessageDto> subscribeToChannel(String channelName);

  /// 메시지 전송
  Future<void> sendMessage(String channelName, String content);

  /// 메시지 히스토리 가져오기
  Future<List<ChatMessageDto>> getMessageHistory(String channelName,
      {int limit = 50});

  /// 채널 구독 해제
  void unsubscribeFromChannel(String channelName);

  /// 연결 해제
  Future<void> disconnect();

  /// 연결 상태 확인
  bool get isConnected;

  /// 현재 사용자 ID
  String? get currentUserId;
}

import 'dart:async';

import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:flutter_application_1/core/di/dio_client.dart';
import 'package:flutter_application_1/data/models/ably/ably_token_data.dart';
import 'package:flutter_application_1/data/models/common/api_response_dto.dart';
import 'package:flutter_application_1/domain/entities/chat/chat_message.dart';
import 'package:flutter_application_1/domain/repositories/chat/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository_impl.g.dart';

@riverpod
ChatRepository chatRepository(Ref ref) {
  return ChatRepositoryImpl(ref);
}

class ChatRepositoryImpl implements ChatRepository {
  final Ref ref;
  final Logger _logger = Logger();

  // Ably 관련 필드들
  ably.Realtime? _realtime;
  ably.Rest? _rest;
  String? _currentUserId;
  String? _currentUserName;
  String? _currentUserAvatar;

  // 스트림 컨트롤러들
  final Map<String, StreamController<ChatMessage>> _messageControllers = {};
  final StreamController<ably.ConnectionStateChange> _connectionController =
      StreamController<ably.ConnectionStateChange>.broadcast();

  ChatRepositoryImpl(this.ref);

  // 연결 상태 스트림
  Stream<ably.ConnectionStateChange> get connectionStream =>
      _connectionController.stream;

  // Ably 토큰 발급
  Future<ably.TokenDetails> _fetchAblyToken() async {
    try {
      final dio = ref.read(dioClientProvider);
      final response = await dio.post('/api/v2/ably/token');
      final apiResponse = ApiResponseDto.fromJson(
        response.data,
        (json) => AblyTokenData.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.data?.token != null) {
        return ably.TokenDetails(apiResponse.data!.token);
      } else {
        throw Exception('Ably 토큰을 받아오지 못했습니다.');
      }
    } catch (e) {
      _logger.e('Failed to fetch Ably token: $e');
      rethrow;
    }
  }

  @override
  Future<void> initializeChat({
    required String userId,
    required String userName,
    String? userAvatar,
  }) async {
    try {
      _currentUserId = userId;
      _currentUserName = userName;
      _currentUserAvatar = userAvatar;

      // Ably 토큰 발급 및 초기화
      final clientOptions = ably.ClientOptions(
        authCallback: (params) async {
          return await _fetchAblyToken();
        },
        clientId: userId,
      );

      _realtime = ably.Realtime(options: clientOptions);
      _rest = ably.Rest(options: clientOptions);

      // 연결 상태 리스너
      _realtime!.connection.on().listen((stateChange) {
        _connectionController.add(stateChange);
        _logger.i('Ably connection state: ${stateChange.current}');
      });

      _logger.i('Chat repository initialized successfully');
    } catch (e) {
      _logger.e('Failed to initialize chat repository: $e');
      rethrow;
    }
  }

  @override
  Stream<ChatMessage> subscribeToChannel(String channelName) {
    if (_realtime == null) {
      throw Exception('Chat repository not initialized');
    }

    // 이미 구독 중인 채널인지 확인
    if (_messageControllers.containsKey(channelName)) {
      return _messageControllers[channelName]!.stream;
    }

    // 새로운 스트림 컨트롤러 생성
    final controller = StreamController<ChatMessage>.broadcast();
    _messageControllers[channelName] = controller;

    try {
      final channel = _realtime!.channels.get(channelName);
      final messageStream = channel.subscribe();

      messageStream.listen((ablyMessage) {
        try {
          final messageData = ablyMessage.data as Map<String, dynamic>;
          final chatMessage = ChatMessage(
            id: ablyMessage.id ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            senderId: messageData['senderId'] ?? '',
            senderName: messageData['senderName'] ?? '',
            content: messageData['content'] ?? '',
            timestamp: DateTime.parse(
                messageData['timestamp'] ?? DateTime.now().toIso8601String()),
            senderAvatar: messageData['senderAvatar'],
            isFromMe: messageData['senderId'] == _currentUserId,
          );

          controller.add(chatMessage);
          _logger.d('Received message: ${chatMessage.content}');
        } catch (e) {
          _logger.e('Error parsing message: $e');
        }
      });

      _logger.i('Subscribed to channel: $channelName');
    } catch (e) {
      _logger.e('Failed to subscribe to channel $channelName: $e');
      controller.close();
      _messageControllers.remove(channelName);
      rethrow;
    }

    return controller.stream;
  }

  @override
  Future<void> sendMessage(String channelName, String content) async {
    if (_realtime == null) {
      throw Exception('Chat repository not initialized');
    }

    try {
      final channel = _realtime!.channels.get(channelName);
      final messageData = {
        'senderId': _currentUserId,
        'senderName': _currentUserName,
        'content': content,
        'timestamp': DateTime.now().toIso8601String(),
        'senderAvatar': _currentUserAvatar,
      };

      await channel.publish(name: 'chat-message', data: messageData);
      _logger.i('Message sent to channel: $channelName');
    } catch (e) {
      _logger.e('Failed to send message: $e');
      rethrow;
    }
  }

  @override
  Future<List<ChatMessage>> getMessageHistory(String channelName,
      {int limit = 50}) async {
    if (_rest == null) {
      throw Exception('Chat repository not initialized');
    }

    try {
      final channel = _rest!.channels.get(channelName);
      final history = await channel.history(
        ably.RestHistoryParams(
          limit: limit,
          direction: "backwards", // 최신 메시지부터 가져오기
        ),
      );

      final messages = history.items.map((ablyMessage) {
        final messageData = ablyMessage.data as Map<String, dynamic>;
        return ChatMessage(
          id: ablyMessage.id ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: messageData['senderId'] ?? '',
          senderName: messageData['senderName'] ?? '',
          content: messageData['content'] ?? '',
          timestamp: DateTime.parse(
              messageData['timestamp'] ?? DateTime.now().toIso8601String()),
          senderAvatar: messageData['senderAvatar'],
          isFromMe: messageData['senderId'] == _currentUserId,
        );
      }).toList();

      _logger.i('Retrieved ${messages.length} messages from history');
      return messages;
    } catch (e) {
      _logger.e('Failed to get message history: $e');
      rethrow;
    }
  }

  @override
  void unsubscribeFromChannel(String channelName) {
    final controller = _messageControllers[channelName];
    if (controller != null) {
      controller.close();
      _messageControllers.remove(channelName);
      _logger.i('Unsubscribed from channel: $channelName');
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      // 모든 스트림 컨트롤러 닫기
      for (final controller in _messageControllers.values) {
        controller.close();
      }
      _messageControllers.clear();

      // 연결 컨트롤러 닫기
      await _connectionController.close();

      // Ably 연결 해제
      await _realtime?.close();

      _realtime = null;
      _rest = null;
      _currentUserId = null;
      _currentUserName = null;
      _currentUserAvatar = null;

      _logger.i('Chat repository disconnected');
    } catch (e) {
      _logger.e('Error disconnecting chat repository: $e');
    }
  }

  @override
  bool get isConnected =>
      _realtime?.connection.state == ably.ConnectionState.connected;

  @override
  String? get currentUserId => _currentUserId;
}

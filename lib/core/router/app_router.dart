import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/screens/auth/login_screen.dart';
import 'package:flutter_application_1/presentation/screens/booktalk/booktalk_main_screen.dart';
import 'package:flutter_application_1/presentation/screens/booktalk/chatroom_screen.dart';
import 'package:flutter_application_1/presentation/screens/chat/chat_list_screen.dart';
import 'package:flutter_application_1/presentation/screens/chat/chat_screen.dart';
import 'package:flutter_application_1/presentation/screens/root_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../presentation/screens/main/main_screen.dart';
import '../../presentation/screens/search/search_result_detail_screen.dart';
import '../../presentation/screens/search/search_screen.dart';

part 'app_router.g.dart';

// private navigators
final _shellNavigatorAKey = GlobalKey<NavigatorState>(debugLabel: 'shellA');
final _shellNavigatorBKey = GlobalKey<NavigatorState>(debugLabel: 'shellB');
final _shellNavigatorCKey = GlobalKey<NavigatorState>(debugLabel: 'shellC');

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return RootScreen(navigationShell: navigationShell);
        },
        branches: [
          // 첫 번째 탭: 책픽
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAKey,
            routes: [
              GoRoute(
                path: '/book-pick',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: MainScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'search',
                    builder: (context, state) => const SearchScreen(),
                  ),
                  GoRoute(
                    path: 'book/:bookId',
                    builder: (context, state) {
                      final bookId = state.pathParameters['bookId']!;
                      return SearchResultDetailScreen(bookId: bookId);
                    },
                  ),
                ],
              ),
            ],
          ),
          // 두 번째 탭: 책톡
          StatefulShellBranch(
            navigatorKey: _shellNavigatorBKey,
            routes: [
              GoRoute(
                path: '/book-talk',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: BookTalkMainScreen(),
                ),
                routes: [
                  GoRoute(
                    path: ':chatRoomId',
                    builder: (context, state) {
                      final chatRoomId = state.pathParameters['chatRoomId']!;
                      return ChatRoomScreen(chatRoomId: chatRoomId);
                    },
                  ),
                ],
              ),
            ],
          ),
          // 세 번째 탭: 채팅
          StatefulShellBranch(
            navigatorKey: _shellNavigatorCKey,
            routes: [
              GoRoute(
                path: '/chat',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ChatListScreen(),
                ),
                routes: [
                  GoRoute(
                    path: ':channelId',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      final channelName = extra?['channelName'] ?? state.pathParameters['channelId']!;
                      final channelTitle = extra?['channelTitle'] ?? '채팅';
                      return ChatScreen(
                        channelName: channelName,
                        channelTitle: channelTitle,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

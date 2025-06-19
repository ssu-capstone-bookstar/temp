import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      // 사용자가 같은 탭을 다시 탭했을 때,
      // 그 탭의 첫 페이지로 이동할지 여부를 결정합니다.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(context, index),
        type: BottomNavigationBarType.fixed, // 3개 이상의 탭을 위해 필요
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '책픽',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: '책톡',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: '채팅',
          ),
          // 추후 프로필 탭 등 추가 가능
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person_outline),
          //   label: '마이페이지',
          // ),
        ],
      ),
    );
  }
} 
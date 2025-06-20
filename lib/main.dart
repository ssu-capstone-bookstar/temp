import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/app_router.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // flutter_hooks 추가
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';

// configureDependencies가 어디서 오는지 확인 필요 (get_it, injectable 등)
// import 'package:flutter_application_1/injection.dart'; // 예시

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  // Kakao SDK 초기화는 runApp 이전에 한 번만 실행
  final String? kakaoAppKey = dotenv.env['KAKAO_NATIVE_KEY'];
  if (kakaoAppKey != null && kakaoAppKey.isNotEmpty) {
    KakaoSdk.init(nativeAppKey: kakaoAppKey);
  } else {
    debugPrint('카카오 SDK 초기화 실패: 앱 키가 없습니다.');
  }

  // configureDependencies()가 main 함수에 바로 있다면 여기에 두세요.
  // get_it 또는 injectable 같은 DI 셋업 함수일 가능성이 높습니다.
  // await configureDependencies(); // 필요한 경우 주석 해제

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(appRouterProvider)를 사용하여 GoRouter 인스턴스를 가져옵니다.
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Focus Timer & Book Pick',
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}

// 기존 MyHomePage를 HookConsumerWidget으로 변경
// 더 이상 StatefulWidget이 아니므로 State 클래스 (_MyHomePageState)는 필요 없습니다.
class MyHomePage extends HookConsumerWidget {
  // ConsumerWidget 대신 HookConsumerWidget
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // build 메서드 시그니처 변경
    // useState 훅을 사용하여 _counter 상태를 관리합니다.
    // 'value'는 현재 값이고, 'setCounter'는 값을 변경하는 함수입니다.
    final counter = useState<int>(
        0); // final ValueNotifier<int> counter = useState<int>(0);

    // _incrementCounter 메서드를 훅과 함께 인라인 함수로 변경
    void incrementCounter() {
      counter.value++; // counter.value를 직접 변경하면 UI가 자동으로 리빌드됩니다.
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title), // widget.title 대신 직접 title 사용
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              // counter.value를 사용하여 현재 상태 값에 접근
              '${counter.value}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementCounter, // 훅으로 관리되는 함수 호출
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

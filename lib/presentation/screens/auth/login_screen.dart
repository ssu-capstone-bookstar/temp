import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_constants.dart';
import 'package:flutter_application_1/data/models/member/provider_type.dart';
import 'package:flutter_application_1/presentation/viewmodels/auth/login_viewmodel.dart';
import 'package:flutter_application_1/presentation/viewmodels/auth/state/login_state.dart';
import 'package:flutter_application_1/presentation/widgets/social_login_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  Future<void> _showPrivacyPolicyDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final agreed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PrivacyPolicyDialog(),
    );
    if (agreed == true) {
      await ref.read(loginViewModelProvider.notifier).agreeToPolicy();
    } else {
      await ref.read(loginViewModelProvider.notifier).disagreeToPolicy();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('개인정보 처리 방침에 동의해야 서비스를 이용할 수 있습니다.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<LoginState>(loginViewModelProvider, (previous, next) {
      next.whenOrNull(
        success: () =>
            context.go('/book-pick'), // Or wherever you want to navigate
        error: (message) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message))),
        needsPolicyAgreement: () => _showPrivacyPolicyDialog(context, ref),
      );
    });

    final loginState = ref.watch(loginViewModelProvider);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(), // Top spacer
                  Column(
                    children: [
                      Hero(
                        tag: 'Logo',
                        child: Image.asset('assets/images/app_logo.png',
                            width: 100, height: 100),
                      ),
                      const SizedBox(height: 20),
                      Image.asset('assets/images/app_text_logo.png',
                          width: 150, height: 50),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 60.0, left: 20, right: 20),
                    child: Column(
                      children: [
                        SocialLoginButton(
                          providerType: ProviderType.google,
                          onPressed: () => ref
                              .read(loginViewModelProvider.notifier)
                              .login(ProviderType.google),
                        ),
                        const SizedBox(height: 10),
                        SocialLoginButton(
                          providerType: ProviderType.kakao,
                          onPressed: () => ref
                              .read(loginViewModelProvider.notifier)
                              .login(ProviderType.kakao),
                        ),
                        const SizedBox(height: 10),
                        SocialLoginButton(
                          providerType: ProviderType.apple,
                          onPressed: () => ref
                              .read(loginViewModelProvider.notifier)
                              .login(ProviderType.apple),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (loginState is LoginLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class PrivacyPolicyDialog extends StatefulWidget {
  const PrivacyPolicyDialog({super.key});

  @override
  State<PrivacyPolicyDialog> createState() => _PrivacyPolicyDialogState();
}

class _PrivacyPolicyDialogState extends State<PrivacyPolicyDialog> {
  bool _isAllAgreed = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('개인정보 처리방침 동의'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              title: const Text('전체 동의'),
              value: _isAllAgreed,
              onChanged: (value) {
                setState(() {
                  _isAllAgreed = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const Divider(),
            const Text(
              '개인정보 처리 방침',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: const SingleChildScrollView(
                child: Text(
                  AppConstants.privacyPolicy,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed:
              _isAllAgreed ? () => Navigator.of(context).pop(true) : null,
          child: const Text('동의'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/member/provider_type.dart';

class SocialLoginButton extends StatelessWidget {
  final ProviderType providerType;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.providerType,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    switch (providerType) {
      case ProviderType.google:
        return _buildGoogleButton();
      case ProviderType.kakao:
        return _buildKakaoButton();
      case ProviderType.apple:
        return _buildAppleButton();
    }
  }

  Widget _buildGoogleButton() {
    return Container(
      width: 340,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/google_logo.png', height: 24),
          const SizedBox(width: 10),
          const Text(
            'Google로 계속하기',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKakaoButton() {
    return Image.asset(
      'assets/images/kakao.png',
      width: 340,
      fit: BoxFit.fitWidth,
    );
  }

  Widget _buildAppleButton() {
    return Container(
      width: 340,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(2),
      ),
      child: const Center(
        child: Text(
          'Apple로 계속하기',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}

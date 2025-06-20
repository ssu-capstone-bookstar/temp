import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_colors.dart';
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
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    switch (providerType) {
      case ProviderType.google:
        return _buildGoogleButton(context);
      case ProviderType.kakao:
        return _buildKakaoButton(context);
      case ProviderType.apple:
        return _buildAppleButton(context);
    }
  }

  Widget _buildGoogleButton(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: 340,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: AppColors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/google_logo.png', height: 24),
          const SizedBox(width: 10),
          Text(
            'Google로 계속하기',
            style: textTheme.labelLarge?.copyWith(
              color: AppColors.black.withOpacity(0.87),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKakaoButton(BuildContext context) {
    return Image.asset(
      'assets/images/kakao.png',
      width: 340,
      fit: BoxFit.fitWidth,
    );
  }

  Widget _buildAppleButton(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: 340,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Center(
        child: Text(
          'Apple로 계속하기',
          style: textTheme.labelLarge?.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}

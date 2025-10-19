import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/common/constants/app_text_styles.dart';
import 'package:fabrica_de_software/common/constants/routes.dart';
import 'package:fabrica_de_software/widgets/custom_primary_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class OnboardingPag extends StatefulWidget {
  const OnboardingPag({super.key});

  @override
  State<OnboardingPag> createState() => _OnboardingPagState();
}

class _OnboardingPagState extends State<OnboardingPag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 100),
          Image.asset(
            'assets/banners/banner_logo_two.png',
            width: 300.0,
            height: 350.0,
          ),
          SizedBox(height: 15.0),
          Text(
            'Spend Smarter',
            textAlign: TextAlign.center,
            style: AppTextStyles.mediumText.copyWith(
              color: AppColors.greenlightTwo,
            ),
          ),
          Text(
            'Save More',
            textAlign: TextAlign.center,
            style: AppTextStyles.mediumText.copyWith(
              color: AppColors.greenlightTwo,
            ),
          ),
          SizedBox(height: 70.0),
          ClipRRect(
            child: Container(
              alignment: Alignment.center,
              child: PrimaryButton(
                text: 'Vamos começar',
                onPressed: () {
                  Navigator.pushNamed(context, NamedRoutes.signUp);
                },
              ),
            ),
          ),
          SizedBox(height: 5.0),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Sua conta ja existe?',
              style: AppTextStyles.smallText16.copyWith(color: AppColors.grey),
              children: <TextSpan>[
                TextSpan(
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap =
                            () => Navigator.pushReplacementNamed(
                              context,
                              NamedRoutes.signIn,
                            ),
                  text: ' Entrar',
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.greenlightTwo,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.0),
        ],
      ),
    );
  }
}

import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/common/constants/app_text_styles.dart';
import 'package:fabrica_de_software/common/constants/routes.dart';
import 'package:fabrica_de_software/locator.dart';
import 'package:fabrica_de_software/splash/splash_controller.dart';
import 'package:fabrica_de_software/splash/splash_state.dart';
import 'package:fabrica_de_software/widgets/custom_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _splashController = locator.get<SplashController>();

  @override
  void initState() {
    super.initState();
    _splashController.isUserLogged();
    _splashController.addListener(() {
      if (mounted) {
        if (_splashController.state is SplashStateSucess) {
          Navigator.pushReplacementNamed(context, NamedRoutes.home);
        } else if (_splashController.state is SplashStateError) {
          Navigator.pushReplacementNamed(context, NamedRoutes.initial);
        }
      }
    });
  }

  @override
  void dispose() {
    _splashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.gradientColors,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Financy',
              style: AppTextStyles.bigText.copyWith(color: AppColors.white),
            ),
            const CustomCircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

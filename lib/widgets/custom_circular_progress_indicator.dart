import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: 9.5,
      color: AppColors.greenlightTwo,
      backgroundColor: AppColors.white,
    );
  }
}

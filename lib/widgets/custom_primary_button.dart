import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Padding? padding;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greenlightTwo,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          minimumSize: const Size(200, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ).copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}

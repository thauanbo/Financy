import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/widgets/custom_primary_button.dart';
import 'package:flutter/material.dart';

Future<dynamic> customModelBottomSheet(
  BuildContext context, {
  required String text,
}) {
  return showModalBottomSheet(
    context: context,
    builder:
        (context) => Container(
          height: MediaQuery.of(context).size.width > 800 ? 400 : 210,
          width: MediaQuery.of(context).size.width > 800 ? 900 : 500,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(38),
              topRight: Radius.circular(38),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: AppColors.greenlightOne,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width > 800 ? 50 : 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: PrimaryButton(
                  text: 'Try Again',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
  );
}

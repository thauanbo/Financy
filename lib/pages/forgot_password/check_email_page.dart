import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/common/constants/app_text_styles.dart';
import 'package:fabrica_de_software/common/constants/routes.dart';
import 'package:fabrica_de_software/widgets/custom_primary_button.dart';
import 'package:flutter/material.dart';

class CheckEmailPage extends StatelessWidget {
  const CheckEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkgrey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              'Esqueceu a senha?',
              style: AppTextStyles.smallText16.copyWith(
                color: AppColors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Verifique seu e-mail',
              textAlign: TextAlign.center,
              style: AppTextStyles.mediumText.copyWith(
                color: AppColors.greenlightTwo,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            // Ilustração
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.greenlightOne.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.email_outlined,
                size: 60,
                color: AppColors.greenlightTwo,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Siga as instruções no seu e-mail para redefinir sua senha. Não se esqueça de verificar a caixa de spam também!',
              textAlign: TextAlign.center,
              style: AppTextStyles.smallText.copyWith(
                color: AppColors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
            const Spacer(),
            // Botão Login
            PrimaryButton(
              text: 'Entrar',
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  NamedRoutes.signIn,
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 20),
            // Texto adicional
            Text(
              'Não recebeu o e-mail? Verifique seu filtro de spam ou tente outro endereço de e-mail.',
              textAlign: TextAlign.center,
              style: AppTextStyles.smallText.copyWith(
                color: AppColors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

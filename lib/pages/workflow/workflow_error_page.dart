import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/common/constants/app_text_styles.dart';
import 'package:fabrica_de_software/widgets/custom_primary_button.dart';
import 'package:flutter/material.dart';

class WorkflowErrorPage extends StatelessWidget {
  const WorkflowErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenlightTwo,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Fluxo de Trabalho',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.mediumText.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      // Ícone de erro
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red.shade400,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        'Oops! Algo deu errado',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.smallText16.copyWith(
                          color: AppColors.darkgrey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        'Parece que houve um problema ao processar\nsua solicitação. Tente novamente.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.smallText.copyWith(
                          color: AppColors.grey,
                          fontWeight: FontWeight.normal,
                        ),
                      ),

                      const Spacer(),

                      // Botão Try Again
                      PrimaryButton(
                        text: 'Tente Novamente',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),

                      const SizedBox(height: 20),

                      // Link para suporte
                      GestureDetector(
                        onTap: () {
                          // Implementar contato com suporte
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Entrando em contato com o suporte...',
                              ),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        },
                        child: Text(
                          'Precisa de ajuda? Entre em contato conosco',
                          style: AppTextStyles.smallText.copyWith(
                            color: AppColors.greenlightTwo,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

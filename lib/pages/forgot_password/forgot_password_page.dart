import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/common/constants/app_text_styles.dart';
import 'package:fabrica_de_software/common/constants/routes.dart';
import 'package:fabrica_de_software/widgets/custom_primary_button.dart';
import 'package:fabrica_de_software/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                'Esqueci a Senha',
                style: AppTextStyles.smallText16.copyWith(
                  color: AppColors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Redefinir sua senha',
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
                  Icons.lock_reset,
                  size: 60,
                  color: AppColors.greenlightTwo,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Digite seu endereço de e-mail e um link será enviado para redefinir sua senha',
                textAlign: TextAlign.center,
                style: AppTextStyles.smallText.copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 40),
              // Campo de email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Seu email',
                  hintText: 'exemplo@email.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.greenlightTwo),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Por favor, insira um email válido';
                  }
                  return null;
                },
              ),
              const Spacer(),
              // Botão Send Link
              PrimaryButton(
                text: _isLoading ? 'Enviando...' : 'Link enviado',
                onPressed: _isLoading ? null : _sendResetLink,
              ),
              const SizedBox(height: 20),
              // Link para Sign Up
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, NamedRoutes.signUp);
                },
                child: Text(
                  "Não tem conta? Cadastre-se",
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
    );
  }

  void _sendResetLink() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Simular envio de email
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          // Navegar para a tela de verificação de email
          Navigator.pushNamed(context, NamedRoutes.checkEmail);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.errorSendingEmail(e.toString()),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}

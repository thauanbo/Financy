import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/common/constants/app_text_styles.dart';
import 'package:fabrica_de_software/common/constants/routes.dart';
import 'package:fabrica_de_software/locator.dart';
import 'package:fabrica_de_software/pages/sign_in/sign_in_controller.dart';
import 'package:fabrica_de_software/pages/sign_in/sign_in_state.dart';
import 'package:fabrica_de_software/widgets/custom_bottom_sheet.dart';
import 'package:fabrica_de_software/generated/app_localizations.dart';

import 'package:fabrica_de_software/widgets/custom_primary_button.dart';
import 'package:fabrica_de_software/widgets/custom_text_form_field.dart';
import 'package:fabrica_de_software/widgets/password_form_field.dart';
import 'package:fabrica_de_software/widgets/validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _controller = locator.get<SignInController>();
  final _finalKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.state is SignInStateLoading) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(width: 20),
                      Text(AppLocalizations.of(context)!.signingIn),
                    ],
                  ),
                ),
              ),
        );
      }
      if (_controller.state is SignInStateSucess) {
        if (Navigator.canPop(context)) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        Navigator.pushReplacementNamed(context, NamedRoutes.home);
      }
      if (_controller.state is SignInStateError) {
        final error = _controller.state as SignInStateError;
        if (Navigator.canPop(context)) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        customModelBottomSheet(context, text: error.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 40),
          Text(
            'Bem Vindo de Volta',
            textAlign: TextAlign.center,
            style: AppTextStyles.mediumText.copyWith(
              color: AppColors.greenlightTwo,
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.1),
            child: Image.asset(
              'assets/banners/sign_in.png',
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 40),
          Form(
            key: _finalKey,
            child: Column(
              children: [
                CustomTextFormField(
                  labelText: 'Seu Email',
                  hinText: 'Entre com seu email',
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  controller: _emailController,
                  validator: Validator.validatorEmail,
                  maxLength: 50,
                  obscureText: false,
                ),
                PasswordFormField(
                  labelText: 'Sua Senha',
                  hinText: 'Entre com sua senha',
                  maxLength: 10,
                  controller: _passwordController,
                  validator: Validator.validatorPassword,
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: PrimaryButton(
              text: 'Entrar',
              onPressed: () {
                final valid = _finalKey.currentState?.validate();
                if (valid == true) {
                  _controller.signIn(
                    _emailController.text,
                    _passwordController.text,
                  );
                }
                // Form validation handled by UI feedback
              },
            ),
          ),
          // Link Forgot Password
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, NamedRoutes.forgotPassword);
                },
                child: Text(
                  'Esqueci minha senha',
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.greenlightTwo,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: 'Nao tem conta?',
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.grey,
                  ),
                  children: [
                    TextSpan(
                      text: ' Cadastre-se',
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacementNamed(
                                context,
                                NamedRoutes.signUp,
                              );
                            },
                      style: AppTextStyles.smallText16.copyWith(
                        color: AppColors.greenlightTwo,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

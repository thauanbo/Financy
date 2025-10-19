import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/common/constants/app_text_styles.dart';
import 'package:fabrica_de_software/common/constants/routes.dart';
import 'package:fabrica_de_software/locator.dart';
import 'package:fabrica_de_software/pages/sign_up/sign_up_controller.dart';
import 'package:fabrica_de_software/pages/sign_up/sign_up_state.dart';
import 'package:fabrica_de_software/widgets/custom_bottom_sheet.dart';
import 'package:fabrica_de_software/generated/app_localizations.dart';

import 'package:fabrica_de_software/widgets/custom_primary_button.dart';
import 'package:fabrica_de_software/widgets/custom_text_form_field.dart';
import 'package:fabrica_de_software/widgets/password_form_field.dart';
import 'package:fabrica_de_software/widgets/uppercase_text_format.dart';
import 'package:fabrica_de_software/widgets/validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _controller = locator.get<SignUpController>();
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
      if (_controller.getState is SignUpLoadingState) {
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
                      Text(AppLocalizations.of(context)!.creatingAccount),
                    ],
                  ),
                ),
              ),
        );
      }
      if (_controller.getState is SignUpSuccessState) {
        if (Navigator.canPop(context)) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        Navigator.pushReplacementNamed(context, NamedRoutes.home);
      }
      if (_controller.getState is SignUpErrorState) {
        final error = _controller.getState as SignUpErrorState;
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.1),
            child: Image.asset(
              'assets/banners/sign_up_img.png',
              height: 200,
              fit: BoxFit.contain,
            ),
          ),

          Form(
            key: _finalKey,
            child: Column(
              children: [
                CustomTextFormField(
                  labelText: 'Seu nome',
                  hinText: 'Entre com seu nome',
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                  validator: Validator.validatorName,
                  maxLength: 30,
                  inputFormatters: [UppercaseTextFormat()],
                  obscureText: false,
                ),
                CustomTextFormField(
                  labelText: 'Seu email',
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
                  labelText: 'Escolha sua senha',
                  hinText: 'Entre com seu password',
                  maxLength: 10,
                  controller: _passwordController,
                  helperText:
                      'Deve ter pelo menos 8 caracteres, 1 letra maiúscula, 1 letra minúscula e 1 número',
                  validator: Validator.validatorPassword,
                ),
                PasswordFormField(
                  labelText: 'Confirmar senha',
                  hinText: 'Re-confirme sua senha',
                  maxLength: 10,
                  validator:
                      (value) => Validator.validatorConfirmPassword(
                        value,
                        _passwordController.text,
                      ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: PrimaryButton(
              text: 'Cadastre-se',
              onPressed: () {
                final valid = _finalKey.currentState?.validate();
                if (valid == true) {
                  _controller.signUp(
                    _nameController.text,
                    _emailController.text,
                    _passwordController.text,
                  );
                }
                // Form validation handled by UI feedback
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: 'Já tem conta?',
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.grey,
                  ),
                  children: [
                    TextSpan(
                      text: ' Entrar',
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacementNamed(
                                context,
                                NamedRoutes.signIn,
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

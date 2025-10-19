import 'package:fabrica_de_software/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final TextEditingController? controller;
  final String hinText;
  final String labelText;
  final String? helperText;
  final String? Function(String?)? validator;
  const PasswordFormField({
    super.key,
    this.padding,
    this.controller,
    required this.hinText,
    required this.labelText,
    this.validator,
    required int maxLength,
    this.helperText,
  });

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      validator: widget.validator,
      helperText: widget.helperText,
      suffixIcon: InkWell(
        borderRadius: BorderRadius.circular(50),
        child: Icon(isHidden ? Icons.visibility_off : Icons.visibility),
        onTap: () {
          setState(() {
            isHidden = !isHidden;
          });
        },
      ),
      controller: widget.controller,
      padding: widget.padding,
      hinText: widget.hinText,
      labelText: widget.labelText,
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.visiblePassword,
      obscureText: isHidden,
    );
  }
}

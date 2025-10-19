import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final String hinText;
  final String labelText;
  final TextCapitalization textCapitalization;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? helperText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  const CustomTextFormField({
    super.key,
    this.padding,
    required this.hinText,
    required this.labelText,
    required this.textCapitalization,
    this.controller,
    this.keyboardType,
    this.maxLength,
    this.textInputAction,
    this.suffixIcon,
    required this.obscureText,
    this.inputFormatters,
    this.validator,
    this.helperText,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final defaultBorder = OutlineInputBorder();

  String? _helperText;

  @override
  void initState() {
    super.initState();
    _helperText = widget.helperText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          widget.padding ??
          (MediaQuery.of(context).size.width > 800
              ? EdgeInsets.symmetric(horizontal: 350.0, vertical: 15.0)
              : EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0)),
      child: TextFormField(
        onChanged: (value) {
          if (value.length == 1) {
            setState(() {
              _helperText = null;
            });
          } else if (value.isEmpty) {
            setState(() {
              _helperText = widget.helperText;
            });
          }
        },

        validator: widget.validator,
        inputFormatters: widget.inputFormatters,
        obscureText: widget.obscureText,
        textInputAction: widget.textInputAction,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        textCapitalization: widget.textCapitalization,
        decoration: InputDecoration(
          helperText: _helperText,
          helperMaxLines: 3,
          errorStyle: TextStyle(color: Colors.red),
          suffixIcon: widget.suffixIcon,
          focusedBorder: defaultBorder.copyWith(
            borderSide: BorderSide(color: AppColors.greenlightOne),
          ),
          errorBorder: defaultBorder.copyWith(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: defaultBorder.copyWith(
            borderSide: BorderSide(color: Colors.red),
          ),
          enabledBorder: defaultBorder.copyWith(
            borderSide: BorderSide(color: AppColors.greenlightTwo),
          ),
          hintText: widget.hinText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: widget.labelText,
          labelStyle: TextStyle(color: AppColors.grey),
        ),
      ),
    );
  }
}

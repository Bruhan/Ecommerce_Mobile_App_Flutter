import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscure;
  final Widget? prefix;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.obscure = false,
    this.prefix,
    this.suffix,
    this.validator,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscure,
      validator: widget.validator,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: widget.prefix,
        suffixIcon: widget.suffix,
      ),
    );
  }
}

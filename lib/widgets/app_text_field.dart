import 'package:flutter/material.dart';
import '../globals/theme.dart';

/// Unified text field used across the app (auth, search, forms).
/// Supports prefix/suffix icons, readOnly, onTap, validators, etc.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;

  final bool obscure;
  final Widget? prefix;
  final Widget? suffix;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  final bool readOnly;
  final VoidCallback? onTap;
  final bool enabled;

  final int? maxLines; // defaults to 1 if null and not obscured
  final int? minLines;
  final EdgeInsetsGeometry? contentPadding;

  const AppTextField({
    super.key,
    this.controller,
    this.hint,
    this.obscure = false,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.enabled = true,
    this.maxLines,
    this.minLines,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      readOnly: readOnly,
      onTap: onTap,
      enabled: enabled,
      maxLines: obscure ? 1 : (maxLines ?? 1),
      minLines: minLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefix,
        suffixIcon: suffix,
        filled: true,
        // If your theme doesn't define surface, use Colors.white instead.
        fillColor: AppColors.surface,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: BorderSide(color: AppColors.fieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: BorderSide(color: AppColors.fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: BorderSide(color: AppColors.textPrimary, width: 1.4),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: BorderSide(color: AppColors.fieldBorder.withOpacity(0.5)),
        ),
      ),
      style: AppTextStyles.body,
    );
  }
}

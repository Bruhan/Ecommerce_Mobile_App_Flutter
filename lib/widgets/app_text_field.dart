import 'package:flutter/material.dart';
import '../globals/theme.dart';

class AppTextField extends StatelessWidget {
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
    this.onFieldSubmitted,
    this.readOnly = false,
    this.onTap,
    this.enabled = true,
    this.maxLines,
    this.minLines,
    this.contentPadding,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
  });

  // Core
  final TextEditingController? controller;
  final String? hint;
  final bool obscure;

  // Icons
  final Widget? prefix;
  final Widget? suffix;

  // Input behavior
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  // Interaction
  final bool readOnly;
  final VoidCallback? onTap;
  final bool enabled;

  // Layout
  final int? maxLines; // if obscured, forced to 1
  final int? minLines;
  final EdgeInsetsGeometry? contentPadding;

  // Extras
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      readOnly: readOnly,
      onTap: onTap,
      enabled: enabled,
      autofillHints: autofillHints,
      textCapitalization: textCapitalization,
      maxLines: obscure ? 1 : (maxLines ?? 1),
      minLines: minLines,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.body.copyWith(
          color: AppColors.textSecondary.withOpacity(0.7),
        ),
        prefixIcon: prefix,
        suffixIcon: suffix,
        isDense: true,
        filled: true,
        // Use your token; if you have `fieldBackground`, switch to that:
        fillColor: AppColors.surface,
        contentPadding:
            contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: BorderSide(color: AppColors.danger, width: 1.4),
        ),
      ),
    );
  }
}

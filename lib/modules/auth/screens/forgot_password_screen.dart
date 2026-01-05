import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/widgets/app_button.dart';
import 'package:ecommerce_mobile/widgets/app_text_field.dart';
import 'package:ecommerce_mobile/globals/text_styles.dart' as TextStyles;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _loading = false);

    Navigator.pushNamed(
      context,
      Routes.otp,
      arguments: _email.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            AppSpacing.xl + bottom,
          ),
          child: Column(
            children: [
              // Title + Subtitle
              Text(
                'Reset Your Password',
                style: TextStyles.AppTextStyles.h1?.copyWith(
                  color: AppColors.brand,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Enter your registered email address to receive an OTP\nfor password reset.',
                style: TextStyles.AppTextStyles.subtitle
                    ?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AppSpacing.xxl),

              // White card container
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registered Email Address',
                        style: TextStyles.AppTextStyles.body,
                      ),
                      SizedBox(height: AppSpacing.xs),

                      AppTextField(
                        controller: _email,
                        hint: 'Enter your registered email address',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Email is required';
                          final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v);
                          return ok ? null : 'Enter a valid email';
                        },
                      ),

                      SizedBox(height: AppSpacing.lg),

                      // Green Send OTP button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _sendOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brand,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadii.sm),
                            ),
                          ),
                          child: Text(
                            _loading ? 'Sending...' : 'Send OTP',
                            style: TextStyles.AppTextStyles.body?.copyWith(
                              color: AppColors.surface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: AppSpacing.lg),

                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Back to Login',
                            style: TextStyles.AppTextStyles.body?.copyWith(
                              color: AppColors.brand,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

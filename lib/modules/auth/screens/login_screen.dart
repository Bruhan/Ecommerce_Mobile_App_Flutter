import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/widgets/app_button.dart';
import 'package:ecommerce_mobile/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    // Simulate backend delay
    await Future.delayed(const Duration(milliseconds: 700));

    setState(() => _loading = false);

    // ✅ Navigate to Home and clear back stack
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.home,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.xl,
                  AppSpacing.xl,
                  AppSpacing.xl + bottom,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Login to your account', style: AppTextStyles.h1),
                      SizedBox(height: AppSpacing.xs),
                      Text("It’s great to see you again.",
                          style: AppTextStyles.subtitle),
                      SizedBox(height: AppSpacing.xxl),
                      Text('Email', style: AppTextStyles.body),
                      SizedBox(height: AppSpacing.xs),
                      AppTextField(
                        controller: _email,
                        hint: 'Enter your email address',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Email is required';
                          final ok =
                              RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim());
                          return ok ? null : 'Enter a valid email';
                        },
                      ),
                      SizedBox(height: AppSpacing.lg),
                      Text('Password', style: AppTextStyles.body),
                      SizedBox(height: AppSpacing.xs),
                      AppTextField(
                        controller: _password,
                        hint: 'Enter your password',
                        obscure: _obscure,
                        suffix: IconButton(
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Password is required';
                          }
                          if (v.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, Routes.forgotPassword),
                          child: const Text('Reset your password'),
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      AppButton(
                        label: _loading ? 'Loading...' : 'Login',
                        onPressed: _loading ? null : _onLogin,
                      ),
                      SizedBox(height: AppSpacing.xl),
                      Row(
                        children: [
                          Expanded(child: Divider(color: AppColors.divider)),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            child: Text('Or', style: AppTextStyles.caption),
                          ),
                          Expanded(child: Divider(color: AppColors.divider)),
                        ],
                      ),
                      SizedBox(height: AppSpacing.lg),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.fieldBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadii.lg),
                          ),
                          backgroundColor: AppColors.surface,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(
                          'Login with Google',
                          style: AppTextStyles.body
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.fieldBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadii.lg),
                          ),
                          backgroundColor: AppColors.surface,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(
                          'Login with Facebook',
                          style: AppTextStyles.body
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: AppSpacing.xl),
                      Center(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Don’t have an account? ',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushReplacementNamed(
                                  context, Routes.register),
                              child: Text(
                                'Join',
                                style: AppTextStyles.body.copyWith(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

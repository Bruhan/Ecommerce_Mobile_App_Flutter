import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/widgets/app_button.dart';
import 'package:ecommerce_mobile/widgets/app_text_field.dart';

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

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600)); // TODO: API call
    setState(() => _loading = false);
    Navigator.pushNamed(context, Routes.otp, arguments: _email.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
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
                Text('Forgot password', style: AppTextStyles.h1),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'Enter your email for the verification process.\nWe will send 4 digits code to your email.',
                  style: AppTextStyles.subtitle,
                ),
                SizedBox(height: AppSpacing.xxl),
                Text('Email', style: AppTextStyles.body),
                SizedBox(height: AppSpacing.xs),
                AppTextField(
                  controller: _email,
                  hint: 'cody.fisher45@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    final ok =
                        RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim());
                    return ok ? null : 'Enter a valid email';
                  },
                ),
                SizedBox(height: AppSpacing.xl),
                AppButton(
                  label: 'Send Code',
                  onPressed: _sendCode,
                  loading: _loading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

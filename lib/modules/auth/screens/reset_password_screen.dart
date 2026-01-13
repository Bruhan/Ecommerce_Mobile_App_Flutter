import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/widgets/app_button.dart';
import 'package:ecommerce_mobile/widgets/app_text_field.dart';

import '../../../globals/text_styles.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _p1 = TextEditingController();
  final _p2 = TextEditingController();
  bool _ob1 = true, _ob2 = true;
  bool _loading = false;

  @override
  void dispose() { _p1.dispose(); _p2.dispose(); super.dispose(); }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() => _loading = false);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.lg)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.check_circle_rounded, size: 48, color: AppColors.success),
            const SizedBox(height: AppSpacing.md),
            Text('Password Changed!', style: AppTextStyles.h2),
            const SizedBox(height: AppSpacing.xs),
            Text('You can now use your new password to login to your account.',
                style: AppTextStyles.subtitle, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Login'),
              ),
            ),
          ]),
        ),
      ),
    );

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, Routes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.xl + bottom),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Reset Password', style: AppTextStyles.h1),
              const SizedBox(height: AppSpacing.xs),
              Text('Set the new password for your account so you can login and access all the features.', style: AppTextStyles.subtitle),
              const SizedBox(height: AppSpacing.xxl),

              Text('Password', style: AppTextStyles.body),
              const SizedBox(height: AppSpacing.xs),
              AppTextField(
                controller: _p1, hint: '**********', obscure: _ob1,
                suffix: IconButton(icon: Icon(_ob1 ? Icons.visibility_rounded : Icons.visibility_off_rounded), onPressed: ()=> setState(()=> _ob1 = !_ob1)),
                validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
              ),
              const SizedBox(height: AppSpacing.lg),

              Text('Password', style: AppTextStyles.body),
              const SizedBox(height: AppSpacing.xs),
              AppTextField(
                controller: _p2, hint: '**********', obscure: _ob2,
                suffix: IconButton(icon: Icon(_ob2 ? Icons.visibility_rounded : Icons.visibility_off_rounded), onPressed: ()=> setState(()=> _ob2 = !_ob2)),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please confirm password';
                  if (v != _p1.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              AppButton(label: 'Continue', onPressed: _continue, loading: _loading),
            ]),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/widgets/app_button.dart';
import 'package:ecommerce_mobile/widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600)); // TODO: API
    setState(() => _loading = false);

    // TODO: navigate on success
    // if (!mounted) return;
    // Navigator.pushReplacementNamed(context, Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.xl + bottomInset,
            ),
            child: AutofillGroup(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create an account', style: AppTextStyles.h1),
                    SizedBox(height: AppSpacing.xs),
                    Text("Let’s create your account.",
                        style: AppTextStyles.subtitle),
                    SizedBox(height: AppSpacing.xxl),
                    Text('Full Name', style: AppTextStyles.body),
                    SizedBox(height: AppSpacing.xs),
                    AppTextField(
                      controller: _name,
                      hint: 'Enter your full name',
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Name is required'
                          : null,
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Text('Email', style: AppTextStyles.body),
                    SizedBox(height: AppSpacing.xs),
                    AppTextField(
                      controller: _email,
                      hint: 'Enter your email address',
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
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
                      validator: (v) => (v == null || v.length < 6)
                          ? 'Min 6 characters'
                          : null,
                    ),
                    SizedBox(height: AppSpacing.xl),
                    Text(
                      'By signing up you agree to our Terms, Privacy Policy, and Cookie Use',
                      style: AppTextStyles.caption,
                    ),
                    SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: 'Create an Account',
                      onPressed: _onRegister,
                      loading: _loading,
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
                        'Sign Up with Google',
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
                        'Sign Up with Facebook',
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
                            'Already have an account? ',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(
                              context,
                              Routes.login,
                            ),
                            child: Text(
                              'Log In',
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
    );
  }
}

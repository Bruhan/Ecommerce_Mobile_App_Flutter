import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/widgets/app_text_field.dart';
import 'package:ecommerce_mobile/globals/text_styles.dart' as TextStyles;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _mobile = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  // validation state
  bool _nameValid = false;
  bool _emailValid = false;
  bool _mobileValid = false;
  bool _passwordValid = false;
  bool _confirmValid = false;

  // UI state
  bool _obscure = true;
  bool _loading = false;
  int _passwordScore = 0; // 0..4

  @override
  void initState() {
    super.initState();
    _name.addListener(_validateName);
    _email.addListener(_validateEmail);
    _mobile.addListener(_validateMobile);
    _password.addListener(() {
      _evaluatePassword();
      _validatePassword();
      _validateConfirm();
    });
    _confirm.addListener(_validateConfirm);
  }

  @override
  void dispose() {
    _name.removeListener(_validateName);
    _email.removeListener(_validateEmail);
    _mobile.removeListener(_validateMobile);
    _password.removeListener(_evaluatePassword);
    _password.removeListener(_validatePassword);
    _confirm.removeListener(_validateConfirm);

    _name.dispose();
    _email.dispose();
    _mobile.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  // Validators (used for animations and final form validation)
  void _validateName() {
    final ok = _name.text.trim().isNotEmpty;
    if (ok != _nameValid) setState(() => _nameValid = ok);
  }

  void _validateEmail() {
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_email.text.trim());
    if (ok != _emailValid) setState(() => _emailValid = ok);
  }

  void _validateMobile() {
    final ok = RegExp(r'^[6-9]\d{9}$').hasMatch(_mobile.text.trim());
    if (ok != _mobileValid) setState(() => _mobileValid = ok);
  }

  void _validatePassword() {
    final v = _password.text;
    final ok = v.length >= 6;
    if (ok != _passwordValid) setState(() => _passwordValid = ok);
  }

  void _validateConfirm() {
    final ok = _confirm.text == _password.text && _confirm.text.isNotEmpty;
    if (ok != _confirmValid) setState(() => _confirmValid = ok);
  }

  // Simple password strength scoring
  void _evaluatePassword() {
    final v = _password.text;
    int score = 0;
    if (v.length >= 6) score++; // length
    if (RegExp(r'[0-9]').hasMatch(v)) score++; // digit
    if (RegExp(r'[A-Z]').hasMatch(v)) score++; // uppercase
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(v)) score++; // special
    if (score != _passwordScore) setState(() => _passwordScore = score);
  }

  String _passwordLabel() {
    switch (_passwordScore) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
      default:
        return 'Strong';
    }
  }

  Color _passwordColor() {
    switch (_passwordScore) {
      case 0:
      case 1:
        return Colors.redAccent;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.lightGreen;
      case 4:
      default:
        return Colors.green;
    }
  }

  Future<void> _onRegister() async {
    // run final validators
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) {
      // ensure animations reflect errors
      _validateName();
      _validateEmail();
      _validateMobile();
      _validatePassword();
      _validateConfirm();
      return;
    }

    setState(() => _loading = true);

    // simulate network call
    await Future.delayed(const Duration(milliseconds: 900));

    setState(() => _loading = false);

    // success popup
    _showSuccessPopup();
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.lg)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // success icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.brand,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(Icons.check, color: AppColors.surface, size: 40),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Account Created',
                  style:
                      TextStyles.AppTextStyles.h2?.copyWith(color: AppColors.textPrimary),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Your account has been created successfully. Proceed to login.',
                  style: TextStyles.AppTextStyles.body?.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx); // close dialog
                      Navigator.pushReplacementNamed(context, Routes.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brand,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadii.sm)),
                      minimumSize: const Size(double.infinity, 44),
                    ),
                    child: Text('Go to Login',
                        style: TextStyles.AppTextStyles.body
                            ?.copyWith(color: AppColors.surface, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget requiredLabel(String text) {
    return Row(
      children: [
        Text(text, style: TextStyles.AppTextStyles.body?.copyWith(color: AppColors.textPrimary)),
        const SizedBox(width: 6),
        const Text('*', style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _animatedValidationHint(bool valid, String? message) {
    // when valid==true, show green check + "Looks good"
    // when valid==false and message!=null show message
    final show = valid || (message != null && message.isNotEmpty);
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: show ? 1.0 : 0.0,
        child: Padding(
          padding: EdgeInsets.only(top: show ? AppSpacing.xs : 0),
          child: Row(
            children: [
              if (valid) ...[
                Icon(Icons.check_circle, size: 16, color: Colors.green),
                SizedBox(width: AppSpacing.xs),
                Text('Looks good', style: TextStyles.AppTextStyles.caption?.copyWith(color: Colors.green)),
              ] else if (message != null) ...[
                Icon(Icons.error_outline, size: 16, color: Colors.redAccent),
                SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(message, style: TextStyles.AppTextStyles.caption?.copyWith(color: Colors.redAccent)),
                ),
              ],
            ],
          ),
        ),
      ),
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
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title + subtitle
                  Text(
                    'Create Account',
                    style: TextStyles.AppTextStyles.h1?.copyWith(color: AppColors.brand),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Create an account to explore timeless books and vintage treasures.',
                    style: TextStyles.AppTextStyles.subtitle?.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // White Card (FORM)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Full Name
                          requiredLabel("Full Name"),
                          SizedBox(height: AppSpacing.xs),
                          AppTextField(
                            controller: _name,
                            hint: 'Enter your full name',
                            validator: (v) => (v == null || v.isEmpty) ? 'Name is required' : null,
                          ),
                          _animatedValidationHint(_nameValid, _name.text.trim().isEmpty ? null : null),
                          SizedBox(height: AppSpacing.lg),

                          // Email
                          requiredLabel("Email Address"),
                          SizedBox(height: AppSpacing.xs),
                          AppTextField(
                            controller: _email,
                            hint: 'Enter your email address',
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Email is required';
                              final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v);
                              return ok ? null : 'Enter a valid email';
                            },
                          ),
                          _animatedValidationHint(_emailValid, (_email.text.isEmpty) ? null : (!_emailValid ? 'Enter a valid email' : null)),
                          SizedBox(height: AppSpacing.lg),

                          // Mobile
                          requiredLabel("Mobile Number"),
                          SizedBox(height: AppSpacing.xs),
                          AppTextField(
                            controller: _mobile,
                            hint: 'Enter mobile number',
                            keyboardType: TextInputType.phone,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Mobile number required';
                              final ok = RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim());
                              return ok ? null : 'Enter a valid mobile number';
                            },
                          ),
                          _animatedValidationHint(_mobileValid, (_mobile.text.isEmpty) ? null : (!_mobileValid ? 'Enter a valid mobile number' : null)),
                          SizedBox(height: AppSpacing.lg),

                          // Password
                          requiredLabel("Password"),
                          SizedBox(height: AppSpacing.xs),
                          AppTextField(
                            controller: _password,
                            hint: 'Create a password',
                            obscure: _obscure,
                            suffix: IconButton(
                              icon: Icon(_obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Password is required';
                              if (v.length < 6) return 'Password must be at least 6 characters';
                              return null;
                            },
                          ),

                          // Password strength meter
                          SizedBox(height: AppSpacing.xs),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 180),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // visual bar
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    height: 8,
                                    color: AppColors.fieldBorder,
                                    child: Row(
                                      children: List.generate(4, (i) {
                                        final fill = i < _passwordScore;
                                        return Expanded(
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 220),
                                            margin: const EdgeInsets.symmetric(horizontal: 4),
                                            decoration: BoxDecoration(
                                              color: fill ? _passwordColor() : Colors.transparent,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xs),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Strength: ${_passwordLabel()}',
                                      style: TextStyles.AppTextStyles.caption?.copyWith(color: _passwordScore >= 3 ? Colors.green : (_passwordScore == 2 ? Colors.orange : Colors.redAccent)),
                                    ),
                                    if (_passwordScore < 4)
                                      Text('Use uppercase, numbers, symbols', style: TextStyles.AppTextStyles.caption?.copyWith(color: AppColors.textSecondary)),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          _animatedValidationHint(_passwordValid, (_password.text.isEmpty) ? null : (!_passwordValid ? 'Password must be at least 6 characters' : null)),
                          SizedBox(height: AppSpacing.lg),

                          // Confirm Password
                          requiredLabel("Confirm Password"),
                          SizedBox(height: AppSpacing.xs),
                          AppTextField(
                            controller: _confirm,
                            hint: 'Confirm your password',
                            obscure: _obscure,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Confirm password';
                              if (v != _password.text) return 'Passwords do not match';
                              return null;
                            },
                          ),
                          _animatedValidationHint(_confirmValid, (_confirm.text.isEmpty) ? null : (!_confirmValid ? 'Passwords do not match' : null)),
                          SizedBox(height: AppSpacing.xl),

                          // Green CTA button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _onRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.brand,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: _loading
                                  ? SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.2,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.surface),
                                      ),
                                    )
                                  : Text(
                                      'Create a Moore Market Account',
                                      style: TextStyles.AppTextStyles.body?.copyWith(
                                        color: AppColors.surface,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),

                          SizedBox(height: AppSpacing.md),

                          Center(
                            child: Text(
                              'By creating an account, you agree to our Terms of Service and Privacy Policy.',
                              style: TextStyles.AppTextStyles.caption?.copyWith(color: AppColors.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(height: AppSpacing.lg),

                          Center(
                            child: Wrap(
                              children: [
                                Text(
                                  'Already have an account? ',
                                  style: TextStyles.AppTextStyles.body?.copyWith(color: AppColors.textSecondary),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pushReplacementNamed(context, Routes.login),
                                  child: Text(
                                    'Sign In',
                                    style: TextStyles.AppTextStyles.body?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.brand,
                                      decoration: TextDecoration.underline,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

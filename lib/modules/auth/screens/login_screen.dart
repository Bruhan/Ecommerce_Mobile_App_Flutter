import 'dart:convert';

import 'package:ecommerce_mobile/globals/globals.dart';
import 'package:ecommerce_mobile/modules/auth/constants/auth-api.routes.dart';
import 'package:ecommerce_mobile/modules/auth/types/login_with_password_response.dart';
import 'package:ecommerce_mobile/modules/general/types/api.types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/widgets/app_text_field.dart';
import 'package:ecommerce_mobile/globals/text_styles.dart' as TextStyles;
import '../../../network/api_service.dart';
import '../lib/jwt.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // Password fields
  final _username = TextEditingController();
  final _password = TextEditingController();

  // OTP fields
  final _mobile = TextEditingController();
  String _countryPrefix = '+91';

  bool _obscure = true;
  bool _loading = false;
  bool _sendingOtp = false;

  // Top tab selection (password / otp)
  bool _usePassword = true;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _mobile.dispose();
    super.dispose();
  }

  // existing password login flow
  Future<void> _onLoginPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final ApiService _apiService = ApiService();
    try {
      final reqBody = {
        'authenticationId': _username.text.trim(),
        'password': _password.text,
        'loginType': "user"
      };

      print(reqBody);

      final res =
          await _apiService.post(AuthApiRoutes.loginWithPassword, json.encode(reqBody));

      WebResponse<LoginWithPasswordResponse> response =
          WebResponse.fromJson(res, (data) {
        return LoginWithPasswordResponse.fromJson(data);
      });

      if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Unauthorized')),
        );
        setState(() => _loading = false);
        return;
      }

      if (response.statusCode == 200) {
        final LoginWithPasswordResponse loginData = response.results!;
        try {
          final Map<String, dynamic>? decodedToken = JWT.processJwt(loginData.token);
          // optionally use decodedToken...
        } catch (_) {
          // ignore decode errors
        }

        await storage.write(key: 'jwt', value: loginData.token);

        setState(() => _loading = false);

        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.home,
          (route) => false,
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? 'Login failed')),
      );
      setState(() => _loading = false);
    } catch (err, st) {
      debugPrint('Login error: $err\n$st');
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
      );
    }
  }

  // OTP send flow
  Future<void> _sendOtp() async {
    final mobileValue = _mobile.text.trim();
    if (mobileValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter mobile number')),
      );
      return;
    }

    // ensure exactly 10 digits
    if (mobileValue.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mobile number must be 10 digits')),
      );
      return;
    }

    // basic validation for Indian mobile numbers
    final ok = RegExp(r'^[6-9]\d{9}$').hasMatch(mobileValue);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid mobile number')),
      );
      return;
    }

    setState(() => _sendingOtp = true);

    // simulate network send, replace with real API call if required
    await Future.delayed(const Duration(milliseconds: 700));

    setState(() => _sendingOtp = false);

    // navigate to OTP screen with the full mobile number (prefix + number)
    final fullNumber = '$_countryPrefix$mobileValue';
    Navigator.pushNamed(context, Routes.otp, arguments: fullNumber);
  }

  void _showSignUpPopup() {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: AppColors.brand,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.lg)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // top circle icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.book_rounded,
                      size: 28,
                      color: AppColors.brand,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                Text(
                  'Join Moore Market',
                  style: TextStyles.AppTextStyles.h2?.copyWith(color: AppColors.surface),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Sign up today and earn 5 loyalty points on your purchase and enjoy even more exclusive member benefits!',
                  style: TextStyles.AppTextStyles.body?.copyWith(color: AppColors.surface),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.lg),
                Divider(color: AppColors.fieldBorder, thickness: 0.6),
                SizedBox(height: AppSpacing.sm),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushNamed(context, Routes.register);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.surface),
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.sm),
                    ),
                  ),
                  child: Text('Create Account', style: TextStyles.AppTextStyles.body?.copyWith(color: AppColors.surface)),
                ),
                SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('Already have an account? Sign In', style: TextStyles.AppTextStyles.caption?.copyWith(color: AppColors.surface)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ------------ UPDATED TOP TABS: BOTH BUTTONS EQUAL SIZE ------------
  Widget _buildTopTabs(BuildContext ctx) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _usePassword = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _usePassword ? AppColors.brand : AppColors.surface,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                  color: _usePassword ? AppColors.brand : AppColors.fieldBorder,
                ),
              ),
            ),
            child: Text(
              'Sign In with Password',
              style: TextStyles.AppTextStyles.body?.copyWith(
                color: _usePassword ? AppColors.surface : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: ElevatedButton(
            onPressed: () => setState(() => _usePassword = false),
            style: ElevatedButton.styleFrom(
              backgroundColor: !_usePassword ? AppColors.brand : AppColors.surface,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(
                  color: !_usePassword ? AppColors.brand : AppColors.fieldBorder,
                ),
              ),
            ),
            child: Text(
              'Sign In With OTP',
              style: TextStyles.AppTextStyles.body?.copyWith(
                color: !_usePassword ? AppColors.surface : AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
  // -----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.xl,
                  AppSpacing.xl,
                  AppSpacing.xl + bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/logo_transparent.png',
                      width: 110,
                      height: 70,
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: AppSpacing.md),

                    // Top tabs (equal sized)
                    _buildTopTabs(context),

                    SizedBox(height: AppSpacing.xl),

                    // Title + subtitle changes depending on mode
                    Text(
                      _usePassword ? 'Sign In to Your Account' : 'Sign In with OTP',
                      style: TextStyles.AppTextStyles.h1?.copyWith(color: AppColors.brand),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      _usePassword ? "It’s great to see you again." : "Enter your mobile number to receive an OTP",
                      style: TextStyles.AppTextStyles.subtitle?.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: AppSpacing.lg),

                    // White rounded card containing the active form
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
                      child: _usePassword ? _buildPasswordForm(context) : _buildOtpForm(context),
                    ),

                    SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Password form
  Widget _buildPasswordForm(BuildContext ctx) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Email or mobile number', style: TextStyles.AppTextStyles.body),
          SizedBox(height: AppSpacing.xs),
          AppTextField(
            controller: _username,
            hint: 'Enter email or mobile number',
            keyboardType: TextInputType.text,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email or Mobile No is required';
              final ok = RegExp(r'^((\+91)?[6-9]\d{9}|[^@]+@[^@]+\.[^@]+)$')
                  .hasMatch(v.trim());
              return ok ? null : 'Enter a valid email or mobile number';
            },
          ),
          SizedBox(height: AppSpacing.lg),
          Text('Password', style: TextStyles.AppTextStyles.body),
          SizedBox(height: AppSpacing.xs),
          AppTextField(
            controller: _password,
            hint: 'Enter your password',
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
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, Routes.forgotPassword),
              child: Text('Forgot password?', style: TextStyles.AppTextStyles.caption?.copyWith(color: AppColors.brand)),
            ),
          ),
          SizedBox(height: AppSpacing.sm),

          // Sign In button (green)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _loading ? null : _onLoginPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brand,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                _loading ? 'Loading...' : 'Sign In',
                style: TextStyles.AppTextStyles.body?.copyWith(color: AppColors.surface, fontWeight: FontWeight.w700),
              ),
            ),
          ),

          SizedBox(height: AppSpacing.md),

          // Signup link
          Center(
            child: GestureDetector(
              onTap: _showSignUpPopup,
              child: Text(
                'Don’t have an account? Sign Up',
                style: TextStyles.AppTextStyles.body?.copyWith(
                  color: AppColors.brand,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // OTP form (with +91 prefix box and input limitters)
  Widget _buildOtpForm(BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mobile number', style: TextStyles.AppTextStyles.body),
        SizedBox(height: AppSpacing.xs),

        // Row with fixed prefix and input
        Row(
          children: [
            // prefix box (fixed width)
            Container(
              height: 48,
              width: 60,
              decoration: BoxDecoration(
                color: AppColors.brand,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                _countryPrefix,
                style: TextStyles.AppTextStyles.body?.copyWith(color: AppColors.surface, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            // mobile input with digit-only & length limiter
            Expanded(
              child: AppTextField(
                controller: _mobile,
                hint: 'Enter mobile number',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Mobile number required';
                  if (v.length != 10) return 'Mobile number must be 10 digits';
                  final ok = RegExp(r'^[6-9]\d{9}$').hasMatch(v.trim());
                  return ok ? null : 'Enter a valid mobile number';
                },
              ),
            ),
          ],
        ),

        SizedBox(height: AppSpacing.lg),

        // Send OTP button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _sendingOtp ? null : _sendOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brand,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: _sendingOtp
                ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.surface),
                    ),
                  )
                : Text(
                    'Send OTP',
                    style: TextStyles.AppTextStyles.body?.copyWith(color: AppColors.surface, fontWeight: FontWeight.w700),
                  ),
          ),
        ),

        SizedBox(height: AppSpacing.md),

        Text(
          'By continuing, you agree to Moore Market’s Terms of Use & Policy',
          style: TextStyles.AppTextStyles.caption?.copyWith(color: AppColors.textSecondary),
        ),

        SizedBox(height: AppSpacing.lg),

        Center(
          child: GestureDetector(
            onTap: _showSignUpPopup,
            child: Text(
              'Don\'t have an account? Sign Up',
              style: TextStyles.AppTextStyles.body?.copyWith(color: AppColors.brand, decoration: TextDecoration.underline),
            ),
          ),
        ),
      ],
    );
  }
}

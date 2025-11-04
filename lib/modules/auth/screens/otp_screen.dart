import 'package:flutter/material.dart';
import '../../../globals/theme.dart';
import '../../../routes/routes.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_otp_fields.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _code = '';
  bool _loading = false;

  Future<void> _continue() async {
    if (_code.length != 4) return;
    setState(() => _loading = true);

    // TODO: verify OTP with your backend using [_code]
    await Future.delayed(const Duration(milliseconds: 600));

    setState(() => _loading = false);
    Navigator.pushReplacementNamed(context, Routes.resetPassword);
  }

  @override
  Widget build(BuildContext context) {
    final email = (ModalRoute.of(context)?.settings.arguments as String?) ?? '';
    final bottom = MediaQuery.of(context).viewInsets.bottom;

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
              AppSpacing.xl + bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enter 4 Digit Code', style: AppTextStyles.h1),
                SizedBox(height: AppSpacing.xs),
                Text(
                  "Enter 4 digit code that you receive on your email (${email.isEmpty ? 'example@email.com' : email}).",
                  style: AppTextStyles.subtitle,
                ),
                SizedBox(height: AppSpacing.xxl),
                AppOtpFields(onCompleted: (c) => setState(() => _code = c)),
                SizedBox(height: AppSpacing.md),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Email not received? ",
                          style: AppTextStyles.caption),
                      TextButton(
                        onPressed: () {
                          // TODO: trigger resend code API
                        },
                        child: const Text('Resend code'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: 'Continue',
                  onPressed: _code.length == 4 ? _continue : null,
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

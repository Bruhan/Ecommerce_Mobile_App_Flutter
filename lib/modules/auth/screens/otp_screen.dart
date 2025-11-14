import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/widgets/app_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controllers = List.generate(4, (_) => TextEditingController());
  bool _loading = false;

  String get _code => _controllers.map((c) => c.text).join();

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_code.length != 4) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _loading = false);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Routes.resetPassword);
  }

  @override
  Widget build(BuildContext context) {
    final email = (ModalRoute.of(context)?.settings.arguments ?? '') as String? ?? '';
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.xl, AppSpacing.xl + bottom),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Enter 4 Digit Code', style: AppTextStyles.h1),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "Enter 4 digit code that your receive on your email (${email.isEmpty ? 'example@email.com' : email}).",
              style: AppTextStyles.subtitle,
            ),
            const SizedBox(height: AppSpacing.xxl),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (i) {
                return SizedBox(
                  width: 64,
                  child: TextField(
                    controller: _controllers[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: const InputDecoration(counterText: ''),
                    onChanged: (v) {
                      if (v.isNotEmpty && i < 3) FocusScope.of(context).nextFocus();
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: AppSpacing.md),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Email not received? ", style: AppTextStyles.caption),
                  TextButton(onPressed: () {}, child: const Text('Resend code')),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            AppButton(label: 'Continue', onPressed: _continue, loading: _loading),
          ]),
        ),
      ),
    );
  }
}

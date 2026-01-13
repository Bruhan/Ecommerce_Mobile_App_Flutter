import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/routes/routes.dart';
import 'package:ecommerce_mobile/widgets/app_text_field.dart';
import 'package:ecommerce_mobile/globals/text_styles.dart' as TextStyles;
// API integration imports --sufiyan 
// import '../../../network/api_service.dart';
// import '../lib/jwt.dart';
// import 'package:ecommerce_mobile/modules/auth/constants/auth-api.routes.dart';
// import 'package:ecommerce_mobile/modules/auth/types/login_with_password_response.dart';
// import 'package:ecommerce_mobile/modules/general/types/api.types.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  bool _loading = false;

  static const int _initialSeconds = 60; // 1 minutes
  late int _secondsRemaining;
  Timer? _timer;
  bool _resendInProgress = false;
  Timer? _clipboardTimer;
  bool _clipboardWatching = false;


  bool _verifying = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = _initialSeconds;
    _startTimer();

    _otpController.addListener(() {
      final v = _otpController.text.trim();
      if (v.length == 6 && !_verifying) {
        _verifyOtp(); // auto submit
      }
    });

    // start clipboard watcher for a short period
    _startClipboardWatcher();
  }

  @override
  void dispose() {
    _stopTimer();
    _stopClipboardWatcher();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _stopTimer();
    setState(() => _secondsRemaining = _initialSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining <= 0) {
        t.cancel();
        setState(() {});
        return;
      }
      setState(() => _secondsRemaining -= 1);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _startClipboardWatcher() {
    if (_clipboardWatching) return;
    _clipboardWatching = true;
    int ticks = 0;
    _clipboardTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      ticks++;
      if (ticks > 60) {

        _stopClipboardWatcher();
        return;
      }
      try {
        final data = await Clipboard.getData(Clipboard.kTextPlain);
        final text = data?.text ?? '';
        final code = _extract6Digit(text);
        if (code != null) {
          // fill and auto-submit
          _otpController.text = code;
          // move cursor to end
          _otpController.selection = TextSelection.collapsed(offset: code.length);
          // auto verify
          if (!_verifying) _verifyOtp();
          _stopClipboardWatcher();
        }
      } catch (_) {
        // ignore clipboard errors
      }
    });
  }

  void _stopClipboardWatcher() {
    _clipboardTimer?.cancel();
    _clipboardTimer = null;
    _clipboardWatching = false;
  }

  String? _extract6Digit(String text) {
    final re = RegExp(r'(\d{6})');
    final m = re.firstMatch(text);
    if (m != null) return m.group(0);
    return null;
  }

  String _formatTime(int seconds) {
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  /// Verify OTP (currently simulated). See commented API block for future integration.
  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter the 6-digit OTP')),
      );
      return;
    }

    if (_verifying) return;
    setState(() {
      _verifying = true;
      _loading = true;
    });

    try {
      // --------------------------
      // FUTURE: replace simulation with real API call like this:
      //
      // final ApiService api = ApiService();
      // final args = (ModalRoute.of(context)?.settings.arguments ?? '') as String? ?? '';
      // final payload = { 'mobile': args, 'otp': otp };
      // final res = await api.post(AuthApiRoutes.verifyOtp, json.encode(payload));
      // WebResponse<LoginWithPasswordResponse> response = WebResponse.fromJson(res, (data) {
      //   return LoginWithPasswordResponse.fromJson(data);
      // });
      // if (response.statusCode == 200 && response.results != null) {
      //   final loginData = response.results!;
      //   if (loginData.token != null && loginData.token!.isNotEmpty) {
      //     await storage.write(key: 'jwt', value: loginData.token);
      //   }
      //   // navigate to home...
      // }
      // else { show error from response.message }
      // --------------------------

      // Simulated verification delay (keep while API isn't hooked)
      await Future.delayed(const Duration(milliseconds: 900));

      // On simulated success: stop timers and navigate to home
      _stopTimer();
      _stopClipboardWatcher();

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
      return;
    } catch (err, st) {
      debugPrint('OTP verify error: $err\n$st');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _verifying = false;
          _loading = false;
        });
      } else {
        _verifying = false;
        _loading = false;
      }
    }
  }

  /// Resend OTP (currently simulated). See commented API block for future integration.
  Future<void> _resendOtp() async {
    if (_secondsRemaining > 0) return; // protection
    setState(() => _resendInProgress = true);
    try {
      // --------------------------
      // FUTURE: replace with real API call:
      //
      // final ApiService api = ApiService();
      // final args = (ModalRoute.of(context)?.settings.arguments ?? '') as String? ?? '';
      // final payload = { 'mobile': args };
      // await api.post(AuthApiRoutes.resendOtp, json.encode(payload));
      // --------------------------

      // simulated resend delay
      await Future.delayed(const Duration(milliseconds: 900));

      // restart timer and inform user
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP resent')));
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to resend OTP: $err')));
    } finally {
      if (mounted) setState(() => _resendInProgress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final phoneArg = (ModalRoute.of(context)?.settings.arguments ?? '') as String? ?? '';
    final phoneDisplay = phoneArg.isNotEmpty ? phoneArg : '+91 9XXXXXXXXX';
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(leading: const BackButton(), backgroundColor: AppColors.bg, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.xl + bottom,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top card title area
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
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'OTP Verification',
                          style: TextStyles.AppTextStyles.h1?.copyWith(color: AppColors.brand),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          'Enter the OTP sent to your mobile number',
                          style: TextStyles.AppTextStyles.subtitle?.copyWith(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // Main card with phone, input and actions
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
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // phone row with change link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // phone pill
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.fieldBorder.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.fieldBorder),
                              ),
                              child: Text(
                                phoneDisplay,
                                style: TextStyles.AppTextStyles.body?.copyWith(color: AppColors.textPrimary),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Change', style: TextStyles.AppTextStyles.body?.copyWith(color: AppColors.brand)),
                            ),
                          ],
                        ),

                        SizedBox(height: AppSpacing.lg),

                        // Single OTP input (6-digit) with autofill hint
                        AppTextField(
                          controller: _otpController,
                          hint: 'Enter the 6-digit OTP',
                          keyboardType: TextInputType.number,
                          autofillHints: const [AutofillHints.oneTimeCode],
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                        ),

                        SizedBox(height: AppSpacing.lg),

                        // Verify button
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brand,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              minimumSize: const Size(double.infinity, 48),
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
                                : Text('Verify OTP', style: TextStyles.AppTextStyles.body?.copyWith(color: AppColors.surface, fontWeight: FontWeight.w700)),
                          ),
                        ),

                        SizedBox(height: AppSpacing.md),

                        // timer & resend link
                        Column(
                          children: [
                            Divider(color: AppColors.fieldBorder),
                            SizedBox(height: AppSpacing.sm),
                            Text('OTP expires in: ${_formatTime(_secondsRemaining)}', style: TextStyles.AppTextStyles.caption?.copyWith(color: AppColors.textSecondary)),
                            SizedBox(height: AppSpacing.xs),
                            GestureDetector(
                              onTap: (_secondsRemaining == 0 && !_resendInProgress) ? _resendOtp : null,
                              child: Text(
                                _secondsRemaining == 0 ? 'You can resend now' : 'Didn\'t receive the code? You can resend now',
                                style: TextStyles.AppTextStyles.caption?.copyWith(color: _secondsRemaining == 0 ? AppColors.brand : AppColors.textSecondary),
                              ),
                            ),
                            SizedBox(height: AppSpacing.lg),
                            // Resend OTP (orange)
                            SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: (_secondsRemaining == 0 && !_resendInProgress) ? _resendOtp : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  minimumSize: const Size(double.infinity, 48),
                                  elevation: 0,
                                ),
                                child: _resendInProgress
                                    ? SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Text('Resend OTP', style: TextStyles.AppTextStyles.body?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: AppSpacing.md),

                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(context, Routes.login),
                            child: Text(
                              'Back to Login',
                              style: TextStyles.AppTextStyles.body?.copyWith(color: AppColors.brand),
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
    );
  }
}

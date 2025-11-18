import 'package:flutter/material.dart';
import '../globals/theme.dart';

class AppOtpFields extends StatefulWidget {
  final Function(String code) onCompleted;

  const AppOtpFields({super.key, required this.onCompleted});

  @override
  State<AppOtpFields> createState() => _AppOtpFieldsState();
}

class _AppOtpFieldsState extends State<AppOtpFields> {
  final List<TextEditingController> _ctrls =
      List.generate(4, (_) => TextEditingController());

  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_ctrls.every((c) => c.text.isNotEmpty)) {
      final code = _ctrls.map((c) => c.text).join();
      widget.onCompleted(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (i) {
        return SizedBox(
          width: 60,
          child: TextField(
            controller: _ctrls[i],
            focusNode: _focusNodes[i],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: AppTextStyles.h2,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.lg),
                borderSide: const BorderSide(color: AppColors.fieldBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.lg),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
            onChanged: (v) => _onChanged(v, i),
          ),
        );
      }),
    );
  }
}

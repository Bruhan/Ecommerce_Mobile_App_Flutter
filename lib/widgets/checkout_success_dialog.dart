import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import '../globals/text_styles.dart';

class CheckoutSuccessDialog extends StatelessWidget {
  final VoidCallback onTrack;
  final String title;
  final String message;
  final String actionText;

  const CheckoutSuccessDialog({
    Key? key,
    required this.onTrack,
    this.title = 'Congratulations!',
    this.message = 'Your order has been placed.',
    this.actionText = 'Track Your Order',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success.withOpacity(0.15),
                border: Border.all(color: AppColors.success, width: 3),
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 40,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 18),
            Text(title, style: AppTextStyles.h2, textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(message,
                style: AppTextStyles.caption, textAlign: TextAlign.center),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onTrack();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  actionText,
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

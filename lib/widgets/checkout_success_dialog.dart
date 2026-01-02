import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';

class CheckoutSuccessDialog extends StatelessWidget {
  final VoidCallback? onTrack;
  final String title;
  final String message;
  final String actionText;

  const CheckoutSuccessDialog({
    Key? key,
    this.onTrack,
    this.title = 'Congratulations!',
    this.message = 'oops Your order has been placed.',
    this.actionText = 'Track Your Order',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 18, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.withOpacity(0.12),
                border: Border.all(color: Colors.green, width: 4),
              ),
              child: const Center(child: Icon(Icons.check, size: 44, color: Colors.green)),
            ),
            const SizedBox(height: 18),
            Text(title, style: AppTextStyles.h2, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message, style: AppTextStyles.caption, textAlign: TextAlign.center),
            const SizedBox(height: 20),
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      Navigator.of(context).pop(); // close dialog
      if (onTrack != null) onTrack!();
    },
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: AppColors.primary ?? Colors.black,
    ),
    child: Text(
      actionText,
      style: AppTextStyles.body.copyWith(
        fontWeight: FontWeight.w700,
        color: Colors.white,
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

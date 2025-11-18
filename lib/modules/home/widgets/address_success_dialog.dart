import 'package:flutter/material.dart';

class AddressSuccessDialog {
  static Future<void> show(
    BuildContext context, {
    String title = 'Congratulations!',
    String subtitle = 'Your new address has been added.',
    String buttonText = 'Thanks',
    bool barrierDismissible = false,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 28),
              padding: const EdgeInsets.fromLTRB(22, 28, 22, 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 18, offset: const Offset(0, 6)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // green circular check
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withOpacity(0.12),
                      border: Border.all(color: Colors.green, width: 3),
                    ),
                    child: const Center(
                      child: Icon(Icons.check, size: 40, color: Colors.green),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: Text(buttonText, style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

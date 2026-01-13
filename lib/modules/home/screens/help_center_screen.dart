import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';
import 'package:ecommerce_mobile/globals/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'customer_service_chat_screen.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  Future<void> _openWhatsApp() async {
    const phoneNumber = '918754391586';
    const message = 'Hello, I need help with my order.';
    final uri = Uri.parse(
      'whatsapp://send?phone=$phoneNumber&text=$message',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWebsite() async {
    final uri = Uri.parse('https://mooremarket.u-clo.com/');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _item({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.brand),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          child: Column(
            children: [
              _item(
                icon: Icons.headset_mic_outlined,
                title: 'Customer Service',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CustomerServiceChatScreen(),
                    ),
                  );
                },
              ),
              _item(
                icon: Icons.chat_outlined,
                title: 'WhatsApp',
                onTap: _openWhatsApp,
              ),
              _item(
                icon: Icons.language_outlined,
                title: 'Website',
                onTap: _openWebsite,
              ),
              _item(
                icon: Icons.facebook,
                title: 'Facebook',
                onTap: () {},
              ),
              _item(
                icon: Icons.alternate_email,
                title: 'Twitter',
                onTap: () {},
              ),
              _item(
                icon: Icons.camera_alt_outlined,
                title: 'Instagram',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

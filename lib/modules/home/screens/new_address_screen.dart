import 'package:flutter/material.dart';
import '../../../globals/theme.dart';

class NewAddressScreen extends StatefulWidget {
  const NewAddressScreen({super.key});

  @override
  State<NewAddressScreen> createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<NewAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  bool _isDefault = false;

  @override
  void dispose() {
    _labelCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This layout mimics the bottom sheet + map preview in your Figma.
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Address'),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // map placeholder (replace with real map widget later)
            Container(
              height: 220,
              color: AppColors.card,
              alignment: Alignment.center,
              child: const Icon(Icons.map_outlined, size: 48),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.md),
                      Align(alignment: Alignment.centerLeft, child: Text('Address Nickname', style: AppTextStyles.caption)),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(controller: _labelCtrl, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Home / Office / Other')),
                      const SizedBox(height: AppSpacing.md),
                      Align(alignment: Alignment.centerLeft, child: Text('Full Address', style: AppTextStyles.caption)),
                      const SizedBox(height: AppSpacing.sm),
                      TextFormField(controller: _addressCtrl, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter your full address...'), maxLines: 2),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Checkbox(value: _isDefault, onChanged: (v) => setState(() => _isDefault = v ?? false)),
                          const SizedBox(width: 8),
                          Text('Make this as a default address', style: AppTextStyles.body),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if ((_formKey.currentState?.validate() ?? true)) {
                              final result = {
                                'label': _labelCtrl.text.isEmpty ? 'Address' : _labelCtrl.text,
                                'address': _addressCtrl.text,
                                'isDefault': _isDefault,
                              };
                              Navigator.pop(context, result);
                            }
                          },
                          child: const Text('Add'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
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

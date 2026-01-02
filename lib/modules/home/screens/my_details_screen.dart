// lib/modules/home/screens/my_details_screen.dart

import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/globals/theme.dart';

class MyDetailsScreen extends StatefulWidget {
  const MyDetailsScreen({super.key});

  @override
  State<MyDetailsScreen> createState() => _MyDetailsScreenState();
}

class _MyDetailsScreenState extends State<MyDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  // controllers
  final TextEditingController _nameCtrl = TextEditingController(text: 'John Doe');
  final TextEditingController _emailCtrl = TextEditingController(text: 'john.doe@example.com');
  final TextEditingController _dobCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController(text: '7436892389');

  // local state
  DateTime? _selectedDob;
  String _gender = 'Male';
  String _countryCode = '+91';

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _countryCodes = ['+91', '+1', '+44', '+34']; // expand as required

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _dobCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd/$mm/$yyyy';
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final first = DateTime(now.year - 100, 1, 1);
    final last = DateTime(now.year - 10, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(now.year - 25),
      firstDate: first,
      lastDate: last,
    );
    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobCtrl.text = _formatDate(picked);
      });
    }
  }

  /// When saving, validate, then pop with the updated details
  void _onSave() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final result = <String, String>{
      'name': _nameCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'dob': _dobCtrl.text.trim(),
      'gender': _gender,
      'phone': _phoneCtrl.text.trim(),
      'countryCode': _countryCode,
    };

    // You can also persist to a service here (UserManager) before returning.
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final double verticalGap = AppSpacing.md;
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.transparent),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Details'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name
                Text('Full Name', style: AppTextStyles.body),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Enter full name',
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter full name' : null,
                ),
                SizedBox(height: verticalGap),

                // Email
                Text('Email Address', style: AppTextStyles.body),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailCtrl,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter email address',
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Please enter email';
                    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                    if (!emailRegex.hasMatch(v.trim())) return 'Please enter a valid email';
                    return null;
                  },
                ),
                SizedBox(height: verticalGap),

                // DOB
                Text('Date of Birth', style: AppTextStyles.body),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dobCtrl,
                  readOnly: true,
                  onTap: _pickDob,
                  decoration: InputDecoration(
                    hintText: 'Select date of birth',
                    suffixIcon: const Icon(Icons.calendar_today_outlined),
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please select date of birth' : null,
                ),
                SizedBox(height: verticalGap),

                // Gender
                Text('Gender', style: AppTextStyles.body),
                const SizedBox(height: 8),
                InputDecorator(
                  decoration: InputDecoration(
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _gender,
                      isExpanded: true,
                      items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _gender = v);
                      },
                    ),
                  ),
                ),
                SizedBox(height: verticalGap),

                // Phone
                Text('Phone Number', style: AppTextStyles.body),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // country code dropdown
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _countryCode,
                          items: _countryCodes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() => _countryCode = v);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Phone number',
                          border: inputBorder,
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Please enter phone number';
                          if (!RegExp(r'^[0-9()+\-\s]{7,15}$').hasMatch(v.trim())) return 'Enter valid phone number';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                // Big spacing then Save button
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

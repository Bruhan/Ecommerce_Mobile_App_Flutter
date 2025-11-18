import 'package:flutter/material.dart';
import 'package:ecommerce_mobile/services/address_manager.dart';

class NewAddressBottomSheet extends StatefulWidget {
  const NewAddressBottomSheet({Key? key}) : super(key: key);

  @override
  State<NewAddressBottomSheet> createState() => _NewAddressBottomSheetState();
}

class _NewAddressBottomSheetState extends State<NewAddressBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final AddressManager _addressManager = AddressManager.instance;

  // controllers
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _line1Controller = TextEditingController();
  final TextEditingController _line2Controller = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  String _nickname = 'Home';
  bool _makeDefault = false;
  final List<String> _nicknames = ['Home', 'Office', 'Other'];

  @override
  void dispose() {
    _recipientController.dispose();
    _phoneController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  String _composeFullAddress() {
    final parts = <String>[];

    final name = _recipientController.text.trim();
    if (name.isNotEmpty) parts.add(name);

    final phone = _phoneController.text.trim();
    if (phone.isNotEmpty) parts.add('Phone: $phone');

    final a1 = _line1Controller.text.trim();
    final a2 = _line2Controller.text.trim();
    if (a1.isNotEmpty) parts.add(a1);
    if (a2.isNotEmpty) parts.add(a2);

    final landmark = _landmarkController.text.trim();
    if (landmark.isNotEmpty) parts.add('Landmark: $landmark');

    final city = _cityController.text.trim();
    final state = _stateController.text.trim();
    final pin = _pincodeController.text.trim();
    final csp = [city, state, pin].where((s) => s.isNotEmpty).join(', ');
    if (csp.isNotEmpty) parts.add(csp);

    parts.add('Type: $_nickname');

    return parts.join(' · ');
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Please enter phone number';
    final raw = v.replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^[0-9()+\-]+$').hasMatch(raw)) return 'Enter valid phone number';
    if (raw.length < 7) return 'Enter a valid phone number';
    return null;
  }

  String? _validateNotEmpty(String? v, String message) {
    if (v == null || v.trim().isEmpty) return message;
    return null;
  }

  Future<void> _showSuccessDialogAndClose() async {
    // show non-dismissible Figma-like dialog
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dc) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 28),
              padding: const EdgeInsets.fromLTRB(22, 28, 22, 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 18, offset: const Offset(0, 6))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // green check
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withOpacity(0.12),
                      border: Border.all(color: Colors.green, width: 3),
                    ),
                    child: const Center(child: Icon(Icons.check, size: 40, color: Colors.green)),
                  ),
                  const SizedBox(height: 18),
                  const Text('Congratulations!', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Your new address has been added.', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.of(dc).pop(),
                      child: const Text('Thanks', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // after dialog closes, close the bottom sheet and signal success
    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _onAddPressed() async {
    if (!_formKey.currentState!.validate()) return;

    final fullAddress = _composeFullAddress();

    _addressManager.addAddress(
      nickname: _nickname,
      fullAddress: fullAddress,
      latitude: null,
      longitude: null,
      makeDefault: _makeDefault,
    );

    await _showSuccessDialogAndClose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.72;

    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        child: Material(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              children: [
                // drag indicator
                Container(width: 56, height: 6, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12))),
                const SizedBox(height: 10),

                // header row
                Row(
                  children: [
                    Expanded(child: Text('New Address', style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.w700))),
                    IconButton(onPressed: () => Navigator.of(context).pop(false), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 8),

                // form
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const SizedBox(height: 6),
                        Text('Recipient name', style: Theme.of(context).textTheme.bodyText2),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _recipientController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(hintText: 'Full name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                          validator: (v) => _validateNotEmpty(v, 'Please enter recipient name'),
                        ),
                        const SizedBox(height: 12),

                        Text('Phone number', style: Theme.of(context).textTheme.bodyText2),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(hintText: 'e.g. 9123456789', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                          validator: _validatePhone,
                        ),
                        const SizedBox(height: 12),

                        Text('Address line 1', style: Theme.of(context).textTheme.bodyText2),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _line1Controller,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(hintText: 'House number, street name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                          validator: (v) => _validateNotEmpty(v, 'Please enter address line 1'),
                        ),
                        const SizedBox(height: 12),

                        Text('Address line 2 (optional)', style: Theme.of(context).textTheme.bodyText2),
                        const SizedBox(height: 6),
                        TextFormField(controller: _line2Controller, textInputAction: TextInputAction.next, decoration: InputDecoration(hintText: 'Apartment, suite, floor (optional)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                        const SizedBox(height: 12),

                        Text('Landmark (optional)', style: Theme.of(context).textTheme.bodyText2),
                        const SizedBox(height: 6),
                        TextFormField(controller: _landmarkController, textInputAction: TextInputAction.next, decoration: InputDecoration(hintText: 'e.g. Near City Mall', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
                        const SizedBox(height: 12),

                        // city/state/pin row
                        Row(children: [
                          Expanded(
                            flex: 2,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('City', style: Theme.of(context).textTheme.bodyText2),
                              const SizedBox(height: 6),
                              TextFormField(controller: _cityController, textInputAction: TextInputAction.next, decoration: InputDecoration(hintText: 'City', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), validator: (v) => _validateNotEmpty(v, 'Please enter city')),
                            ]),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('State', style: Theme.of(context).textTheme.bodyText2),
                              const SizedBox(height: 6),
                              TextFormField(controller: _stateController, textInputAction: TextInputAction.next, decoration: InputDecoration(hintText: 'State', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), validator: (v) => _validateNotEmpty(v, 'Please enter state')),
                            ]),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Pin', style: Theme.of(context).textTheme.bodyText2),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _pincodeController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(hintText: 'Pin', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return 'Please enter pin';
                                  if (!RegExp(r'^\d{3,10}$').hasMatch(v.trim())) return 'Enter valid pin';
                                  return null;
                                },
                              ),
                            ]),
                          ),
                        ]),
                        const SizedBox(height: 14),

                        Align(alignment: Alignment.centerLeft, child: Text('Address Nickname', style: Theme.of(context).textTheme.bodyText2)),
                        const SizedBox(height: 6),
                        InputDecorator(
                          decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _nickname,
                              isExpanded: true,
                              items: _nicknames.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
                              onChanged: (v) {
                                if (v == null) return;
                                setState(() => _nickname = v);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        CheckboxListTile(contentPadding: EdgeInsets.zero, value: _makeDefault, onChanged: (v) => setState(() => _makeDefault = v ?? false), title: const Text('Make this as a default address'), controlAffinity: ListTileControlAffinity.leading),
                      ]),
                    ),
                  ),
                ),

                // Add button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onAddPressed,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: const Text('Add', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// lib/modules/home/screens/addresses_screen.dart
import 'dart:async';
import 'package:ecommerce_mobile/globals/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

// return typed CustomerAddress on selection
import 'package:ecommerce_mobile/modules/checkout/types/customer_address.dart';
import '../../../services/address_manager.dart';

class AddressesScreen extends StatefulWidget {
  static const String routeName = '/addresses';

  const AddressesScreen({Key? key}) : super(key: key);

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  late final ValueNotifier<List<AddressModel>> _addressesNotifier;
  String? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    _addressesNotifier = AddressManager.instance.addresses;

    if (_addressesNotifier.value.isEmpty) {
      AddressManager.instance.init();
    }

    _addressesNotifier.addListener(_syncSelectedFromManager);
    _syncSelectedFromManager();
  }

  void _syncSelectedFromManager() {
    final list = _addressesNotifier.value;
    if (list.isEmpty) {
      setState(() {
        _selectedAddressId = null;
      });
      return;
    }

    final defaultAddr = list.firstWhere((a) => a.isDefault, orElse: () => list.first);
    setState(() {
      _selectedAddressId = defaultAddr.id;
    });
  }

  @override
  void dispose() {
    _addressesNotifier.removeListener(_syncSelectedFromManager);
    super.dispose();
  }

  void _openAddAddressSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _AddAddressBottomSheet(
          onAdd: (AddressModel newAddr) async {
            await AddressManager.instance.add(newAddr);
            setState(() {
              _selectedAddressId = newAddr.id;
            });
          },
        );
      },
    );
  }

  /// When apply is pressed we pop the selected CustomerAddress so
  /// the caller (checkout screen) receives it.
  void _applySelected() {
    if (_selectedAddressId == null) return;
    final selected = _addressesNotifier.value.firstWhere((a) => a.id == _selectedAddressId);

    // Build a map that matches your checkout CustomerAddress fields
    final m = <String, dynamic>{
      'id': selected.id,
      'addr1': selected.nickname,
      'addr2': selected.fullAddress,
      'addr3': '',
      'addr4': '',
      'mobileNumber': '',
      'state': '',
      'country': '',
      'latitude': selected.latitude,
      'longitude': selected.longitude,
    };

    final cust = CustomerAddress.fromJson(m);
    Navigator.of(context).pop(cust);
  }

  Widget _buildAddressCard(AddressModel address) {
    final isSelected = address.id == _selectedAddressId;

    return InkWell(
      onTap: () {
        final m = <String, dynamic>{
          'id': address.id,
          'addr1': address.nickname,
          'addr2': address.fullAddress,
          'addr3': '',
          'addr4': '',
          'mobileNumber': '',
          'state': '',
          'country': '',
          'latitude': address.latitude,
          'longitude': address.longitude,
        };
        final cust = CustomerAddress.fromJson(m);
        Navigator.of(context).pop(cust);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
          color: Theme.of(context).cardColor,
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(address.nickname, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(width: 8),
                      if (address.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).highlightColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('Default', style: Theme.of(context).textTheme.bodySmall),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    address.fullAddress,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Radio<String>(
              value: address.id,
              groupValue: _selectedAddressId,
              onChanged: (v) async {
                if (v == null) return;
                setState(() => _selectedAddressId = v);
                await AddressManager.instance.setDefault(v);
              },
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
        title: const Text('Address'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Saved Address', style: Theme.of(context).textTheme.titleSmall),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ValueListenableBuilder<List<AddressModel>>(
                  valueListenable: _addressesNotifier,
                  builder: (context, list, _) {
                    if (list.isEmpty) {
                      return Center(child: Text('No saved addresses', style: Theme.of(context).textTheme.bodyMedium));
                    }
                    return ListView(
                      children: [
                        ...list.map(_buildAddressCard),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _openAddAddressSheet,
                          icon: const Icon(Icons.add),
                          label: const Text('Add New Address'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    );
                  },
                ),
              ),

              // Apply button pinned at bottom; returns selected CustomerAddress to caller
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _applySelected,
                  child: const Text('Apply'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet with Google Map + draggable marker and address form
class _AddAddressBottomSheet extends StatefulWidget {
  final void Function(AddressModel) onAdd;

  const _AddAddressBottomSheet({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<_AddAddressBottomSheet> createState() => _AddAddressBottomSheetState();
}

class _AddAddressBottomSheetState extends State<_AddAddressBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullAddressC = TextEditingController();
  String _nickname = 'Home';
  bool _isDefault = false;
  final List<String> _nicknames = ['Home', 'Office', 'Apartment', "Parent's House", 'Other'];

  // Google Map related
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  static const LatLng _initialLatLng = LatLng(37.7749, -122.4194);
  LatLng _markerPosition = _initialLatLng;
  final CameraPosition _initialCamera = const CameraPosition(target: _initialLatLng, zoom: 14.0);

  @override
  void dispose() {
    _fullAddressC.dispose();
    super.dispose();
  }

  Future<void> _handleAdd() async {
    if (!_formKey.currentState!.validate()) return;

    final newAddr = AddressModel(
      id: const Uuid().v4(),
      nickname: _nickname,
      fullAddress: _fullAddressC.text.trim(),
      isDefault: _isDefault,
      latitude: _markerPosition.latitude,
      longitude: _markerPosition.longitude,
    );

    widget.onAdd(newAddr);
    Navigator.of(context).pop();
  }

  Future<void> _attemptReverseGeocode(LatLng pos) async {
    // TODO: implement reverse geocoding if desired
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {}, // absorb taps
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.78,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollCtrl) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 220,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GoogleMap(
                        initialCameraPosition: _initialCamera,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        onMapCreated: (controller) {
                          if (!_mapController.isCompleted) _mapController.complete(controller);
                        },
                        markers: {
                          Marker(
                            markerId: const MarkerId('selected'),
                            position: _markerPosition,
                            draggable: true,
                            onDragEnd: (newPos) async {
                              setState(() => _markerPosition = newPos);
                              await _attemptReverseGeocode(newPos);
                            },
                          ),
                        },
                        onTap: (pos) async {
                          setState(() => _markerPosition = pos);
                          final c = await _mapController.future;
                          c.animateCamera(CameraUpdate.newLatLng(pos));
                          await _attemptReverseGeocode(pos);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text('Address', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _nickname,
                          decoration: const InputDecoration(
                            labelText: 'Address Nickname',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          ),
                          items: _nicknames
                              .map((n) => DropdownMenuItem<String>(
                                    value: n,
                                    child: Text(n),
                                  ))
                              .toList(),
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() => _nickname = v);
                          },
                        ),
                        const SizedBox(height: 12),

                        TextFormField(
                          controller: _fullAddressC,
                          decoration: const InputDecoration(
                            labelText: 'Full Address',
                            hintText: 'Enter your full address...',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          ),
                          maxLines: 3,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Please enter address';
                            if (v.trim().length < 6) return 'Address too short';
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Checkbox(
                              value: _isDefault,
                              onChanged: (v) {
                                if (v == null) return;
                                setState(() => _isDefault = v);
                              },
                            ),
                            const SizedBox(width: 8),
                            const Expanded(child: Text('Make this as a default address')),
                          ],
                        ),
                        const SizedBox(height: 18),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _fullAddressC.text.trim().isEmpty ? null : _handleAdd,
                            child: const Text('Add'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

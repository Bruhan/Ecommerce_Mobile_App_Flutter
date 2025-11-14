import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class AddressModel {
  final String id;
  final String nickname;
  final String fullAddress;
  final bool isDefault;
  final double? latitude;
  final double? longitude;

  AddressModel({
    required this.id,
    required this.nickname,
    required this.fullAddress,
    this.isDefault = false,
    this.latitude,
    this.longitude,
  });

  AddressModel copyWith({
    String? id,
    String? nickname,
    String? fullAddress,
    bool? isDefault,
    double? latitude,
    double? longitude,
  }) {
    return AddressModel(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      fullAddress: fullAddress ?? this.fullAddress,
      isDefault: isDefault ?? this.isDefault,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'fullAddress': fullAddress,
      'isDefault': isDefault,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory AddressModel.fromJson(Map<String, dynamic> j) {
    return AddressModel(
      id: j['id'] as String,
      nickname: j['nickname'] as String,
      fullAddress: j['fullAddress'] as String,
      isDefault: j['isDefault'] as bool? ?? false,
      latitude: (j['latitude'] as num?)?.toDouble(),
      longitude: (j['longitude'] as num?)?.toDouble(),
    );
  }
}

class AddressManager {
  AddressManager._internal();

  static final AddressManager instance = AddressManager._internal();

  final ValueNotifier<List<AddressModel>> addresses = ValueNotifier<List<AddressModel>>([]);

  Future<void> init() async {

    if (addresses.value.isEmpty) {
      addresses.value = [
        AddressModel(
          id: const Uuid().v4(),
          nickname: 'Home',
          fullAddress: 'J8FR+PM Massa, Metropolitan City, 123456',
          isDefault: true,
        ),
        AddressModel(
          id: const Uuid().v4(),
          nickname: 'Office',
          fullAddress: '999 Granville St, Vancouver, BC V6C 1T2',
        ),
      ];
    }
  }

  List<AddressModel> getAll() => List.unmodifiable(addresses.value);

  /// Returns AddressModel if found, otherwise null.
  AddressModel? getById(String id) {
    try {
      return addresses.value.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> add(AddressModel a) async {
    if (a.isDefault) {
      addresses.value = addresses.value.map((e) => e.copyWith(isDefault: false)).toList();
    }
    addresses.value = [a, ...addresses.value];
    addresses.notifyListeners();
    // TODO: persist to storage or backend
  }

  Future<void> update(AddressModel updated) async {
    addresses.value = addresses.value.map((a) => a.id == updated.id ? updated : a).toList();
    addresses.notifyListeners();
    // TODO: persist changes
  }

  Future<void> remove(String id) async {
    addresses.value = addresses.value.where((a) => a.id != id).toList();
    addresses.notifyListeners();
    // TODO: persist changes
  }

  Future<void> setDefault(String id) async {
    addresses.value = addresses.value
        .map((a) => a.id == id ? a.copyWith(isDefault: true) : a.copyWith(isDefault: false))
        .toList();
    addresses.notifyListeners();
    // TODO: persist changes
  }
}

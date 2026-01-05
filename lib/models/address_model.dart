// lib/models/address_model.dart
class AddressModel {
  final String id;
  final String nickname;
  final String address;
  final double latitude;
  final double longitude;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.nickname,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
  });

  AddressModel copyWith({
    String? id,
    String? nickname,
    String? address,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

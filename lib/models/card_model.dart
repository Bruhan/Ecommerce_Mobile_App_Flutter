class CardModel {
  final String id;
  final String brand; // VISA, MC, etc.
  final String last4;
  final String expiry; // MM/YY
  final bool isDefault;

  CardModel({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expiry,
    this.isDefault = false,
  });

  CardModel copyWith({
    String? id,
    String? brand,
    String? last4,
    String? expiry,
    bool? isDefault,
  }) {
    return CardModel(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      last4: last4 ?? this.last4,
      expiry: expiry ?? this.expiry,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

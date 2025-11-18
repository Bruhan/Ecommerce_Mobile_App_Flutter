import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  final String? plant;
  final String? customerNo;
  final String? fullName;
  final String? mobileNo;
  final String? email;
  final int? cartCount;

  const Customer({
    this.plant,
    this.customerNo,
    this.fullName,
    this.mobileNo,
    this.email,
    this.cartCount,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

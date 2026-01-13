import 'package:json_annotation/json_annotation.dart';

part 'customer_billing_address.g.dart';

@JsonSerializable()
class CustomerBillingAddress {
  final String? customerName;
  final String? mobileNumber;
  final String? email;
  final String? addr1;
  final String? addr2;
  final String? addr3;
  final String? addr4;
  final String? state;
  final String? pinCode;
  final String? country;

  const CustomerBillingAddress({
    this.customerName,
    this.mobileNumber,
    this.email,
    this.addr1,
    this.addr2,
    this.addr3,
    this.addr4,
    this.state,
    this.pinCode,
    this.country,
  });

  factory CustomerBillingAddress.fromJson(Map<String, dynamic> json) =>
      _$CustomerBillingAddressFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerBillingAddressToJson(this);

  @override
  String toString() {
    return 'CustomerBillingAddress{customerName: $customerName, mobileNumber: $mobileNumber, email: $email, addr1: $addr1, addr2: $addr2, addr3: $addr3, addr4: $addr4, state: $state, pinCode: $pinCode, country: $country}';
  }
}

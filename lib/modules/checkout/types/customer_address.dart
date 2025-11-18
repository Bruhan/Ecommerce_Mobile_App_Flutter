import 'package:json_annotation/json_annotation.dart';

part 'customer_address.g.dart';

@JsonSerializable()
class CustomerAddress {
  final String? addr1;
  final String? addr2;
  final String? addr3;
  final String? addr4;
  final String? customerName;
  final int? id;
  final String? mobileNumber;
  final String? pinCode;
  final String? state;

  const CustomerAddress({
    this.addr1,
    this.addr2,
    this.addr3,
    this.addr4,
    this.customerName,
    this.id,
    this.mobileNumber,
    this.pinCode,
    this.state,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) =>
      _$CustomerAddressFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerAddressToJson(this);

  @override
  String toString() {
    return 'CustomerAddress{addr1: $addr1, addr2: $addr2, addr3: $addr3, addr4: $addr4, customerName: $customerName, id: $id, mobileNumber: $mobileNumber, pinCode: $pinCode, state: $state}';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_billing_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerBillingAddress _$CustomerBillingAddressFromJson(
        Map<String, dynamic> json) =>
    CustomerBillingAddress(
      customerName: json['customerName'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      email: json['email'] as String?,
      addr1: json['addr1'] as String?,
      addr2: json['addr2'] as String?,
      addr3: json['addr3'] as String?,
      addr4: json['addr4'] as String?,
      state: json['state'] as String?,
      pinCode: json['pinCode'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$CustomerBillingAddressToJson(
        CustomerBillingAddress instance) =>
    <String, dynamic>{
      'customerName': instance.customerName,
      'mobileNumber': instance.mobileNumber,
      'email': instance.email,
      'addr1': instance.addr1,
      'addr2': instance.addr2,
      'addr3': instance.addr3,
      'addr4': instance.addr4,
      'state': instance.state,
      'pinCode': instance.pinCode,
      'country': instance.country,
    };

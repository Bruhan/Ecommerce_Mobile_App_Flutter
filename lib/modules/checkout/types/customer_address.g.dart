// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerAddress _$CustomerAddressFromJson(Map<String, dynamic> json) =>
    CustomerAddress(
      addr1: json['addr1'] as String?,
      addr2: json['addr2'] as String?,
      addr3: json['addr3'] as String?,
      addr4: json['addr4'] as String?,
      customerName: json['customerName'] as String?,
      id: (json['id'] as num?)?.toInt(),
      mobileNumber: json['mobileNumber'] as String?,
      pinCode: json['pinCode'] as String?,
      state: json['state'] as String?,
    );

Map<String, dynamic> _$CustomerAddressToJson(CustomerAddress instance) =>
    <String, dynamic>{
      'addr1': instance.addr1,
      'addr2': instance.addr2,
      'addr3': instance.addr3,
      'addr4': instance.addr4,
      'customerName': instance.customerName,
      'id': instance.id,
      'mobileNumber': instance.mobileNumber,
      'pinCode': instance.pinCode,
      'state': instance.state,
    };

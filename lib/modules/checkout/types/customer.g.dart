// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      plant: json['plant'] as String?,
      customerNo: json['customerNo'] as String?,
      fullName: json['fullName'] as String?,
      mobileNo: json['mobileNo'] as String?,
      email: json['email'] as String?,
      cartCount: (json['cartCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'plant': instance.plant,
      'customerNo': instance.customerNo,
      'fullName': instance.fullName,
      'mobileNo': instance.mobileNo,
      'email': instance.email,
      'cartCount': instance.cartCount,
    };

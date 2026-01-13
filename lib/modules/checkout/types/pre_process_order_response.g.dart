// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_process_order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreProcessOrderResponse _$PreProcessOrderResponseFromJson(
        Map<String, dynamic> json) =>
    PreProcessOrderResponse(
      plant: json['plant'] as String?,
      orderId: json['orderId'] as String?,
      orderDate: json['orderDate'] as String?,
      deliveryAddress: json['deliveryAddress'],
      waybillNos: (json['waybillNos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      totalPrice: (json['totalPrice'] as num?)?.toInt(),
      shippingAddressDTO: json['shippingAddressDTO'] == null
          ? null
          : ShippingAddressDTO.fromJson(
              json['shippingAddressDTO'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PreProcessOrderResponseToJson(
        PreProcessOrderResponse instance) =>
    <String, dynamic>{
      'plant': instance.plant,
      'orderId': instance.orderId,
      'orderDate': instance.orderDate,
      'deliveryAddress': instance.deliveryAddress,
      'waybillNos': instance.waybillNos,
      'totalPrice': instance.totalPrice,
      'shippingAddressDTO': instance.shippingAddressDTO,
    };

ShippingAddressDTO _$ShippingAddressDTOFromJson(Map<String, dynamic> json) =>
    ShippingAddressDTO(
      address1: json['address1'] as String?,
      phone: json['phone'] as String?,
      city: json['city'] as String?,
      zip: json['zip'] as String?,
      country: json['country'] as String?,
      address2: json['address2'] as String?,
      address3: json['address3'] as String?,
      address4: json['address4'] as String?,
      state: json['state'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ShippingAddressDTOToJson(ShippingAddressDTO instance) =>
    <String, dynamic>{
      'address1': instance.address1,
      'phone': instance.phone,
      'city': instance.city,
      'zip': instance.zip,
      'country': instance.country,
      'address2': instance.address2,
      'address3': instance.address3,
      'address4': instance.address4,
      'state': instance.state,
      'name': instance.name,
    };

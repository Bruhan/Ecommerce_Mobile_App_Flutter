// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_process_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreProcessOrderRequest _$PreProcessOrderRequestFromJson(
        Map<String, dynamic> json) =>
    PreProcessOrderRequest(
      shippingAddressId: (json['shippingAddressId'] as num?)?.toInt(),
      isShippingSameAsBilling: json['isShippingSameAsBilling'] as bool?,
      itemList: (json['itemList'] as List<dynamic>?)
          ?.map((e) => ItemList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PreProcessOrderRequestToJson(
        PreProcessOrderRequest instance) =>
    <String, dynamic>{
      'shippingAddressId': instance.shippingAddressId,
      'isShippingSameAsBilling': instance.isShippingSameAsBilling,
      'itemList': instance.itemList,
    };

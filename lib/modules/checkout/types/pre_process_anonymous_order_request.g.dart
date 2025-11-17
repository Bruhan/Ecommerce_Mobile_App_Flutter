// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_process_anonymous_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreProcessAnonymousOrderRequest _$PreProcessAnonymousOrderRequestFromJson(
        Map<String, dynamic> json) =>
    PreProcessAnonymousOrderRequest(
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
      itemList: (json['itemList'] as List<dynamic>?)
          ?.map((e) => ItemList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PreProcessAnonymousOrderRequestToJson(
        PreProcessAnonymousOrderRequest instance) =>
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
      'itemList': instance.itemList,
    };

ItemList _$ItemListFromJson(Map<String, dynamic> json) => ItemList(
      item: json['item'] as String?,
      doLineNo: (json['doLineNo'] as num?)?.toInt(),
      ecomUnitPrice: (json['ecomUnitPrice'] as num?)?.toInt(),
      quantityOr: (json['quantityOr'] as num?)?.toInt(),
      promotions: json['promotions'] as List<dynamic>?,
    );

Map<String, dynamic> _$ItemListToJson(ItemList instance) => <String, dynamic>{
      'item': instance.item,
      'doLineNo': instance.doLineNo,
      'ecomUnitPrice': instance.ecomUnitPrice,
      'quantityOr': instance.quantityOr,
      'promotions': instance.promotions,
    };

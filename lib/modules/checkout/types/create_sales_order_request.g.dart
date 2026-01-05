// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_sales_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSalesOrderRequest _$CreateSalesOrderRequestFromJson(
        Map<String, dynamic> json) =>
    CreateSalesOrderRequest(
      orderId: json['orderId'] as String?,
      orderDate: json['orderDate'] as String?,
      waybillNos: json['waybillNos'] as List<dynamic>?,
      rzpOrderId: json['rzpOrderId'] as String?,
      rzpStatus: json['rzpStatus'] as String?,
      shippingAddressId: (json['shippingAddressId'] as num?)?.toInt(),
      isShippingSameAsBilling: json['isShippingSameAsBilling'] as bool?,
      itemList: (json['itemList'] as List<dynamic>?)
          ?.map((e) => ItemList.fromJson(e as Map<String, dynamic>))
          .toList(),
      remarks: (json['remarks'] as List<dynamic>?)
          ?.map((e) => Remarks.fromJson(e as Map<String, dynamic>))
          .toList(),
      batch: (json['batch'] as List<dynamic>?)
          ?.map((e) => Batch.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentType: json['paymentType'] as String?,
    );

Map<String, dynamic> _$CreateSalesOrderRequestToJson(
        CreateSalesOrderRequest instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'orderDate': instance.orderDate,
      'waybillNos': instance.waybillNos,
      'rzpOrderId': instance.rzpOrderId,
      'rzpStatus': instance.rzpStatus,
      'shippingAddressId': instance.shippingAddressId,
      'isShippingSameAsBilling': instance.isShippingSameAsBilling,
      'itemList': instance.itemList,
      'remarks': instance.remarks,
      'batch': instance.batch,
      'paymentType': instance.paymentType,
    };

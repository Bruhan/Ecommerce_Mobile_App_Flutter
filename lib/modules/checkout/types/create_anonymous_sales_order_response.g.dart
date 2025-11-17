// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_anonymous_sales_order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAnonymousSalesOrderResponse _$CreateAnonymousSalesOrderResponseFromJson(
        Map<String, dynamic> json) =>
    CreateAnonymousSalesOrderResponse(
      plant: json['plant'] as String?,
      status: json['status'] as String?,
      orderId: json['orderId'] as String?,
      orderDate: json['orderDate'] as String?,
    );

Map<String, dynamic> _$CreateAnonymousSalesOrderResponseToJson(
        CreateAnonymousSalesOrderResponse instance) =>
    <String, dynamic>{
      'plant': instance.plant,
      'status': instance.status,
      'orderId': instance.orderId,
      'orderDate': instance.orderDate,
    };

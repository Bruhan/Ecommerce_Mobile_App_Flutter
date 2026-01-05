// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_sales_order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSalesOrderResponse _$CreateSalesOrderResponseFromJson(
        Map<String, dynamic> json) =>
    CreateSalesOrderResponse(
      plant: json['plant'] as String?,
      status: json['status'] as String?,
      orderId: json['orderId'] as String?,
      orderDate: json['orderDate'] as String?,
    );

Map<String, dynamic> _$CreateSalesOrderResponseToJson(
        CreateSalesOrderResponse instance) =>
    <String, dynamic>{
      'plant': instance.plant,
      'status': instance.status,
      'orderId': instance.orderId,
      'orderDate': instance.orderDate,
    };

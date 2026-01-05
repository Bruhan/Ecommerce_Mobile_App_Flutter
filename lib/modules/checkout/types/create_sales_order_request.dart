import 'package:ecommerce_mobile/modules/checkout/types/pre_process_anonymous_order_request.dart';
import 'package:json_annotation/json_annotation.dart';

import 'create_anonymous_sales_order_request.dart';

part 'create_sales_order_request.g.dart';

@JsonSerializable()
class CreateSalesOrderRequest {
  final String? orderId;
  final String? orderDate;
  final List<dynamic>? waybillNos;
  final String? rzpOrderId;
  final String? rzpStatus;
  final int? shippingAddressId;
  final bool? isShippingSameAsBilling;
  final List<ItemList>? itemList;
  final List<Remarks>? remarks;
  final List<Batch>? batch;
  final String? paymentType;

  const CreateSalesOrderRequest({
    this.orderId,
    this.orderDate,
    this.waybillNos,
    this.rzpOrderId,
    this.rzpStatus,
    this.shippingAddressId,
    this.isShippingSameAsBilling,
    this.itemList,
    this.remarks,
    this.batch,
    this.paymentType,
  });

  factory CreateSalesOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateSalesOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSalesOrderRequestToJson(this);
}


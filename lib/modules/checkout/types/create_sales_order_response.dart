import 'package:json_annotation/json_annotation.dart';

part 'create_sales_order_response.g.dart';

@JsonSerializable()
class CreateSalesOrderResponse {
  final String? plant;
  final String? status;
  final String? orderId;
  final String? orderDate;

  const CreateSalesOrderResponse({
    this.plant,
    this.status,
    this.orderId,
    this.orderDate,
  });

  factory CreateSalesOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateSalesOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateSalesOrderResponseToJson(this);
}

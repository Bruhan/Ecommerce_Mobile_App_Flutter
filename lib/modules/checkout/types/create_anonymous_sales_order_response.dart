import 'package:json_annotation/json_annotation.dart';

part 'create_anonymous_sales_order_response.g.dart';

@JsonSerializable()
class CreateAnonymousSalesOrderResponse {
  final String? plant;
  final String? status;
  final String? orderId;
  final String? orderDate;

  const CreateAnonymousSalesOrderResponse({
    this.plant,
    this.status,
    this.orderId,
    this.orderDate,
  });

  factory CreateAnonymousSalesOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateAnonymousSalesOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAnonymousSalesOrderResponseToJson(this);
}

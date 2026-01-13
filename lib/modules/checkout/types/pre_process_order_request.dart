import 'package:ecommerce_mobile/modules/checkout/types/pre_process_anonymous_order_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pre_process_order_request.g.dart';

@JsonSerializable()
class PreProcessOrderRequest {
  final int? shippingAddressId;
  final bool? isShippingSameAsBilling;
  final List<ItemList>? itemList;

  const PreProcessOrderRequest({
    this.shippingAddressId,
    this.isShippingSameAsBilling,
    this.itemList,
  });

  factory PreProcessOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$PreProcessOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PreProcessOrderRequestToJson(this);
}

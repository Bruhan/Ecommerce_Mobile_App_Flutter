import 'package:json_annotation/json_annotation.dart';

part 'pre_process_anonymous_order_request.g.dart';

@JsonSerializable()
class PreProcessAnonymousOrderRequest {
  final String? customerName;
  final String? mobileNumber;
  final String? email;
  final String? addr1;
  final String? addr2;
  final String? addr3;
  final String? addr4;
  final String? state;
  final String? pinCode;
  final String? country;
  final List<ItemList>? itemList;

  const PreProcessAnonymousOrderRequest({
    this.customerName,
    this.mobileNumber,
    this.email,
    this.addr1,
    this.addr2,
    this.addr3,
    this.addr4,
    this.state,
    this.pinCode,
    this.country,
    this.itemList,
  });

  factory PreProcessAnonymousOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$PreProcessAnonymousOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PreProcessAnonymousOrderRequestToJson(this);
}

@JsonSerializable()
class ItemList {
  final String? item;
  final int? doLineNo;
  final int? ecomUnitPrice;
  final int? quantityOr;
  final List<dynamic>? promotions;

  const ItemList({
    this.item,
    this.doLineNo,
    this.ecomUnitPrice,
    this.quantityOr,
    this.promotions,
  });

  factory ItemList.fromJson(Map<String, dynamic> json) =>
      _$ItemListFromJson(json);

  Map<String, dynamic> toJson() => _$ItemListToJson(this);
}

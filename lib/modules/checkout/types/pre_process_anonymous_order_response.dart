import 'package:json_annotation/json_annotation.dart';

part 'pre_process_anonymous_order_response.g.dart';

@JsonSerializable()
class PreProcessAnonymousOrderResponse {
  final String? plant;
  final String? orderId;
  final String? orderDate;
  final dynamic deliveryAddress;
  final List<dynamic>? waybillNos;
  final double? totalPrice;
  final ShippingAddressDTO? shippingAddressDTO;

  const PreProcessAnonymousOrderResponse({
    this.plant,
    this.orderId,
    this.orderDate,
    this.deliveryAddress,
    this.waybillNos,
    this.totalPrice,
    this.shippingAddressDTO,
  });

  factory PreProcessAnonymousOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$PreProcessAnonymousOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PreProcessAnonymousOrderResponseToJson(this);
}

@JsonSerializable()
class ShippingAddressDTO {
  final String? address1;
  final String? phone;
  final String? city;
  final String? zip;
  final String? country;
  final String? address2;
  final String? address3;
  final String? address4;
  final String? state;
  final String? name;

  const ShippingAddressDTO({
    this.address1,
    this.phone,
    this.city,
    this.zip,
    this.country,
    this.address2,
    this.address3,
    this.address4,
    this.state,
    this.name,
  });

  factory ShippingAddressDTO.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressDTOToJson(this);
}

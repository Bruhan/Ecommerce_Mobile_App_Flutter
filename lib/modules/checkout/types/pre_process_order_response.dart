import 'package:json_annotation/json_annotation.dart';

part 'pre_process_order_response.g.dart';

@JsonSerializable()
class PreProcessOrderResponse {
  final String? plant;
  final String? orderId;
  final String? orderDate;
  final dynamic deliveryAddress;
  final List<String>? waybillNos;
  final int? totalPrice;
  final ShippingAddressDTO? shippingAddressDTO;

  const PreProcessOrderResponse({
    this.plant,
    this.orderId,
    this.orderDate,
    this.deliveryAddress,
    this.waybillNos,
    this.totalPrice,
    this.shippingAddressDTO,
  });

  factory PreProcessOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$PreProcessOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PreProcessOrderResponseToJson(this);
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

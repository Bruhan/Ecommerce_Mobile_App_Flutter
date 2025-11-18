import 'package:ecommerce_mobile/modules/checkout/types/pre_process_anonymous_order_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_anonymous_sales_order_request.g.dart';

@JsonSerializable()
class CreateAnonymousSalesOrderRequest {
  final int? id;
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
  final String? customerNo;
  final String? orderId;
  final String? orderDate;
  final List<dynamic>? waybillNos;
  final String? rzpOrderId;
  final String? rzpStatus;
  final List<ItemList>? itemList;
  final List<Remarks>? remarks;
  final List<Batch>? batch;
  final String? paymentType;

  const CreateAnonymousSalesOrderRequest({
    this.id,
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
    this.customerNo,
    this.orderId,
    this.orderDate,
    this.waybillNos,
    this.rzpOrderId,
    this.rzpStatus,
    this.itemList,
    this.remarks,
    this.batch,
    this.paymentType,
  });

  factory CreateAnonymousSalesOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAnonymousSalesOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAnonymousSalesOrderRequestToJson(this);
}


@JsonSerializable()
class Remarks {
  final String? item;
  final int? doLineNo;
  final String? remarks;

  const Remarks({
    this.item,
    this.doLineNo,
    this.remarks,
  });

  factory Remarks.fromJson(Map<String, dynamic> json) =>
      _$RemarksFromJson(json);

  Map<String, dynamic> toJson() => _$RemarksToJson(this);
}

@JsonSerializable()
class Batch {
  final int? doLineNo;
  final String? batch;
  final String? location;

  const Batch({
    this.doLineNo,
    this.batch,
    this.location,
  });

  factory Batch.fromJson(Map<String, dynamic> json) =>
      _$BatchFromJson(json);

  Map<String, dynamic> toJson() => _$BatchToJson(this);
}

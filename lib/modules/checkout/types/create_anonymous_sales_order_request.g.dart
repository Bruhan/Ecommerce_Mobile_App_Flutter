// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_anonymous_sales_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAnonymousSalesOrderRequest _$CreateAnonymousSalesOrderRequestFromJson(
        Map<String, dynamic> json) =>
    CreateAnonymousSalesOrderRequest(
      id: (json['id'] as num?)?.toInt(),
      customerName: json['customerName'] as String?,
      mobileNumber: json['mobileNumber'] as String?,
      email: json['email'] as String?,
      addr1: json['addr1'] as String?,
      addr2: json['addr2'] as String?,
      addr3: json['addr3'] as String?,
      addr4: json['addr4'] as String?,
      state: json['state'] as String?,
      pinCode: json['pinCode'] as String?,
      country: json['country'] as String?,
      customerNo: json['customerNo'] as String?,
      orderId: json['orderId'] as String?,
      orderDate: json['orderDate'] as String?,
      waybillNos: json['waybillNos'] as List<dynamic>?,
      rzpOrderId: json['rzpOrderId'] as String?,
      rzpStatus: json['rzpStatus'] as String?,
      itemList: (json['itemList'] as List<dynamic>?)
          ?.map((e) => ItemList.fromJson(e as Map<String, dynamic>))
          .toList(),
      remarks: (json['remarks'] as List<dynamic>?)
          ?.map((e) => Remarks.fromJson(e as Map<String, dynamic>))
          .toList(),
      batch: (json['batch'] as List<dynamic>?)
          ?.map((e) => Batch.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentType: json['paymentType'] as String?,
    );

Map<String, dynamic> _$CreateAnonymousSalesOrderRequestToJson(
        CreateAnonymousSalesOrderRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerName': instance.customerName,
      'mobileNumber': instance.mobileNumber,
      'email': instance.email,
      'addr1': instance.addr1,
      'addr2': instance.addr2,
      'addr3': instance.addr3,
      'addr4': instance.addr4,
      'state': instance.state,
      'pinCode': instance.pinCode,
      'country': instance.country,
      'customerNo': instance.customerNo,
      'orderId': instance.orderId,
      'orderDate': instance.orderDate,
      'waybillNos': instance.waybillNos,
      'rzpOrderId': instance.rzpOrderId,
      'rzpStatus': instance.rzpStatus,
      'itemList': instance.itemList,
      'remarks': instance.remarks,
      'batch': instance.batch,
      'paymentType': instance.paymentType,
    };

Remarks _$RemarksFromJson(Map<String, dynamic> json) => Remarks(
      item: json['item'] as String?,
      doLineNo: (json['doLineNo'] as num?)?.toInt(),
      remarks: json['remarks'] as String?,
    );

Map<String, dynamic> _$RemarksToJson(Remarks instance) => <String, dynamic>{
      'item': instance.item,
      'doLineNo': instance.doLineNo,
      'remarks': instance.remarks,
    };

Batch _$BatchFromJson(Map<String, dynamic> json) => Batch(
      doLineNo: (json['doLineNo'] as num?)?.toInt(),
      batch: json['batch'] as String?,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$BatchToJson(Batch instance) => <String, dynamic>{
      'doLineNo': instance.doLineNo,
      'batch': instance.batch,
      'location': instance.location,
    };

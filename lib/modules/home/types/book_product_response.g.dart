// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_product_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookProductResponse _$BookProductResponseFromJson(Map<String, dynamic> json) =>
    BookProductResponse(
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Products.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalProducts: (json['totalProducts'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BookProductResponseToJson(
        BookProductResponse instance) =>
    <String, dynamic>{
      'products': instance.products,
      'totalProducts': instance.totalProducts,
    };

Products _$ProductsFromJson(Map<String, dynamic> json) => Products(
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      promotions: (json['promotions'] as List<dynamic>?)
          ?.map((e) => Promotions.fromJson(e as Map<String, dynamic>))
          .toList(),
      imagePath: json['imagePath'] as String?,
    );

Map<String, dynamic> _$ProductsToJson(Products instance) => <String, dynamic>{
      'product': instance.product,
      'promotions': instance.promotions,
      'imagePath': instance.imagePath,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: (json['id'] as num?)?.toInt(),
      item: json['item'] as String?,
      itemDesc: json['itemDesc'] as String?,
      remark1: json['remark1'] as String?,
      category: json['category'] as String?,
      department: json['department'] as String?,
      brand: json['brand'] as String?,
      subCategory: json['subCategory'] as String?,
      salesUom: json['salesUom'] as String?,
      purchaseUom: json['purchaseUom'] as String?,
      unitPrice: (json['unitPrice'] as num?)?.toInt(),
      stockQty: (json['stockQty'] as num?)?.toInt(),
      baseCurrency: json['baseCurrency'] as String?,
      isNewArrival: (json['isNewArrival'] as num?)?.toInt(),
      isTopSelling: (json['isTopSelling'] as num?)?.toInt(),
      cost: (json['cost'] as num?)?.toInt(),
      mrp: (json['mrp'] as num?)?.toInt(),
      sellingPrice: (json['sellingPrice'] as num?)?.toInt(),
      minimumSellingPrice: (json['minimumSellingPrice'] as num?)?.toInt(),
      inventoryUom: json['inventoryUom'] as String?,
      minimumStkQty: (json['minimumStkQty'] as num?)?.toInt(),
      maximumStkQty: (json['maximumStkQty'] as num?)?.toInt(),
      hsCode: json['hsCode'] as String?,
      isEcomItem: (json['isEcomItem'] as num?)?.toInt(),
      minimumInvQty: (json['minimumInvQty'] as num?)?.toInt(),
      ecomUnitPrice: (json['ecomUnitPrice'] as num?)?.toInt(),
      labelPara1: json['labelPara1'] as String?,
      parameter1: json['parameter1'] as String?,
      labelPara2: json['labelPara2'] as String?,
      parameter2: json['parameter2'] as String?,
      labelPara3: json['labelPara3'] as String?,
      parameter3: json['parameter3'] as String?,
      labelPara4: json['labelPara4'] as String?,
      parameter4: json['parameter4'] as String?,
      labelPara5: json['labelPara5'] as String?,
      parameter5: json['parameter5'] as String?,
      labelPara6: json['labelPara6'] as String?,
      parameter6: json['parameter6'] as String?,
      labelPara7: json['labelPara7'] as String?,
      parameter7: json['parameter7'] as String?,
      labelPara8: json['labelPara8'] as String?,
      parameter8: json['parameter8'] as String?,
      ecomDescription: json['ecomDescription'] as String?,
      gst: (json['gst'] as num?)?.toInt(),
      cgst: (json['cgst'] as num?)?.toInt(),
      sgst: (json['sgst'] as num?)?.toInt(),
      cess: (json['cess'] as num?)?.toInt(),
      itemGroupId: json['itemGroupId'] as String?,
      remarkTwo: json['remarkTwo'] as String?,
      isActive: json['isActive'] as String?,
      author: json['author'] as String?,
      language: json['language'] as String?,
      academic: json['academic'] as String?,
      merchandise: json['merchandise'] as String?,
      subClassId: json['subClassId'] as String?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'item': instance.item,
      'itemDesc': instance.itemDesc,
      'remark1': instance.remark1,
      'category': instance.category,
      'department': instance.department,
      'brand': instance.brand,
      'subCategory': instance.subCategory,
      'salesUom': instance.salesUom,
      'purchaseUom': instance.purchaseUom,
      'unitPrice': instance.unitPrice,
      'stockQty': instance.stockQty,
      'baseCurrency': instance.baseCurrency,
      'isNewArrival': instance.isNewArrival,
      'isTopSelling': instance.isTopSelling,
      'cost': instance.cost,
      'mrp': instance.mrp,
      'sellingPrice': instance.sellingPrice,
      'minimumSellingPrice': instance.minimumSellingPrice,
      'inventoryUom': instance.inventoryUom,
      'minimumStkQty': instance.minimumStkQty,
      'maximumStkQty': instance.maximumStkQty,
      'hsCode': instance.hsCode,
      'isEcomItem': instance.isEcomItem,
      'minimumInvQty': instance.minimumInvQty,
      'ecomUnitPrice': instance.ecomUnitPrice,
      'labelPara1': instance.labelPara1,
      'parameter1': instance.parameter1,
      'labelPara2': instance.labelPara2,
      'parameter2': instance.parameter2,
      'labelPara3': instance.labelPara3,
      'parameter3': instance.parameter3,
      'labelPara4': instance.labelPara4,
      'parameter4': instance.parameter4,
      'labelPara5': instance.labelPara5,
      'parameter5': instance.parameter5,
      'labelPara6': instance.labelPara6,
      'parameter6': instance.parameter6,
      'labelPara7': instance.labelPara7,
      'parameter7': instance.parameter7,
      'labelPara8': instance.labelPara8,
      'parameter8': instance.parameter8,
      'ecomDescription': instance.ecomDescription,
      'gst': instance.gst,
      'cgst': instance.cgst,
      'sgst': instance.sgst,
      'cess': instance.cess,
      'itemGroupId': instance.itemGroupId,
      'remarkTwo': instance.remarkTwo,
      'isActive': instance.isActive,
      'author': instance.author,
      'language': instance.language,
      'academic': instance.academic,
      'merchandise': instance.merchandise,
      'subClassId': instance.subClassId,
    };

Promotions _$PromotionsFromJson(Map<String, dynamic> json) => Promotions(
      promotionId: (json['promotionId'] as num?)?.toInt(),
      promotionName: json['promotionName'] as String?,
      promotionDesc: json['promotionDesc'] as String?,
      promotionBy: json['promotionBy'] as String?,
      buyQty: (json['buyQty'] as num?)?.toInt(),
      getItem: json['getItem'] as String?,
      getQty: (json['getQty'] as num?)?.toInt(),
      promotionType: json['promotionType'] as String?,
      promotion: (json['promotion'] as num?)?.toInt(),
      limitOfUsage: (json['limitOfUsage'] as num?)?.toInt(),
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
    );

Map<String, dynamic> _$PromotionsToJson(Promotions instance) =>
    <String, dynamic>{
      'promotionId': instance.promotionId,
      'promotionName': instance.promotionName,
      'promotionDesc': instance.promotionDesc,
      'promotionBy': instance.promotionBy,
      'buyQty': instance.buyQty,
      'getItem': instance.getItem,
      'getQty': instance.getQty,
      'promotionType': instance.promotionType,
      'promotion': instance.promotion,
      'limitOfUsage': instance.limitOfUsage,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };

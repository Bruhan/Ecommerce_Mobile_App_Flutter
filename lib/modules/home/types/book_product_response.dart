import 'package:json_annotation/json_annotation.dart';

part 'book_product_response.g.dart';

@JsonSerializable()
class BookProductResponse {
  final List<Products>? products;
  final int? totalProducts;

  const BookProductResponse({
    this.products,
    this.totalProducts,k

  });

  factory BookProductResponse.fromJson(Map<String, dynamic> json) =>
      _$BookProductResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookProductResponseToJson(this);

  @override
  String toString() {
    return 'BookProductResponse{products: $products, totalProducts: $totalProducts}';
  }
}

@JsonSerializable()
class Products {
  final Product? product;
  final List<Promotions>? promotions;
  final String? imagePath;

  const Products({
    this.product,
    this.promotions,
    this.imagePath,
  });

  factory Products.fromJson(Map<String, dynamic> json) =>
      _$ProductsFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsToJson(this);

  @override
  String toString() {
    return 'Products{product: $product, promotions: $promotions, imagePath: $imagePath}';
  }
}

@JsonSerializable()
class Product {
  final int? id;
  final String? item;
  final String? itemDesc;
  final String? remark1;
  final String? category;
  final String? department;
  final String? brand;
  final String? subCategory;
  final String? salesUom;
  final String? purchaseUom;
  final int? unitPrice;
  final int? stockQty;
  final String? baseCurrency;
  final int? isNewArrival;
  final int? isTopSelling;
  final int? cost;
  final int? mrp;
  final int? sellingPrice;
  final int? minimumSellingPrice;
  final String? inventoryUom;
  final int? minimumStkQty;
  final int? maximumStkQty;
  final String? hsCode;
  final int? isEcomItem;
  final int? minimumInvQty;
  final int? ecomUnitPrice;
  final String? labelPara1;
  final String? parameter1;
  final String? labelPara2;
  final String? parameter2;
  final String? labelPara3;
  final String? parameter3;
  final String? labelPara4;
  final String? parameter4;
  final String? labelPara5;
  final String? parameter5;
  final String? labelPara6;
  final String? parameter6;
  final String? labelPara7;
  final String? parameter7;
  final String? labelPara8;
  final String? parameter8;
  final String? ecomDescription;
  final int? gst;
  final int? cgst;
  final int? sgst;
  final int? cess;
  final String? itemGroupId;
  final String? remarkTwo;
  final String? isActive;
  final String? author;
  final String? language;
  final String? academic;
  final String? merchandise;
  final String? subClassId;

  const Product({
    this.id,
    this.item,
    this.itemDesc,
    this.remark1,
    this.category,
    this.department,
    this.brand,
    this.subCategory,
    this.salesUom,
    this.purchaseUom,
    this.unitPrice,
    this.stockQty,
    this.baseCurrency,
    this.isNewArrival,
    this.isTopSelling,
    this.cost,
    this.mrp,
    this.sellingPrice,
    this.minimumSellingPrice,
    this.inventoryUom,
    this.minimumStkQty,
    this.maximumStkQty,
    this.hsCode,
    this.isEcomItem,
    this.minimumInvQty,
    this.ecomUnitPrice,
    this.labelPara1,
    this.parameter1,
    this.labelPara2,
    this.parameter2,
    this.labelPara3,
    this.parameter3,
    this.labelPara4,
    this.parameter4,
    this.labelPara5,
    this.parameter5,
    this.labelPara6,
    this.parameter6,
    this.labelPara7,
    this.parameter7,
    this.labelPara8,
    this.parameter8,
    this.ecomDescription,
    this.gst,
    this.cgst,
    this.sgst,
    this.cess,
    this.itemGroupId,
    this.remarkTwo,
    this.isActive,
    this.author,
    this.language,
    this.academic,
    this.merchandise,
    this.subClassId,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  String toString() {
    return 'Product{id: $id, item: $item, itemDesc: $itemDesc, remark1: $remark1, category: $category, department: $department, brand: $brand, subCategory: $subCategory, salesUom: $salesUom, purchaseUom: $purchaseUom, unitPrice: $unitPrice, stockQty: $stockQty, baseCurrency: $baseCurrency, isNewArrival: $isNewArrival, isTopSelling: $isTopSelling, cost: $cost, mrp: $mrp, sellingPrice: $sellingPrice, minimumSellingPrice: $minimumSellingPrice, inventoryUom: $inventoryUom, minimumStkQty: $minimumStkQty, maximumStkQty: $maximumStkQty, hsCode: $hsCode, isEcomItem: $isEcomItem, minimumInvQty: $minimumInvQty, ecomUnitPrice: $ecomUnitPrice, labelPara1: $labelPara1, parameter1: $parameter1, labelPara2: $labelPara2, parameter2: $parameter2, labelPara3: $labelPara3, parameter3: $parameter3, labelPara4: $labelPara4, parameter4: $parameter4, labelPara5: $labelPara5, parameter5: $parameter5, labelPara6: $labelPara6, parameter6: $parameter6, labelPara7: $labelPara7, parameter7: $parameter7, labelPara8: $labelPara8, parameter8: $parameter8, ecomDescription: $ecomDescription, gst: $gst, cgst: $cgst, sgst: $sgst, cess: $cess, itemGroupId: $itemGroupId, remarkTwo: $remarkTwo, isActive: $isActive, author: $author, language: $language, academic: $academic, merchandise: $merchandise, subClassId: $subClassId}';
  }
}

@JsonSerializable()
class Promotions {
  final int? promotionId;
  final String? promotionName;
  final String? promotionDesc;
  final String? promotionBy;
  final int? buyQty;
  final String? getItem;
  final int? getQty;
  final String? promotionType;
  final int? promotion;
  final int? limitOfUsage;
  final String? startDate;
  final String? endDate;

  const Promotions({
    this.promotionId,
    this.promotionName,
    this.promotionDesc,
    this.promotionBy,
    this.buyQty,
    this.getItem,
    this.getQty,
    this.promotionType,
    this.promotion,
    this.limitOfUsage,
    this.startDate,
    this.endDate,
  });

  factory Promotions.fromJson(Map<String, dynamic> json) =>
      _$PromotionsFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionsToJson(this);

  @override
  String toString() {
    return 'Promotions{promotionId: $promotionId, promotionName: $promotionName, promotionDesc: $promotionDesc, promotionBy: $promotionBy, buyQty: $buyQty, getItem: $getItem, getQty: $getQty, promotionType: $promotionType, promotion: $promotion, limitOfUsage: $limitOfUsage, startDate: $startDate, endDate: $endDate}';
  }
}

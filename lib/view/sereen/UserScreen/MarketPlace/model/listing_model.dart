import 'item_detail_model.dart';

class MarketplaceListingResponse {
  final bool? success;
  final String? message;
  final List<MarketplaceListing>? data;
  final Meta? meta;

  MarketplaceListingResponse({
    this.success,
    this.message,
    this.data,
    this.meta,
  });

  factory MarketplaceListingResponse.fromJson(Map<String, dynamic> json) {
    return MarketplaceListingResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List?)
          ?.map((e) => MarketplaceListing.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] != null
          ? Meta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class MarketplaceListing {
  final String? id;
  final String? title;
  final String? category;
  final String? itemType;
  final num? price;
  final num? askingPrice;
  final String? condition;
  final List<String>? visualAssets;
  final String? location;
  final String? description;
  final String? brand;
  final String? modelDesignation;
  final String? productionYear;
  final Seller? seller;

  MarketplaceListing({
    this.id,
    this.title,
    this.category,
    this.itemType,
    this.price,
    this.askingPrice,
    this.condition,
    this.visualAssets,
    this.location,
    this.description,
    this.brand,
    this.modelDesignation,
    this.productionYear,
    this.seller,
  });

  factory MarketplaceListing.fromJson(Map<String, dynamic> json) {
    return MarketplaceListing(
      id: (json['_id'] ?? json['id'])?.toString(),
      title: json['title'] as String?,
      category: json['category'] as String?,
      itemType: json['itemType'] as String?,
      price: json['price'] as num?,
      askingPrice: json['askingPrice'] as num?,
      condition: json['condition'] as String?,
      visualAssets: (json['visualAssets'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      location: json['location'] as String?,
      description: json['description'] as String?,
      brand: json['brand'] as String?,
      modelDesignation: json['modelDesignation'] as String?,
      productionYear: json['productionYear']?.toString(),
      seller: json['seller'] != null ? Seller.fromJson(json['seller']) : null,
    );
  }
}

class Meta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  Meta({this.page, this.limit, this.total, this.totalPage});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      total: json['total'] as int?,
      totalPage: json['totalPage'] as int?,
    );
  }
}

class ItemDetailResponse {
  final bool? success;
  final String? message;
  final ItemDetailModel? data;

  ItemDetailResponse({
    this.success,
    this.message,
    this.data,
  });

  factory ItemDetailResponse.fromJson(Map<String, dynamic> json) {
    return ItemDetailResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? ItemDetailModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ItemDetailModel {
  final String? id;
  final Seller? seller;
  final String? itemType;
  final num? askingPrice;
  final String? location;
  final String? description;
  final List<String>? visualAssets;
  final String? status;
  final String? brand;
  final String? modelDesignation;
  final num? productionYear;
  final String? engineType;
  final String? powerHP;
  final String? torqueNM;
  final num? weightKG;
  final String? zeroToHundred;
  final String? displacementCC;
  final String? transmission;
  final String? suspension;
  final String? brakingSystem;
  final String? topSpeed;
  final num? mileageKM;
  final String? engineConfiguration;
  final String? drivetrain;
  final String? aerodynamicsBody;
  final String? createdAt;
  final String? updatedAt;
  final String? moderationStatus;
  final bool? isFeatured;
  final String? map;

  // Additional fields for PERFORMANCE_PARTS
  final String? partName;
  final String? category;
  final String? compatibility;
  final String? condition;
  final num? weightReductionKG;
  final String? performanceGain;
  final String? material;
  final String? partNumber;
  final String? shippingStrategy;

  // Additional fields for EXPERT_SERVICES
  final String? listingTitle;
  final String? providerName;
  final num? hourlyRateUSD;
  final String? locationType;
  final List<String>? trackSpecializations;
  final num? experienceYears;

  ItemDetailModel({
    this.id,
    this.seller,
    this.itemType,
    this.askingPrice,
    this.location,
    this.description,
    this.visualAssets,
    this.status,
    this.brand,
    this.modelDesignation,
    this.productionYear,
    this.engineType,
    this.powerHP,
    this.torqueNM,
    this.weightKG,
    this.zeroToHundred,
    this.displacementCC,
    this.transmission,
    this.suspension,
    this.brakingSystem,
    this.topSpeed,
    this.mileageKM,
    this.engineConfiguration,
    this.drivetrain,
    this.aerodynamicsBody,
    this.createdAt,
    this.updatedAt,
    this.moderationStatus,
    this.isFeatured,
    this.map,
    this.partName,
    this.category,
    this.compatibility,
    this.condition,
    this.weightReductionKG,
    this.performanceGain,
    this.material,
    this.partNumber,
    this.shippingStrategy,
    this.listingTitle,
    this.providerName,
    this.hourlyRateUSD,
    this.locationType,
    this.trackSpecializations,
    this.experienceYears,
  });

  factory ItemDetailModel.fromJson(Map<String, dynamic> json) {
    return ItemDetailModel(
      id: json['_id'] as String?,
      seller: json['seller'] != null ? Seller.fromJson(json['seller']) : null,
      itemType: json['itemType']?.toString(),
      askingPrice: num.tryParse(json['askingPrice']?.toString() ?? ''),
      location: json['location']?.toString(),
      description: json['description']?.toString(),
      visualAssets: (json['visualAssets'] as List?)?.map((e) => e.toString()).toList(),
      status: json['status']?.toString(),
      brand: json['brand']?.toString(),
      modelDesignation: json['modelDesignation']?.toString(),
      productionYear: num.tryParse(json['productionYear']?.toString() ?? ''),
      engineType: json['engineType']?.toString(),
      powerHP: json['powerHP']?.toString(),
      torqueNM: json['torqueNM']?.toString(),
      weightKG: num.tryParse(json['weightKG']?.toString() ?? ''),
      zeroToHundred: json['zeroToHundred']?.toString(),
      displacementCC: json['displacementCC']?.toString(),
      transmission: json['transmission']?.toString(),
      suspension: json['suspension']?.toString(),
      brakingSystem: json['brakingSystem']?.toString(),
      topSpeed: json['topSpeed']?.toString(),
      mileageKM: num.tryParse(json['mileageKM']?.toString() ?? ''),
      engineConfiguration: json['engineConfiguration']?.toString(),
      drivetrain: json['drivetrain']?.toString(),
      aerodynamicsBody: json['aerodynamicsBody']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      moderationStatus: json['moderationStatus']?.toString(),
      isFeatured: json['isFeatured'] == true || json['isFeatured'] == 'true',
      map: json['map']?.toString(),
      partName: json['partName']?.toString(),
      category: json['category']?.toString(),
      compatibility: json['compatibility']?.toString(),
      condition: json['condition']?.toString(),
      weightReductionKG: num.tryParse(json['weightReductionKG']?.toString() ?? ''),
      performanceGain: json['performanceGain']?.toString(),
      material: json['material']?.toString(),
      partNumber: json['partNumber']?.toString(),
      shippingStrategy: json['shippingStrategy']?.toString(),
      listingTitle: json['listingTitle']?.toString(),
      providerName: json['providerName']?.toString(),
      hourlyRateUSD: num.tryParse(json['hourlyRateUSD']?.toString() ?? ''),
      locationType: json['locationType']?.toString(),
      trackSpecializations: (json['trackSpecializations'] as List?)?.map((e) => e.toString()).toList(),
      experienceYears: num.tryParse(json['experienceYears']?.toString() ?? ''),
    );
  }
}

class Seller {
  final String? id;
  final String? name;
  final String? email;
  final String? profileImage;
  final num? activeListing;
  final num? totalSell;
  final bool? isFollowing;

  Seller({
    this.id,
    this.name,
    this.email,
    this.profileImage,
    this.activeListing,
    this.totalSell,
    this.isFollowing,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      profileImage: json['profileImage'] as String?,
      activeListing: num.tryParse(json['activeListing']?.toString() ?? ''),
      totalSell: num.tryParse(json['totalSell']?.toString() ?? ''),
      isFollowing: json['isFollowing'] == true || json['isFollowing'] == 'true',
    );
  }
}

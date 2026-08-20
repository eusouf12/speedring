class MyListingsResponse {
  final int? statusCode;
  final bool? success;
  final String? message;
  final MyListingsMeta? meta;
  final List<MyListing>? data;

  MyListingsResponse({
    this.statusCode,
    this.success,
    this.message,
    this.meta,
    this.data,
  });

  factory MyListingsResponse.fromJson(Map<String, dynamic> json) {
    return MyListingsResponse(
      statusCode: json['statusCode'],
      success: json['success'],
      message: json['message'],
      meta: json['meta'] != null ? MyListingsMeta.fromJson(json['meta']) : null,
      data: json['data'] != null
          ? List<MyListing>.from(json['data'].map((x) => MyListing.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'success': success,
      'message': message,
      'meta': meta?.toJson(),
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }
}

class MyListingsMeta {
  final int? page;
  final int? limit;
  final int? total;

  MyListingsMeta({this.page, this.limit, this.total});

  factory MyListingsMeta.fromJson(Map<String, dynamic> json) {
    return MyListingsMeta(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'page': page, 'limit': limit, 'total': total};
  }
}

class MyListing {
  final String? id;
  final Seller? seller;
  final String? itemType;
  final num? askingPrice;
  final String? location;
  final String? description;
  final List<String>? visualAssets;
  final String? status;
  final String? moderationStatus;
  final bool? isFeatured;

  // Common
  final String? category;
  final String? brand;

  // Vehicle
  final String? modelDesignation;
  final int? productionYear;
  final String? powerHp;
  final String? torqueNm;
  final num? weightKg;
  final String? zeroToHundred;
  final String? topSpeed;
  final num? mileageKm;
  final String? engineType;
  final String? displacementCc;
  final String? transmission;
  final String? suspension;
  final String? brakingSystem;
  final String? engineConfiguration;
  final String? drivetrain;
  final String? aerodynamicsBody;

  // Performance Parts
  final String? partName;
  final String? compatibility;
  final String? condition;
  final num? weightReductionKg;
  final String? performanceGain;
  final String? material;
  final String? partNumber;
  final String? shippingStrategy;

  // Expert Services
  final String? listingTitle;
  final String? providerName;
  final num? hourlyRateUsd;
  final String? locationType;
  final List<String>? trackSpecializations;
  final num? experienceYears;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  MyListing({
    this.id,
    this.seller,
    this.itemType,
    this.askingPrice,
    this.location,
    this.description,
    this.visualAssets,
    this.status,
    this.moderationStatus,
    this.isFeatured,
    this.category,
    this.brand,
    this.modelDesignation,
    this.productionYear,
    this.powerHp,
    this.torqueNm,
    this.weightKg,
    this.zeroToHundred,
    this.topSpeed,
    this.mileageKm,
    this.engineType,
    this.displacementCc,
    this.transmission,
    this.suspension,
    this.brakingSystem,
    this.engineConfiguration,
    this.drivetrain,
    this.aerodynamicsBody,
    this.partName,
    this.compatibility,
    this.condition,
    this.weightReductionKg,
    this.performanceGain,
    this.material,
    this.partNumber,
    this.shippingStrategy,
    this.listingTitle,
    this.providerName,
    this.hourlyRateUsd,
    this.locationType,
    this.trackSpecializations,
    this.experienceYears,
    this.createdAt,
    this.updatedAt,
  });

  factory MyListing.fromJson(Map<String, dynamic> json) {
    return MyListing(
      id: json['_id'],
      seller: json['seller'] != null ? Seller.fromJson(json['seller']) : null,
      itemType: json['itemType'],
      askingPrice: json['askingPrice'],
      location: json['location'],
      description: json['description'],

      visualAssets: json['visualAssets'] != null
          ? List<String>.from(json['visualAssets'])
          : [],

      status: json['status'],
      moderationStatus: json['moderationStatus'],
      isFeatured: json['isFeatured'],

      category: json['category'],
      brand: json['brand'],

      // Vehicle
      modelDesignation: json['modelDesignation'],
      productionYear: json['productionYear'],
      powerHp: json['powerHP']?.toString(),
      torqueNm: json['torqueNM']?.toString(),
      weightKg: json['weightKG'],
      zeroToHundred: json['zeroToHundred']?.toString(),
      topSpeed: json['topSpeed']?.toString(),
      mileageKm: json['mileageKM'],
      engineType: json['engineType'],
      displacementCc: json['displacementCC']?.toString(),
      transmission: json['transmission'],
      suspension: json['suspension'],
      brakingSystem: json['brakingSystem'],
      engineConfiguration: json['engineConfiguration'],
      drivetrain: json['drivetrain'],
      aerodynamicsBody: json['aerodynamicsBody'],

      // Performance Parts
      partName: json['partName'],
      compatibility: json['compatibility'],
      condition: json['condition'],
      weightReductionKg: json['weightReductionKG'],
      performanceGain: json['performanceGain'],
      material: json['material'],
      partNumber: json['partNumber'],
      shippingStrategy: json['shippingStrategy'],

      // Expert Services
      listingTitle: json['listingTitle'],
      providerName: json['providerName'],
      hourlyRateUsd: json['hourlyRateUSD'],
      locationType: json['locationType'],

      trackSpecializations: json['trackSpecializations'] != null
          ? List<String>.from(json['trackSpecializations'])
          : [],

      experienceYears: json['experienceYears'],

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,

      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'seller': seller?.toJson(),
      'itemType': itemType,
      'askingPrice': askingPrice,
      'location': location,
      'description': description,
      'visualAssets': visualAssets,
      'status': status,
      'moderationStatus': moderationStatus,
      'isFeatured': isFeatured,
      'category': category,
      'brand': brand,

      'modelDesignation': modelDesignation,
      'productionYear': productionYear,
      'powerHP': powerHp,
      'torqueNM': torqueNm,
      'weightKG': weightKg,
      'zeroToHundred': zeroToHundred,
      'topSpeed': topSpeed,
      'mileageKM': mileageKm,
      'engineType': engineType,
      'displacementCC': displacementCc,
      'transmission': transmission,
      'suspension': suspension,
      'brakingSystem': brakingSystem,
      'engineConfiguration': engineConfiguration,
      'drivetrain': drivetrain,
      'aerodynamicsBody': aerodynamicsBody,

      'partName': partName,
      'compatibility': compatibility,
      'condition': condition,
      'weightReductionKG': weightReductionKg,
      'performanceGain': performanceGain,
      'material': material,
      'partNumber': partNumber,
      'shippingStrategy': shippingStrategy,

      'listingTitle': listingTitle,
      'providerName': providerName,
      'hourlyRateUSD': hourlyRateUsd,
      'locationType': locationType,
      'trackSpecializations': trackSpecializations,
      'experienceYears': experienceYears,

      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Seller {
  final String? id;
  final String? name;
  final String? email;
  final String? profileImage;

  Seller({this.id, this.name, this.email, this.profileImage});

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
    };
  }
}

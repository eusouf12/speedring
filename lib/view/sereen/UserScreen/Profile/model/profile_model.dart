import 'dart:io';

class ProfileResponse {
  final int? statusCode;
  final bool? success;
  final String? message;
  final ProfileData? data;

  ProfileResponse({this.statusCode, this.success, this.message, this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      statusCode: json['statusCode'],
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ProfileData {
  final DriverInfo? driverInfo;
  final String? id;
  final String? name;
  final String? userName;
  final String? email;
  final String? ageGroup;
  final String? phone;
  final String? address;
  final bool? agreedToTerms;
  final bool? isVerify;
  final String? role;
  final String? subscriptionStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;
  final String? profileImage;
  final String? profileBanner;
  final String? status;
  final String? stripeCustomerId;
  final String? subscriptionPlan;
  final String? stripeSubscriptionId;
  final List<String>? following;
  final bool? isProfileSetup;
  final int? followerCount;

  ProfileData({
    this.driverInfo,
    this.id,
    this.name,
    this.userName,
    this.email,
    this.ageGroup,
    this.phone,
    this.address,
    this.agreedToTerms,
    this.isVerify,
    this.role,
    this.subscriptionStatus,
    this.createdAt,
    this.updatedAt,
    this.version,
    this.profileImage,
    this.profileBanner,
    this.status,
    this.stripeCustomerId,
    this.subscriptionPlan,
    this.stripeSubscriptionId,
    this.following,
    this.isProfileSetup,
    this.followerCount,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      driverInfo: json['driverInfo'] != null
          ? DriverInfo.fromJson(json['driverInfo'])
          : null,
      id: json['_id'],
      name: json['name'],
      userName: json['userName'],
      email: json['email'],
      ageGroup: json['ageGroup'],
      phone: json['phone'],
      address: json['address'],
      agreedToTerms: json['agreedToTerms'],
      isVerify: json['isVerify'],
      role: json['role'],
      subscriptionStatus: json['subscriptionStatus'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      version: json['__v'],
      profileImage: json['profileImage'],
      profileBanner: json['profileBanner'],
      status: json['status'],
      stripeCustomerId: json['stripeCustomerId'],
      subscriptionPlan: json['subscriptionPlan'] is Map 
          ? json['subscriptionPlan']['name'] 
          : json['subscriptionPlan'],
      stripeSubscriptionId: json['stripeSubscriptionId'],
      following: json['following'] != null
          ? List<String>.from(json['following'])
          : null,
      isProfileSetup: json['isProfileSetup'],
      followerCount: json['followerCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverInfo': driverInfo?.toJson(),
      '_id': id,
      'name': name,
      'userName': userName,
      'email': email,
      'ageGroup': ageGroup,
      'phone': phone,
      'address': address,
      'agreedToTerms': agreedToTerms,
      'isVerify': isVerify,
      'role': role,
      'subscriptionStatus': subscriptionStatus,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
      'profileImage': profileImage,
      'profileBanner': profileBanner,
      'status': status,
      'stripeCustomerId': stripeCustomerId,
      'subscriptionPlan': subscriptionPlan,
      'stripeSubscriptionId': stripeSubscriptionId,
      'following': following,
      'isProfileSetup': isProfileSetup,
      'followerCount': followerCount,
    };
  }
}

class DriverInfo {
  final SocialLinks? socialLinks;
  final NotificationPreferences? notificationPreferences;
  final String? displayName;
  final String? bio;
  final String? driverRole;
  final bool? isRolePublic;
  final String? nationality;
  final List<String>? favoriteVehicles;
  final List<Vehicle>? vehicles;

  DriverInfo({
    this.socialLinks,
    this.notificationPreferences,
    this.displayName,
    this.bio,
    this.driverRole,
    this.isRolePublic,
    this.nationality,
    this.favoriteVehicles,
    this.vehicles,
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      socialLinks: json['socialLinks'] != null
          ? SocialLinks.fromJson(json['socialLinks'])
          : null,
      notificationPreferences: json['notificationPreferences'] != null
          ? NotificationPreferences.fromJson(json['notificationPreferences'])
          : null,
      displayName: json['displayName'],
      bio: json['bio'],
      driverRole: json['driverRole'],
      isRolePublic: json['isRolePublic'],
      nationality: json['nationality'],
      favoriteVehicles: json['favoriteVehicles'] != null
          ? List<String>.from(json['favoriteVehicles'])
          : null,
      vehicles: json['vehicles'] != null
          ? (json['vehicles'] as List).map((e) => Vehicle.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'socialLinks': socialLinks?.toJson(),
      'notificationPreferences': notificationPreferences?.toJson(),
      'displayName': displayName,
      'bio': bio,
      'driverRole': driverRole,
      'isRolePublic': isRolePublic,
      'nationality': nationality,
      'favoriteVehicles': favoriteVehicles,
      'vehicles': vehicles?.map((e) => e.toJson()).toList(),
    };
  }
}

class SocialLinks {
  final String? instagram;
  final String? youtube;
  final String? tiktok;
  final String? facebook;

  SocialLinks({this.instagram, this.youtube, this.tiktok, this.facebook});

  factory SocialLinks.fromJson(Map<String, dynamic> json) {
    return SocialLinks(
      instagram: json['instagram'],
      youtube: json['youtube'],
      tiktok: json['tiktok'],
      facebook: json['facebook'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'instagram': instagram,
      'youtube': youtube,
      'tiktok': tiktok,
      'facebook': facebook,
    };
  }
}

class NotificationPreferences {
  final bool? liveTelemetry;
  final bool? social;
  final bool? locationBased;
  final bool? marketplace;
  final bool? proTour;

  NotificationPreferences({
    this.liveTelemetry,
    this.social,
    this.locationBased,
    this.marketplace,
    this.proTour,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      liveTelemetry: json['liveTelemetry'],
      social: json['social'],
      locationBased: json['locationBased'],
      marketplace: json['marketplace'],
      proTour: json['proTour'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'liveTelemetry': liveTelemetry,
      'social': social,
      'locationBased': locationBased,
      'marketplace': marketplace,
      'proTour': proTour,
    };
  }
}

class Vehicle {
  final String? vehicleName;
  final String? brand;
  final String? model;
  final String? year;
  final String? hp;
  final String? engineType;
  final String? vehicleImage;
  final String? id;
  final String? numberPlate;
  final File? localImageFile;

  Vehicle({
    this.vehicleName,
    this.brand,
    this.model,
    this.year,
    this.hp,
    this.engineType,
    this.vehicleImage,
    this.id,
    this.numberPlate,
    this.localImageFile,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleName: json['vehicleName'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      hp: json['hp'],
      engineType: json['engineType'],
      vehicleImage: json['vehicleImage'],
      id: json['_id'],
      numberPlate: json['numberPlate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleName': vehicleName,
      'brand': brand,
      'model': model,
      'year': year,
      'hp': hp,
      'engineType': engineType,
      if (vehicleImage != null) 'vehicleImage': vehicleImage,
      if (id != null) '_id': id,
      if (numberPlate != null) 'numberPlate': numberPlate,
    };
  }
}

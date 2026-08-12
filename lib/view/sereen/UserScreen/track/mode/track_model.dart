class TracksResponse {
  final int? statusCode;
  final bool? success;
  final String? message;
  final TracksMeta? meta;
  final List<Track>? data;

  TracksResponse({
    this.statusCode,
    this.success,
    this.message,
    this.meta,
    this.data,
  });

  factory TracksResponse.fromJson(Map<String, dynamic> json) {
    return TracksResponse(
      statusCode: json['statusCode'],
      success: json['success'],
      message: json['message'],
      meta: json['meta'] != null ? TracksMeta.fromJson(json['meta']) : null,
      data: json['data'] != null
          ? List<Track>.from(json['data'].map((x) => Track.fromJson(x)))
          : null,
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

class TracksMeta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  TracksMeta({this.page, this.limit, this.total, this.totalPage});

  factory TracksMeta.fromJson(Map<String, dynamic> json) {
    return TracksMeta(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPage: json['totalPage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPage': totalPage,
    };
  }
}

class Track {
  final String? id;
  final String? creator;
  final String? name;
  final String? country;
  final String? city;
  final String? address;
  final String? trackType;
  final double? lengthKm;
  final int? numCorners;
  final double? elevationChange;
  final String? startLocation;
  final String? endLocation;
  final TrackCoordinates? startCoordinates;
  final TrackCoordinates? finishCoordinates;
  final String? description;
  final String? coverImage;
  final String? layoutImage;
  final List<String>? photos;
  final bool? isFeatured;
  final bool? visibleInApp;
  final bool? allowLeaderboards;
  final bool? enableGroupTracking;
  final bool? liveTelemetryEnabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Track({
    this.id,
    this.creator,
    this.name,
    this.country,
    this.city,
    this.address,
    this.trackType,
    this.lengthKm,
    this.numCorners,
    this.elevationChange,
    this.startLocation,
    this.endLocation,
    this.startCoordinates,
    this.finishCoordinates,
    this.description,
    this.coverImage,
    this.layoutImage,
    this.photos,
    this.isFeatured,
    this.visibleInApp,
    this.allowLeaderboards,
    this.enableGroupTracking,
    this.liveTelemetryEnabled,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['_id'],
      creator: json['creator'],
      name: json['name'],
      country: json['country'],
      city: json['city'],
      address: json['address'],
      trackType: json['trackType'],
      lengthKm: (json['lengthKm'] as num?)?.toDouble(),
      numCorners: json['numCorners'],
      elevationChange: (json['elevationChange'] as num?)?.toDouble(),
      startLocation: json['startLocation'],
      endLocation: json['endLocation'],
      startCoordinates: json['startCoordinates'] != null
          ? TrackCoordinates.fromJson(json['startCoordinates'])
          : null,
      finishCoordinates: json['finishCoordinates'] != null
          ? TrackCoordinates.fromJson(json['finishCoordinates'])
          : null,
      description: json['description'],
      coverImage: json['coverImage'],
      layoutImage: json['layoutImage'],
      photos: json['photos'] != null ? List<String>.from(json['photos']) : null,
      isFeatured: json['isFeatured'],
      visibleInApp: json['visibleInApp'],
      allowLeaderboards: json['allowLeaderboards'],
      enableGroupTracking: json['enableGroupTracking'],
      liveTelemetryEnabled: json['liveTelemetryEnabled'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'creator': creator,
      'name': name,
      'country': country,
      'city': city,
      'address': address,
      'trackType': trackType,
      'lengthKm': lengthKm,
      'numCorners': numCorners,
      'elevationChange': elevationChange,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'startCoordinates': startCoordinates?.toJson(),
      'finishCoordinates': finishCoordinates?.toJson(),
      'description': description,
      'coverImage': coverImage,
      'layoutImage': layoutImage,
      'photos': photos,
      'isFeatured': isFeatured,
      'visibleInApp': visibleInApp,
      'allowLeaderboards': allowLeaderboards,
      'enableGroupTracking': enableGroupTracking,
      'liveTelemetryEnabled': liveTelemetryEnabled,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class TrackCoordinates {
  final double? lat;
  final double? lng;

  TrackCoordinates({this.lat, this.lng});

  factory TrackCoordinates.fromJson(Map<String, dynamic> json) {
    return TrackCoordinates(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
  }
}

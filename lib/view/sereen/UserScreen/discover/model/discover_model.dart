class DiscoverPostResponse {
  final int? statusCode;
  final bool? success;
  final String? message;
  final DiscoverMeta? meta;
  final List<DiscoverPost>? data;

  DiscoverPostResponse({
    this.statusCode,
    this.success,
    this.message,
    this.meta,
    this.data,
  });

  factory DiscoverPostResponse.fromJson(Map<String, dynamic> json) {
    return DiscoverPostResponse(
      statusCode: json['statusCode'],
      success: json['success'],
      message: json['message'],
      meta: json['meta'] != null ? DiscoverMeta.fromJson(json['meta']) : null,
      data: json['data'] != null
          ? List<DiscoverPost>.from(
              json['data'].map((x) => DiscoverPost.fromJson(x)),
            )
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

class DiscoverMeta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  DiscoverMeta({this.page, this.limit, this.total, this.totalPage});

  factory DiscoverMeta.fromJson(Map<String, dynamic> json) {
    return DiscoverMeta(
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

class DiscoverPost {
  final SpotDetails? spotDetails;
  final String? id;
  final DiscoverUser? user;
  final List<DiscoverMedia>? media;
  final int? shareCount;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  DiscoverPost({
    this.spotDetails,
    this.id,
    this.user,
    this.media,
    this.shareCount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory DiscoverPost.fromJson(Map<String, dynamic> json) {
    return DiscoverPost(
      spotDetails: json['spotDetails'] != null
          ? SpotDetails.fromJson(json['spotDetails'])
          : null,
      id: json['_id'] ?? json['id'],
      user: json['user'] != null ? DiscoverUser.fromJson(json['user']) : null,
      media: json['media'] != null
          ? List<DiscoverMedia>.from(
              json['media'].map((x) => DiscoverMedia.fromJson(x)),
            )
          : [],
      shareCount: json['shareCount'],
      status: json['status'],
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
      'spotDetails': spotDetails?.toJson(),
      '_id': id,
      'user': user?.toJson(),
      'media': media?.map((x) => x.toJson()).toList(),
      'shareCount': shareCount,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class SpotDetails {
  final String? licensePlate;
  final String? region;
  final String? makeAndModel;
  final String? engine;
  final String? powerHp;
  final String? zeroToHundred;

  SpotDetails({
    this.licensePlate,
    this.region,
    this.makeAndModel,
    this.engine,
    this.powerHp,
    this.zeroToHundred,
  });

  factory SpotDetails.fromJson(Map<String, dynamic> json) {
    return SpotDetails(
      licensePlate: json['licensePlate'],
      region: json['region'],
      makeAndModel: json['makeAndModel'],
      engine: json['engine'],
      powerHp: json['powerHp'],
      zeroToHundred: json['zeroToHundred'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'licensePlate': licensePlate,
      'region': region,
      'makeAndModel': makeAndModel,
      'engine': engine,
      'powerHp': powerHp,
      'zeroToHundred': zeroToHundred,
    };
  }
}

class DiscoverUser {
  final String? id;
  final String? name;
  final String? userName;
  final String? role;

  DiscoverUser({this.id, this.name, this.userName, this.role});

  factory DiscoverUser.fromJson(Map<String, dynamic> json) {
    return DiscoverUser(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      userName: json['userName'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'userName': userName, 'role': role};
  }
}

class DiscoverMedia {
  final String? url;
  final String? type;
  final String? id;

  DiscoverMedia({this.url, this.type, this.id});

  factory DiscoverMedia.fromJson(Map<String, dynamic> json) {
    return DiscoverMedia(
      url: json['url'],
      type: json['type'],
      id: json['_id'] ?? json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'type': type, '_id': id};
  }
}

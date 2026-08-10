class NetworkUserResponse {
  final int? statusCode;
  final bool? success;
  final String? message;
  final NetworkUserMeta? meta;
  final List<NetworkUser>? data;

  NetworkUserResponse({
    this.statusCode,
    this.success,
    this.message,
    this.meta,
    this.data,
  });

  factory NetworkUserResponse.fromJson(Map<String, dynamic> json) {
    return NetworkUserResponse(
      statusCode: json['statusCode'],
      success: json['success'],
      message: json['message'],
      meta: json['meta'] != null ? NetworkUserMeta.fromJson(json['meta']) : null,
      data: json['data'] != null
          ? List<NetworkUser>.from(
              json['data'].map((x) => NetworkUser.fromJson(x)),
            )
          : [],
    );
  }
}

class NetworkUserMeta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  NetworkUserMeta({this.page, this.limit, this.total, this.totalPage});

  factory NetworkUserMeta.fromJson(Map<String, dynamic> json) {
    return NetworkUserMeta(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPage: json['totalPage'],
    );
  }
}

class NetworkUser {
  final String? id;
  final String? name;
  final String? userName;
  final String? profileImage;
  final String? role;
  bool isFollowing;

  NetworkUser({
    this.id,
    this.name,
    this.userName,
    this.profileImage,
    this.role,
    this.isFollowing = false,
  });

  factory NetworkUser.fromJson(Map<String, dynamic> json) {
    return NetworkUser(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      userName: json['userName'],
      profileImage: json['profileImage'],
      role: json['role'],
      isFollowing: json['isFollowing'] ?? false,
    );
  }
}

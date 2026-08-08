class VideoPostResponse {
  final List<VideoPost>? data;
  final VideoMeta? meta;

  VideoPostResponse({this.data, this.meta});

  factory VideoPostResponse.fromJson(Map<String, dynamic> json) {
    return VideoPostResponse(
      data: json["data"] != null
          ? List<VideoPost>.from(json["data"].map((x) => VideoPost.fromJson(x)))
          : [],
      meta: json["meta"] != null ? VideoMeta.fromJson(json["meta"]) : null,
    );
  }
}

class VideoMeta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  VideoMeta({this.page, this.limit, this.total, this.totalPage});

  factory VideoMeta.fromJson(Map<String, dynamic> json) => VideoMeta(
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    totalPage: json["totalPage"],
  );
}

class VideoPost {
  final String? id;
  final VideoUser? user;
  final String? videoUrl;
  final VideoDetails? videoDetails;
  final int? views;
  final int? shareCount;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VideoPost({
    this.id,
    this.user,
    this.videoUrl,
    this.videoDetails,
    this.views,
    this.shareCount,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory VideoPost.fromJson(Map<String, dynamic> json) => VideoPost(
    id: json["_id"] ?? json["id"],
    user: json["user"] != null ? VideoUser.fromJson(json["user"]) : null,
    videoUrl: json["videoUrl"],
    videoDetails: json["videoDetails"] != null
        ? VideoDetails.fromJson(json["videoDetails"])
        : null,
    views: json["views"],
    shareCount: json["shareCount"],
    status: json["status"],
    createdAt: json["createdAt"] != null
        ? DateTime.tryParse(json["createdAt"])
        : null,
    updatedAt: json["updatedAt"] != null
        ? DateTime.tryParse(json["updatedAt"])
        : null,
  );
}

class VideoDetails {
  final String? thumbnail;
  final String? title;
  final String? description;
  final String? classification;

  VideoDetails({
    this.thumbnail,
    this.title,
    this.description,
    this.classification,
  });

  factory VideoDetails.fromJson(Map<String, dynamic> json) => VideoDetails(
    thumbnail: json["thumbnail"],
    title: json["title"],
    description: json["description"],
    classification: json["classification"],
  );
}

class VideoUser {
  final String? id;
  final String? name;
  final String? userName;
  final String? profileImage;
  final String? role;

  VideoUser({this.id, this.name, this.userName, this.profileImage, this.role});

  factory VideoUser.fromJson(Map<String, dynamic> json) => VideoUser(
    id: json["_id"] ?? json["id"],
    name: json["name"],
    userName: json["userName"],
    profileImage: json["profileImage"],
    role: json["role"],
  );
}

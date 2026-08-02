class PostResponse {
  final int? statusCode;
  final bool? success;
  final String? message;
  final PostMeta? meta;
  final List<PostModel>? data;

  PostResponse({
    this.statusCode,
    this.success,
    this.message,
    this.meta,
    this.data,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      statusCode: json["statusCode"],
      success: json["success"],
      message: json["message"],
      meta: json["meta"] != null ? PostMeta.fromJson(json["meta"]) : null,
      data: json["data"] == null
          ? []
          : List<PostModel>.from(
              json["data"].map((x) => PostModel.fromJson(x)),
            ),
    );
  }
}

class PostMeta {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  PostMeta({this.page, this.limit, this.total, this.totalPage});

  factory PostMeta.fromJson(Map<String, dynamic> json) {
    return PostMeta(
      page: json["page"],
      limit: json["limit"],
      total: json["total"],
      totalPage: json["totalPage"],
    );
  }
}

class PostModel {
  final String? id;
  final String? category;
  final String? visibility;
  final String? club;
  final String? status;

  final PostUser? user;

  final ClubPostDetails? clubPostDetails;
  final BusinessPostDetails? businessPostDetails;
  final SessionDetails? sessionDetails;
  final SpotDetails? spotDetails;
  final TrackUpdateDetails? trackUpdateDetails;

  final List<PostMedia>? media;
  final List<PostReact>? reacts;
  final List<PostComment>? comments;

  final int? reactCount;
  final int? commentCount;
  final bool? isReacted;
  final String? myReactType;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  PostModel({
    this.id,
    this.category,
    this.visibility,
    this.club,
    this.status,
    this.user,
    this.clubPostDetails,
    this.businessPostDetails,
    this.sessionDetails,
    this.spotDetails,
    this.trackUpdateDetails,
    this.media,
    this.reacts,
    this.comments,
    this.reactCount,
    this.commentCount,
    this.isReacted,
    this.myReactType,
    this.createdAt,
    this.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json["_id"],
      category: json["category"],
      visibility: json["visibility"],
      club: json["club"],
      status: json["status"],

      user: json["user"] != null ? PostUser.fromJson(json["user"]) : null,

      clubPostDetails: json["clubPostDetails"] != null
          ? ClubPostDetails.fromJson(json["clubPostDetails"])
          : null,

      businessPostDetails: json["businessPostDetails"] != null
          ? BusinessPostDetails.fromJson(json["businessPostDetails"])
          : null,

      sessionDetails: json["sessionDetails"] != null
          ? SessionDetails.fromJson(json["sessionDetails"])
          : null,

      spotDetails: json["spotDetails"] != null
          ? SpotDetails.fromJson(json["spotDetails"])
          : null,

      trackUpdateDetails: json["trackUpdateDetails"] != null
          ? TrackUpdateDetails.fromJson(json["trackUpdateDetails"])
          : null,

      media: json["media"] == null
          ? []
          : List<PostMedia>.from(
              json["media"].map((x) => PostMedia.fromJson(x)),
            ),

      reacts: json["reacts"] == null
          ? []
          : List<PostReact>.from(
              json["reacts"].map((x) => PostReact.fromJson(x)),
            ),

      comments: json["comments"] == null
          ? []
          : List<PostComment>.from(
              json["comments"].map((x) => PostComment.fromJson(x)),
            ),

      reactCount: json["reactCount"],
      commentCount: json["commentCount"],
      isReacted: json["isReacted"],
      myReactType: json["myReactType"],

      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,

      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : null,
    );
  }
}

class PostUser {
  final String? id;
  final String? name;
  final String? role;
  final String? profileImage;
  final String? userName;

  PostUser({this.id, this.name, this.role, this.profileImage, this.userName});

  factory PostUser.fromJson(Map<String, dynamic> json) {
    return PostUser(
      id: json["_id"],
      name: json["name"],
      role: json["role"],
      profileImage: json["profileImage"],
      userName: json["userName"],
    );
  }
}

class PostMedia {
  final String? id;
  final String? url;
  final String? type;

  PostMedia({this.id, this.url, this.type});

  factory PostMedia.fromJson(Map<String, dynamic> json) {
    return PostMedia(id: json["_id"], url: json["url"], type: json["type"]);
  }
}

class PostReact {
  final String? id;
  final String? reactType;
  final PostUser? user;
  final DateTime? reactedAt;

  PostReact({this.id, this.reactType, this.user, this.reactedAt});

  factory PostReact.fromJson(Map<String, dynamic> json) {
    return PostReact(
      id: json["_id"],
      reactType: json["reactType"],
      user: json["user"] is Map<String, dynamic>
          ? PostUser.fromJson(json["user"])
          : (json["user"] is String
              ? PostUser(id: json["user"])
              : null),
      reactedAt: json["reactedAt"] != null
          ? DateTime.parse(json["reactedAt"])
          : null,
    );
  }
}

class PostComment {
  final String? id;
  final PostUser? user;
  final String? comment;
  final DateTime? commentedAt;
  final List<PostReact>? reacts;
  final List<PostReply>? replies;
  final bool? isReacted;
  final String? myReactType;

  PostComment({
    this.id,
    this.user,
    this.comment,
    this.commentedAt,
    this.reacts,
    this.replies,
    this.isReacted,
    this.myReactType,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    return PostComment(
      id: json["_id"],
      user: json["user"] != null ? PostUser.fromJson(json["user"]) : null,
      comment: json["comment"],
      commentedAt: json["commentedAt"] != null
          ? DateTime.parse(json["commentedAt"])
          : null,
      reacts: json["reacts"] == null
          ? []
          : List<PostReact>.from(
              json["reacts"].map((x) => PostReact.fromJson(x)),
            ),
      replies: json["replies"] == null
          ? []
          : List<PostReply>.from(
              json["replies"].map((x) => PostReply.fromJson(x)),
            ),
      isReacted: json["isReacted"],
      myReactType: json["myReactType"],
    );
  }
}

class PostReply {
  final String? id;
  final PostUser? user;
  final String? comment;
  final DateTime? commentedAt;
  final List<PostReact>? reacts;

  PostReply({this.id, this.user, this.comment, this.commentedAt, this.reacts});

  factory PostReply.fromJson(Map<String, dynamic> json) {
    return PostReply(
      id: json["_id"],
      user: json["user"] != null ? PostUser.fromJson(json["user"]) : null,
      comment: json["comment"],
      commentedAt: json["commentedAt"] != null
          ? DateTime.parse(json["commentedAt"])
          : null,
      reacts: json["reacts"] == null
          ? []
          : List<PostReact>.from(
              json["reacts"].map((x) => PostReact.fromJson(x)),
            ),
    );
  }
}

class ClubPostDetails {
  final String? title;
  final String? details;
  final bool? isPinned;

  ClubPostDetails({this.title, this.details, this.isPinned});

  factory ClubPostDetails.fromJson(Map<String, dynamic> json) {
    return ClubPostDetails(
      title: json["title"],
      details: json["details"],
      isPinned: json["isPinned"],
    );
  }
}

class BusinessPostDetails {
  final String? listingTitle;
  final String? listingCategory;
  final String? price;
  final String? callToAction;
  final String? description;
  final String? telemetryAudio;

  BusinessPostDetails({
    this.listingTitle,
    this.listingCategory,
    this.price,
    this.callToAction,
    this.description,
    this.telemetryAudio,
  });

  factory BusinessPostDetails.fromJson(Map<String, dynamic> json) {
    return BusinessPostDetails(
      listingTitle: json["listingTitle"],
      listingCategory: json["listingCategory"],
      price: json["price"],
      callToAction: json["callToAction"],
      description: json["description"],
      telemetryAudio: json["telemetryAudio"],
    );
  }
}

class SessionDetails {
  final String? vehicle;
  final String? circuit;
  final String? trackName;
  final String? bestLapTime;
  final String? topSpeed;
  final String? summary;

  SessionDetails({
    this.vehicle,
    this.circuit,
    this.trackName,
    this.bestLapTime,
    this.topSpeed,
    this.summary,
  });

  factory SessionDetails.fromJson(Map<String, dynamic> json) {
    return SessionDetails(
      vehicle: json["vehicle"],
      circuit: json["circuit"],
      trackName: json["trackName"],
      bestLapTime: json["bestLapTime"],
      topSpeed: json["topSpeed"],
      summary: json["summary"],
    );
  }
}

class SpotDetails {
  final String? licensePlate;
  final String? region;
  final String? makeAndModel;
  final String? engine;
  final String? powerHp;

  SpotDetails({
    this.licensePlate,
    this.region,
    this.makeAndModel,
    this.engine,
    this.powerHp,
  });

  factory SpotDetails.fromJson(Map<String, dynamic> json) {
    return SpotDetails(
      licensePlate: json["licensePlate"],
      region: json["region"],
      makeAndModel: json["makeAndModel"],
      engine: json["engine"],
      powerHp: json["powerHp"],
    );
  }
}

class TrackUpdateDetails {
  final String? circuit;
  final String? surfaceCondition;
  final List<String>? hazards;
  final String? notes;

  TrackUpdateDetails({
    this.circuit,
    this.surfaceCondition,
    this.hazards,
    this.notes,
  });

  factory TrackUpdateDetails.fromJson(Map<String, dynamic> json) {
    return TrackUpdateDetails(
      circuit: json["circuit"],
      surfaceCondition: json["surfaceCondition"],
      hazards: json["hazards"] == null
          ? []
          : List<String>.from(json["hazards"]),
      notes: json["notes"],
    );
  }
}

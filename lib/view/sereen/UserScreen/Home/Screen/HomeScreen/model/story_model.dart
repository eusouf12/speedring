class StoryResponse {
  final int? statusCode;
  final bool? success;
  final String? message;
  final List<StoryUserGroup>? data;

  StoryResponse({this.statusCode, this.success, this.message, this.data});

  factory StoryResponse.fromJson(Map<String, dynamic> json) {
    return StoryResponse(
      statusCode: json["statusCode"],
      success: json["success"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<StoryUserGroup>.from(
              json["data"].map((x) => StoryUserGroup.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "success": success,
    "message": message,
    "data": data?.map((e) => e.toJson()).toList(),
  };
}

class StoryUserGroup {
  final StoryUser? user;
  final List<Story>? stories;

  StoryUserGroup({this.user, this.stories});

  factory StoryUserGroup.fromJson(Map<String, dynamic> json) {
    return StoryUserGroup(
      user: json["user"] == null ? null : StoryUser.fromJson(json["user"]),
      stories: json["stories"] == null
          ? []
          : List<Story>.from(json["stories"].map((x) => Story.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
    "stories": stories?.map((e) => e.toJson()).toList(),
  };
}

class Story {
  final String? id;
  final StoryUser? user;
  final List<StoryMedia>? media;
  final StoryMusic? music;
  final StoryLocation? location;
  final int? shareCount;
  final List<dynamic>? hiddenFrom;
  final String? status;
  final List<dynamic>? viewers;
  final List<dynamic>? reacts;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final int? viewCount;
  final int? reactCount;

  Story({
    this.id,
    this.user,
    this.media,
    this.music,
    this.location,
    this.shareCount,
    this.hiddenFrom,
    this.status,
    this.viewers,
    this.reacts,
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.viewCount,
    this.reactCount,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json["_id"],
      user: json["user"] == null ? null : StoryUser.fromJson(json["user"]),
      media: json["media"] == null
          ? []
          : List<StoryMedia>.from(
              json["media"].map((x) => StoryMedia.fromJson(x)),
            ),
      music: json["music"] == null ? null : StoryMusic.fromJson(json["music"]),
      location: json["location"] == null
          ? null
          : StoryLocation.fromJson(json["location"]),
      shareCount: json["shareCount"],
      hiddenFrom: json["hiddenFrom"] ?? [],
      status: json["status"],
      viewers: json["viewers"] ?? [],
      reacts: json["reacts"] ?? [],
      expiresAt: json["expiresAt"] == null
          ? null
          : DateTime.tryParse(json["expiresAt"]),
      createdAt: json["createdAt"] == null
          ? null
          : DateTime.tryParse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null
          ? null
          : DateTime.tryParse(json["updatedAt"]),
      v: json["__v"],
      viewCount: json["viewCount"],
      reactCount: json["reactCount"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user": user?.toJson(),
    "media": media?.map((e) => e.toJson()).toList(),
    "music": music?.toJson(),
    "location": location?.toJson(),
    "shareCount": shareCount,
    "hiddenFrom": hiddenFrom,
    "status": status,
    "viewers": viewers,
    "reacts": reacts,
    "expiresAt": expiresAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "viewCount": viewCount,
    "reactCount": reactCount,
  };
}

class StoryUser {
  final String? id;
  final String? name;
  final String? role;
  final String? profileImage;
  final String? userName;

  StoryUser({this.id, this.name, this.role, this.profileImage, this.userName});

  factory StoryUser.fromJson(Map<String, dynamic> json) {
    return StoryUser(
      id: json["_id"],
      name: json["name"],
      role: json["role"],
      profileImage: json["profileImage"],
      userName: json["userName"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "role": role,
    "profileImage": profileImage,
    "userName": userName,
  };
}

class StoryMedia {
  final String? id;
  final String? url;
  final String? type;
  final int? duration;

  StoryMedia({this.id, this.url, this.type, this.duration});

  factory StoryMedia.fromJson(Map<String, dynamic> json) {
    return StoryMedia(
      id: json["_id"],
      url: json["url"],
      type: json["type"],
      duration: json["duration"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "url": url,
    "type": type,
    "duration": duration,
  };
}

class StoryMusic {
  final String? name;
  final String? url;

  StoryMusic({this.name, this.url});

  factory StoryMusic.fromJson(Map<String, dynamic> json) {
    return StoryMusic(name: json["name"], url: json["url"]);
  }

  Map<String, dynamic> toJson() => {"name": name, "url": url};
}

class StoryLocation {
  final String? name;
  final List<double>? coordinates;

  StoryLocation({this.name, this.coordinates});

  factory StoryLocation.fromJson(Map<String, dynamic> json) {
    return StoryLocation(
      name: json["name"],
      coordinates: json["coordinates"] == null
          ? []
          : List<double>.from(json["coordinates"].map((x) => x.toDouble())),
    );
  }

  Map<String, dynamic> toJson() => {"name": name, "coordinates": coordinates};
}

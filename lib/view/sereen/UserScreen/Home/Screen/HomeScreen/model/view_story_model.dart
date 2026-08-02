class StoryViewersResponse {
  final int? statusCode;
  final bool? success;
  final String? message;
  final StoryViewersData? data;

  StoryViewersResponse({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory StoryViewersResponse.fromJson(Map<String, dynamic> json) {
    return StoryViewersResponse(
      statusCode: json["statusCode"],
      success: json["success"],
      message: json["message"],
      data: json["data"] != null
          ? StoryViewersData.fromJson(json["data"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "statusCode": statusCode,
      "success": success,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class StoryViewersData {
  final int? viewCount;
  final int? reactCount;
  final List<StoryViewer>? viewers;

  StoryViewersData({this.viewCount, this.reactCount, this.viewers});

  factory StoryViewersData.fromJson(Map<String, dynamic> json) {
    return StoryViewersData(
      viewCount: json["viewCount"],
      reactCount: json["reactCount"],
      viewers: json["viewers"] == null
          ? []
          : List<StoryViewer>.from(
              json["viewers"].map((x) => StoryViewer.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "viewCount": viewCount,
      "reactCount": reactCount,
      "viewers": viewers?.map((e) => e.toJson()).toList(),
    };
  }
}

class StoryViewer {
  final String? id;
  final ViewerUser? user;
  final DateTime? viewedAt;
  final StoryViewerReaction? reaction;

  StoryViewer({this.id, this.user, this.viewedAt, this.reaction});

  factory StoryViewer.fromJson(Map<String, dynamic> json) {
    return StoryViewer(
      id: json["_id"],
      user: json["user"] != null ? ViewerUser.fromJson(json["user"]) : null,
      viewedAt: json["viewedAt"] != null
          ? DateTime.parse(json["viewedAt"])
          : null,
      reaction: json["reaction"] != null
          ? StoryViewerReaction.fromJson(json["reaction"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "user": user?.toJson(),
      "viewedAt": viewedAt?.toIso8601String(),
      "reaction": reaction?.toJson(),
    };
  }
}

class ViewerUser {
  final String? id;
  final String? name;
  final String? profileImage;

  ViewerUser({this.id, this.name, this.profileImage});

  factory ViewerUser.fromJson(Map<String, dynamic> json) {
    return ViewerUser(
      id: json["_id"],
      name: json["name"],
      profileImage: json["profileImage"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"_id": id, "name": name, "profileImage": profileImage};
  }
}

class StoryViewerReaction {
  final String? type;
  final DateTime? reactedAt;

  StoryViewerReaction({this.type, this.reactedAt});

  factory StoryViewerReaction.fromJson(Map<String, dynamic> json) {
    return StoryViewerReaction(
      type: json["type"],
      reactedAt: json["reactedAt"] != null
          ? DateTime.parse(json["reactedAt"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "reactedAt": reactedAt?.toIso8601String(),
    };
  }
}

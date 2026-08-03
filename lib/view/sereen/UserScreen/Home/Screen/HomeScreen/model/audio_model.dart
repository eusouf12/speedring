class MusicResponse {
  final int? statusCode;
  final bool? success;
  final String? message;
  final MusicMeta? meta;
  final List<MusicModel>? data;

  MusicResponse({
    this.statusCode,
    this.success,
    this.message,
    this.meta,
    this.data,
  });

  factory MusicResponse.fromJson(Map<String, dynamic> json) {
    return MusicResponse(
      statusCode: json["statusCode"],
      success: json["success"],
      message: json["message"],
      meta: json["meta"] != null ? MusicMeta.fromJson(json["meta"]) : null,
      data: json["data"] == null
          ? []
          : List<MusicModel>.from(
              json["data"].map((x) => MusicModel.fromJson(x)),
            ),
    );
  }
}

class MusicMeta {
  final int? page;
  final int? limit;
  final int? total;

  MusicMeta({this.page, this.limit, this.total});

  factory MusicMeta.fromJson(Map<String, dynamic> json) {
    return MusicMeta(
      page: json["page"],
      limit: json["limit"],
      total: json["total"],
    );
  }
}

class MusicModel {
  final String? id;
  final String? title;
  final String? artist;
  final String? audioUrl;
  final int? duration;
  final String? genre;
  final int? usageCount;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MusicModel({
    this.id,
    this.title,
    this.artist,
    this.audioUrl,
    this.duration,
    this.genre,
    this.usageCount,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
      id: json["_id"],
      title: json["title"],
      artist: json["artist"],
      audioUrl: json["audioUrl"],
      duration: json["duration"],
      genre: json["genre"],
      usageCount: json["usageCount"],
      isActive: json["isActive"],
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : null,
    );
  }
}

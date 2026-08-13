class ExpeditionResponse {
  final int? statusCode;
  final bool? success;
  final String? message;
  final MetaData? meta;
  final List<Expedition>? data;

  ExpeditionResponse({
    this.statusCode,
    this.success,
    this.message,
    this.meta,
    this.data,
  });

  factory ExpeditionResponse.fromJson(Map<String, dynamic> json) {
    return ExpeditionResponse(
      statusCode: json['statusCode'],
      success: json['success'],
      message: json['message'],
      meta: json['meta'] != null ? MetaData.fromJson(json['meta']) : null,
      data: json['data'] != null
          ? List<Expedition>.from(json['data'].map((x) => Expedition.fromJson(x)))
          : null,
    );
  }
}

class MetaData {
  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  MetaData({this.page, this.limit, this.total, this.totalPage});

  factory MetaData.fromJson(Map<String, dynamic> json) {
    return MetaData(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPage: json['totalPage'],
    );
  }
}

class Expedition {
  final String? id;
  final String? tripName;
  final String? objective;
  final String? coverImage;
  final DateTime? deploymentDate;
  final String? startTime;
  final MeetingPoint? meetingPoint;
  final int? maxParticipants;
  final String? vehicleClass;
  final String? privacy;
  final dynamic routeTrack;
  final Host? host;
  final List<Host>? participants;
  final String? status;

  Expedition({
    this.id,
    this.tripName,
    this.objective,
    this.coverImage,
    this.deploymentDate,
    this.startTime,
    this.meetingPoint,
    this.maxParticipants,
    this.vehicleClass,
    this.privacy,
    this.routeTrack,
    this.host,
    this.participants,
    this.status,
  });

  factory Expedition.fromJson(Map<String, dynamic> json) {
    return Expedition(
      id: json['_id'],
      tripName: json['tripName'],
      objective: json['objective'],
      coverImage: json['coverImage'],
      deploymentDate: json['deploymentDate'] != null ? DateTime.parse(json['deploymentDate']) : null,
      startTime: json['startTime'],
      meetingPoint: json['meetingPoint'] != null ? MeetingPoint.fromJson(json['meetingPoint']) : null,
      maxParticipants: json['maxParticipants'],
      vehicleClass: json['vehicleClass'],
      privacy: json['privacy'],
      routeTrack: json['routeTrack'],
      host: json['host'] != null ? Host.fromJson(json['host']) : null,
      participants: json['participants'] != null
          ? List<Host>.from(json['participants'].map((x) => Host.fromJson(x)))
          : null,
      status: json['status'],
    );
  }
}

class MeetingPoint {
  final double? lat;
  final double? lng;
  final String? address;

  MeetingPoint({this.lat, this.lng, this.address});

  factory MeetingPoint.fromJson(Map<String, dynamic> json) {
    return MeetingPoint(
      lat: json['lat'] != null ? (json['lat'] as num).toDouble() : null,
      lng: json['lng'] != null ? (json['lng'] as num).toDouble() : null,
      address: json['address'],
    );
  }
}

class Host {
  final String? id;
  final String? name;
  final String? userName;
  final String? profileImage;

  Host({this.id, this.name, this.userName, this.profileImage});

  factory Host.fromJson(Map<String, dynamic> json) {
    return Host(
      id: json['_id'],
      name: json['name'],
      userName: json['userName'],
      profileImage: json['profileImage'],
    );
  }
}

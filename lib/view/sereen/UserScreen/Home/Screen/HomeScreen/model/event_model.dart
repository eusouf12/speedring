class EventModel {
  String? id;
  String? eventName;
  String? missionType;
  String? deploymentDate;
  String? locationCircuit;
  int? maxCapacity;
  String? accessType;
  String? briefing;
  String? bannerImage;
  int? shareCount;
  String? status;
  int? joinCount;
  int? reactCount;
  int? commentCount;
  bool? isReacted;
  bool? isEventJoined;
  String? myReactType;
  TimeWindow? timeWindow;
  EventUser? user;
  List<EventComment>? comments;

  EventModel({
    this.id,
    this.eventName,
    this.missionType,
    this.deploymentDate,
    this.locationCircuit,
    this.maxCapacity,
    this.accessType,
    this.briefing,
    this.bannerImage,
    this.shareCount,
    this.status,
    this.joinCount,
    this.reactCount,
    this.commentCount,
    this.isReacted,
    this.isEventJoined,
    this.myReactType,
    this.timeWindow,
    this.user,
    this.comments,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id'],
      eventName: json['eventName'],
      missionType: json['missionType'],
      deploymentDate: json['deploymentDate']?.toString(),
      locationCircuit: json['locationCircuit'],
      maxCapacity: json['maxCapacity'],
      accessType: json['accessType'],
      briefing: json['briefing'],
      bannerImage: json['bannerImage'],
      shareCount: json['shareCount'],
      status: json['status'],
      joinCount: json['joinCount'],
      reactCount: json['reactCount'],
      commentCount: json['commentCount'],
      isReacted: json['isReacted'],
      isEventJoined: json['isEventJoined'],
      myReactType: json['myReactType'],
      timeWindow: json['timeWindow'] != null
          ? TimeWindow.fromJson(json['timeWindow'])
          : null,
      user: json['user'] != null
          ? (json['user'] is String
              ? EventUser(id: json['user'])
              : EventUser.fromJson(json['user']))
          : null,
      comments: json['comments'] != null
          ? (json['comments'] as List)
              .map((c) => EventComment.fromJson(c))
              .toList()
          : null,
    );
  }
}

// ─── Comment ──────────────────────────────────────────────────────────────────

class EventComment {
  String? id;
  String? comment;
  String? commentedAt;
  EventUser? user;
  List<EventCommentReact>? reacts;
  List<EventCommentReply>? replies;
  bool? isReacted;
  String? myReactType;

  EventComment({
    this.id,
    this.comment,
    this.commentedAt,
    this.user,
    this.reacts,
    this.replies,
    this.isReacted,
    this.myReactType,
  });

  factory EventComment.fromJson(Map<String, dynamic> json) {
    return EventComment(
      id: json['_id'],
      comment: json['comment'],
      commentedAt: json['commentedAt']?.toString(),
      user: json['user'] != null
          ? (json['user'] is String
              ? EventUser(id: json['user'])
              : EventUser.fromJson(json['user']))
          : null,
      reacts: json['reacts'] != null
          ? (json['reacts'] as List)
              .map((r) => EventCommentReact.fromJson(r))
              .toList()
          : null,
      replies: json['replies'] != null
          ? (json['replies'] as List)
              .map((r) => EventCommentReply.fromJson(r))
              .toList()
          : null,
      isReacted: json['isReacted'],
      myReactType: json['myReactType'],
    );
  }
}

// ─── Reply ────────────────────────────────────────────────────────────────────

class EventCommentReply {
  String? id;
  String? comment;
  String? commentedAt;
  EventUser? user;
  List<EventCommentReact>? reacts;

  EventCommentReply({
    this.id,
    this.comment,
    this.commentedAt,
    this.user,
    this.reacts,
  });

  factory EventCommentReply.fromJson(Map<String, dynamic> json) {
    return EventCommentReply(
      id: json['_id'],
      comment: json['comment'],
      commentedAt: json['commentedAt']?.toString(),
      user: json['user'] != null
          ? (json['user'] is String
              ? EventUser(id: json['user'])
              : EventUser.fromJson(json['user']))
          : null,
      reacts: json['reacts'] != null
          ? (json['reacts'] as List)
              .map((r) => EventCommentReact.fromJson(r))
              .toList()
          : null,
    );
  }
}

// ─── React ────────────────────────────────────────────────────────────────────

class EventCommentReact {
  String? id;
  String? reactType;
  String? reactedAt;
  EventUser? user;

  EventCommentReact({this.id, this.reactType, this.reactedAt, this.user});

  factory EventCommentReact.fromJson(Map<String, dynamic> json) {
    return EventCommentReact(
      id: json['_id'],
      reactType: json['reactType'],
      reactedAt: json['reactedAt']?.toString(),
      user: json['user'] != null
          ? (json['user'] is String
              ? EventUser(id: json['user'])
              : EventUser.fromJson(json['user']))
          : null,
    );
  }
}

// ─── User ─────────────────────────────────────────────────────────────────────

class EventUser {
  String? id;
  String? name;
  String? role;
  String? profileImage;
  String? userName;

  EventUser({this.id, this.name, this.role, this.profileImage, this.userName});

  factory EventUser.fromJson(Map<String, dynamic> json) {
    return EventUser(
      id: json['_id'],
      name: json['name'],
      role: json['role'],
      profileImage: json['profileImage'],
      userName: json['userName'],
    );
  }
}

// ─── TimeWindow ───────────────────────────────────────────────────────────────

class TimeWindow {
  String? start;
  String? end;

  TimeWindow({this.start, this.end});

  factory TimeWindow.fromJson(Map<String, dynamic> json) {
    return TimeWindow(
      start: json['start'],
      end: json['end'],
    );
  }
}

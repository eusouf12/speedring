class ClubModel {
  String? id;
  String? clubName;
  String? description;
  List<String>? categories;
  String? accessType;
  bool? telemetryVerification;
  String? logo;
  String? banner;
  int? shareCount;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<ClubMember>? members;

  ClubModel({
    this.id,
    this.clubName,
    this.description,
    this.categories,
    this.accessType,
    this.telemetryVerification,
    this.logo,
    this.banner,
    this.shareCount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.members,
  });

  factory ClubModel.fromJson(Map<String, dynamic> json) {
    return ClubModel(
      id: json['_id'],
      clubName: json['clubName'],
      description: json['description'],
      categories: json['categories'] != null
          ? List<String>.from(json['categories'])
          : null,
      accessType: json['accessType'],
      telemetryVerification: json['telemetryVerification'],
      logo: json['logo'],
      banner: json['banner'],
      shareCount: json['shareCount'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      members: json['members'] != null
          ? List<ClubMember>.from(
              json['members'].map((x) => ClubMember.fromJson(x)))
          : null,
    );
  }

}

class ClubMember {
  String? id; 
  String? role;
  String? joinedAt;
  ClubUser? user;

  ClubMember({
    this.id,
    this.role,
    this.joinedAt,
    this.user,
  });

  factory ClubMember.fromJson(Map<String, dynamic> json) {
    return ClubMember(
      id: json['_id'],
      role: json['role'],
      joinedAt: json['joinedAt'],
      user: json['user'] != null
          ? (json['user'] is Map<String, dynamic>
              ? ClubUser.fromJson(json['user'])
              : null) 
          : null,
    );
  }

}

class ClubUser {
  String? id;
  String? name;
  String? email;
  String? profileImage;
  String? role;

  ClubUser({
    this.id,
    this.name,
    this.email,
    this.profileImage,
    this.role,
  });

  factory ClubUser.fromJson(Map<String, dynamic> json) {
    return ClubUser(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      profileImage: json['profileImage'],
      role: json['role'],
    );
  }

}

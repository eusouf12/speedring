class DriveSessionStatsResponse {
  final int? statusCode;
  final bool? success;
  final String? message;
  final DriveSessionStatsData? data;

  DriveSessionStatsResponse({
    this.statusCode,
    this.success,
    this.message,
    this.data,
  });

  factory DriveSessionStatsResponse.fromJson(Map<String, dynamic> json) {
    return DriveSessionStatsResponse(
      statusCode: json['statusCode'],
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? DriveSessionStatsData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class DriveSessionStatsData {
  final int? totalSessions;
  final num? totalDistance;
  final num? totalDriveScore;

  DriveSessionStatsData({
    this.totalSessions,
    this.totalDistance,
    this.totalDriveScore,
  });

  factory DriveSessionStatsData.fromJson(Map<String, dynamic> json) {
    return DriveSessionStatsData(
      totalSessions: json['totalSessions'],
      totalDistance: json['totalDistance'],
      totalDriveScore: json['totalDriveScore'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSessions': totalSessions,
      'totalDistance': totalDistance,
      'totalDriveScore': totalDriveScore,
    };
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import 'package:speedring/view/sereen/UserScreen/track/controller/track_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../components/custom_royel_appbar/custom_royel_appbar.dart'
    show CustomRoyelAppbar;
import 'package:speedring/view/sereen/UserScreen/Home/Screen/HomeScreen/controller/home_controller.dart';
import 'package:speedring/core/app_routes/app_routes.dart';

class MySessionsScreen extends StatefulWidget {
  const MySessionsScreen({super.key});

  @override
  State<MySessionsScreen> createState() => _MySessionsScreenState();
}

class _MySessionsScreenState extends State<MySessionsScreen> {
  final TrackController trackController = Get.find<TrackController>();
  final HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      trackController.getMySessions();
    });
  }

  int _parseTimeStringToSeconds(String timeStr) {
    if (timeStr == "--") return 0;
    List<String> parts = timeStr.split(':');
    try {
      if (parts.length == 3) {
        return int.parse(parts[0]) * 3600 + int.parse(parts[1]) * 60 + int.parse(parts[2]);
      } else if (parts.length == 2) {
        return int.parse(parts[0]) * 60 + int.parse(parts[1]);
      }
    } catch (e) {
      return 0;
    }
    return 0;
  }

  void _showDeleteModal(String sessionId) {
    Get.defaultDialog(
      title: "deleteSession".tr,
      titleStyle: const TextStyle(
        color: AppColors.yellow,
        fontWeight: FontWeight.bold,
      ),
      middleText: "areYouSureDeleteSession".tr,
      middleTextStyle: const TextStyle(color: Colors.white70),
      backgroundColor: const Color(0xff111111),
      radius: 12,
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            "no".tr,
            style: const TextStyle(
              color: Colors.white54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Get.back();
            trackController.deleteSession(sessionId);
          },
          child: Text(
            "yes".tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomRoyelAppbar(titleName: "mySessions".tr, leftIcon: true),
        body: Obx(() {
          if (trackController.isLoadingSessions.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }

          if (trackController.mySessionsList.isEmpty) {
            return Center(
              child: CustomText(
                text: "noTracksFound".tr,
                color: Colors.white54,
                fontSize: 16.sp,
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            itemCount: trackController.mySessionsList.length,
            itemBuilder: (context, index) {
              final session = trackController.mySessionsList[index];
              final String sessionId = session["_id"] ?? session["id"] ?? "";
              final String time = session["time"] ?? "--";
              final num distance = session["distance"] ?? 0.0;
              final String topSpeed = session["topSpeed"] ?? "--";

              return GestureDetector(
                onTap: () {
                  int elapsedSeconds = _parseTimeStringToSeconds(time);
                  double totalDistanceKm = (session["distance"] as num?)?.toDouble() ?? 0.0;
                  double topSpeedKmh = double.tryParse(session["topSpeed"]?.toString() ?? "0") ?? 0.0;
                  double averageSpeedKmh = double.tryParse(session["avgSpeed"]?.toString() ?? "0") ?? 0.0;
                  
                  List<double> speedHistory = [];
                  if (session["speedOverTime"] != null) {
                    for (var s in session["speedOverTime"]) {
                      speedHistory.add(double.tryParse(s["speed"]?.toString() ?? "0") ?? 0.0);
                    }
                  }
                  
                  List<LatLng> routePoints = [];
                  if (session["sessionTrack"] != null) {
                    for (var t in session["sessionTrack"]) {
                      routePoints.add(LatLng(
                        double.tryParse(t["lat"]?.toString() ?? "0") ?? 0.0,
                        double.tryParse(t["lng"]?.toString() ?? "0") ?? 0.0,
                      ));
                    }
                  }
                  
                  Get.toNamed(AppRoutes.driveSummaryScreen, arguments: {
                    'routePoints': routePoints,
                    'elapsedSeconds': elapsedSeconds,
                    'totalDistanceKm': totalDistanceKm,
                    'averageSpeedKmh': averageSpeedKmh,
                    'topSpeedKmh': topSpeedKmh,
                    'speedHistory': speedHistory,
                    'best0to100Time': (session["best0to100Time"] as num?)?.toDouble() ?? 0.0,
                    'best0to200Time': (session["best0to200Time"] as num?)?.toDouble() ?? 0.0,
                    'best100to200Time': (session["best100to200Time"] as num?)?.toDouble() ?? 0.0,
                    'best0to300Time': (session["best0to300Time"] as num?)?.toDouble() ?? 0.0,
                    'best200to300Time': (session["best200to300Time"] as num?)?.toDouble() ?? 0.0,
                    'peakGForce': (session["peakGForce"] as num?)?.toDouble() ?? 0.0,
                    'temperature': session["temperature"] ?? "--",
                    'isReadOnly': true,
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff111111),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: const BoxDecoration(
                          color: Colors.white10,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.directions_car,
                          color: AppColors.yellow,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text:
                                "${"distance".tr}: ${distance.toStringAsFixed(1)} ${"km".tr}",
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.white38,
                                size: 12.sp,
                              ),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: time,
                                color: Colors.white38,
                                fontSize: 10.sp,
                              ),
                              SizedBox(width: 12.w),
                              Icon(
                                Icons.flash_on,
                                color: AppColors.yellow,
                                size: 12.sp,
                              ),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: "$topSpeed ${"kmh".tr}",
                                color: AppColors.yellow,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white70),
                      color: const Color(0xff181818),
                      onSelected: (value) {
                        if (value == 'delete') {
                          _showDeleteModal(sessionId);
                        } else if (value == 'share') {
                          _showShareBottomSheet(session);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'share',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.share_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "shareResults".tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "deleteSession".tr,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          );
        }),
      ),
    );
  }
  void _showShareBottomSheet(dynamic session) {
    Get.bottomSheet(
      Material(
        color: const Color(0xff181818),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                title: Text(
                  "shareToFriends".tr,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Get.back();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.post_add,
                  color: AppColors.yellow,
                ),
                title: Text(
                  "postToApp".tr,
                  style: const TextStyle(
                    color: AppColors.yellow,
                  ),
                ),
                onTap: () async {
                  Get.back();
                  
                  // Construct session details from the fetched session data
                  // Default to N/A if not available since old sessions might not have them
                  Map<String, dynamic> sessionDetails = {
                    "vehicle": "N/A", // Not stored in session model yet
                    "vehicleImage": "", 
                    "circuit": "N/A", 
                    "trackName": "N/A", 
                    "bestLapTime": session['time'] ?? "N/A",
                    "topSpeed": session['topSpeed'] ?? "0",
                    "summary":
                        "Completed a drive of ${session['distance'] ?? '0.0'} km in ${session['time'] ?? 'N/A'}.",
                  };

                  bool success = await homeController.createPost(
                    category: "SESSION_POST",
                    visibility: "Public",
                    sessionDetails: sessionDetails,
                    mediaUrl: null,
                  );
                  if (success) {
                    Get.offAllNamed(AppRoutes.userHomeScreen);
                    Get.snackbar(
                      "Success",
                      "Post created successfully",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

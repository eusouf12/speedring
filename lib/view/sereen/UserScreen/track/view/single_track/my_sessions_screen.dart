import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import 'package:speedring/view/sereen/UserScreen/track/controller/track_controller.dart';
import '../../../../../components/custom_royel_appbar/custom_royel_appbar.dart'
    show CustomRoyelAppbar;

class MySessionsScreen extends StatefulWidget {
  const MySessionsScreen({super.key});

  @override
  State<MySessionsScreen> createState() => _MySessionsScreenState();
}

class _MySessionsScreenState extends State<MySessionsScreen> {
  final TrackController trackController = Get.find<TrackController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      trackController.getMySessions();
    });
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

              return Container(
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
                        }
                      },
                      itemBuilder: (BuildContext context) => [
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
              );
            },
          );
        }),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/app_routes/app_routes.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_text/custom_text.dart';

class SupportSuccessController extends GetxController {
  final progress = 0.0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Progress bar animation
    const duration = Duration(milliseconds: 3000);
    const interval = Duration(milliseconds: 30);
    int elapsed = 0;
    _timer = Timer.periodic(interval, (timer) {
      elapsed += 30;
      progress.value = elapsed / duration.inMilliseconds;
      if (progress.value >= 1.0) {
        timer.cancel();
        // Redirect back to profile
        if (Get.currentRoute == AppRoutes.supportSuccessScreen) {
          Get.until((route) => Get.currentRoute == AppRoutes.profileScreen || route.isFirst);
        }
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

class SupportSuccessScreen extends StatelessWidget {
  const SupportSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SupportSuccessController());
    final Map<String, dynamic> arguments = Get.arguments ?? {
      "amount": "€10.00",
      "recipient": "MAX VERSTAPPEN",
      "txId": "SRX-928-883-M7"
    };

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Confetti Decoration Flakes in Background
          ..._buildConfettiDecoration(),

          // Main Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // Verified Driver Avatar stack
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 140.w,
                          height: 140.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.yellow, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.yellow.withValues(alpha:0.15),
                                blurRadius: 30,
                                spreadRadius: 5,
                              )
                            ],
                          ),
                          child: ClipOval(
                            child: Image.network(
                              "https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=250&fit=crop",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -6.h,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: AppColors.yellow,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check, color: Colors.black, size: 10.w),
                                SizedBox(width: 4.w),
                                const Text(
                                  "VERIFIED",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 36.h),

                  // Large slanted success header
                  Text(
                    "SUPPORT SENT SUCCESSFULLY",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.yellow,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.5,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Telemetry transaction subtext
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: CustomText(
                      text: "Elite performance telemetry transaction confirmed on the Speedring network.",
                      color: Colors.white70,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Transaction Receipt Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: const Color(0xff111111),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white.withValues(alpha:0.05)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: "TRANSACTION ID",
                                  color: Colors.white38,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                                SizedBox(height: 6.h),
                                CustomText(
                                  text: arguments["txId"] ?? "SRX-928-883-M7",
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.verified_user_outlined,
                              color: AppColors.yellow,
                              size: 20.w,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Divider(color: Colors.white.withValues(alpha:0.05), height: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: "SENT AMOUNT",
                                  color: Colors.white38,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                                SizedBox(height: 6.h),
                                CustomText(
                                  text: arguments["amount"] ?? "€10.00",
                                  color: AppColors.yellow,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomText(
                                  text: "RECIPIENT",
                                  color: Colors.white38,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                                SizedBox(height: 6.h),
                                CustomText(
                                  text: arguments["recipient"] ?? "MAX VERSTAPPEN",
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Returning to dashboard indicator
                  Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60.w,
                            height: 3.h,
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: controller.progress.value,
                                child: Container(
                                  color: AppColors.yellow,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          CustomText(
                            text: "RETURNING TO DASHBOARD",
                            color: Colors.white38,
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ],
                      )),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildConfettiDecoration() {
    final List<Map<String, double>> positions = [
      {"top": 0.1, "left": 0.15, "size": 8, "angle": 0.3},
      {"top": 0.25, "left": 0.8, "size": 12, "angle": 0.7},
      {"top": 0.45, "left": 0.1, "size": 10, "angle": 1.2},
      {"top": 0.6, "left": 0.85, "size": 14, "angle": 0.5},
      {"top": 0.75, "left": 0.2, "size": 9, "angle": 1.5},
      {"top": 0.8, "left": 0.75, "size": 11, "angle": 0.2},
      {"top": 0.15, "left": 0.65, "size": 10, "angle": 0.9},
      {"top": 0.5, "left": 0.9, "size": 8, "angle": 1.4},
    ];

    return positions.map((pos) {
      return Positioned(
        top: pos["top"]! * ScreenUtil().screenHeight,
        left: pos["left"]! * ScreenUtil().screenWidth,
        child: Transform.rotate(
          angle: pos["angle"]!,
          child: Container(
            width: pos["size"]!.w,
            height: (pos["size"]! * 1.6).h,
            decoration: BoxDecoration(
              color: AppColors.yellow.withValues(alpha:0.15),
              borderRadius: BorderRadius.circular(1.r),
            ),
          ),
        ),
      );
    }).toList();
  }
}

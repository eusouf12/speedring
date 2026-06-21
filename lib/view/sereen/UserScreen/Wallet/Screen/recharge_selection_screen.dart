import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';

class RechargeSelectionController extends GetxController {
  final selectedAssets = <String>[].obs;
}

class RechargeSelectionScreen extends StatelessWidget {
  const RechargeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RechargeSelectionController());

    final List<Map<String, dynamic>> assets = [
      {
        'id': 'espresso',
        'title': 'ESPRESSO ASSETS',
        'icon': Icons.local_cafe_outlined,
        'value': 14,
      },
      {
        'id': 'screw',
        'title': 'SCREW ASSETS',
        'icon': Icons.build_outlined,
        'value': 82,
      },
      {
        'id': 'energy_drink',
        'title': 'ENERGY DRINK ASSETS',
        'icon': Icons.local_drink_outlined,
        'value': 82,
      },
      {
        'id': 'fuel',
        'title': 'FUEL ASSETS',
        'icon': Icons.local_gas_station_outlined,
        'value': 82,
      },
      {
        'id': 'coffee',
        'title': 'COFFEE ASSETS',
        'icon': Icons.coffee_outlined,
        'value': 82,
      },
      {
        'id': 'bronze_cup_1',
        'title': 'BRONZE CUP ASSETS',
        'icon': Icons.emoji_events_outlined,
        'value': 82,
      },
      {
        'id': 'bronze_cup_2',
        'title': 'BRONZE CUP ASSETS',
        'icon': Icons.emoji_events_outlined,
        'value': 82,
      },
      {
        'id': 'silver_cup',
        'title': 'SILVER CUP ASSETS',
        'icon': Icons.emoji_events_outlined,
        'value': 82,
      },
      {
        'id': 'gold_cup',
        'title': 'GOLD CUP ASSETS',
        'icon': Icons.emoji_events_outlined,
        'value': 82,
      },
      {
        'id': 'champion_trophy',
        'title': 'CHAMPION TROPHY ASSETS',
        'icon': Icons.emoji_events_outlined,
        'value': 82,
      },
    ];

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: const CustomRoyelAppbar(
          titleName: "RECHARGE ASSETS",
          leftIcon: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: const Color(0xff141414),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// USER DOSSIER label
                    Row(
                      children: [
                        Container(
                          width: 4.w,
                          height: 12.h,
                          color: AppColors.yellow,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "USER_DOSSIER // 042",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            fontFamily: "Courier",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    /// Balance Header
                    const Text(
                      "CURRENT BALANCE",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    /// Balance Value
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "12,450",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "sc",
                          style: TextStyle(
                            color: AppColors.yellow,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    /// Assets list
                    Column(
                      children: assets.map((item) {
                        return Obx(() {
                          final isSelected = controller.selectedAssets.contains(item['id']);
                          return GestureDetector(
                            onTap: () {
                              if (isSelected) {
                                controller.selectedAssets.remove(item['id']);
                              } else {
                                controller.selectedAssets.add(item['id']);
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: EdgeInsets.only(bottom: 12.h),
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                              decoration: BoxDecoration(
                                color: const Color(0xff111111),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: isSelected ? AppColors.yellow : Colors.white.withValues(alpha: 0.03),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    item['icon'] as IconData,
                                    color: isSelected ? AppColors.yellow : AppColors.yellow.withValues(alpha: 0.6),
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: Text(
                                      item['title'] as String,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.white70,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${item['value']}",
                                    style: TextStyle(
                                      color: isSelected ? AppColors.yellow : Colors.white54,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      }).toList(),
                    ),
                    SizedBox(height: 12.h),

                    /// RECHARGE CREDITS button
                    CustomButton(
                      height: 50.h,
                      title: "RECHARGE CREDITS",
                      fontSize: 13,
                      borderRadius: 12.r,
                      fillColor: AppColors.yellow,
                      textColor: Colors.black,
                      fontWeight: FontWeight.w900,
                      onTap: () {
                        if (controller.selectedAssets.isEmpty) {
                          Get.snackbar(
                            "No Selection",
                            "Please select at least one asset to recharge.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(0xff181818),
                            colorText: Colors.redAccent,
                            borderColor: Colors.redAccent.withValues(alpha: 0.5),
                            borderWidth: 1,
                          );
                        } else {
                          Get.toNamed(AppRoutes.buyCoinsScreen);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

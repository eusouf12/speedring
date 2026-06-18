import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_text/custom_text.dart';

class BusinessProfileSheetHelper {
  static void show(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: const Color(0xff111111),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          border: const Border(
            top: BorderSide(color: Colors.white10, width: 1),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 18.h),

            // Profile header
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: const Color(0xff222222),
                  backgroundImage: const NetworkImage(
                    "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=100&fit=crop",
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            text: "ANDERSON RACING",
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w900,
                          ),
                          SizedBox(width: 4.w),
                          const Icon(Icons.verified, color: AppColors.yellow, size: 14),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      CustomText(
                        text: "Business Organizer Account",
                        color: Colors.white30,
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white10, height: 24),

            // Switch items
            _buildSwitchItem(
              icon: Icons.calendar_today_outlined,
              title: "Manage Events",
              subtitle: "Active racing sessions and briefings",
              onTap: () {
                Get.back(); 
                Get.offAllNamed(AppRoutes.businessEventsListScreen);
              },
            ),
            _buildSwitchItem(
              icon: Icons.groups_outlined,
              title: "Racing Clubs",
              subtitle: "Your private clubs and trending circles",
              onTap: () {
                Get.back();
                Get.offAllNamed(AppRoutes.businessClubsScreen);
              },
            ),
            _buildSwitchItem(
              icon: Icons.directions_car_filled_outlined,
              title: "Asset Inventory",
              subtitle: "Manage your vehicles, parts & services",
              onTap: () {
                Get.back();
                Get.offAllNamed(AppRoutes.assetInventoryScreen);
              },
            ),
            _buildSwitchItem(
              icon: Icons.logout_rounded,
              title: "Switch to Driver Profile",
              subtitle: "Access personal driver dashboard",
              textColor: AppColors.yellow,
              onTap: () {
                Get.back();
                Get.offAllNamed(AppRoutes.userHomeScreen);
              },
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  static Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color textColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: const Color(0xff1E1E1E),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: textColor == Colors.white ? Colors.white70 : textColor, size: 18.sp),
            ),
            SizedBox(width: 14.w),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    color: textColor,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: subtitle,
                    color: Colors.white30,
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 18),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import 'package:speedring/helper/guest_checker.dart';

class CustomBusinessNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBusinessNavBar({required this.currentIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// ── Dark Navigation Bar Background ─────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70.h,
              decoration: BoxDecoration(
                color: const Color(0xff0D0D0D),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
                border: const Border(
                  top: BorderSide(color: Colors.white10, width: 1),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _buildNormalNavItem(
                        0,
                        'businessDashboard'.tr.toUpperCase(),
                        Icons.grid_view_rounded,
                      ),
                    ),
                    Expanded(
                      child: _buildNormalNavItem(
                        1,
                        'socialHub'.tr.toUpperCase(),
                        Icons.people_outline_rounded,
                      ),
                    ),
                    const Expanded(
                      child: SizedBox.shrink(),
                    ), // Space for the center Track item
                    Expanded(
                      child: _buildNormalNavItem(
                        3,
                        'market'.tr.toUpperCase(),
                        Icons.storefront_outlined,
                      ),
                    ),
                    Expanded(
                      child: _buildNormalNavItem(
                        4,
                        'profile'.tr.toUpperCase(),
                        Icons.account_circle_outlined,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// ── Floating Center TRACK Button ───────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => _onTap(2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 58.w,
                      height: 58.w,
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.yellow.withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.speed,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "track".tr.toUpperCase(),
                      style: TextStyle(
                        color: currentIndex == 2 ? AppColors.yellow : const Color(0xffD1C5AB),
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalNavItem(int index, String label, IconData icon) {
    final bool isSelected = index == currentIndex;
    final Color itemColor = isSelected
        ? AppColors.yellow
        : const Color(0xffD1C5AB);

    return GestureDetector(
      onTap: () => _onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22.sp, color: itemColor),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 8.sp,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              color: itemColor,
              letterSpacing: 0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _onTap(int index) {
    if (index != currentIndex) {
      if (index == 0 || index == 2 || index == 4) {
        if (GuestChecker.showLoginDialogIfGuest()) return;
      }
      if (index == 0) {
        Get.offAllNamed(AppRoutes.businessHomeScreen);
      } else if (index == 1) {
        Get.offAllNamed(AppRoutes.businessSocialHubScreen);
      } else if (index == 2) {
        Get.offAllNamed(AppRoutes.businessTrackHubScreen);
      } else if (index == 3) {
        Get.offAllNamed(AppRoutes.businessMarketplaceScreen);
      } else if (index == 4) {
        Get.offAllNamed(AppRoutes.businessProfileScreen);
      }
    }
  }
}

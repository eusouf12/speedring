import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';

class CustomBusinessNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBusinessNavBar({required this.currentIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.h,
      decoration: BoxDecoration(
        color: const Color(0xff0D0D0D),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        border: const Border(
          top: BorderSide(color: Colors.white10, width: 1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(0, "DASHBOARD", Icons.grid_view_rounded),
            _buildNavItem(1, "INVENTORY", Icons.directions_car_filled_outlined),
            _buildNavItem(2, "SOCIAL HUB", Icons.people_outline_rounded),
            _buildNavItem(3, "MARKET", Icons.storefront_outlined),
            _buildNavItem(4, "PROFILE", Icons.account_circle_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon) {
    final bool isSelected = index == currentIndex;
    final Color itemColor = isSelected ? AppColors.yellow : const Color(0xffD1C5AB);

    return GestureDetector(
      onTap: () => _onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 65.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22.sp,
              color: itemColor,
            ),
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
      ),
    );
  }

  void _onTap(int index) {
    if (index != currentIndex) {
      if (index == 0) {
        Get.offAllNamed(AppRoutes.businessHomeScreen);
      } else if (index == 1) {
        Get.offAllNamed(AppRoutes.assetInventoryScreen);
      } else if (index == 2) {
        Get.offAllNamed(AppRoutes.businessSocialHubScreen);
      } else if (index == 3) {
        Get.offAllNamed(AppRoutes.businessMarketplaceScreen);
      } else if (index == 4) {
        Get.offAllNamed(AppRoutes.businessProfileScreen);
      }
    }
  }
}

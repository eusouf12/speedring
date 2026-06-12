import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_icons/app_icons.dart';

class CustomNavBar extends StatefulWidget {
  final int currentIndex;

  const CustomNavBar({required this.currentIndex, super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  late int bottomNavIndex;

  @override
  void initState() {
    bottomNavIndex = widget.currentIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(left: 0.w, right: 0.w, bottom: 10.h),
      height: 75.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Inner cyan top gradient glow
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 35.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.r),
                  topRight: Radius.circular(40.r),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.navbarColor,
                    AppColors.white,
                  ],
                ),
              ),
            ),
          ),

          // Row of buttons
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNavItem(0, "HOME", Icons.home),
                  _buildNavItem(1, "BOOKINGS", Icons.calendar_today_rounded),
                  _buildNavItem(2, "MESSAGES", Icons.chat_bubble),
                  _buildNavItem(3, "SOCIAL", null, isImage: true),
                  _buildNavItem(4, "ACCOUNT", Icons.person),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    String label,
    IconData? icon, {
    bool isImage = false,
  }) {
    bool isSelected = index == bottomNavIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 62.w,
        height: 62.w,
        decoration: BoxDecoration(
          color: isSelected ? null : const Color(0xFF161616),
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.navbarColor1,
                    AppColors.navbarColor2,
                  ],
                )
              : null,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isImage)
              Transform.translate(
                offset: const Offset(0, 2),
                child: Image.asset(
                  AppIcons.newLogo, 
                  height: 36.h, 
                  width: 50.w,
                  fit: BoxFit.contain,
                ),
              )
            else
              Icon(
                icon,
                size: 24.sp,
                color: Colors.white,
              ),

            isImage ? const SizedBox.shrink() : SizedBox(height: 3.h),

            Transform.translate(
              offset: Offset(0, isImage ? -4.h : 0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTap(int index) {
    if (index != bottomNavIndex) {
      if (index == 0) {
       // Get.offAllNamed(AppRoutes.homeScreen);
      } else if (index == 1) {
       // Get.offAllNamed(AppRoutes.bookingScreen);
      } else if (index == 2) {
        // Get.offAllNamed(AppRoutes.messagesScreen);
      } else if (index == 3) {
        // Get.offAllNamed(AppRoutes.socialScreen);
      } else if (index == 4) {
       // Get.offAllNamed(AppRoutes.userProfileScreen);
      }
    }
  }
}

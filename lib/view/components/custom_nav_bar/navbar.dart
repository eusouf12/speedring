import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/app_colors/app_colors.dart';

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
                    Expanded(child: _buildNormalNavItem(0, "HOME", Icons.home_outlined)),
                    Expanded(child: _buildNormalNavItem(1, "DISCOVER", Icons.explore_outlined)),
                    const Expanded(child: SizedBox.shrink()), // Space for the center Track item
                    Expanded(child: _buildNormalNavItem(3, "MARKET", Icons.shopping_cart_outlined)),
                    Expanded(child: _buildNormalNavItem(4, "PROFILE", Icons.person_outline)),
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
                onTap: () => onTap(2),
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
                            color: AppColors.yellow.withOpacity(0.3),
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
                      "TRACK",
                      style: TextStyle(
                        color: AppColors.yellow,
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
    final bool isSelected = index == bottomNavIndex;
    final Color itemColor = isSelected ? AppColors.yellow : const Color(0xffD1C5AB);

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
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
              fontSize: 8.5.sp,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              color: itemColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  void onTap(int index) {
    if (index != bottomNavIndex) {
      setState(() {
        bottomNavIndex = index;
      });
      // Handle page switching route calls here if wired with GetX
      // e.g., if (index == 0) Get.offAllNamed(AppRoutes.userHomeScreen);
    }
  }
}

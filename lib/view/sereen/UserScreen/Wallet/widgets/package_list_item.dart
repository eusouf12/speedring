import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_text/custom_text.dart';

class PackageListItem extends StatelessWidget {
  final String coins;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFullWidth;

  const PackageListItem({
    super.key,
    required this.coins,
    required this.price,
    required this.isSelected,
    required this.onTap,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isFullWidth ? 96.h : null,
        width: isFullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          color: const Color(0xff111111),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected
                ? AppColors.yellow
                : Colors.white.withValues(alpha: 0.05),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              text: price,
              color: AppColors.yellow,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
            SizedBox(height: 6.h),
            CustomText(
              text: coins,
              color: isSelected ? AppColors.yellow : Colors.white38,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ],
        ),
      ),
    );
  }
}

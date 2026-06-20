import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_text/custom_text.dart';

class SupportedDriverCard extends StatelessWidget {
  final String avatarUrl;
  final String driverName;
  final String supportAmount;

  const SupportedDriverCard({
    super.key,
    required this.avatarUrl,
    required this.driverName,
    required this.supportAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110.w,
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withValues(alpha:0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.yellow, width: 1.5),
            ),
            child: ClipOval(
              child: Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xff1C1C1C),
                  child: const Icon(Icons.person, color: Colors.white24, size: 28),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          CustomText(
            text: driverName,
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: supportAmount,
            color: AppColors.yellow,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ],
      ),
    );
  }
}

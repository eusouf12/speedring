import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_text/custom_text.dart';

class ActivityListItem extends StatelessWidget {
  final bool isIncoming;
  final String title;
  final String dateTime;
  final String amount;
  final String status;

  const ActivityListItem({
    super.key,
    required this.isIncoming,
    required this.title,
    required this.dateTime,
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withValues(alpha:0.05)),
      ),
      child: Row(
        children: [
          // Direction Icon
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0xff1C1C1C),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncoming ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncoming ? AppColors.yellow : Colors.white60,
              size: 18.w,
            ),
          ),
          SizedBox(width: 14.w),
          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: dateTime,
                  color: Colors.white38,
                  fontSize: 9,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          // Amount & Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: amount,
                color: isIncoming ? AppColors.yellow : Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 4.h),
              CustomText(
                text: status,
                color: isIncoming ? AppColors.yellow.withValues(alpha:0.7) : Colors.white38,
                fontSize: 7.5,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

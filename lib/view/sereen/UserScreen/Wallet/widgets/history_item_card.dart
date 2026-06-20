import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_text/custom_text.dart';

class HistoryItemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtext;
  final String amount;
  final String status;
  final bool isIncoming;

  const HistoryItemCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtext,
    required this.amount,
    required this.status,
    required this.isIncoming,
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
          // Icon Container
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: const Color(0xff1C1C1C),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.white.withValues(alpha:0.03)),
            ),
            child: Icon(
              icon,
              color: isIncoming ? AppColors.yellow : Colors.white60,
              size: 20.w,
            ),
          ),
          SizedBox(width: 14.w),
          // Title & ID/Date Subtext
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: subtext,
                  color: Colors.white38,
                  fontSize: 9,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          // Amount & Verified Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: amount,
                color: isIncoming ? AppColors.yellow : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
              SizedBox(height: 6.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5.w,
                    height: 5.w,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  CustomText(
                    text: status.toUpperCase(),
                    color: Colors.green,
                    fontSize: 7.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

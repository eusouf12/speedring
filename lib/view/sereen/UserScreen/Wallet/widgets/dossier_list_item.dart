import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_text/custom_text.dart';

class DossierListItem extends StatelessWidget {
  final String avatarUrl;
  final String driverName;
  final String username;
  final String amount;
  final String date;
  final String message;

  const DossierListItem({
    super.key,
    required this.avatarUrl,
    required this.driverName,
    required this.username,
    required this.amount,
    required this.date,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withValues(alpha:0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: ClipOval(
                  child: Image.network(
                    avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xff1C1C1C),
                      child: const Icon(Icons.person, color: Colors.white24, size: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Driver Name / Username / Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: driverName,
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 2.h),
                    CustomText(
                      text: username,
                      color: Colors.white38,
                      fontSize: 8.5,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    text: amount,
                    color: AppColors.yellow,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: date,
                    color: Colors.white38,
                    fontSize: 8.5,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Message box
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              '"$message"',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10.sp,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

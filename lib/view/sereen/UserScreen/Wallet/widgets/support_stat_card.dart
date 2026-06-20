import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_text/custom_text.dart';

class SupportStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? trend;

  const SupportStatCard({
    super.key,
    required this.label,
    required this.value,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xff111111),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withValues(alpha:0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: label,
              color: Colors.white38,
              fontSize: 8,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                CustomText(
                  text: value,
                  color: AppColors.yellow,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
                if (trend != null)
                  CustomText(
                    text: trend!,
                    color: Colors.green,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

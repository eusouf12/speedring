import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../components/custom_text/custom_text.dart';

class SpecTile extends StatelessWidget {
  final String label;
  final String value;

  const SpecTile({
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xff161616),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withValues(alpha:0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: label.toUpperCase(),
            color: Colors.white38,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 6.h),
          CustomText(
            text: value,
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

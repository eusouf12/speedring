import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_text/custom_text.dart';

class PackageListItem extends StatelessWidget {
  final String coins;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCustom;
  final int? customQty;
  final ValueChanged<String>? onQtyChanged;

  const PackageListItem({
    super.key,
    required this.coins,
    required this.price,
    required this.isSelected,
    required this.onTap,
    this.isCustom = false,
    this.customQty,
    this.onQtyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: const Color(0xff111111),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.yellow : Colors.white.withValues(alpha:0.05),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: coins,
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomText(
                    text: price,
                    color: AppColors.yellow,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            if (isCustom && isSelected)
              Container(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.h),
                child: Row(
                  children: [
                    CustomText(
                      text: "QTY: ",
                      color: Colors.white60,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Container(
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: const Color(0xff0A0A0A),
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: AppColors.yellow,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                            border: InputBorder.none,
                            hintText: "Enter amount",
                            hintStyle: TextStyle(
                              color: Colors.white24,
                              fontSize: 11.sp,
                            ),
                          ),
                          onChanged: onQtyChanged,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

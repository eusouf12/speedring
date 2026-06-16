import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../components/custom_button/custom_button.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';

class MarketplaceItemCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String subtitle;
  final String tag;
  final VoidCallback onViewDetails;
  final VoidCallback onChatTap;

  const MarketplaceItemCard({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.subtitle,
    required this.tag,
    required this.onViewDetails,
    required this.onChatTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Item Image with Tag Stack
          Stack(
            children: [
              Image.network(
                imageUrl,
                height: 190.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 190.h,
                  color: const Color(0xff222222),
                  child: const Center(
                    child: Icon(Icons.image_not_supported_outlined, color: Colors.white24, size: 40),
                  ),
                ),
              ),
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: CustomText(
                    text: tag.toUpperCase(),
                    color: Colors.black,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          /// Description Section
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: title.toUpperCase(),
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        textAlign: TextAlign.start,
                        letterSpacing: 0.5,
                      ),
                    ),
                    CustomText(
                      text: price,
                      color: AppColors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      textAlign: TextAlign.end,
                      letterSpacing: 0.5,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: subtitle,
                  color: Colors.white38,
                  fontSize: 11,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 16.h),

                /// Actions Row
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        height: 40.h,
                        title: "VIEW DETAILS",
                        fontSize: 12,
                        borderRadius: 8.r,
                        onTap: onViewDetails,
                        icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.black, size: 16),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    GestureDetector(
                      onTap: onChatTap,
                      child: Container(
                        height: 40.h,
                        width: 40.h,
                        decoration: BoxDecoration(
                          color: const Color(0xff222222),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: const Icon(Icons.chat_bubble_outline, color: Colors.white70, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

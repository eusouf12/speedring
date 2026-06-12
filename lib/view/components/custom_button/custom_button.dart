import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors/app_colors.dart';
import '../custom_image/custom_image.dart';
import '../custom_text/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.height = 54,
    this.width = double.maxFinite,
    required this.onTap,
    this.title = '',
    this.marginVertical = 0,
    this.marginHorizontal = 0,
    this.fillColor = AppColors.yellow1,
    this.textColor = AppColors.primary,
    this.isBorder = false,
    this.fontSize,
    this.borderWidth,
    this.borderRadius,
    this.borderColor = AppColors.primary,
    this.showSocialButton = false,
    this.imageSrc,
    this.fontWeight,
    this.icon,
    this.isImageRight = false,
    //required bool isLoading,
  });

  final double height;
  final double? width;
  final Color? fillColor;
  final Color textColor;
  final Color borderColor;
  final VoidCallback? onTap;
  final String title;
  final double marginVertical;
  final double marginHorizontal;
  final bool isBorder;
  final double? fontSize;
  final double? borderWidth;
  final double? borderRadius;
  final bool showSocialButton;
  final String? imageSrc;
  final Widget? icon;
  final FontWeight? fontWeight;
  final bool isImageRight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0.0),
        margin: EdgeInsets.symmetric(
          vertical: marginVertical,
          horizontal: marginHorizontal,
        ),
        alignment: Alignment.center,
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: isBorder
              ? Border.all(color: borderColor, width: borderWidth ?? .05)
              : null,
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
          color: fillColor,
        ),
        child: showSocialButton
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImage(imageSrc: imageSrc ?? ""),
                  CustomText(
                    left: 8,
                    fontSize: fontSize ?? 16.sp,
                    fontWeight: fontWeight ?? FontWeight.w700,
                    color: textColor,
                    textAlign: TextAlign.center,
                    text: title,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isImageRight && imageSrc != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CustomImage(
                        imageSrc: imageSrc!,
                        imageColor: textColor,
                      ),
                    )
                  else if (!isImageRight && icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 0.0),
                      child: icon,
                    ),

                  CustomText(
                    fontSize: fontSize ?? 18.sp,
                    fontWeight: fontWeight ?? FontWeight.w700,
                    color: textColor,
                    textAlign: TextAlign.center,
                    text: title,
                  ),

                  if (isImageRight && imageSrc != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: CustomImage(
                        imageSrc: imageSrc!,
                        imageColor: textColor,
                        height: 20,
                      ),
                    )
                  else if (isImageRight && icon != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: icon,
                    ),
                ],
              ),
      ),
    );
  }
}

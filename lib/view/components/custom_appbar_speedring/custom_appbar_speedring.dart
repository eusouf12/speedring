import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../custom_image/custom_image.dart';
import '../../../utils/app_images/app_images.dart';

class CustomAppBarSpeedring extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarSpeedring({
    super.key,
    this.showBackButton = true,
    this.backgroundColor = Colors.transparent,
    this.onBackTap,
  });

  final bool showBackButton;
  final Color backgroundColor;
  final VoidCallback? onBackTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      title: Row(
        children: [
          /// Back button
          if (showBackButton)
            GestureDetector(
              onTap: onBackTap ?? () => Get.back(),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),

          const Spacer(),

          /// Center logo
          CustomImage(
            imageSrc: AppImages.logo,
            imageType: ImageType.png,
            height: 48,
            width: 140,
            fit: BoxFit.contain,
          ),

          const Spacer(),

          /// Placeholder to balance back button width
          if (showBackButton) const SizedBox(width: 20),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

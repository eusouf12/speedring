import 'package:flutter/material.dart';
import '../custom_image/custom_image.dart';
import '../../../utils/app_images/app_images.dart';

class CustomAppBarStepped extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarStepped({
    super.key,
    this.showBackButton = true,
    this.backgroundColor = Colors.transparent,
    this.onBackTap,
    this.currentStep = 3, // Default step dynamic korar jonno
    this.totalSteps = 4,
  });

  final bool showBackButton;
  final Color backgroundColor;
  final VoidCallback? onBackTap;
  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Left side: Back Button (Sudu showBackButton true hoile dekhabe)
            if (showBackButton) BackButton() else const SizedBox(width: 48),
        
            const Spacer(),
        
            /// Center side: Logo
            CustomImage(
              imageSrc: AppImages.logo,
              imageType: ImageType.png,
              height: 48,
              width: 140,
              fit: BoxFit.contain,
            ),
        
            const Spacer(),
        
            /// Right side: Step Text
            Text(
              'STEP $currentStep OF $totalSteps'.toUpperCase(),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.0, // Image er moto premium look anar jonno
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

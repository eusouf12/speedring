import 'package:flutter/material.dart';
import '../custom_image/custom_image.dart';
import '../../../utils/app_images/app_images.dart';
import '../../../utils/app_colors/app_colors.dart';

/// Premium User AppBar with search icon, centered logo, and action icons (mail, notification).
class CustomAppBarUser extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarUser({
    super.key,
    this.showSearchIcon = true,
    this.backgroundColor = Colors.black,
    this.onSearchTap,
    this.onMailTap,
    this.onNotificationTap,
    this.hasNewMail = false,
    this.hasNewNotification = true,
  });

  final bool showSearchIcon;
  final Color backgroundColor;
  final VoidCallback? onSearchTap;
  final VoidCallback? onMailTap;
  final VoidCallback? onNotificationTap;
  final bool hasNewMail;
  final bool hasNewNotification;

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
          children: [
            /// ── Left side: Search Icon ──
            if (showSearchIcon)
              GestureDetector(
                onTap: onSearchTap,
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 24,
                ),
              )
            else
              const SizedBox(width: 24),

            const Spacer(),

            /// ── Center side: Logo ──
            CustomImage(
              imageSrc: AppImages.logo,
              imageType: ImageType.png,
              height: 40,
              width: 130,
              fit: BoxFit.contain,
            ),

            const Spacer(),

            /// ── Right side: Mail & Notification ──
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Mail Icon
                GestureDetector(
                  onTap: onMailTap,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.mail_outline_rounded,
                        color: Color(0xffD1C5AB), // Muted tan/gold color from SS
                        size: 24,
                      ),
                      if (hasNewMail)
                        Positioned(
                          right: -1,
                          top: -1,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.yellow,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                /// Notification Icon
                GestureDetector(
                  onTap: onNotificationTap,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.notifications_none_outlined,
                        color: Color(0xffD1C5AB), // Muted tan/gold color from SS
                        size: 24,
                      ),
                      if (hasNewNotification)
                        Positioned(
                          right: 1,
                          top: 1,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.yellow,
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(
                                BorderSide(color: Colors.black, width: 1),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';

import '../../../../../utils/app_images/app_images.dart';

class TrackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showLogo;
  final String profilePic;

  const TrackAppBar({
    required this.title,
    this.leading,
    this.actions,
    this.showLogo = false,
    super.key,
    required this.profilePic,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: leading,
      title: showLogo
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppImages.splashLogo,
                  height: 150,
                  width: 350,
                  fit: BoxFit.contain,
                ),
                if (title.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.yellow,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ],
            )
          : Text(
              title,
              style: const TextStyle(
                color: AppColors.yellow,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
      actions:
          actions ??
          [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Get.offAllNamed(AppRoutes.profileScreen);
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.yellow, width: 1.5),
                      image: DecorationImage(
                        image: NetworkImage(profilePic),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

import 'package:flutter/material.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';

class TrackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showLogo;

  const TrackAppBar({
    required this.title,
    this.leading,
    this.actions,
    this.showLogo = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leading: leading ?? IconButton(
        icon: const Icon(Icons.menu, color: AppColors.yellow),
        onPressed: () {},
      ),
      title: showLogo
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  "https://picsum.photos/seed/speedringlogo/130/40",
                  height: 30,
                  width: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, _, __) => const Text(
                    "SPEEDRING",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
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
                ]
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
      actions: actions ?? [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.yellow, width: 1.5),
                image: const DecorationImage(
                  image: NetworkImage("https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=100&fit=crop"),
                  fit: BoxFit.cover,
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

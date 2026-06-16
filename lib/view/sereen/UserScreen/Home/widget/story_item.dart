import 'package:flutter/material.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import '../../../../components/custom_image/custom_image.dart';
import '../../../../components/custom_text/custom_text.dart';

class StoryItem extends StatelessWidget {
  const StoryItem({
    super.key,
    required this.isMe,
    required this.name,
    this.imageSrc,
    this.icon,
  });

  final bool isMe;
  final String name;
  final String? imageSrc;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Column(
        children: [
          /// Story Circle
          if (isMe)
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.yellow,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.yellow.withValues(alpha: 0.35),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 26,
                  weight: 900,
                ),
              ),
            )
          else
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.yellow, width: 1.5),
              ),
              child: ClipOval(
                child: imageSrc != null
                    ? CustomImage(
                        imageSrc: imageSrc!,
                        imageType: ImageType.png,
                        fit: BoxFit.cover,
                        width: 66,
                        height: 66,
                      )
                    : Container(
                        color: const Color(0xff1C1C1C),
                        child: Center(
                          child: Icon(
                            icon ?? Icons.person,
                            color: AppColors.yellow,
                            size: 22,
                          ),
                        ),
                      ),
              ),
            ),

          const SizedBox(height: 8),

          /// Name Label
          CustomText(
            text: name.toUpperCase(),
            color: isMe ? AppColors.yellow : Colors.white70,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ],
      ),
    );
  }
}

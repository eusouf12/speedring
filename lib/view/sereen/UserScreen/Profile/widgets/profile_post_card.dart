import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';

class ProfilePostCard extends StatelessWidget {
  final String authorName;
  final String authorAvatar;
  final String timeAgo;
  final String imageUrl;
  final String likes;
  final String comments;
  final String caption;
  final String username;
  final List<String> hashtags;

  const ProfilePostCard({
    required this.authorName,
    required this.authorAvatar,
    required this.timeAgo,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.caption,
    required this.username,
    required this.hashtags,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header: Avatar, Name, Time, More Icon
          Row(
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.network(
                    authorAvatar,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xff1C1C1C),
                      child: const Icon(Icons.person, color: Colors.white24, size: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: authorName.toUpperCase(),
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      textAlign: TextAlign.start,
                      letterSpacing: 0.5,
                    ),
                    SizedBox(height: 2.h),
                    CustomText(
                      text: timeAgo,
                      color: Colors.white38,
                      fontSize: 10,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, color: Colors.white60),
            ],
          ),
          SizedBox(height: 12.h),

          /// Post Image
          Container(
            height: 300.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xff1C1C1C),
                  child: const Icon(Icons.image, color: Colors.white24, size: 48),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          /// Actions Row: Like, Comment, Share
          Row(
            children: [
              const Icon(Icons.favorite_border, color: Colors.white70, size: 20),
              SizedBox(width: 6.w),
              CustomText(
                text: likes,
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(width: 18.w),
              const Icon(Icons.chat_bubble_outline, color: Colors.white70, size: 18),
              SizedBox(width: 6.w),
              CustomText(
                text: comments,
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              const Spacer(),
              const Icon(Icons.share_outlined, color: Colors.white70, size: 18),
            ],
          ),
          SizedBox(height: 12.h),

          /// Caption and Hashtags
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'Barlow Condensed',
                fontSize: 12.sp,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: "$username ",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: "$caption ",
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
                ...hashtags.map(
                  (tag) => TextSpan(
                    text: "$tag ",
                    style: const TextStyle(
                      color: AppColors.yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

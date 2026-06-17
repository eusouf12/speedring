import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../components/custom_text/custom_text.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: BackButton(color: AppColors.yellow,),
          title: Image.network(
            "https://picsum.photos/seed/speedringlogo/130/40",
            height: 30.h,
            width: 100.w,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Text(
              "SPEEDRING",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: AppColors.yellow),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Screen Title & Clear All
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "NOTIFICATIONS",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      CustomText(
                        text: "SYSTEM FEED",
                        color: Colors.white38,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        const Icon(
                          Icons.close,
                          color: Colors.white60,
                          size: 14,
                        ),
                        SizedBox(width: 4.w),
                        CustomText(
                          text: "CLEAR ALL",
                          color: Colors.white60,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              /// NEW Section
              _buildSectionDivider("NEW"),
              SizedBox(height: 12.h),

              /// Notification 1: Track
              _buildNotificationCard(
                avatarWidget: _buildIconBox(Icons.speed, AppColors.yellow),
                category: "TRACK",
                categoryColor: AppColors.yellow,
                time: "02:14 PM",
                title: "SPA-FRANCORCHAMPS: SESSION LIVE",
                content:
                    "The circuit is now green for public lapping. Track temperature is 24°C. Grip levels optimal.",
                isUnread: true,
                actionButton: _buildActionButton(
                  label: "View",
                  onTap: () {},
                  isSolid: true,
                ),
              ),
              SizedBox(height: 12.h),

              /// Notification 2: Social
              _buildNotificationCard(
                avatarWidget: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=100&fit=crop",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                category: "SOCIAL",
                categoryColor: Colors.white60,
                time: "11:45 AM",
                contentWidget: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.sp,
                      height: 1.45,
                    ),
                    children: [
                      const TextSpan(
                        text: "@max_verstappen_33 ",
                        style: TextStyle(
                          color: AppColors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: "mentioned you:\n"),
                      TextSpan(
                        text: "\"Great line through Eau Rouge!\"",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                isUnread: false,
                actionButton: _buildActionButton(
                  label: "View",
                  onTap: () {},
                  isSolid: false,
                ),
              ),
              SizedBox(height: 12.h),

              /// Notification 3: Market
              _buildNotificationCard(
                avatarWidget: _buildIconBox(
                  Icons.shopping_cart_outlined,
                  AppColors.yellow,
                ),
                category: "MARKET",
                categoryColor: AppColors.yellow,
                time: "09:12 AM",
                title: "NEW LEAD: 2024 PORSCHE 911 GT3 RS",
                content:
                    "A verified buyer has sent an inquiry regarding your listing. Buyer Rating: 4.9/5.0.",
                isUnread: true,
                actionButton: _buildActionButton(
                  label: "VIEW LEAD",
                  onTap: () {},
                  isSolid: true,
                ),
              ),
              SizedBox(height: 24.h),

              /// EARLIER Section
              _buildSectionDivider("EARLIER"),
              SizedBox(height: 12.h),

              /// Notification 4: Track (Earlier)
              _buildNotificationCard(
                avatarWidget: _buildIconBox(
                  Icons.timer_outlined,
                  AppColors.yellow,
                ),
                category: "TRACK",
                categoryColor: Colors.white60,
                time: "YESTERDAY",
                title: "NEW RECORD: SECTOR 2 PB",
                content:
                    "You've set a new personal best in Sector 2 at Silverstone.",
                isUnread: false,
                extraWidget: Container(
                  margin: EdgeInsets.only(top: 8.h),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        text: "LAP TIME: ",
                        color: Colors.white38,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      const CustomText(
                        text: "32.441s",
                        color: AppColors.yellow,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionDivider(String title) {
    return Row(
      children: [
        CustomText(
          text: title,
          color: AppColors.yellow,
          fontSize: 9.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }

  Widget _buildIconBox(IconData icon, Color color) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: const Color(0xff181818),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Center(child: Icon(icon, color: color, size: 18)),
    );
  }

  Widget _buildNotificationCard({
    required Widget avatarWidget,
    required String category,
    required Color categoryColor,
    required String time,
    String? title,
    String? content,
    Widget? contentWidget,
    required bool isUnread,
    Widget? actionButton,
    Widget? extraWidget,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isUnread ? Colors.white24 : Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          avatarWidget,
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Category and Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (isUnread) ...[
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: const BoxDecoration(
                              color: AppColors.yellow,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                        ],
                        CustomText(
                          text: category,
                          color: categoryColor,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ],
                    ),
                    CustomText(
                      text: time,
                      color: Colors.white38,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                SizedBox(height: 6.h),

                /// Title
                if (title != null) ...[
                  CustomText(
                    text: title,
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  SizedBox(height: 4.h),
                ],

                /// Content Body
                if (contentWidget != null)
                  contentWidget
                else if (content != null)
                  CustomText(
                    text: content,
                    color: Colors.white70,
                    fontSize: 11.5.sp,
                    height: 1.4,
                  ),

                /// Extra Widget (e.g. LAP TIME badge)
                ?extraWidget,

                /// Action Button
                if (actionButton != null) ...[
                  SizedBox(height: 12.h),
                  actionButton,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onTap,
    required bool isSolid,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSolid ? AppColors.yellow : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
          border: isSolid
              ? null
              : Border.all(color: AppColors.yellow.withValues(alpha: 0.4)),
        ),
        child: Center(
          child: CustomText(
            text: label,
            color: isSolid ? Colors.black : AppColors.yellow,
            fontSize: 10.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

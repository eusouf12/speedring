import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../components/custom_gradient/custom_gradient.dart';

class BusinessPromotionHubScreen extends StatelessWidget {
  const BusinessPromotionHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Local reactive tab selection for sub-navigation (defaults to index 2: "Ads")
    final RxInt subNavIndex = 2.obs;

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "PROMOTION HUB",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
              onPressed: () => Get.toNamed(AppRoutes.businessAccountSettingsScreen),
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header description
              CustomText(
                text: "ACTIVE PROMOTIONS",
                color: AppColors.yellow,
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
              SizedBox(height: 6.h),
              CustomText(
                text: "Manage your active campaigns, schedule future posts, or review previous runs to optimize your reach.",
                color: Colors.white54,
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 16.h),

              // + NEW PROMOTION Button
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.businessCreatePromotionScreen),
                child: Container(
                  height: 44.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_circle_outline, color: Colors.black, size: 16),
                      SizedBox(width: 8.w),
                      CustomText(
                        text: "NEW PROMOTION",
                        color: Colors.black,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // ACTIVE Campaign Card
              _buildCampaignCard(
                title: "911 GT3 RS SHOWCASE",
                statusText: "ACTIVE NOW",
                statusColor: Colors.green,
                isProgressBar: true,
                progress: 0.68,
                stats: [
                  {'label': 'REACH', 'value': '14,240'},
                  {'label': 'CLICKS', 'value': '1,120'},
                  {'label': 'SPEND', 'value': '\$170.00 / \$250.00'},
                ],
                imageUrl: "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=200&fit=crop",
              ),
              SizedBox(height: 16.h),

              // SCHEDULED Campaign Card
              _buildCampaignCard(
                title: "NIGHT DRIVE: MONACO CIRCUIT",
                statusText: "SCHEDULED",
                statusColor: Colors.blue,
                timerText: "Launch in 14:02:45",
                stats: [
                  {'label': 'GOAL', 'value': 'More Views'},
                  {'label': 'BUDGET', 'value': '\$25.00 / Day'},
                  {'label': 'DURATION', 'value': '7 Days'},
                ],
                imageUrl: "https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?w=200&fit=crop",
              ),
              SizedBox(height: 16.h),

              // FINISHED Campaign Card
              _buildCampaignCard(
                title: "ENDURANCE SERIES RECAP",
                statusText: "FINISHED",
                statusColor: Colors.white38,
                timerText: "Completed Oct 24, 2023",
                stats: [
                  {'label': 'TOTAL REACH', 'value': '24,510'},
                  {'label': 'TOTAL LEADS', 'value': '86'},
                  {'label': 'TOTAL SPEND', 'value': '\$150.00'},
                ],
                imageUrl: "https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=200&fit=crop",
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
        bottomNavigationBar: _buildSubNavBar(subNavIndex),
      ),
    );
  }

  Widget _buildCampaignCard({
    required String title,
    required String statusText,
    required Color statusColor,
    String? timerText,
    bool isProgressBar = false,
    double progress = 0.0,
    required List<Map<String, String>> stats,
    required String imageUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header of campaign (image preview + title + status)
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: Image.network(
                    imageUrl,
                    width: 50.r,
                    height: 50.r,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 50.r,
                      height: 50.r,
                      color: Colors.white10,
                      child: const Icon(Icons.image_not_supported_outlined, color: Colors.white24),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: CustomText(
                              text: statusText,
                              color: statusColor,
                              fontSize: 7.sp,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (timerText != null)
                            CustomText(
                              text: timerText,
                              color: Colors.white54,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                            ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        text: title,
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (isProgressBar)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.yellow),
                      minHeight: 4.h,
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),

          const Divider(color: Colors.white10, height: 1),

          // Campaign Stats grid
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...stats.map((stat) {
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: stat['label']!,
                          color: Colors.white38,
                          fontSize: 7.5.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 2.h),
                        CustomText(
                          text: stat['value']!,
                          color: Colors.white70,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ],
                    ),
                  );
                }),
                // Manage button
                GestureDetector(
                  onTap: () {
                    Get.snackbar(
                      title,
                      "This campaign configuration is fully calibrated.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: const Color(0xff111111),
                      colorText: Colors.white,
                      borderColor: AppColors.yellow,
                      borderWidth: 1,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.yellow, width: 1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: CustomText(
                      text: "MANAGE",
                      color: AppColors.yellow,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w900,
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

  Widget _buildSubNavBar(RxInt selectedIndex) {
    final navItems = [
      {'label': 'POSTS', 'icon': Icons.article_outlined, 'route': AppRoutes.businessProfileScreen},
      {'label': 'STATS', 'icon': Icons.analytics_outlined, 'route': AppRoutes.businessAnalyticsScreen},
      {'label': 'ADS', 'icon': Icons.rocket_launch, 'route': ''}, // Stay
      {'label': 'PROFILE', 'icon': Icons.account_circle_outlined, 'route': AppRoutes.businessProfileScreen},
    ];

    return Container(
      height: 75.h,
      decoration: BoxDecoration(
        color: const Color(0xff0D0D0D),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        border: const Border(
          top: BorderSide(color: Colors.white10, width: 1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(navItems.length, (index) {
            final isSelected = index == selectedIndex.value;
            final item = navItems[index];
            final color = isSelected ? AppColors.yellow : const Color(0xffD1C5AB);

            return GestureDetector(
              onTap: () {
                final route = item['route'] as String;
                if (route.isNotEmpty) {
                  Get.offNamed(route);
                }
              },
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 65.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      size: 22.sp,
                      color: color,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item['label'] as String,
                      style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                        color: color,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

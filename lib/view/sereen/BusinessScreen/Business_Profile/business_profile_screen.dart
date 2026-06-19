import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_text/custom_text.dart';
import '../BusinessHome/business_navbar.dart';
import '../BusinessHome/Controller/business_dashboard_controller.dart';

class BusinessProfileScreen extends StatelessWidget {
  const BusinessProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BusinessDashboardController>();
    final RxString activeTab = "INVENTORY".obs;

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner & Profile Info
              _buildHeroHeader(),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Metrics Section
                    _buildMetricsSection(),
                    SizedBox(height: 24.h),

                    // Quick Operations Grid
                    _buildQuickOperationsGrid(),
                    SizedBox(height: 28.h),

                    // Navigation Tabs Header
                    _buildProfileTabs(activeTab),
                    SizedBox(height: 20.h),

                    // Add Post Action Button
                    _buildAddPostButton(),
                    SizedBox(height: 20.h),

                    // Dynamic Tab Content
                    Obx(() {
                      switch (activeTab.value) {
                        case "POSTS":
                          return _buildPostsSection();
                        case "INVENTORY":
                          return _buildInventorySection(controller);
                        case "EVENT":
                          return _buildEventsSection();
                        case "CLUBS":
                          return _buildClubsSection();
                        default:
                          return const SizedBox.shrink();
                      }
                    }),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBusinessNavBar(currentIndex: 4),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white, size: 22),
        onPressed: () {},
      ),
      title: Image.asset(
        AppImages.logo,
        height: 26.h,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => CustomText(
          text: "SPEEDRING",
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: AppColors.yellow, size: 20),
          onPressed: () => Get.toNamed(AppRoutes.businessAccountSettingsScreen),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildHeroHeader() {
    return SizedBox(
      height: 240.h,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cover Banner
          Container(
            height: 170.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?w=1000&fit=crop",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withValues(alpha: 0.1), Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Profile Info Overlay at bottom left
          Positioned(
            bottom: 0.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Initials Logo Box (AR)
                Container(
                  width: 76.r,
                  height: 76.r,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.yellow, width: 1.8),
                  ),
                  child: Center(
                    child: CustomText(
                      text: "AR",
                      color: AppColors.yellow,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(width: 14.w),

                // Name & Verified Badge
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: "ANDERSON RACING",
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                            ),
                            SizedBox(width: 6.w),
                            const Icon(Icons.verified, color: AppColors.yellow, size: 16),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        CustomText(
                          text: "EXECUTIVE OPERATIONS COMMAND",
                          color: const Color(0xffADAEBC),
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ],
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

  Widget _buildMetricsSection() {
    return Column(
      children: [
        _buildMetricRow(
          metricNum: "METRIC_01",
          label: "ACTIVE LISTINGS",
          value: "12",
          suffix: "UNITS",
        ),
        SizedBox(height: 10.h),
        _buildMetricRow(
          metricNum: "METRIC_02",
          label: "TEAM CAPACITY",
          value: "08 / 10",
          suffix: "ACTIVE",
        ),
        SizedBox(height: 10.h),
        _buildMetricRow(
          metricNum: "METRIC_03",
          label: "PADDOCK RATING",
          value: "4.9",
          isRating: true,
        ),
      ],
    );
  }

  Widget _buildMetricRow({
    required String metricNum,
    required String label,
    required String value,
    String suffix = "",
    bool isRating = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: metricNum,
            color: AppColors.yellow,
            fontSize: 7.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: label,
                color: Colors.white38,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  CustomText(
                    text: value,
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  if (suffix.isNotEmpty) ...[
                    SizedBox(width: 4.w),
                    CustomText(
                      text: suffix,
                      color: AppColors.yellow,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ],
                  if (isRating) ...[
                    SizedBox(width: 6.w),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          color: AppColors.yellow,
                          size: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickOperationsGrid() {
    final operations = [
      {
        'title': 'ORGANIZE EVENTS',
        'icon': Icons.calendar_today_outlined,
        'route': AppRoutes.businessEventsListScreen,
      },
      {
        'title': 'PROMOTE POST',
        'icon': Icons.campaign_outlined,
        'route': '',
      },
      {
        'title': 'CLUBS',
        'icon': Icons.groups_outlined,
        'route': AppRoutes.businessClubsScreen,
      },
      {
        'title': 'TRACK ANALYTICS',
        'icon': Icons.analytics_outlined,
        'route': AppRoutes.businessAnalyticsScreen,
      },
      {
        'title': 'ACCOUNT SETTINGS',
        'icon': Icons.tune_rounded,
        'route': AppRoutes.businessAccountSettingsScreen,
      },
      {
        'title': 'LISTINGS',
        'icon': Icons.storefront_outlined,
        'route': AppRoutes.businessMyListingsScreen,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1.6,
      ),
      itemCount: operations.length,
      itemBuilder: (context, index) {
        final op = operations[index];
        return GestureDetector(
          onTap: () {
            final route = op['route'] as String;
            if (route.isNotEmpty) {
              Get.toNamed(route);
            } else {
              Get.snackbar(
                op['title'] as String,
                "This administrative action is fully calibrated and will connect to live servers soon.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xff111111),
                colorText: Colors.white,
                borderColor: AppColors.yellow,
                borderWidth: 1,
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xff111111),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  op['icon'] as IconData,
                  color: AppColors.yellow,
                  size: 24.sp,
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: op['title'] as String,
                  color: Colors.white,
                  fontSize: 8.5.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileTabs(RxString activeTab) {
    final tabs = ["POSTS", "INVENTORY", "EVENT", "CLUBS"];

    return Obx(() {
      return Container(
        height: 38.h,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white10, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: tabs.map((tab) {
            final isSelected = activeTab.value == tab;
            return GestureDetector(
              onTap: () => activeTab.value = tab,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? AppColors.yellow : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Center(
                  child: CustomText(
                    text: tab,
                    color: isSelected ? AppColors.yellow : Colors.white38,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildAddPostButton() {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.businessCreatePostScreen),
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
              text: "ADD POST",
              color: Colors.black,
              fontSize: 11.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsSection() {
    final posts = [
      {
        'title': 'TELEMETRY CALIBRATION REPORT',
        'time': '2 HOURS AGO',
        'body': 'Completed the track telemetry calibration on our primary 911 GT3 RS. Aerodynamic efficiency was measured with +15% downforce improvement under the Weissach Package specifications.',
        'views': '1.8K',
      },
      {
        'title': 'BREMBO GTR CALIPERS INSTALLED',
        'time': '1 DAY AGO',
        'body': 'Billet monoblock brake system successfully integrated for racing telemetry. Testing begins tomorrow at Silverstone circuit.',
        'views': '940',
      },
    ];

    return Column(
      children: posts.map((post) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: const Color(0xff111111),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: post['title']!,
                    color: AppColors.yellow,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  CustomText(
                    text: post['time']!,
                    color: Colors.white24,
                    fontSize: 7.5.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              CustomText(
                text: post['body']!,
                color: const Color(0xffB0B0B0),
                fontSize: 11.sp,
                textAlign: TextAlign.start,
                height: 1.4,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  const Icon(Icons.remove_red_eye_outlined, color: Colors.white24, size: 14),
                  SizedBox(width: 4.w),
                  CustomText(
                    text: "${post['views']} Views",
                    color: Colors.white38,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInventorySection(BusinessDashboardController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "VERIFIED INVENTORY",
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
            ),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.assetInventoryScreen),
              child: CustomText(
                text: "VIEW FULL STOCK",
                color: AppColors.yellow,
                fontSize: 8.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Obx(() {
          final assets = controller.rxAssets.take(2).toList();
          return Column(
            children: assets.map((asset) {
              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white10),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      asset.imageUrl,
                      height: 140.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 140.h,
                        color: const Color(0xff222222),
                        child: const Icon(Icons.broken_image, color: Colors.white24, size: 28),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(14.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: asset.title,
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w900,
                              ),
                              CustomText(
                                text: asset.price,
                                color: AppColors.yellow,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          CustomText(
                            text: "VIN: ${asset.code}",
                            color: Colors.white38,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          const Divider(color: Colors.white10, height: 16),
                          Row(
                            children: [
                              const Icon(Icons.remove_red_eye_outlined, color: Colors.white24, size: 13),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: "${asset.views} Views",
                                color: Colors.white38,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(width: 14.w),
                              const Icon(Icons.favorite_border, color: Colors.white24, size: 12),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: "${asset.leads} Likes",
                                color: Colors.white38,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildEventsSection() {
    final events = [
      {
        'title': 'SILVERSTONE PERFORMANCE PADDOCK',
        'date': 'OCT 24',
        'location': 'SILVERSTONE',
        'slots': '42/50',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "ACTIVE EVENTS",
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
            ),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.businessEventsListScreen),
              child: CustomText(
                text: "VIEW ALL EVENTS",
                color: AppColors.yellow,
                fontSize: 8.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Column(
          children: events.map((event) {
            return GestureDetector(
              onTap: () => Get.toNamed(
                AppRoutes.businessEventDetailsScreen,
                arguments: {
                  'title': event['title'],
                  'organizer': 'ANDERSON RACING',
                  'imageUrl': 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=800&fit=crop',
                  'date': '${event['date']}, 2024',
                  'time': '09:00 GMT',
                  'location': '${event['location']} CIRCUIT',
                  'capacity': 0.84,
                  'capacityText': '${event['slots']} FULL',
                  'weather': 'OPTIMAL (18°C)',
                  'dataStream': 'FULL ACCESS',
                },
              ),
              child: Container(
                margin: EdgeInsets.only(bottom: 14.h),
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.yellow, width: 1),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: event['date']!.split(' ')[0],
                              color: Colors.white,
                              fontSize: 7.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText(
                              text: event['date']!.split(' ')[1],
                              color: AppColors.yellow,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: event['title']!,
                            color: Colors.white,
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w900,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: Colors.white38, size: 11),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: event['location']!,
                                color: Colors.white38,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(width: 12.w),
                              const Icon(Icons.group_outlined, color: Colors.white38, size: 11),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: "SLOTS: ${event['slots']}",
                                color: AppColors.yellow,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildClubsSection() {
    final clubs = [
      {
        'name': 'Porsche GT3 Collective',
        'members': '1,240 ACTIVE MEMBERS',
        'imageUrl': 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=100&fit=crop',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "SPONSORED CLUBS",
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
            ),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.businessClubsScreen),
              child: CustomText(
                text: "VIEW ALL CLUBS",
                color: AppColors.yellow,
                fontSize: 8.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Column(
          children: clubs.map((club) {
            return GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.businessClubDetailsScreen, arguments: club),
              child: Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        image: DecorationImage(
                          image: NetworkImage(club['imageUrl']!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: club['name']!,
                            color: Colors.white,
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w900,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 2.h),
                          CustomText(
                            text: club['members']!,
                            color: Colors.white38,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

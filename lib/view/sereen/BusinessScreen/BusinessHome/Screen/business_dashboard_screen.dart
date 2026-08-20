import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../../core/app_routes/app_routes.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../service/api_url.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../components/custom_appbar_user/custom_appbar_user.dart';
import '../../../UserScreen/Profile/controller/profile_controller.dart';
import '../business_navbar.dart';

class BusinessHomeScreen extends StatelessWidget {
  const BusinessHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Header
              Row(
                children: [
                  Container(width: 4.w, height: 24.h, color: AppColors.yellow),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: "commandCenter".tr.toUpperCase(),
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              CustomText(
                text: "strategicOversight".tr.toUpperCase(),
                color: const Color(0xffB0B0B0),
                fontSize: 9.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
              SizedBox(height: 24.h),

              // Strategic Operations Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  CustomText(
                    text: "strategicOperations".tr.toUpperCase(),
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                  CustomText(
                    text: "quickActions".tr.toUpperCase(),
                    color: const Color(0xffADAEBC),
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Quick Actions Grid (2 columns)
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 1.6,
                children: [
                  _buildQuickActionCard(
                    title: "createListing".tr.toUpperCase(),
                    icon: Icons.add_box,
                    onTap: () => Get.toNamed(AppRoutes.selectCategoryScreen),
                  ),
                  _buildQuickActionCard(
                    title: "organizeEvent".tr.toUpperCase(),
                    icon: Icons.calendar_today_rounded,
                    onTap: () => Get.toNamed(AppRoutes.businessMyEventScreen),
                  ),
                  _buildQuickActionCard(
                    title: "promotePost".tr.toUpperCase(),
                    icon: Icons.campaign_rounded,
                    onTap: () =>
                        Get.toNamed(AppRoutes.businessPromotionHubScreen),
                  ),
                  _buildQuickActionCard(
                    title: "clubs".tr.toUpperCase(),
                    icon: Icons.groups_outlined,
                    onTap: () => Get.toNamed(AppRoutes.businessClubsScreen),
                  ),
                  _buildQuickActionCard(
                    title: "trackAnalytics".tr.toUpperCase(),
                    icon: Icons.analytics_rounded,
                    onTap: () => Get.toNamed(AppRoutes.businessAnalyticsScreen),
                  ),
                  _buildQuickActionCard(
                    title: "settings".tr.toUpperCase(),
                    icon: Icons.tune_rounded,
                    onTap: () => _showMockSnackbar(
                      "Settings",
                      "Operational panel configurations loaded.",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28.h),

              // Performance Cards
              _buildRevenueCard(),
              SizedBox(height: 16.h),
              _buildLeadsCard(),
              SizedBox(height: 16.h),
              _buildConversionCard(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBusinessNavBar(currentIndex: 0),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final ProfileScreenController profileController =
        Get.find<ProfileScreenController>();

    return CustomAppBarUser(
      showSearchIcon: false,
      leadingWidget: Obx(() {
        final profileImage = profileController.profileData.value?.profileImage;
        final hasImage = profileImage != null && profileImage.isNotEmpty;

        return CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xff222222),
          backgroundImage: hasImage
              ? NetworkImage(
                  profileImage.startsWith('http')
                      ? profileImage
                      : ApiUrl.baseUrl + profileImage,
                )
              : null,
          child: !hasImage
              ? const Icon(Icons.person, color: Colors.white, size: 30)
              : null,
        );
      }),
      onNotificationTap: () {
        Get.toNamed(AppRoutes.notificationScreen);
      },
      onMailTap: () {
        Get.toNamed(AppRoutes.messageScreen);
      },
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xff111111),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: AppColors.yellow, size: 24.sp),
            CustomText(
              text: title,
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
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
                text: "totalRevenue".tr.toUpperCase(),
                color: const Color(0xffB0B0B0),
                fontSize: 9.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
              const Icon(
                Icons.account_balance_wallet_outlined,
                color: Colors.white24,
                size: 18,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              CustomText(
                text: "\$4.82M",
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.w900,
              ),
              SizedBox(width: 8.w),
              CustomText(
                text: "+12.4%",
                color: AppColors.green,
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildMiniBarChart([
            _ChartBarData(height: 8.h, isYellow: false),
            _ChartBarData(height: 12.h, isYellow: false),
            _ChartBarData(height: 32.h, isYellow: true),
            _ChartBarData(height: 10.h, isYellow: false),
            _ChartBarData(height: 42.h, isYellow: true),
            _ChartBarData(height: 14.h, isYellow: false),
          ]),
        ],
      ),
    );
  }

  Widget _buildLeadsCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
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
                text: "activeLeads".tr.toUpperCase(),
                color: const Color(0xffB0B0B0),
                fontSize: 9.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
              const Icon(Icons.hub_outlined, color: Colors.white24, size: 18),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              CustomText(
                text: "1,248",
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.w900,
              ),
              SizedBox(width: 8.w),
              CustomText(
                text: "84 NEW",
                color: AppColors.yellow,
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildMiniBarChart([
            _ChartBarData(height: 10.h, isYellow: true),
            _ChartBarData(height: 20.h, isYellow: true),
            _ChartBarData(height: 34.h, isYellow: true),
            _ChartBarData(height: 12.h, isYellow: false),
            _ChartBarData(height: 8.h, isYellow: false),
            _ChartBarData(height: 28.h, isYellow: true),
          ]),
        ],
      ),
    );
  }

  Widget _buildConversionCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
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
                text: "conversionRate".tr.toUpperCase(),
                color: const Color(0xffB0B0B0),
                fontSize: 9.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
              const Icon(Icons.speed_outlined, color: Colors.white24, size: 18),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              CustomText(
                text: "18.2%",
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.w900,
              ),
              SizedBox(width: 8.w),
              CustomText(
                text: "+1.2%",
                color: AppColors.green,
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildMiniBarChart([
            _ChartBarData(height: 12.h, isYellow: false),
            _ChartBarData(height: 22.h, isYellow: false),
            _ChartBarData(height: 8.h, isYellow: false),
            _ChartBarData(height: 20.h, isYellow: true),
            _ChartBarData(height: 40.h, isYellow: true),
            _ChartBarData(height: 14.h, isYellow: false),
          ]),
        ],
      ),
    );
  }

  Widget _buildMiniBarChart(List<_ChartBarData> bars) {
    return SizedBox(
      height: 45.h,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: bars.map((bar) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              height: bar.height,
              decoration: BoxDecoration(
                color: bar.isYellow
                    ? AppColors.yellow
                    : const Color(0xff222222),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showMockSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff181818),
      colorText: Colors.white,
      borderColor: AppColors.yellow,
      borderWidth: 1,
      duration: const Duration(seconds: 2),
    );
  }
}

class _ChartBarData {
  final double height;
  final bool isYellow;

  _ChartBarData({required this.height, required this.isYellow});
}

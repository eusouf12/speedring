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
                    title: "myListing".tr.toUpperCase(),
                    icon: Icons.list,
                    onTap: () => Get.toNamed(AppRoutes.myListingsScreen),
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
                    onTap: () => Get.toNamed(AppRoutes.mySessionsScreen),
                  ),
                  _buildQuickActionCard(
                    title: "settings".tr.toUpperCase(),
                    icon: Icons.tune_rounded,
                    onTap: () => Get.toNamed(AppRoutes.userParametersScreen),
                  ),
                  _buildQuickActionCard(
                    title: "network".tr.toUpperCase(),
                    icon: Icons.network_cell,
                    onTap: () => Get.toNamed(AppRoutes.businessNetworkScreen),
                  ),
                ],
              ),
              SizedBox(height: 28.h),
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
            Icon(icon, color: AppColors.yellow, size: 26.sp),
            CustomText(
              text: title,
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}

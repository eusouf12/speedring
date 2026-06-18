import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../../core/app_routes/app_routes.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../BusinessHome/business_navbar.dart';
import '../../BusinessHome/Controller/business_dashboard_controller.dart';

class ManageAssetScreen extends StatelessWidget {
  const ManageAssetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<BusinessDashboardController>()
        ? Get.find<BusinessDashboardController>()
        : Get.put(BusinessDashboardController());

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _buildAppBar(),
        body: Obx(() {
          final asset = controller.rxSelectedAsset.value;
          if (asset == null) {
            return Center(
              child: CustomText(
                text: "NO ASSET SELECTED",
                color: Colors.white60,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            );
          }

          // Determine status tag color
          Color tagColor = AppColors.yellow;
          if (asset.status == "LIVE") {
            tagColor = AppColors.green;
          } else if (asset.status == "RESERVED") {
            tagColor = Colors.orangeAccent;
          } else if (asset.status == "DRAFT") {
            tagColor = Colors.white38;
          } else if (asset.status == "SOLD") {
            tagColor = Colors.redAccent;
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "ASSET OVERVIEW",
                  color: AppColors.yellow,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
                SizedBox(height: 12.h),

                // Main Asset Card
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff111111),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.white10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        asset.imageUrl,
                        height: 180.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180.h,
                          color: const Color(0xff222222),
                          child: Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: Colors.white24,
                              size: 36.r,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(6.r),
                                    border: Border.all(
                                      color: tagColor.withValues(alpha: 0.5),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 5.r,
                                        height: 5.r,
                                        decoration: BoxDecoration(
                                          color: tagColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        asset.status,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 7.5.sp,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                CustomText(
                                  text: "CHASSIS ID: ${asset.code}",
                                  color: Colors.white38,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            CustomText(
                              text: asset.title,
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w900,
                            ),
                            SizedBox(height: 8.h),
                            CustomText(
                              text: asset.description,
                              color: const Color(0xffB0B0B0),
                              fontSize: 12.sp,
                              textAlign: TextAlign.start,
                              height: 1.4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // Detail Statistics (leads, views, days online)
                _buildStatsCard(
                  label: "ACTIVE LEADS",
                  value: asset.leads,
                  icon: Icons.people_outline_rounded,
                  valueColor: AppColors.yellow,
                ),
                SizedBox(height: 12.h),
                _buildStatsCard(
                  label: "TOTAL VIEWS",
                  value: asset.views,
                  icon: Icons.remove_red_eye_outlined,
                  valueColor: AppColors.yellow,
                ),
                SizedBox(height: 12.h),
                _buildStatsCard(
                  label: "DAYS ONLINE",
                  value: "09", // Hardcoded mockup day value
                  icon: Icons.access_time_rounded,
                  valueColor: AppColors.yellow,
                ),
                SizedBox(height: 24.h),

                // Action Buttons
                GestureDetector(
                  onTap: () {
                    controller.setAssetForEdit(asset);
                    Get.toNamed(AppRoutes.editListingScreen);
                  },
                  child: Container(
                    height: 48.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.edit, color: Colors.black, size: 18),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: "EDIT LISTING",
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                if (asset.status != "SOLD")
                  GestureDetector(
                    onTap: () {
                      controller.markAsSold();
                      Get.snackbar(
                        "Listing Updated",
                        "Asset marked as SOLD successfully.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xff181818),
                        colorText: Colors.white,
                        borderColor: Colors.redAccent,
                        borderWidth: 1,
                      );
                    },
                    child: Container(
                      height: 48.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xff8B0000), // Dark Red
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8.w),
                          CustomText(
                            text: "MARK AS SOLD",
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        }),
        bottomNavigationBar: const CustomBusinessNavBar(currentIndex: 1),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        "MANAGE ASSET",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: const CircleAvatar(
            backgroundColor: Color(0xff222222),
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard({
    required String label,
    required String value,
    required IconData icon,
    required Color valueColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: label,
                color: Colors.white38,
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: value,
                color: valueColor,
                fontSize: 26.sp,
                fontWeight: FontWeight.w900,
              ),
            ],
          ),
          Icon(icon, color: Colors.white24, size: 28.sp),
        ],
      ),
    );
  }
}

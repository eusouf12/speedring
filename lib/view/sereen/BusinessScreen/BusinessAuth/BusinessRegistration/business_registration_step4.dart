import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/utils/app_images/app_images.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_image/custom_image.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import 'business_registration_controller.dart';

class BusinessRegistrationStep4 extends StatelessWidget {
  const BusinessRegistrationStep4({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<BusinessRegistrationController>()
        ? Get.find<BusinessRegistrationController>()
        : Get.put(BusinessRegistrationController());

    return CustomGradient(
      child: Obx(() {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
              onPressed: () => Get.back(),
            ),
            title: CustomImage(
              imageSrc: AppImages.splashLogo,
              imageType: ImageType.png,
              height: 35.h,
              fit: BoxFit.contain,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Header
                Row(
                  children: [
                    CustomText(
                      text: "PHASE 04 // ASSET CLASS",
                      color: AppColors.yellow,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  height: 4.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                CustomText(
                  text: "CREATE YOUR FIRST",
                  color: Colors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w900,
                ),
                CustomText(
                  text: "LISTING",
                  color: AppColors.yellow,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w900,
                ),
                SizedBox(height: 12.h),
                CustomText(
                  text:
                      "Select your core asset category to initialize your verified marketplace inventory. This selection calibrates your specialized telemetry and transaction dashboard.",
                  color: Colors.white60,
                  fontSize: 12.sp,
                  textAlign: TextAlign.start,
                  height: 1.4,
                ),
                SizedBox(height: 24.h),

                CustomText(
                  text: "PHASE_04: ASSET_INITIALIZATION",
                  color: AppColors.yellow,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
                SizedBox(height: 12.h),

                _buildListingAssetCard(
                  index: 0,
                  title: "VEHICLE",
                  classTag: "HIGH_PERFORMANCE",
                  classNum: "#VH-01",
                  desc:
                      "Performance cars, GT3 chassis, and street-legal supercars, min 200 HP.",
                  icon: Icons.directions_car_outlined,
                  controller: controller,
                ),
                SizedBox(height: 12.h),
                _buildListingAssetCard(
                  index: 1,
                  title: "MOTORCYCLE",
                  classTag: "SUPERBIKE",
                  classNum: "#MC-02",
                  desc:
                      "Racing superbikes and high-performance track machines.",
                  icon: Icons.two_wheeler_outlined,
                  controller: controller,
                ),
                SizedBox(height: 12.h),
                _buildListingAssetCard(
                  index: 2,
                  title: "TECHNICAL PART",
                  classTag: "COMPONENT",
                  classNum: "#TP-03",
                  desc: "Suspension, braking systems, and aerodynamics.",
                  icon: Icons.tune_outlined,
                  controller: controller,
                ),
                SizedBox(height: 12.h),
                _buildListingAssetCard(
                  index: 3,
                  title: "EXPERT SERVICE",
                  classTag: "TECHNICAL",
                  classNum: "#SR-04",
                  desc:
                      "Telemetry, ECU tuning, and professional track-side support.",
                  icon: Icons.build_outlined,
                  controller: controller,
                ),
                SizedBox(height: 32.h),

                CustomButton(
                  onTap: () {
                    // Complete flow, navigate to home screen and clear routes stack
                    Get.offAllNamed(AppRoutes.businessHomeScreen);
                  },
                  title: "CREATE LISTING",
                  fillColor: AppColors.yellow,
                  textColor: Colors.black,
                  borderRadius: 16.r,
                  isImageRight: true,
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildListingAssetCard({
    required int index,
    required String title,
    required String classTag,
    required String classNum,
    required String desc,
    required IconData icon,
    required BusinessRegistrationController controller,
  }) {
    final isSelected = controller.selectedAssetClass.value == index;

    return GestureDetector(
      onTap: () {
        controller.selectedAssetClass.value = index;
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xff111111),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.yellow
                : Colors.white.withValues(alpha: 0.08),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.yellow : Colors.white38,
                size: 24.r,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: title,
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                      ),
                      CustomText(
                        text: classNum,
                        color: Colors.white38,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: "CLASS: $classTag",
                    color: isSelected ? AppColors.yellow : Colors.white38,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    text: desc,
                    color: const Color(0xffB0B0B0),
                    fontSize: 11.sp,
                    textAlign: TextAlign.start,
                    height: 1.3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

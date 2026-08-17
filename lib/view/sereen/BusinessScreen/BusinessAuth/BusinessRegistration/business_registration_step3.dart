import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import 'package:speedring/view/components/custom_text_field/custom_text_field.dart';
import '../controller/business_registration_controller.dart';

class BusinessRegistrationStep3 extends StatelessWidget {
  const BusinessRegistrationStep3({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BusinessRegistrationController>();

    return CustomGradient(
      child: Obx(() {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: CustomText(
              text: 'businessVerification'.tr,
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline, color: Colors.white60),
                onPressed: () => _showHelpDialog(),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Indicator
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      text: 'step3Of4'.tr,
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
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
                        widthFactor: 0.75,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.yellow,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                CustomText(
                  text: 'setupPublicIdentity'.tr,
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                ),
                SizedBox(height: 6.h),
                CustomText(
                  text: 'configureHowYourEngineering'.tr,
                  color: Colors.white60,
                  fontSize: 12.sp,
                  textAlign: TextAlign.start,
                  height: 1.4,
                ),
                SizedBox(height: 24.h),

                _buildModuleHeader('phase01'.tr, 'brandAssets'.tr),
                SizedBox(height: 12.h),

                CustomText(
                  text: 'businessBanner169'.tr,
                  color: Colors.white60,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () => controller.uploadBanner(),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CustomPaint(
                      painter: DashedBorderPainter(color: Colors.white12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: controller.bannerFileName.value.isNotEmpty
                            ? Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(
                                    File(controller.bannerFileName.value),
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, o, s) => Container(
                                      color: const Color(0xff111111),
                                    ),
                                  ),
                                  Container(color: Colors.black38),
                                  Center(
                                    child: Icon(
                                      Icons.add_a_photo_outlined,
                                      color: Colors.white,
                                      size: 28.r,
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                color: const Color(0xff111111),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (controller.isBannerUploading.value)
                                      const CircularProgressIndicator(
                                        color: AppColors.yellow,
                                      )
                                    else ...[
                                      Icon(
                                        Icons.add_a_photo_outlined,
                                        color: AppColors.yellow,
                                        size: 24.r,
                                      ),
                                      SizedBox(height: 8.h),
                                      CustomText(
                                        text: 'uploadHighresBanner'.tr,
                                        color: Colors.white,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                CustomText(
                  text: 'officialLogo11'.tr,
                  color: Colors.white60,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () => controller.uploadBrandLogo(),
                  child: Container(
                    width: 110.w,
                    height: 110.w,
                    decoration: BoxDecoration(
                      color: const Color(0xff111111),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: CustomPaint(
                      painter: DashedBorderPainter(color: Colors.white12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: controller.brandLogoName.value.isNotEmpty
                            ? Image.file(
                                File(controller.brandLogoName.value),
                                fit: BoxFit.cover,
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (controller.isBrandLogoUploading.value)
                                    const CircularProgressIndicator(
                                      color: AppColors.yellow,
                                    )
                                  else ...[
                                    Icon(
                                      Icons.upload_file_outlined,
                                      color: AppColors.yellow,
                                      size: 20.r,
                                    ),
                                    SizedBox(height: 6.h),
                                    CustomText(
                                      text: 'addLogo'.tr,
                                      color: Colors.white,
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                _buildModuleHeader('phase02'.tr, 'coreAttributes'.tr),
                SizedBox(height: 12.h),

                _buildFieldLabel('engineeringPhilosophyHeritage'.tr),
                CustomTextField(
                  textEditingController: controller.philosophyCtrl,
                  hintText: 'detailYourFirmsTechnical'.tr,
                  maxLines: 4,
                ),
                SizedBox(height: 16.h),

                _buildFieldLabel('physicalHq'.tr),
                CustomTextField(
                  textEditingController: controller.hqCtrl,
                  hintText: 'streetAddressCityCountry'.tr,
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.white38,
                  ),
                ),
                SizedBox(height: 16.h),

                _buildFieldLabel('communicationLine'.tr),
                CustomTextField(
                  textEditingController: controller.commCtrl,
                  hintText: '15550000000'.tr,
                  prefixIcon: const Icon(
                    Icons.phone_outlined,
                    color: Colors.white38,
                  ),
                ),
                SizedBox(height: 16.h),

                _buildFieldLabel('digitalHq'.tr),
                CustomTextField(
                  textEditingController: controller.digitalHqCtrl,
                  hintText: 'httpsyourbusinesscom'.tr,
                  prefixIcon: const Icon(
                    Icons.language_outlined,
                    color: Colors.white38,
                  ),
                ),
                SizedBox(height: 16.h),

                _buildFieldLabel('operationalHours'.tr),
                GestureDetector(
                  onTap: () => controller.configureSchedule(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.black_80,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time_outlined,
                          color: Colors.white38,
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: CustomText(
                            text: controller.scheduleText.value,
                            color: Colors.white,
                            fontSize: 15.sp,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.yellow,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                _buildModuleHeader('phase03'.tr, 'networkSync'.tr),
                SizedBox(height: 16.h),

                _buildSocialSyncField(
                  "Instagram Profile",
                  controller.instagramCtrl,
                  Icons.camera_alt_outlined,
                ),
                SizedBox(height: 12.h),
                _buildSocialSyncField(
                  "YouTube Channel",
                  controller.youtubeCtrl,
                  Icons.play_circle_outline,
                ),
                SizedBox(height: 12.h),
                _buildSocialSyncField(
                  "TikTok Handle",
                  controller.tiktokCtrl,
                  Icons.music_note_outlined,
                ),
                SizedBox(height: 12.h),
                _buildSocialSyncField(
                  "Facebook Page",
                  controller.facebookCtrl,
                  Icons.facebook_outlined,
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: CustomButton(
              width: 140.w,
              height: 46.h,
              onTap: () => Get.toNamed(AppRoutes.businessRegistrationStep4),
              title: 'continue'.tr,
              fontSize: 13.sp,
              fillColor: AppColors.yellow,
              textColor: Colors.black,
              borderRadius: 24.r,
            ),
          ),
        );
      }),
    );
  }

  void _showHelpDialog() {
    Get.defaultDialog(
      title: 'businessVerification'.tr,
      titleStyle: TextStyle(
        color: AppColors.yellow,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: const Color(0xff111111),
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: CustomText(
          text: 'verificationEnsuresSpeedringIs'.tr,
          color: Colors.white70,
          fontSize: 13,
          textAlign: TextAlign.center,
        ),
      ),
      textConfirm: "OK",
      confirmTextColor: Colors.black,
      buttonColor: AppColors.yellow,
      onConfirm: () => Get.back(),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: label,
        color: Colors.white60,
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildModuleHeader(String module, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.yellow.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: AppColors.yellow.withValues(alpha: 0.3),
              ),
            ),
            child: CustomText(
              text: module,
              color: AppColors.yellow,
              fontSize: 8.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(width: 8.w),
          CustomText(
            text: title,
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialSyncField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: CustomTextField(
        textEditingController: controller,
        hintText: label,
        prefixIcon: Icon(icon, color: Colors.white38),
      ),
    );
  }
}

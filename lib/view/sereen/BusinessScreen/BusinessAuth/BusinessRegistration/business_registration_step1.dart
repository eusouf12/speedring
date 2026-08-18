import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import 'package:speedring/view/components/custom_text_field/custom_text_field.dart';
import '../controller/business_registration_controller.dart'
    show BusinessRegistrationController;

class BusinessRegistrationStep1 extends StatelessWidget {
  const BusinessRegistrationStep1({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BusinessRegistrationController>();

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
          titleSpacing: 0,
          title: Row(
            children: [
              const Icon(
                Icons.speed_outlined,
                color: AppColors.yellow,
                size: 22,
              ),
              SizedBox(width: 8.w),
              CustomText(
                text: 'registration'.tr,
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'deploymentProgress'.tr,
                        color: AppColors.yellow,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                      CustomText(
                        text: 'step1Of4'.tr,
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
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
                      widthFactor: 0.25,
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

              // Step 1 Form
              Form(
                key: controller.step1FormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: AppColors.yellow.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: CustomText(
                        text: 'identityConfiguration'.tr,
                        color: AppColors.yellow,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    CustomText(
                      text: 'createYournbusinessAccount'.tr,
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w900,
                      textAlign: TextAlign.start,
                      height: 1.1,
                    ),
                    SizedBox(height: 8.h),
                    CustomText(
                      text: 'enterYourProfessionalTelemetry'.tr,
                      color: Colors.white60,
                      fontSize: 12.sp,
                      textAlign: TextAlign.start,
                      height: 1.4,
                      maxLines: 2,
                    ),
                    SizedBox(height: 24.h),

                    _buildFieldLabel('businessNameLabel'.tr),
                    CustomTextField(
                      textEditingController: controller.businessNameCtrl,
                      hintText: 'egApexPerformanceGmbh'.tr,
                      prefixIcon: const Icon(
                        Icons.business_outlined,
                        color: Colors.white38,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'enterBusinessName'.tr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    _buildFieldLabel('ownerRepLabel'.tr),
                    CustomTextField(
                      textEditingController: controller.ownerRepCtrl,
                      hintText: 'fullLegalName'.tr,
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Colors.white38,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'enterOwnerName'.tr;
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    _buildFieldLabel('professionalEmailLabel'.tr),
                    CustomTextField(
                      textEditingController: controller.emailCtrl,
                      hintText: 'namecompanycom'.tr,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(
                        Icons.alternate_email_outlined,
                        color: Colors.white38,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'enterEmailAddress'.tr;
                        }
                        if (!GetUtils.isEmail(v)) {
                          return 'enterValidEmailAddress'.tr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    _buildFieldLabel('contactNumberLabel'.tr),
                    CustomTextField(
                      textEditingController: controller.contactCtrl,
                      hintText: '49'.tr,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(
                        Icons.phone_outlined,
                        color: Colors.white38,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'enterContactNumber'.tr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    _buildFieldLabel('businessCategoryLabel'.tr),
                    Obx(
                      () => GestureDetector(
                        onTap: () => _showCategoryDropdown(context, controller),
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
                                Icons.category_outlined,
                                color: Colors.white38,
                                size: 20,
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: CustomText(
                                  text: controller.category.value.isEmpty
                                      ? 'selectCategory'.tr
                                      : controller.category.value,
                                  color: controller.category.value.isEmpty
                                      ? AppColors.grey
                                      : Colors.white,
                                  fontSize: 16,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white38,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _buildFieldLabel('digitalPresenceUrl'.tr),
                    CustomTextField(
                      textEditingController: controller.websiteCtrl,
                      hintText: 'httpswwwcompanycom'.tr,
                      keyboardType: TextInputType.url,
                      prefixIcon: const Icon(
                        Icons.language_outlined,
                        color: Colors.white38,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'enterWebsiteUrl'.tr;
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),

                    _buildFieldLabel('accessPassword'.tr),
                    CustomTextField(
                      textEditingController: controller.passwordCtrl,
                      hintText: 'empty'.tr,
                      isPassword: true,
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.white38,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'enterPassword'.tr;
                        if (v.length < 6) return 'minimum6Characters'.tr;
                        return null;
                      },
                    ),
                    SizedBox(height: 32.h),

                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.manrope(
                            fontSize: 10.sp,
                            color: Colors.white38,
                            letterSpacing: 0.5,
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(text: 'byContinuingYouAgree'.tr),
                            TextSpan(
                              text: 'commercialTermsOfService'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                    Get.toNamed(AppRoutes.termsScreen),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    CustomButton(
                      onTap: () {
                        if (controller.step1FormKey.currentState!.validate()) {
                          if (controller.category.value.isEmpty) {
                            Get.snackbar(
                              'fieldRequired'.tr,
                              'pleaseSelectCategoryProceed'.tr,
                              colorText: Colors.white,
                              backgroundColor: const Color(0xff111111),
                              snackPosition: SnackPosition.BOTTOM,
                              borderColor: AppColors.yellow,
                              borderWidth: 1,
                            );
                            return;
                          }
                          Get.toNamed(AppRoutes.businessRegistrationStep2);
                        }
                      },
                      title: 'continue'.tr,
                      fillColor: AppColors.yellow,
                      textColor: Colors.black,
                      borderRadius: 16.r,
                    ),
                    SizedBox(height: 24.h),

                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.manrope(
                            fontSize: 12.sp,
                            color: Colors.white60,
                          ),
                          children: [
                            TextSpan(text: 'alreadyHaveAnAccount'.tr),
                            TextSpan(
                              text: 'logIn'.tr,
                              style: const TextStyle(
                                color: AppColors.yellow,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                    Get.offAllNamed(AppRoutes.loginScreen),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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

  void _showCategoryDropdown(
    BuildContext context,
    BusinessRegistrationController controller,
  ) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: const Color(0xff111111),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'selectBusinessCategory'.tr,
              color: AppColors.yellow,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20.h),
            ...[
              'tuningShop'.tr,
              'carDealer'.tr,
              'services'.tr,
              'raceTeam'.tr,
              'partsDistributor'.tr,
              'customGarage'.tr,
            ].map((cat) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: CustomText(
                  text: cat,
                  color: Colors.white,
                  fontSize: 15.sp,
                  textAlign: TextAlign.start,
                ),
                trailing: Obx(
                  () => controller.category.value == cat
                      ? const Icon(Icons.check, color: AppColors.yellow)
                      : const SizedBox.shrink(),
                ),
                onTap: () {
                  controller.category.value = cat;
                  Get.back();
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

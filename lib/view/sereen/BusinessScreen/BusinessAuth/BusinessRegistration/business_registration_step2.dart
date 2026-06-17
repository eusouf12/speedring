import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import 'package:speedring/view/components/custom_text_field/custom_text_field.dart';
import 'business_registration_controller.dart';

class BusinessRegistrationStep2 extends StatelessWidget {
  const BusinessRegistrationStep2({super.key});

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
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: CustomText(
              text: "BUSINESS VERIFICATION",
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
                      text: "STEP 2 OF 4",
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
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
                        widthFactor: 0.50,
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
                  text: "VERIFY YOUR BUSINESS",
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 6.h),
                CustomText(
                  text:
                      "Verification increases trust and marketplace visibility. Complete the modules below to unlock premium selling features.",
                  color: Colors.white60,
                  fontSize: 12.sp,
                  textAlign: TextAlign.start,
                  height: 1.4,
                ),
                SizedBox(height: 24.h),

                _buildModuleHeader("MODULE 01", "BUSINESS LICENSE"),
                CustomText(
                  text: "Upload a valid copy of your official operating license.",
                  color: Colors.white38,
                  fontSize: 11.sp,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 10.h),
                _buildMockUploadCard(
                  fileName: controller.businessLicenseName.value,
                  isUploading: controller.isLicenseUploading.value,
                  onTap: () => controller.uploadLicense(),
                  label: "CHOOSE FILE",
                  icon: Icons.upload_file_outlined,
                ),
                SizedBox(height: 24.h),

                _buildModuleHeader("MODULE 02", "TRADE REGISTRATION"),
                CustomText(
                  text: "Certificate of incorporation or local trade register entry.",
                  color: Colors.white38,
                  fontSize: 11.sp,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 10.h),
                _buildMockUploadCard(
                  fileName: controller.tradeRegName.value,
                  isUploading: controller.isTradeRegUploading.value,
                  onTap: () => controller.uploadTradeReg(),
                  label: "UPLOAD DOC",
                  icon: Icons.verified_outlined,
                ),
                SizedBox(height: 24.h),

                _buildModuleHeader("OPTIONAL", "VAT NUMBER"),
                CustomText(
                  text: "Tax identification for international transactions.",
                  color: Colors.white38,
                  fontSize: 11.sp,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 10.h),
                CustomTextField(
                  textEditingController: controller.vatNumberCtrl,
                  hintText: "EU 123 456 789",
                  prefixIcon: const Icon(Icons.tag, color: Colors.white38),
                ),
                SizedBox(height: 24.h),

                _buildModuleHeader("IDENTITY", "BUSINESS LOGO"),
                CustomText(
                  text: "Visible on your seller profile.",
                  color: Colors.white38,
                  fontSize: 11.sp,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff111111),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: controller.logoFileName.value.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.network(
                                  "https://picsum.photos/seed/apexlogo/100/100",
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.image_outlined, color: Colors.white24),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.isLogoUploading.value)
                              const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.yellow),
                              )
                            else
                              CustomText(
                                text: controller.logoFileName.value.isEmpty
                                    ? "No logo uploaded"
                                    : controller.logoFileName.value,
                                color: controller.logoFileName.value.isEmpty ? Colors.white38 : AppColors.yellow,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                          ],
                        ),
                      ),
                      CustomButton(
                        width: 130.w,
                        height: 38.h,
                        onTap: () => controller.uploadLogo(),
                        title: "UPLOAD SVG/PNG",
                        fontSize: 11.sp,
                        fillColor: const Color(0xff1a1a1a),
                        textColor: AppColors.yellow,
                        isBorder: true,
                        borderColor: AppColors.yellow.withValues(alpha: 0.3),
                        borderRadius: 8.r,
                      ),
                    ],
                  ),
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
              onTap: () => Get.toNamed(AppRoutes.businessRegistrationStep3),
              title: "CONTINUE ",
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
      title: "Business Verification",
      titleStyle: TextStyle(color: AppColors.yellow, fontSize: 16.sp, fontWeight: FontWeight.bold),
      backgroundColor: const Color(0xff111111),
      content: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: CustomText(
          text:
              "Verification ensures Speedring is a secure automotive network. Please upload valid operating licenses or documentation to unlock premium selling capabilities.",
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
              border: Border.all(color: AppColors.yellow.withValues(alpha: 0.3)),
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

  Widget _buildMockUploadCard({
    required String fileName,
    required bool isUploading,
    required VoidCallback onTap,
    required String label,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 85.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xff111111),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: CustomPaint(
          painter: DashedBorderPainter(
            color: fileName.isNotEmpty ? AppColors.yellow : Colors.white12,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isUploading)
                const CircularProgressIndicator(color: AppColors.yellow)
              else if (fileName.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: fileName,
                      color: AppColors.yellow,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: "Tap to change file",
                  color: Colors.white38,
                  fontSize: 10.sp,
                ),
              ] else ...[
                Icon(icon, color: AppColors.yellow, size: 20.r),
                SizedBox(height: 6.h),
                CustomText(
                  text: label,
                  color: Colors.white60,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

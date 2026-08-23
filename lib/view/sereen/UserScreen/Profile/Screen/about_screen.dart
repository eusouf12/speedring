import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../controller/manage_web_controller.dart';
import 'package:speedring/view/components/custom_loader/custom_loader.dart';
import 'package:flutter_html/flutter_html.dart';
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ManageWebController>()..fetchAboutUs();

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
          title: CustomText(
            text: "about".tr.toUpperCase(),
            color: AppColors.yellow,
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        body: Obx(() {
          if (controller.isLoadingAbout.value) {
            return const Center(child: CustomLoader());
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              children: [
                /// Logo image preview
                Container(
                  height: 120.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xff111111),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Center(
                    child: Image.network(
                      "https://picsum.photos/seed/speedringlogo/260/80",
                      height: 50.h,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const CustomText(
                            text: "SPEEDRING",
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                          ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                /// System narrative
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff111111),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSubHeader("ABOUT US".tr),
                      SizedBox(height: 6.h),
                      Html(
                        data: controller.aboutUsContent.value,
                        style: {
                          "body": Style(
                            color: Colors.white70,
                            fontSize: FontSize(12.0),
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                        },
                      ),
                      SizedBox(height: 20.h),
                      _buildSubHeader("systemDetails".tr),
                      SizedBox(height: 10.h),
                      _buildDetailRow("applicationName".tr, "SPEEDRING"),
                      _buildDetailRow("systemVersion".tr, "V4.2.8"),
                      _buildDetailRow("buildHash".tr, "88A92X"),
                      _buildDetailRow(
                        "platformEnvironment".tr,
                        "STAGING / PRODUCTION",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSubHeader(String title) {
    return CustomText(
      text: title,
      color: AppColors.yellow,
      fontSize: 11.sp,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    );
  }

  Widget _buildDetailRow(String label, String val) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: label,
            color: Colors.white38,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
          CustomText(
            text: val,
            color: Colors.white70,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}

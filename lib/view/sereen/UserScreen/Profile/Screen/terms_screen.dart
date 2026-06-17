import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: "LEGAL & COMPLIANCE",
                color: AppColors.yellow,
                fontSize: 8.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
              CustomText(
                text: "TERMS & CONDITIONS",
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("01", "ACCEPTANCE OF TERMS"),
              SizedBox(height: 8.h),
              _buildContentCard(
                child: const CustomText(
                  text:
                      "By creating an account or accessing the Speedring dashboard, you acknowledge that you have read, understood, and agree to be bound by these Terms. Our services are intended for high-performance data tracking and automotive asset management. If you do not agree, you must immediately cease all use of the platform.",
                  color: Color(0xffB0B0B0),
                  fontSize: 12,
                  maxLines: 10,
                  textAlign: TextAlign.start,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),

              _buildSectionHeader("02", "USER ELIGIBILITY"),
              SizedBox(height: 8.h),
              _buildContentCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text:
                          "You must be at least 18 years of age and possess the legal authority to enter into a binding agreement. Professional sellers and racing entities must provide verified credentials to access premium garage features.",
                      color: Color(0xffB0B0B0),
                      fontSize: 12,
                      textAlign: TextAlign.start,
                      height: 1.5,
                      maxLines: 10,
                    ),
                    SizedBox(height: 12.h),
                    _buildBulletPoint(
                      "Valid driver's license required for track telemetry features.",
                    ),
                    SizedBox(height: 8.h),
                    _buildBulletPoint(
                      "Account ownership is non-transferable without written consent.",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              _buildSectionHeader("03", "DATA PRECISION & TELEMETRY"),
              SizedBox(height: 8.h),
              _buildContentCard(
                child: const CustomText(
                  text:
                      "Speedring provides technical data visualization based on hardware input. While we strive for engineering precision, we do not guarantee the 100% accuracy of third-party sensor data. Users are responsible for safe vehicle operation and should not rely solely on digital telemetry for critical safety decisions.",
                  color: Color(0xffB0B0B0),
                  fontSize: 12,
                  textAlign: TextAlign.start,
                  height: 1.5,
                  maxLines: 10,
                ),
              ),
              SizedBox(height: 24.h),

              _buildSectionHeader("04", "INTELLECTUAL PROPERTY"),
              SizedBox(height: 8.h),
              _buildContentCard(
                child: const CustomText(
                  text:
                      "All algorithms, visual interfaces, and telemetry processing methods are the exclusive property of Speedring. Users retain ownership of their uploaded vehicle data but grant Speedring a non-exclusive license to use anonymized data for platform benchmarking and performance optimization.",
                  color: Color(0xffB0B0B0),
                  fontSize: 12,
                  textAlign: TextAlign.start,
                  maxLines: 10,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String num, String title) {
    return Row(
      children: [
        CustomText(
          text: num,
          color: AppColors.yellow,
          fontSize: 13.sp,
          fontWeight: FontWeight.w900,
        ),
        SizedBox(width: 8.w),
        CustomText(
          text: title,
          color: Colors.white,
          fontSize: 13.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ],
    );
  }

  Widget _buildContentCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: child,
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: "- ",
          color: AppColors.yellow,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
        Expanded(
          child: CustomText(
            text: text,
            color: const Color(0xffB0B0B0),
            fontSize: 12,
            textAlign: TextAlign.start,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

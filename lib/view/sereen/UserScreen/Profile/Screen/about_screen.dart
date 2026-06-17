import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                text: "SYSTEM DOSSIER",
                color: AppColors.yellow,
                fontSize: 8.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
              CustomText(
                text: "ABOUT US",
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
            children: [
              /// Logo image preview
              Container(
                height: 120.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Center(
                  child: Image.network(
                    "https://picsum.photos/seed/speedringlogo/260/80",
                    height: 50.h,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const CustomText(
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
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSubHeader("OUR MISSION"),
                    SizedBox(height: 6.h),
                    const CustomText(
                      text:
                          "Speedring is built for drivers who push the limits of performance. Our mission is to democratize professional telemetry logging, connect racing communities, and map real-world track driving through high-precision telemetry. Whether you are driving at Spa or a local closed course, Speedring helps you track your telemetry and refine your lines.",
                      color: Colors.white70,
                      fontSize: 12,
                      textAlign: TextAlign.start,
                      height: 1.5,
                    ),
                    SizedBox(height: 20.h),
                    _buildSubHeader("TELEMETRY ENGINE"),
                    SizedBox(height: 6.h),
                    const CustomText(
                      text:
                          "Speedring's proprietary telemetry engine compiles sub-second GPS coordinate inputs, altitude readings, and speed differentials to render accurate track lap logs. Users can compare telemetry overlays with Pro Drivers and analyze performance diagnostics across multiple sectors.",
                      color: Colors.white70,
                      fontSize: 12,
                      textAlign: TextAlign.start,
                      height: 1.5,
                    ),
                    SizedBox(height: 20.h),
                    _buildSubHeader("SYSTEM DETAILS"),
                    SizedBox(height: 10.h),
                    _buildDetailRow("APPLICATION NAME", "SPEEDRING"),
                    _buildDetailRow("SYSTEM VERSION", "V4.2.8"),
                    _buildDetailRow("BUILD HASH", "88A92X"),
                    _buildDetailRow("PLATFORM ENVIRONMENT", "STAGING / PRODUCTION"),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
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

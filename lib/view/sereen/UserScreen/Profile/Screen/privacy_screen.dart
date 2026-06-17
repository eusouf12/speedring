import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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
                text: "PRIVACY POLICY",
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
              _buildSectionHeader("01", "DATA ENCRYPTION"),
              SizedBox(height: 8.h),
              _buildContentCard(
                child: const CustomText(
                  text:
                      "All your credentials, connection tokens, and account information are heavily encrypted and stored securely using industry-standard protocols. We prioritize securing your credentials at all times.",
                  color: Color(0xffB0B0B0),
                  fontSize: 12,
                  textAlign: TextAlign.start,
                  maxLines: 10,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),

              _buildSectionHeader("02", "TELEMETRY & LOCATIONS"),
              SizedBox(height: 8.h),
              _buildContentCard(
                child: const CustomText(
                  text:
                      "To log your sessions and tracks accurately, Speedring collects fine-grained location telemetry (GPS). This data is processed securely to calculate lap times, sector telemetry, and speeds. Location data is only shared on public leaderboards if explicitly allowed by your profile settings.",
                  color: Color(0xffB0B0B0),
                  fontSize: 12,
                  maxLines: 10,
                  textAlign: TextAlign.start,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),

              _buildSectionHeader("03", "MEDIA STORAGE"),
              SizedBox(height: 8.h),
              _buildContentCard(
                child: const CustomText(
                  text:
                      "Any photos, vehicle listing uploads, or media assets are hosted on secure content delivery networks. You retain all ownership rights over your media, but grant Speedring permission to render and format it across the platform.",
                  color: Color(0xffB0B0B0),
                  fontSize: 12,
                  textAlign: TextAlign.start,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),

              _buildSectionHeader("04", "COOKIES & TRACKING"),
              SizedBox(height: 8.h),
              _buildContentCard(
                child: const CustomText(
                  text:
                      "Speedring uses local session storage and tracking variables to ensure persistent logins, settings preferences, and session logs. We do not sell or lease your tracking profile to third-party ad networks.",
                  color: Color(0xffB0B0B0),
                  fontSize: 12,
                  textAlign: TextAlign.start,
                  maxLines: 10,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),

              _buildSectionHeader("05", "DATA DELETION RIGHTS"),
              SizedBox(height: 8.h),
              _buildContentCard(
                child: const CustomText(
                  text:
                      "You maintain the right to delete your driver profile, telemetry logs, and listings at any time. Terminating your session and requesting account deletion will permanently scrub all records from our active databases.",
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
}

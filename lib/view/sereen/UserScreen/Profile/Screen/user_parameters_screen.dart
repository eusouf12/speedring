import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../core/app_routes/app_routes.dart';

class UserParametersScreen extends StatelessWidget {
  const UserParametersScreen({super.key});

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
                text: "SYSTEM CONFIGURATION",
                color: AppColors.yellow,
                fontSize: 8.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
              CustomText(
                text: "USER PARAMETERS",
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
              /// Driver profile status banner card
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: const BoxDecoration(
                        color: AppColors.yellow,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "DRIVER PROFILE",
                          color: Colors.white38,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        SizedBox(height: 4.h),
                        const CustomText(
                          text: "PRO CERTIFIED",
                          color: AppColors.yellow,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              /// Options group container
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      icon: Icons.settings_outlined,
                      title: "CHANGE PASSWORD",
                      onTap: () {
                        Get.toNamed(AppRoutes.changePasswordScreen);
                      },
                      showDivider: true,
                    ),
                    _buildSettingsTile(
                      icon: Icons.tune,
                      title: "PERSONALIZE YOUR INTERTEST    ",
                      onTap: () => Get.toNamed(AppRoutes.personalizeInterestScreen),
                      showDivider: true,
                    ),
                    _buildSettingsTile(
                      icon: Icons.workspace_premium_outlined,
                      title: "SUBSCRIPTION",
                      onTap: () {
                        Get.toNamed(AppRoutes.choosePlanScreen);
                      },
                      showDivider: true,
                    ),
                    _buildSettingsTile(
                      icon: Icons.gavel_outlined,
                      title: "TERMS & CONDITIONS",
                      onTap: () {
                        Get.toNamed(AppRoutes.termsScreen);
                      },
                      showDivider: true,
                    ),
                    _buildSettingsTile(
                      icon: Icons.security_outlined,
                      title: "PRIVACY POLICY",
                      onTap: () {
                        Get.toNamed(AppRoutes.privacyScreen);
                      },
                      showDivider: true,
                    ),
                    _buildSettingsTile(
                      icon: Icons.help_outline,
                      title: "HELP & SUPPORT",
                      onTap: () {
                        Get.toNamed(AppRoutes.helpSupportScreen);
                      },
                      showDivider: true,
                    ),
                    _buildSettingsTile(
                      icon: Icons.info_outline,
                      title: "ABOUT",
                      onTap: () {
                        Get.toNamed(AppRoutes.aboutScreen);
                      },
                      showDivider: false,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              /// Terminate session button
              Container(
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                  color: const Color(0xff181111),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.15)),
                ),
                child: InkWell(
                  onTap: () {
                    Get.offAllNamed(AppRoutes.loginScreen);
                  },
                  borderRadius: BorderRadius.circular(8.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.logout,
                        color: Color(0xffFF8A8A),
                        size: 18,
                      ),
                      SizedBox(width: 8.w),
                      const CustomText(
                        text: "TERMINATE SESSION",
                        color: Color(0xffFF8A8A),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              /// Build version info
              Center(
                child: CustomText(
                  text: "SPEEDRING SYSTEM V4.2.8 | BUILD 88A92X",
                  color: Colors.white24,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool showDivider,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Icon(icon, color: Colors.white70, size: 20),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomText(
                    text: title,
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.start,
                    letterSpacing: 0.5,
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white38),
              ],
            ),
          ),
          if (showDivider)
            const Divider(
              color: Colors.white10,
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
        ],
      ),
    );
  }
}

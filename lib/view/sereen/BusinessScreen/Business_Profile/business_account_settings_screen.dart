import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_text/custom_text.dart';

class BusinessAccountSettingsScreen extends StatelessWidget {
  const BusinessAccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Reactive preference states
    final RxBool isBiometricEnabled = true.obs;
    final RxBool isEmailAlertsEnabled = true.obs;
    final RxBool isAppNotificationsEnabled = true.obs;

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
          title: const Text(
            "Account Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PERSONAL INFORMATION
              _buildSectionHeader("Personal Information"),
              _buildFormCard([
                _buildFieldLabel("FULL NAME"),
                _buildInfoRow(context, "Marcus Anderson"),
                SizedBox(height: 16.h),
                _buildFieldLabel("EMAIL ADDRESS"),
                _buildInfoRow(context, "m.anderson@racing.io"),
              ]),
              SizedBox(height: 20.h),

              // SECURITY
              _buildSectionHeader("Security"),
              _buildFormCard([
                _buildSecurityPasswordRow(context),
                const Divider(color: Colors.white10, height: 24),
                _buildCheckboxRow(
                  icon: Icons.security,
                  title: "Extra Login Security",
                  subtitle: "Require biometric or hardware key",
                  isEnabled: isBiometricEnabled,
                ),
              ]),
              SizedBox(height: 20.h),

              // COMMUNICATION
              _buildSectionHeader("Communication"),
              _buildFormCard([
                _buildCheckboxRow(
                  title: "Email Alerts",
                  isEnabled: isEmailAlertsEnabled,
                ),
                const Divider(color: Colors.white10, height: 24),
                _buildSwitchRow(
                  title: "App Notifications",
                  isEnabled: isAppNotificationsEnabled,
                ),
              ]),
              SizedBox(height: 20.h),

              // SUBSCRIPTION
              _buildSectionHeader("SUBSCRIPTION"),
              _buildSubscriptionCard(context),
              SizedBox(height: 20.h),

              // TEAM MANAGEMENT
              _buildSectionHeader("Team Management"),
              _buildTeamManagementRow(context),
              SizedBox(height: 32.h),

              // LOGOUT
              _buildLogoutButton(context),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: title,
        color: AppColors.yellow,
        fontSize: 9.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildFormCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: CustomText(
        text: label,
        color: Colors.white38,
        fontSize: 8.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xff0d0d0d),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: value,
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
          GestureDetector(
            onTap: () {
              final controller = TextEditingController(text: value);
              Get.dialog(
                AlertDialog(
                  backgroundColor: const Color(0xff111111),
                  title: const Text("Edit Information", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  content: TextFormField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.yellow)),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("CANCEL", style: TextStyle(color: Colors.white54)),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        Get.snackbar(
                          "Profile Updated",
                          "Personal data sync completed.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xff111111),
                          colorText: Colors.white,
                        );
                      },
                      child: const Text("SAVE", style: TextStyle(color: AppColors.yellow, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xff181818),
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: Colors.white10),
              ),
              child: CustomText(
                text: "Edit",
                color: AppColors.yellow,
                fontSize: 8.5.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityPasswordRow(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.lock_outline_rounded, color: AppColors.yellow, size: 20.sp),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Account Password",
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 2.h),
              CustomText(
                text: "Last changed 4 months ago",
                color: Colors.white38,
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.snackbar(
              "Security Link",
              "Password reset link sent to registered email m.anderson@racing.io",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xff111111),
              colorText: Colors.white,
              borderColor: AppColors.yellow,
              borderWidth: 1,
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              children: [
                CustomText(
                  text: "Change Password",
                  color: Colors.white70,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(width: 4.w),
                Icon(Icons.open_in_new, color: Colors.white54, size: 11.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxRow({
    IconData? icon,
    required String title,
    String? subtitle,
    required RxBool isEnabled,
  }) {
    return Obx(() {
      return Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.yellow, size: 20.sp),
            SizedBox(width: 14.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  CustomText(
                    text: subtitle,
                    color: Colors.white38,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ],
            ),
          ),
          Checkbox(
            value: isEnabled.value,
            activeColor: AppColors.yellow,
            checkColor: Colors.black,
            side: const BorderSide(color: Colors.white38),
            onChanged: (val) {
              if (val != null) isEnabled.value = val;
            },
          ),
        ],
      );
    });
  }

  Widget _buildSwitchRow({
    required String title,
    required RxBool isEnabled,
  }) {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: title,
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
          Switch(
            value: isEnabled.value,
            activeThumbColor: AppColors.yellow,
            activeTrackColor: AppColors.yellow.withValues(alpha: 0.3),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: const Color(0xff222222),
            onChanged: (val) {
              isEnabled.value = val;
            },
          ),
        ],
      );
    });
  }

  Widget _buildSubscriptionCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "CURRENT PLAN",
                    color: Colors.white38,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  SizedBox(height: 6.h),
                  CustomText(
                    text: "Pro Member",
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppColors.yellow,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    side: const BorderSide(color: AppColors.yellow, width: 0.8),
                  ),
                  minimumSize: Size(94.w, 28.h),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                ),
                onPressed: () {
                  Get.toNamed(AppRoutes.businessSelectPlanScreen);
                },
                child: Row(
                  children: [
                    Text(
                      "CHANGE PLAN",
                      style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.open_in_new, color: AppColors.yellow, size: 10.sp),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "NEXT BILLING",
                    color: Colors.white38,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: "OCT 24, 2024",
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ],
              ),
              CustomText(
                text: "AUTO-RENEW ON",
                color: Colors.white24,
                fontSize: 8.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamManagementRow(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      padding: EdgeInsets.all(14.w),
      child: InkWell(
        onTap: () {
          Get.snackbar(
            "Access Matrix",
            "Opening team access management dashboard...",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xff111111),
            colorText: Colors.white,
          );
        },
        child: Row(
          children: [
            Icon(Icons.hub_outlined, color: AppColors.yellow, size: 20.sp),
            SizedBox(width: 14.w),
            Expanded(
              child: CustomText(
                text: "Manage Team Access",
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white24, size: 18.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.dialog(
          AlertDialog(
            backgroundColor: const Color(0xff111111),
            title: const Text("Log Out?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            content: const Text("Are you sure you want to log out of Speedring Business Paddock?", style: TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("CANCEL", style: TextStyle(color: Colors.white54)),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  // In a real app we clear session and go to login. For mock, go back to onboarding/login.
                  Get.offAllNamed(AppRoutes.onboardingScreen);
                },
                child: const Text("LOGOUT", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: const Color(0xff0d0505),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Colors.redAccent, size: 16.sp),
            SizedBox(width: 8.w),
            CustomText(
              text: "LOGOUT",
              color: Colors.redAccent,
              fontSize: 11.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ],
        ),
      ),
    );
  }
}

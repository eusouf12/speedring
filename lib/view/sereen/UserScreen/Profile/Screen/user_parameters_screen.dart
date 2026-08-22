import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/language/language_helper.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../core/app_routes/app_routes.dart';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/helper/shared_prefe/shared_prefe.dart';
import 'package:speedring/utils/app_const/app_const.dart';
import 'package:speedring/helper/guest_checker.dart';
import 'package:speedring/view/sereen/UserScreen/Profile/controller/profile_controller.dart';
import 'package:speedring/view/sereen/UserScreen/MarketPlace/controller/marketpace_controller.dart';

class UserParametersScreen extends StatelessWidget {
  const UserParametersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ProfileScreenController>()
        ? Get.find<ProfileScreenController>()
        : Get.put(ProfileScreenController());

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
          title: Obx(() {
            final isBusiness = controller.profileData.value?.role == 'business';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: "systemConfig".tr.toUpperCase(),
                  color: AppColors.yellow,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
                CustomText(
                  text: isBusiness
                      ? "businessParams".tr.toUpperCase()
                      : "userParams".tr.toUpperCase(),
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                ),
              ],
            );
          }),
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Driver profile status banner card
              Obx(() {
                final isBusiness = controller.profileData.value?.role == 'business';
                final planName = controller.profileData.value?.subscriptionPlan?.toUpperCase() ?? "FREE";
                return Container(
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
                            text: isBusiness
                                ? "businessProfile".tr.toUpperCase()
                                : "driverProfile".tr.toUpperCase(),
                            color: Colors.white38,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          SizedBox(height: 4.h),
                          CustomText(
                            text: planName,
                            color: AppColors.yellow,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
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
                      icon: Icons.language,
                      title: "appLanguageOption".tr.toUpperCase(),
                      onTap: () {
                        LanguageHelper.showLanguageDialog(context);
                      },
                      showDivider: true,
                    ),
                    _buildSettingsTile(
                      icon: Icons.settings_outlined,
                      title: "changePasswordOption".tr.toUpperCase(),
                      onTap: () {
                        Get.toNamed(AppRoutes.changePasswordScreen);
                      },
                      showDivider: true,
                    ),
                    _buildSettingsTile(
                      icon: Icons.tune,
                      title: "personalizeInterest".tr.toUpperCase(),
                      onTap: () =>
                          Get.toNamed(AppRoutes.personalizeInterestScreen),
                      showDivider: true,
                    ),
                    _buildSettingsTile(
                      icon: Icons.workspace_premium_outlined,
                      title: "subscription".tr.toUpperCase(),
                      onTap: () {
                        Get.toNamed(AppRoutes.choosePlanScreen);
                      },
                      showDivider: true,
                    ),
                    _buildSettingsTile(
                      icon: Icons.gavel_outlined,
                      title: "termsConditions".tr.toUpperCase(),
                      onTap: () {
                        Get.toNamed(AppRoutes.termsScreen);
                      },
                      showDivider: true,
                    ),
                    _buildSettingsTile(
                      icon: Icons.security_outlined,
                      title: "privacyPolicyOption".tr.toUpperCase(),
                      onTap: () {
                        Get.toNamed(AppRoutes.privacyScreen);
                      },
                      showDivider: true,
                    ),
                    _buildSettingsTile(
                      icon: Icons.help_outline,
                      title: "helpSupport".tr.toUpperCase(),
                      onTap: () {
                        Get.toNamed(AppRoutes.helpSupportScreen);
                      },
                      showDivider: true,
                    ),
                    _buildSettingsTile(
                      icon: Icons.info_outline,
                      title: "about".tr.toUpperCase(),
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
                  onTap: () async {
                    try {
                      await ApiClient.postData(ApiUrl.logout, {});
                    } catch (e) {
                      debugPrint("Logout API error: $e");
                    }
                    await SharePrefsHelper.remove(AppConstants.bearerToken);
                    await SharePrefsHelper.remove(AppConstants.role);
                    await SharePrefsHelper.remove(AppConstants.userId);
                    await GuestChecker.setGuest(false);
                    if (Get.isRegistered<ProfileScreenController>()) {
                      Get.find<ProfileScreenController>().clearData();
                    }
                    if (Get.isRegistered<MarketplaceFeedController>()) {
                      Get.delete<MarketplaceFeedController>(force: true);
                    }
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
                      CustomText(
                        text: "terminateSession".tr.toUpperCase(),
                        color: const Color(0xffFF8A8A),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              /// Delete account button
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
                    Get.dialog(
                      AlertDialog(
                        backgroundColor: const Color(0xff111111),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          side: const BorderSide(color: Colors.white10, width: 1),
                        ),
                        title: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Colors.red),
                            SizedBox(width: 10.w),
                            CustomText(
                              text: "deleteAccountTitle".tr,
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        content: CustomText(
                          text: "deleteAccountConfirm".tr,
                          color: Colors.white70,
                          fontSize: 14.sp,
                          maxLines: 4,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: CustomText(
                              text: "noLabel".tr,
                              color: Colors.white54,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            ),
                            onPressed: () async {
                              Get.back();
                              final userId = await SharePrefsHelper.getString(AppConstants.userId);
                              if (userId.isNotEmpty) {
                                try {
                                  final response = await ApiClient.deleteData(ApiUrl.deleteAccount(userId));
                                  if (response.statusCode == 200) {
                                    await SharePrefsHelper.remove(AppConstants.bearerToken);
                                    await SharePrefsHelper.remove(AppConstants.role);
                                    await SharePrefsHelper.remove(AppConstants.userId);
                                    await GuestChecker.setGuest(false);
                                    if (Get.isRegistered<ProfileScreenController>()) {
                                      Get.find<ProfileScreenController>().clearData();
                                    }
                                    if (Get.isRegistered<MarketplaceFeedController>()) {
                                      Get.delete<MarketplaceFeedController>(force: true);
                                    }
                                    Get.offAllNamed(AppRoutes.loginScreen);
                                  } else {
                                    Get.snackbar(
                                      "errorLabel".tr,
                                      "deleteAccountFailed".tr,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                } catch (e) {
                                  debugPrint("Delete Account API error: $e");
                                }
                              }
                            },
                            child: CustomText(
                              text: "yesLabel".tr,
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete_forever,
                        color: Color(0xffFF8A8A),
                        size: 18,
                      ),
                      SizedBox(width: 8.w),
                      CustomText(
                        text: "deleteAccountOption".tr.toUpperCase(),
                        color: const Color(0xffFF8A8A),
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

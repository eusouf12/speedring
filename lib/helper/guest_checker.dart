import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/app_routes/app_routes.dart';
import '../helper/shared_prefe/shared_prefe.dart';
import '../utils/app_const/app_const.dart';
import '../utils/app_colors/app_colors.dart';
import '../view/components/custom_text/custom_text.dart';

class GuestChecker {
  static bool _cachedIsGuest = false;

  static Future<void> init() async {
    _cachedIsGuest = await SharePrefsHelper.getBool('isGuest') ?? false;
  }

  static bool get isGuest => _cachedIsGuest;

  static Future<void> setGuest(bool value) async {
    _cachedIsGuest = value;
    await SharePrefsHelper.setBool('isGuest', value);
    if (value) {
      // Clear token when setting guest
      await SharePrefsHelper.remove(AppConstants.bearerToken);
      await SharePrefsHelper.remove(AppConstants.role);
    }
  }

  /// Checks if guest, shows popup if guest, returns true if guest (blocked), false otherwise.
  static bool showLoginDialogIfGuest() {
    if (!_cachedIsGuest) {
      return false;
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xff111111),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: const BorderSide(color: Colors.white10, width: 1),
        ),
        title: Row(
          children: [
            const Icon(Icons.lock_outline, color: AppColors.yellow),
            SizedBox(width: 10.w),
            CustomText(
              text: "loginRequired".tr.isEmpty || "loginRequired".tr == "loginRequired" ? "Login Required" : "loginRequired".tr,
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        content: CustomText(
          text: "pleaseLoginFirst".tr.isEmpty || "pleaseLoginFirst".tr == "pleaseLoginFirst" ? "Please login first to access this feature." : "pleaseLoginFirst".tr,
          color: Colors.white70,
          fontSize: 14.sp,
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: CustomText(
              text: "cancel".tr.isEmpty || "cancel".tr == "cancel" ? "CANCEL" : "cancel".tr.toUpperCase(),
              color: Colors.white54,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            ),
            onPressed: () async {
              Get.back();
              await setGuest(false);
              Get.offAllNamed(AppRoutes.loginScreen);
            },
            child: CustomText(
              text: "login".tr.isEmpty || "login".tr == "login" ? "LOG IN" : "login".tr.toUpperCase(),
              color: Colors.black,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );

    return true;
  }
}

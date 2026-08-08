import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../helper/shared_prefe/shared_prefe.dart';
import '../../utils/app_colors/app_colors.dart';
import '../components/custom_text/custom_text.dart';

class LanguageHelper {
  static const String _key = 'selected_language';

  /// Get saved locale code from SharedPreferences, default is English ('en')
  static Future<Locale> getSavedLocale() async {
    final code = await SharePrefsHelper.getString(_key, defaultValue: 'en');
    return Locale(code);
  }

  /// Change language code, update GetX locale, and save to SharedPreferences
  static Future<void> changeLanguage(String langCode) async {
    final locale = Locale(langCode);
    Get.updateLocale(locale);
    await SharePrefsHelper.setString(_key, langCode);
  }

  /// Show premium language selection dialog / bottom sheet
  static void showLanguageDialog(BuildContext context) {
    final currentLang = Get.locale?.languageCode ?? 'en';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF161616),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            border: Border.all(color: Colors.white10),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 8.h),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'SELECT_LANGUAGE'.tr,
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, color: Colors.white54, size: 20.w),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                _buildLanguageOption(
                  context,
                  title: 'English',
                  langCode: 'en',
                  isSelected: currentLang == 'en',
                ),
                SizedBox(height: 12.h),
                _buildLanguageOption(
                  context,
                  title: 'Deutsch (German)',
                  langCode: 'gr',
                  isSelected: currentLang == 'gr',
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildLanguageOption(
    BuildContext context, {
    required String title,
    required String langCode,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () async {
        await changeLanguage(langCode);
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.yellow.withValues(alpha: 0.08)
              : const Color(0xff1C1C1C),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.yellow : Colors.white10,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: title,
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.yellow,
                size: 20.w,
              )
            else
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30, width: 1.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

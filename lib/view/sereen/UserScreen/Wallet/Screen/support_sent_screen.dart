import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../../../components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../components/custom_button/custom_button.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../controller/send_support_controller.dart';

class SupportSentScreen extends StatelessWidget {
  const SupportSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SendSupportController>();

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomRoyelAppbar(
          leftIcon: true,
          titleName: "SEND_SUPPORT".tr.toUpperCase(),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }

          if (controller.followingList.isEmpty) {
            return Center(
              child: CustomText(
                text: "NO_FRIENDS_FOUND".tr,
                color: Colors.white38,
                fontSize: 14,
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32.h),
                CustomText(
                  text: "SEND_SUPPORT_TO".tr.toUpperCase(),
                  color: Colors.white38,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff111111),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Map<String, dynamic>>(
                      value: controller.selectedUser.value,
                      isExpanded: true,
                      dropdownColor: const Color(0xff111111),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.yellow,
                      ),
                      items: controller.followingList.map((user) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: user,
                          child: Row(
                            children: [
                              user['profileImage'] != null && user['profileImage'].isNotEmpty
                                  ? CircleAvatar(
                                      radius: 14.r,
                                      backgroundImage: NetworkImage(user['profileImage']),
                                    )
                                  : CircleAvatar(
                                      radius: 14.r,
                                      backgroundColor: AppColors.yellow,
                                      child: Icon(Icons.person, size: 16.r, color: Colors.black),
                                    ),
                              SizedBox(width: 12.w),
                              CustomText(
                                text: user['name'] ?? 'User',
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        controller.selectedUser.value = val;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                CustomText(
                  text: "AMOUNT_TO_SEND".tr.toUpperCase(),
                  color: Colors.white38,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff111111),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: TextField(
                    controller: controller.amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    style: TextStyle(
                      color: AppColors.yellow,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixText: "€ ",
                      prefixStyle: TextStyle(
                        color: AppColors.yellow,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      hintText: "0.00",
                      hintStyle: TextStyle(
                        color: Colors.white24,
                        fontSize: 24.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 48.h),
                CustomButton(
                  title: "CONTINUE".tr.toUpperCase(),
                  onTap: () {
                    controller.proceedToVerification();
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

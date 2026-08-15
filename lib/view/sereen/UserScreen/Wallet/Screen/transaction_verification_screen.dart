import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../components/custom_button/custom_button.dart';
import '../controller/send_support_controller.dart';

class TransactionVerificationScreen extends StatelessWidget {
  const TransactionVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SendSupportController>();
    final user = controller.selectedUser.value;
    final amount = controller.supportAmount.value;

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.yellow),
            onPressed: () => Get.back(),
          ),
          title: CustomText(
            text: "TRANSACTION_VERIFICATION".tr,
            color: AppColors.yellow,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              CustomText(
                text: "TARGET_ENTITY".tr.toUpperCase(),
                color: AppColors.yellow,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
              SizedBox(height: 12.h),

              // Entity Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Row(
                  children: [
                    user?['profileImage'] != null && user!['profileImage'].isNotEmpty
                        ? CircleAvatar(
                            radius: 28.r,
                            backgroundColor: AppColors.yellow,
                            child: CircleAvatar(
                              radius: 26.r,
                              backgroundImage: NetworkImage(user['profileImage']),
                            ),
                          )
                        : CircleAvatar(
                            radius: 28.r,
                            backgroundColor: AppColors.yellow,
                            child: Icon(Icons.person, size: 30.r, color: Colors.black),
                          ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: user?['name']?.toUpperCase() ?? "USER",
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                          SizedBox(height: 4.h),
                          CustomText(
                            text: user?['email'] ?? "Email not found",
                            color: Colors.white54,
                            fontSize: 11,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              // Transaction Parameters
              CustomText(
                text: "TRANSACTION_PARAMETERS".tr.toUpperCase(),
                color: AppColors.yellow,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
              SizedBox(height: 12.h),

              // Details Card
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Column(
                  children: [
                    _buildParamRow(
                      "AMOUNT".tr.toUpperCase(),
                      "€${amount.toStringAsFixed(2)}",
                    ),
                    SizedBox(height: 12.h),
                    _buildParamRow("FEE".tr.toUpperCase(), "€0.00"),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Divider(
                        color: Colors.white.withValues(alpha: 0.1),
                        height: 1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "TOTAL".tr.toUpperCase(),
                          color: AppColors.yellow,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                        CustomText(
                          text: "€${amount.toStringAsFixed(2)}",
                          color: AppColors.yellow,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Warning
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 20,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomText(
                        text: "IRREVERSIBLE_ACTION_WARNING".tr,
                        color: Colors.red,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Authorize Button
              Obx(
                () => CustomButton(
                  title: controller.isSending.value
                      ? "PROCESSING".tr.toUpperCase()
                      : "AUTHORIZE_TRANSACTION".tr.toUpperCase(),
                  onTap: () {
                    if (controller.isSending.value) {
                      return;
                    }
                    controller.confirmAndSendSupport();
                  },
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParamRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(text: label, color: Colors.white54, fontSize: 12),
        CustomText(
          text: value,
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/app_routes/app_routes.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../components/custom_button/custom_button.dart';
import '../controller/send_support_controller.dart';
import '../controller/transaction_history_controller.dart';
import 'package:intl/intl.dart';

class TransactionReportScreen extends StatelessWidget {
  const TransactionReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SendSupportController>();
    final user = controller.selectedUser.value;
    final amount = controller.supportAmount.value;
    final formattedDate = DateFormat(
      'dd MMM yyyy • HH:mm',
    ).format(DateTime.now());

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false, // Force them to use the done button
          title: CustomText(
            text: "TRANSACTION_REPORT".tr.toUpperCase(),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
              // Success Icon
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.yellow.withValues(alpha: 0.1),
                  border: Border.all(color: AppColors.yellow, width: 2),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.yellow,
                  size: 40.w,
                ),
              ),
              SizedBox(height: 24.h),

              // Success Message
              CustomText(
                text: "TRANSACTION_SUCCESSFUL".tr.toUpperCase(),
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
              SizedBox(height: 8.h),
              CustomText(
                text: "SUPPORT_HAS_BEEN_TRANSFERRED".tr,
                color: Colors.white54,
                fontSize: 12,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),

              // Report Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Column(
                  children: [
                    _buildReportRow("RECIPIENT".tr, user?['name'] ?? "User"),
                    SizedBox(height: 16.h),
                    _buildReportRow(
                      "AMOUNT_SENT".tr,
                      "€${amount.toStringAsFixed(2)}",
                    ),
                    SizedBox(height: 16.h),
                    _buildReportRow("DATE".tr, formattedDate),
                    SizedBox(height: 16.h),
                    _buildReportRow("STATUS".tr, "COMPLETED".tr),
                  ],
                ),
              ),
              const Spacer(),

              // Done Button
              CustomButton(
                title: "RETURN_TO_WALLET".tr.toUpperCase(),
                onTap: () {
                  if (Get.isRegistered<TransactionHistoryController>()) {
                    Get.find<TransactionHistoryController>().fetchTransactions();
                  }
                  Get.offAllNamed(AppRoutes.walletScreen);
                },
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label.toUpperCase(),
          color: Colors.white54,
          fontSize: 12,
        ),
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

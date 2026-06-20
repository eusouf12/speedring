import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../../../../core/app_routes/app_routes.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../components/custom_button/custom_button.dart';

class TransactionReportScreen extends StatelessWidget {
  const TransactionReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        Get.arguments ?? {"amount": "20.00", "coins": "220"};
    final String purchasedCoins = arguments["coins"] ?? "220";

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomRoyelAppbar(
          leftIcon: true,
          titleName: "TRANSACTION REPORT",
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // Title Message
              CustomText(
                text: "COINS ADDED SUCCESSFULLY",
                color: AppColors.yellow,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
              SizedBox(height: 16.h),
              // Description
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: CustomText(
                  text:
                      "Your performance credits have been successfully verified and added to your driver wallet. System synchronization is now complete.",
                  color: Colors.white60,
                  fontSize: 12,
                  height: 1.5,
                  maxLines: 20,
                ),
              ),
              SizedBox(height: 48.h),

              // Updated Balance Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        CustomText(
                          text: "UPDATED BALANCE",
                          color: Colors.white38,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            CustomText(
                              text: purchasedCoins,
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                            ),
                            SizedBox(width: 8.w),
                            CustomText(
                              text: "COINS",
                              color: AppColors.yellow,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Primary Continue Button
              CustomButton(
                height: 50.h,
                title: "CONTINUE",
                fontSize: 12,
                borderRadius: 8.r,
                fillColor: AppColors.yellow,
                textColor: Colors.black,
                onTap: () {
                  // Navigate back to the profile page or wallet page
                  Get.until(
                    (route) =>
                        Get.currentRoute == AppRoutes.profileScreen ||
                        route.isFirst,
                  );
                },
              ),
              SizedBox(height: 12.h),

              // Secondary action buttons Row
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      height: 48.h,
                      title: "VIEW WALLET",
                      fontSize: 10,
                      borderRadius: 8.r,
                      fillColor: const Color(0xff111111),
                      textColor: Colors.white70,
                      isBorder: true,
                      borderColor: Colors.white12,
                      icon: Icon(
                        Icons.wallet,
                        color: AppColors.yellow,
                        size: 14.w,
                      ),
                      onTap: () {
                        Get.toNamed(AppRoutes.walletScreen);
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomButton(
                      height: 48.h,
                      title: "SUPPORT SOMEONE",
                      fontSize: 10,
                      borderRadius: 8.r,
                      fillColor: const Color(0xff111111),
                      textColor: Colors.white70,
                      isBorder: true,
                      borderColor: Colors.white12,
                      icon: Icon(
                        Icons.handshake_outlined,
                        color: AppColors.yellow,
                        size: 14.w,
                      ),
                      onTap: () {
                        // Go to support tab or discover drivers
                        Get.toNamed(AppRoutes.supportSentScreen);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

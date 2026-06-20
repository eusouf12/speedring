import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/app_routes/app_routes.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../components/custom_button/custom_button.dart';

class TransactionVerificationScreen extends StatelessWidget {
  const TransactionVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            text: "TRANSACTION_VERIFICATION",
            color: AppColors.yellow,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.tune_outlined, color: Colors.white60),
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // TARGET_ENTITY Title
              CustomText(
                text: "TARGET_ENTITY",
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
                  border: Border.all(color: Colors.white.withValues(alpha:0.05)),
                ),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 56.w,
                          height: 56.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.yellow, width: 1.5),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              "https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=120&fit=crop",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -4.h,
                          right: -4.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: AppColors.yellow,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                            child: const Text(
                              "PRO",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 6.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "MAX VERSTAPPEN",
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                        SizedBox(height: 4.h),
                        CustomText(
                          text: "RED BULL RACING | ORACLE",
                          color: Colors.white38,
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 28.h),

              // TELEMETRY_DATA Title
              CustomText(
                text: "TELEMETRY_DATA",
                color: AppColors.yellow,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
              SizedBox(height: 12.h),

              // Telemetry Data Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white.withValues(alpha:0.05)),
                ),
                child: Column(
                  children: [
                    _buildRow("SUPPORT_AMOUNT", "€10.00"),
                    SizedBox(height: 14.h),
                    _buildRow("PLATFORM_FEE", "€1.00"),
                    SizedBox(height: 14.h),
                    _buildRow("SPEEDRING_REVENUE", "€5.00"),
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha:0.4),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "RECIPIENT_EARNINGS",
                            color: AppColors.yellow,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            text: "€4.00",
                            color: AppColors.yellow,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // CONFIRM SUPPORT Button
              CustomButton(
                height: 52.h,
                title: "CONFIRM SUPPORT  ⚡",
                fontSize: 13,
                borderRadius: 12.r,
                fillColor: AppColors.yellow,
                textColor: Colors.black,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.supportSuccessScreen,
                    arguments: {
                      "amount": "€10.00",
                      "recipient": "MAX VERSTAPPEN",
                      "txId": "SRX-928-883-M7"
                    },
                  );
                },
              ),
              SizedBox(height: 12.h),

              // CANCEL Button
              CustomButton(
                height: 50.h,
                title: "CANCEL",
                fontSize: 11,
                borderRadius: 12.r,
                fillColor: Colors.black,
                textColor: Colors.white70,
                isBorder: true,
                borderColor: AppColors.yellow,
                onTap: () => Get.back(),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          color: Colors.white38,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
        CustomText(
          text: value,
          color: Colors.white70,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}

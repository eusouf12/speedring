import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_text/custom_text.dart';

class BusinessSelectPlanScreen extends StatelessWidget {
  const BusinessSelectPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Reactive states
    final RxString billingPeriod = "MONTHLY".obs; // MONTHLY, YEARLY
    final RxString selectedPlan = "XL BUSINESS".obs; // BASIC, XL BUSINESS, XXL BUSINESS, GOLD BUSINESS

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
            "SELECT YOUR PLAN",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    // MONTHLY / YEARLY TOGGLE SWITCH
                    _buildBillingPeriodToggle(billingPeriod),
                    SizedBox(height: 24.h),

                    // PLAN CARDS
                    _buildPlanCard(
                      id: "BASIC",
                      title: "BASIC",
                      price: "Free Entry",
                      features: [
                        "1 active listing",
                        "Essential tools",
                      ],
                      selectedPlan: selectedPlan,
                      isFree: true,
                    ),
                    SizedBox(height: 14.h),

                    _buildPlanCard(
                      id: "XL BUSINESS",
                      title: "XL BUSINESS",
                      price: "€9.99",
                      features: [
                        "Up to 5 listings",
                        "Priority support",
                        "Analytics dashboard",
                      ],
                      selectedPlan: selectedPlan,
                      isRecommended: true,
                    ),
                    SizedBox(height: 14.h),

                    _buildPlanCard(
                      id: "XXL BUSINESS",
                      title: "XXL BUSINESS",
                      price: "€29.99",
                      features: [
                        "Up to 20 listings",
                        "Full telemetry access",
                        "Advanced CRM sync",
                      ],
                      selectedPlan: selectedPlan,
                    ),
                    SizedBox(height: 14.h),

                    _buildPlanCard(
                      id: "GOLD BUSINESS",
                      title: "GOLD BUSINESS",
                      price: "€49.99",
                      features: [
                        "Unlimited listings (21+)",
                        "Dedicated manager",
                        "API connectivity",
                      ],
                      selectedPlan: selectedPlan,
                    ),
                    SizedBox(height: 24.h),

                    // GRID METRICS INFO
                    _buildMetricsGrid(),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            // FOOTER CONTINUE ACTION
            _buildFooterActions(selectedPlan, billingPeriod),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingPeriodToggle(RxString billingPeriod) {
    return Container(
      height: 38.h,
      width: 200.w,
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white10),
      ),
      padding: EdgeInsets.all(2.w),
      child: Obx(() {
        final isMonthly = billingPeriod.value == "MONTHLY";
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => billingPeriod.value = "MONTHLY",
                child: Container(
                  decoration: BoxDecoration(
                    color: isMonthly ? AppColors.yellow : Colors.transparent,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Center(
                    child: CustomText(
                      text: "MONTHLY",
                      color: isMonthly ? Colors.black : Colors.white38,
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => billingPeriod.value = "YEARLY",
                child: Container(
                  decoration: BoxDecoration(
                    color: !isMonthly ? AppColors.yellow : Colors.transparent,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Center(
                    child: CustomText(
                      text: "YEARLY",
                      color: !isMonthly ? Colors.black : Colors.white38,
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPlanCard({
    required String id,
    required String title,
    required String price,
    required List<String> features,
    required RxString selectedPlan,
    bool isFree = false,
    bool isRecommended = false,
  }) {
    return Obx(() {
      final isSelected = selectedPlan.value == id;
      return GestureDetector(
        onTap: () => selectedPlan.value = id,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xff111111),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? AppColors.yellow : Colors.white10,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.yellow.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: title,
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                  if (isRecommended)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        "RECOMMENDED",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 7.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  CustomText(
                    text: price,
                    color: AppColors.yellow,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  if (!isFree) ...[
                    SizedBox(width: 4.w),
                    CustomText(
                      text: "/mo",
                      color: Colors.white38,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ],
              ),
              const Divider(color: Colors.white10, height: 20),
              ...features.map((feature) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: AppColors.yellow, size: 13),
                      SizedBox(width: 8.w),
                      CustomText(
                        text: feature,
                        color: Colors.white60,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMetricsGrid() {
    final metrics = [
      {'label': 'DATA LATENCY', 'val': '< 15MS'},
      {'label': 'UPTIME RECORD', 'val': '99.997%'},
      {'label': 'ENCRYPTION', 'val': 'AES-256'},
      {'label': 'SUPPORT NODE', 'val': 'GLOBAL/L1'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 2.4,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final item = metrics[index];
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xff0d0d0d),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.white10),
          ),
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: item['label']!,
                color: Colors.white24,
                fontSize: 7.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              SizedBox(height: 4.h),
              CustomText(
                text: item['val']!,
                color: Colors.white70,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFooterActions(RxString selectedPlan, RxString billingPeriod) {
    return Container(
      width: double.infinity,
      color: const Color(0xff0d0d0d),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              final planStr = selectedPlan.value;
              final periodStr = billingPeriod.value == "MONTHLY" ? "Monthly" : "Yearly";
              return Column(
                children: [
                  CustomText(
                    text: "SELECTED PLAN",
                    color: Colors.white38,
                    fontSize: 7.5.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: "$planStr ($periodStr) / KEEP CURRENT PLAN",
                    color: Colors.white60,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              );
            }),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () {
                Get.back();
                Get.snackbar(
                  "Subscription Upgraded",
                  "Syncing contract billing cycles...",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xff111111),
                  colorText: Colors.white,
                  borderColor: AppColors.yellow,
                  borderWidth: 1,
                );
              },
              child: Container(
                height: 48.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: const Center(
                  child: CustomText(
                    text: "CONTINUE",
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

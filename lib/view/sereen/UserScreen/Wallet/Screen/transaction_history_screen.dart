import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../widgets/history_item_card.dart';

class TransactionHistoryController extends GetxController {
  final isAllSelected = true.obs;
}

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionHistoryController());

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomRoyelAppbar(
          leftIcon: true,
          titleName: "TRANSACTION HISTORY",
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),

              // Filter Toggles ALL / PURCHASES
              Container(
                width: double.infinity,
                height: 48.h,
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                padding: EdgeInsets.all(4.w),
                child: Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.isAllSelected.value = true,
                          child: Container(
                            decoration: BoxDecoration(
                              color: controller.isAllSelected.value
                                  ? AppColors.yellow
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            alignment: Alignment.center,
                            child: CustomText(
                              text: "ALL",
                              color: controller.isAllSelected.value
                                  ? Colors.black
                                  : Colors.white38,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.isAllSelected.value = false,
                          child: Container(
                            decoration: BoxDecoration(
                              color: !controller.isAllSelected.value
                                  ? AppColors.yellow
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            alignment: Alignment.center,
                            child: CustomText(
                              text: "PURCHASES",
                              color: !controller.isAllSelected.value
                                  ? Colors.black
                                  : Colors.white38,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Search Bar
              Container(
                height: 50.h,
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white60, size: 20),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "SEARCH LEDGER...",
                          hintStyle: TextStyle(
                            color: Colors.white24,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                    CustomText(
                      text: "FILTER_04",
                      color: Colors.white38,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Ledger list
              Expanded(
                child: Obx(() {
                  if (controller.isAllSelected.value) {
                    return ListView(
                      children: const [
                        HistoryItemCard(
                          icon: Icons.add_circle_outline,
                          title: "Reload: 500 Credits",
                          subtext: "TS_ID: 994-01-XPR",
                          amount: "+€50.00",
                          status: "verified",
                          isIncoming: true,
                        ),
                        HistoryItemCard(
                          icon: Icons.handshake_outlined,
                          title: "Support: @MaxVerstappen",
                          subtext: "23 OCT 2023 • 18:45",
                          amount: "-€15.00",
                          status: "verified",
                          isIncoming: false,
                        ),
                        HistoryItemCard(
                          icon: Icons.stars_outlined,
                          title: "Telemetry Support Bounty",
                          subtext: "22 OCT 2023 • 09:12",
                          amount: "+€120.00",
                          status: "verified",
                          isIncoming: true,
                        ),
                      ],
                    );
                  } else {
                    return ListView(
                      children: const [
                        HistoryItemCard(
                          icon: Icons.add_circle_outline,
                          title: "Reload: 500 Credits",
                          subtext: "TS_ID: 994-01-XPR",
                          amount: "+€50.00",
                          status: "verified",
                          isIncoming: true,
                        ),
                      ],
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

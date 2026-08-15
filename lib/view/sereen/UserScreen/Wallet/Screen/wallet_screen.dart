import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/app_routes/app_routes.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_action_button.dart';
import '../widgets/activity_list_item.dart';
import '../controller/transaction_history_controller.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TransactionHistoryController>();
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: BackButton(color: AppColors.yellow),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: AppColors.yellow,
                size: 20.w,
              ),
              SizedBox(width: 8.w),
              CustomText(
                text: "WALLET".tr.toUpperCase(),
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                // Balance Card
                Obx(
                  () => BalanceCard(
                    balance:
                        "€${controller.coinBalance.value.toStringAsFixed(2)}",
                  ),
                ),
                SizedBox(height: 24.h),
                // Quick Actions
                Row(
                  children: [
                    QuickActionButton(
                      icon: Icons.add_circle_outline,
                      title: "BUY_COINS".tr,
                      onTap: () => Get.toNamed(AppRoutes.buyCoinsScreen),
                    ),
                    SizedBox(width: 12.w),
                    QuickActionButton(
                      icon: Icons.history,
                      title: "TRANSACTION_HISTORY".tr,
                      onTap: () =>
                          Get.toNamed(AppRoutes.transactionHistoryScreen),
                    ),
                    SizedBox(width: 12.w),
                    QuickActionButton(
                      icon: Icons.send_outlined,
                      title: "SUPPORT_SENT".tr,
                      onTap: () => Get.toNamed(AppRoutes.supportSentScreen),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                // Recent Activity Header
                Row(
                  children: [
                    Container(
                      width: 4.w,
                      height: 16.h,
                      color: AppColors.yellow,
                    ),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: "RECENT_ACTIVITY".tr.toUpperCase(),
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Activity List
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.yellow),
                    );
                  }
                  final list = controller.allTransactions.take(5).toList();
                  if (list.isEmpty) {
                    return Center(
                      child: CustomText(
                        text: "NO_DATA_FOUND".tr,
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    );
                  }
                  return Column(
                    children: list
                        .map(
                          (item) => ActivityListItem(
                            isIncoming: item.isCredit,
                            title: item.title,
                            dateTime: item.formattedDate,
                            amount:
                                "${item.isCredit ? '+' : '-'}${item.amount.toStringAsFixed(2)}",
                            status: item.status.tr.toUpperCase(),
                          ),
                        )
                        .toList(),
                  );
                }),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                text: "WALLET",
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
                const BalanceCard(balance: "€24.50"),
                SizedBox(height: 24.h),
                // Quick Actions
                Row(
                  children: [
                    QuickActionButton(
                      icon: Icons.add_circle_outline,
                      title: "Buy Coins",
                      onTap: () => Get.toNamed(AppRoutes.buyCoinsScreen),
                    ),
                    SizedBox(width: 12.w),
                    QuickActionButton(
                      icon: Icons.history,
                      title: "Transaction History",
                      onTap: () =>
                          Get.toNamed(AppRoutes.transactionHistoryScreen),
                    ),
                    SizedBox(width: 12.w),
                    QuickActionButton(
                      icon: Icons.send_outlined,
                      title: "Support Sent",
                      onTap: () => Get.toNamed(AppRoutes.supportSentScreen),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                // Recent Activity Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4.w,
                          height: 16.h,
                          color: AppColors.yellow,
                        ),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: "RECENT ACTIVITY",
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.snackbar(
                          "Activity Log",
                          "Viewing all activities.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xff181818),
                          colorText: Colors.white,
                          borderColor: AppColors.yellow,
                          borderWidth: 1,
                        );
                      },
                      child: CustomText(
                        text: "View All",
                        color: AppColors.yellow,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                // Activity List
                const ActivityListItem(
                  isIncoming: true,
                  title: "Reload: 50 Coins",
                  dateTime: "24 OCT 2023 • 14:20",
                  amount: "+€50.00",
                  status: "COMPLETED",
                ),
                const ActivityListItem(
                  isIncoming: false,
                  title: "Support: @MaxVerstappen",
                  dateTime: "23 OCT 2023 • 18:45",
                  amount: "-€15.00",
                  status: "SENT",
                ),
                const ActivityListItem(
                  isIncoming: false,
                  title: "Support: @LewisHamilton",
                  dateTime: "22 OCT 2023 • 09:12",
                  amount: "-€10.50",
                  status: "SENT",
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

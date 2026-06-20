import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/app_routes/app_routes.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../components/custom_button/custom_button.dart';
import '../widgets/package_list_item.dart';
import '../widgets/payment_method_item.dart';

class BuyCoinsController extends GetxController {
  final selectedPackageIndex = 2.obs; // Default 220 coins
  final selectedPaymentMethod = 0.obs; // Default Stripe
  final customQtyText = "".obs;

  final packages = [
    {"coins": "50 COINS", "price": 5.0, "label": "50 SPEEDRING COINS"},
    {"coins": "110 COINS", "price": 10.0, "label": "110 SPEEDRING COINS"},
    {"coins": "220 COINS", "price": 20.0, "label": "220 SPEEDRING COINS"},
    {"coins": "600 COINS", "price": 50.0, "label": "600 SPEEDRING COINS"},
    {"coins": "1250 COINS", "price": 100.0, "label": "1250 SPEEDRING COINS"},
    {"coins": "CUSTOM ALLOCATION", "price": 0.0, "label": "CUSTOM SPEEDRING COINS"},
  ];

  double get subtotal {
    int idx = selectedPackageIndex.value;
    if (idx == 5) {
      double qty = double.tryParse(customQtyText.value) ?? 0.0;
      return qty * 0.10; // €0.10 per coin
    }
    return packages[idx]["price"] as double;
  }

  String get selectedItemLabel {
    int idx = selectedPackageIndex.value;
    if (idx == 5) {
      String qty = customQtyText.value.isEmpty ? "0" : customQtyText.value;
      return "$qty SPEEDRING COINS";
    }
    return packages[idx]["label"] as String;
  }

  double get processingFee => 0.00;

  double get totalAmount => subtotal + processingFee;
}

class BuyCoinsScreen extends StatelessWidget {
  const BuyCoinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BuyCoinsController());

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
           leading: BackButton(color: AppColors.yellow),
          title: CustomText(
            text: "TECHNICAL ENQUIRY",
            color: AppColors.yellow,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.tune_outlined, color: AppColors.yellow),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                // Header Label
                CustomText(
                  text: "PHASE 01: SELECT PACKAGE",
                  color: AppColors.yellow,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
                SizedBox(height: 12.h),

                // Packages list
                Obx(() => Column(
                      children: List.generate(controller.packages.length, (index) {
                        final pkg = controller.packages[index];
                        final isCustom = index == 5;
                        final isSelected = controller.selectedPackageIndex.value == index;
                        final priceStr = isCustom
                            ? "€${controller.subtotal.toStringAsFixed(2)}"
                            : "€${(pkg['price'] as double).toStringAsFixed(2)}";

                        return PackageListItem(
                          coins: pkg["coins"] as String,
                          price: priceStr,
                          isSelected: isSelected,
                          isCustom: isCustom,
                          onQtyChanged: (val) {
                            controller.customQtyText.value = val;
                          },
                          onTap: () {
                            controller.selectedPackageIndex.value = index;
                          },
                        );
                      }),
                    )),

                SizedBox(height: 24.h),

                // Checkout Details
                Obx(() => Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xff111111),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.white.withValues(alpha:0.05)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: "SELECTED ITEM",
                                color: Colors.white38,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomText(
                                text: controller.selectedItemLabel,
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: "SUBTOTAL",
                                color: Colors.white38,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomText(
                                text: "€${controller.subtotal.toStringAsFixed(2)}",
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: "PROCESSING FEE",
                                color: Colors.white38,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomText(
                                text: "€${controller.processingFee.toStringAsFixed(2)}",
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Divider(color: Colors.white.withValues(alpha:0.05), height: 1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: "TOTAL AMOUNT",
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomText(
                                text: "€${controller.totalAmount.toStringAsFixed(2)}",
                                color: AppColors.yellow,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),

                SizedBox(height: 24.h),

                // Secure payment method
                CustomText(
                  text: "SELECT SECURE PAYMENT METHOD",
                  color: Colors.white38,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                SizedBox(height: 12.h),

                Obx(() => Column(
                      children: [
                        PaymentMethodItem(
                          icon: Icon(Icons.credit_card_outlined, color: AppColors.yellow, size: 20.w),
                          label: "Stripe Secure Checkout",
                          isSelected: controller.selectedPaymentMethod.value == 0,
                          onTap: () => controller.selectedPaymentMethod.value = 0,
                        ),
                        PaymentMethodItem(
                          icon: Icon(Icons.apple, color: Colors.white, size: 20.w),
                          label: "Apple Pay",
                          isSelected: controller.selectedPaymentMethod.value == 1,
                          onTap: () => controller.selectedPaymentMethod.value = 1,
                        ),
                        PaymentMethodItem(
                          icon: Icon(Icons.payment, color: Colors.white, size: 20.w),
                          label: "Google Pay",
                          isSelected: controller.selectedPaymentMethod.value == 2,
                          onTap: () => controller.selectedPaymentMethod.value = 2,
                        ),
                        PaymentMethodItem(
                          icon: Icon(Icons.paypal, color: Colors.white, size: 20.w),
                          label: "PayPal",
                          isSelected: controller.selectedPaymentMethod.value == 3,
                          onTap: () => controller.selectedPaymentMethod.value = 3,
                        ),
                      ],
                    )),

                SizedBox(height: 32.h),

                // Button Checkout
                CustomButton(
                  height: 54.h,
                  title: "CONTINUE CHECKOUT >",
                  fontSize: 13,
                  borderRadius: 12.r,
                  fillColor: AppColors.yellow,
                  textColor: Colors.black,
                  onTap: () {
                    // Navigate to transaction success report
                    Get.toNamed(
                      AppRoutes.transactionReportScreen,
                      arguments: {
                        "amount": controller.totalAmount.toStringAsFixed(2),
                        "coins": controller.selectedPackageIndex.value == 5
                            ? (double.tryParse(controller.customQtyText.value) ?? 0.0).toStringAsFixed(0)
                            : controller.packages[controller.selectedPackageIndex.value]["coins"]
                                .toString()
                                .replaceAll(" COINS", "")
                      },
                    );
                  },
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../components/custom_button/custom_button.dart';
import '../controller/support_controller.dart';
import '../widgets/package_list_item.dart';

class BuyCoinsScreen extends StatelessWidget {
  const BuyCoinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SupportController>();

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: BackButton(color: AppColors.yellow),
          title: CustomText(
            text: "technicalEnquiry".tr.toUpperCase(),
            color: AppColors.yellow,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
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
                // Header Label
                CustomText(
                  text: "selectPackage".tr.toUpperCase(),
                  color: AppColors.yellow,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
                SizedBox(height: 12.h),

                // Packages grid
                Obx(() {
                  if (controller.isLoadingPackages.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.yellow),
                    );
                  }
                  if (controller.packages.isEmpty) {
                    return const Center(
                      child: Text(
                        "No packages available",
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: 1.15,
                    ),
                    itemCount: controller.packages.length,
                    itemBuilder: (context, index) {
                      final pkg = controller.packages[index];
                      final isSelected =
                          controller.selectedPackageIndex.value == index;

                      return PackageListItem(
                        coins: "${pkg.name}",
                        price: "€${pkg.price?.toStringAsFixed(2)}",
                        isSelected: isSelected,
                        onTap: () {
                          controller.selectedPackageIndex.value = index;
                        },
                      );
                    },
                  );
                }),
                SizedBox(height: 24.h),

                // Checkout Details
                Obx(
                  () => Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xff111111),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "selectedItem".tr.toUpperCase(),
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
                              text: "subtotal".tr.toUpperCase(),
                              color: Colors.white38,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText(
                              text:
                                  "€${controller.subtotal.toStringAsFixed(2)}",
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
                              text: "processingFee".tr.toUpperCase(),
                              color: Colors.white38,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText(
                              text:
                                  "€${controller.processingFee.toStringAsFixed(2)}",
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Divider(
                            color: Colors.white.withValues(alpha: 0.05),
                            height: 1,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "totalAmount".tr.toUpperCase(),
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText(
                              text:
                                  "€${controller.totalAmount.toStringAsFixed(2)}",
                              color: AppColors.yellow,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Button Checkout
                Obx(
                  () => CustomButton(
                    height: 54.h,
                    title: controller.isCreatingCheckout.value
                        ? "loading".tr.toUpperCase()
                        : "continueCheckout".tr.toUpperCase(),
                    fontSize: 13,
                    borderRadius: 12.r,
                    fillColor: AppColors.yellow,
                    textColor: Colors.black,
                    onTap: controller.isCreatingCheckout.value
                        ? null
                        : () async {
                            if (controller.packages.isEmpty) return;
                            final pkg =
                                controller.packages[controller
                                    .selectedPackageIndex
                                    .value];
                            if (pkg.id != null) {
                              String? url = await controller.buyPackage(
                                pkg.id!,
                              );
                              if (url != null) {
                                // Open payment in external browser for Apple/Google Pay support
                                await launchUrl(
                                  Uri.parse(url),
                                  mode: LaunchMode.inAppBrowserView,
                                );
                              }
                            }
                          },
                  ),
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

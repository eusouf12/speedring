import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import '../BusinessHome/business_navbar.dart';
import '../BusinessHome/Controller/business_dashboard_controller.dart';

class BusinessMyListingsScreen extends StatelessWidget {
  const BusinessMyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BusinessDashboardController>();
    final RxString activeCategory = "ALL".obs;

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
            "MY LISTINGS",
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.yellow),
              onPressed: () => Get.toNamed(AppRoutes.addAssetCategoryScreen),
            ),
          ],
        ),
        body: Obx(() {
          // Calculate valuation dynamically
          double totalVal = 0;
          for (var asset in controller.rxAssets) {
            String priceStr = asset.price.replaceAll(r"$", "").replaceAll(",", "").split("/")[0].trim();
            double? p = double.tryParse(priceStr);
            if (p != null) {
              totalVal += p;
            }
          }

          // Format valuation
          final valuationFormatter = totalVal
              .toStringAsFixed(0)
              .replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},',
              );

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Metrics
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xff111111),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "ACTIVE LISTINGS",
                              color: Colors.white38,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 4.h),
                            CustomText(
                              text: controller.rxAssets.length.toString().padLeft(2, '0'),
                              color: AppColors.yellow,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xff111111),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "TOTAL VALUATION",
                              color: Colors.white38,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(height: 4.h),
                            CustomText(
                              text: "\$$valuationFormatter",
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Categories chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip(activeCategory, "ALL", "ALL (${controller.rxAssets.length})"),
                      SizedBox(width: 8.w),
                      _buildCategoryChip(
                        activeCategory,
                        "VEHICLES",
                        "VEHICLES (${controller.rxAssets.where((a) => a.type == 'VEHICLES').length})",
                      ),
                      SizedBox(width: 8.w),
                      _buildCategoryChip(
                        activeCategory,
                        "MOTORCYCLES",
                        "MOTORCYCLES (${controller.rxAssets.where((a) => a.type == 'MOTORCYCLES').length})",
                      ),
                      SizedBox(width: 8.w),
                      _buildCategoryChip(
                        activeCategory,
                        "PARTS",
                        "PARTS (${controller.rxAssets.where((a) => a.type == 'PARTS').length})",
                      ),
                      SizedBox(width: 8.w),
                      _buildCategoryChip(
                        activeCategory,
                        "SERVICES",
                        "SERVICES (${controller.rxAssets.where((a) => a.type == 'SERVICES').length})",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // Listings list
                ...controller.rxAssets.where((a) {
                  if (activeCategory.value == "ALL") return true;
                  return a.type == activeCategory.value;
                }).map((asset) {
                  // Setup specs map
                  Map<String, String> specs = {};
                  if (asset.type == "VEHICLES" || asset.type == "MOTORCYCLES") {
                    specs = {
                      "ENGINE OUTPUT": asset.power,
                      "DISPLACEMENT": asset.engineConfig,
                    };
                  } else {
                    specs = {
                      "SPECIFICATION": asset.description.length > 20
                          ? asset.description.substring(0, 20) + "..."
                          : asset.description,
                    };
                  }

                  Color tagColor = AppColors.yellow;
                  Color tagTextColor = Colors.black;
                  if (asset.status == "LIVE") {
                    tagColor = AppColors.green;
                    tagTextColor = Colors.black;
                  } else if (asset.status == "RESERVED") {
                    tagColor = Colors.orange;
                    tagTextColor = Colors.white;
                  } else if (asset.status == "SOLD") {
                    tagColor = Colors.white24;
                    tagTextColor = Colors.white60;
                  }

                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: _buildListingCard(
                      context: context,
                      controller: controller,
                      asset: asset,
                      tagColor: tagColor,
                      tagTextColor: tagTextColor,
                      specs: specs,
                    ),
                  );
                }),
              ],
            ),
          );
        }),
        bottomNavigationBar: const CustomBusinessNavBar(currentIndex: 4),
      ),
    );
  }

  Widget _buildCategoryChip(RxString activeCategory, String categoryId, String label) {
    return GestureDetector(
      onTap: () => activeCategory.value = categoryId,
      child: Obx(() {
        final bool isSelected = activeCategory.value == categoryId;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.yellow : const Color(0xff111111),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: isSelected ? AppColors.yellow : Colors.white10),
          ),
          child: CustomText(
            text: label,
            color: isSelected ? Colors.black : Colors.white60,
            fontSize: 9.sp,
            fontWeight: FontWeight.bold,
          ),
        );
      }),
    );
  }

  Widget _buildListingCard({
    required BuildContext context,
    required BusinessDashboardController controller,
    required AssetModel asset,
    required Color tagColor,
    required Color tagTextColor,
    required Map<String, String> specs,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Stack
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: Image.network(
                  asset.imageUrl,
                  height: 180.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180.h,
                    color: const Color(0xff222222),
                    child: const Center(
                      child: Icon(Icons.broken_image_outlined, color: Colors.white24, size: 36),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: CustomText(
                    text: asset.status,
                    color: tagTextColor,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          // Card Details
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: asset.title,
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w900,
                          ),
                          SizedBox(height: 2.h),
                          CustomText(
                            text: "ASSET ID: #${asset.code}",
                            color: Colors.white38,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    CustomText(
                      text: asset.price,
                      color: asset.status == "SOLD" ? Colors.white54 : AppColors.yellow,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Specs Row
                Row(
                  children: specs.entries.map((e) {
                    return Padding(
                      padding: EdgeInsets.only(right: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: e.key,
                            color: Colors.white38,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 2.h),
                          CustomText(
                            text: e.value,
                            color: Colors.white70,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.h),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: asset.status != "SOLD"
                          ? CustomButton(
                              height: 38.h,
                              title: "EDIT LISTING",
                              fontSize: 10.sp,
                              borderRadius: 6.r,
                              fillColor: AppColors.yellow,
                              textColor: Colors.black,
                              onTap: () {
                                controller.setAssetForEdit(asset);
                                Get.toNamed(AppRoutes.editListingScreen);
                              },
                            )
                          : Container(
                              height: 38.h,
                              decoration: BoxDecoration(
                                color: const Color(0xff1a1a1a),
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: InkWell(
                                onTap: () {
                                  controller.setAssetForEdit(asset);
                                  Get.toNamed(AppRoutes.manageAssetScreen);
                                },
                                borderRadius: BorderRadius.circular(6.r),
                                child: const Center(
                                  child: CustomText(
                                    text: "VIEW DETAILS",
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      height: 38.h,
                      width: 44.w,
                      decoration: BoxDecoration(
                        color: const Color(0xff1d1717),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                        onPressed: () {
                          Get.dialog(
                            AlertDialog(
                              backgroundColor: const Color(0xff111111),
                              title: const Text("Terminate Listing?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              content: const Text("Are you sure you want to permanently remove this listing from active inventory?", style: TextStyle(color: Colors.white70)),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text("CANCEL", style: TextStyle(color: Colors.white54)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.rxAssets.removeWhere((a) => a.id == asset.id);
                                    Get.back();
                                    Get.snackbar(
                                      "Listing Terminated",
                                      "Asset removed successfully from records.",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: const Color(0xff181818),
                                      colorText: Colors.white,
                                      borderColor: Colors.redAccent,
                                      borderWidth: 1,
                                    );
                                  },
                                  child: const Text("TERMINATE", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

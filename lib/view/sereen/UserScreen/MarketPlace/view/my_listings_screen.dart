import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_button/custom_button.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../core/app_routes/app_routes.dart';

import '../controller/marketpace_controller.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MarketplaceFeedController>();
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
              onPressed: () => Get.toNamed(AppRoutes.selectCategoryScreen),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Metric boxes
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
                            text: 'activeListings'.tr,
                            color: Colors.white38,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 4.h),
                          const CustomText(
                            text: "03",
                            color: AppColors.yellow,
                            fontSize: 18,
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
                            text: 'totalValuation'.tr,
                            color: Colors.white38,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 4.h),
                          const CustomText(
                            text: "\$1,450,000",
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              /// Categories chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(
                  () => Row(
                    children: [
                      _buildCategoryChip("ALL", "ALL", controller),
                      SizedBox(width: 8.w),
                      _buildCategoryChip("VEHICLES", "VEHICLES", controller),
                      SizedBox(width: 8.w),
                      _buildCategoryChip(
                        "MOTORCYCLES",
                        "MOTORCYCLES",
                        controller,
                      ),
                      SizedBox(width: 8.w),
                      _buildCategoryChip(
                        "PERFORMANCE_PARTS",
                        "PARTS",
                        controller,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              /// Listings items list
              Obx(() {
                if (controller.isLoadingMyListings.value &&
                    controller.myListings.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.yellow),
                  );
                }
                if (controller.myListings.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: 'noListingsFound'.tr,
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.myListings.length,
                  separatorBuilder: (c, i) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final item = controller.myListings[index];
                    final String imageUrl =
                        (item['visualAssets'] != null &&
                            (item['visualAssets'] as List).isNotEmpty)
                        ? item['visualAssets'][0]
                        : "";
                    final title = item['brand'] != null
                        ? "${item['brand']} ${item['modelDesignation']}"
                        : "Listing";
                    final type = item['itemType'] ?? "ITEM";

                    Map<String, String> specs = {};
                    if (item['powerHP'] != null) {
                      specs["POWER"] = "${item['powerHP']} HP";
                    }
                    if (item['displacementCC'] != null) {
                      specs["DISPLACEMENT"] = "${item['displacementCC']} CC";
                    }
                    if (item['productionYear'] != null) {
                      specs["YEAR"] = "${item['productionYear']}";
                    }

                    return _buildListingCard(
                      id: item['id'] ?? "",
                      controller: controller,
                      imageUrl: imageUrl,
                      statusLabel: "ACTIVE",
                      statusColor: AppColors.yellow,
                      statusTextColor: Colors.black,
                      title: title,
                      idLabel:
                          "$type ID: #${item['id']?.toString().substring(0, 8).toUpperCase()}",
                      price: "\$${item['askingPrice']}",
                      priceColor: AppColors.yellow,
                      specs: specs,
                      isEditButton: true,
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    String categoryId,
    String label,
    MarketplaceFeedController controller,
  ) {
    final bool isSelected =
        controller.currentCategoryMyListings.value == categoryId;
    return GestureDetector(
      onTap: () {
        controller.changeCategory(categoryId);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.yellow : const Color(0xff111111),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.yellow : Colors.white10,
          ),
        ),
        child: CustomText(
          text: label,
          color: isSelected ? Colors.black : Colors.white60,
          fontSize: 9.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListingCard({
    required String id,
    required MarketplaceFeedController controller,
    required String imageUrl,
    required String statusLabel,
    required Color statusColor,
    required Color statusTextColor,
    required String title,
    required String idLabel,
    required String price,
    required Color priceColor,
    required Map<String, String> specs,
    required bool isEditButton,
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
          /// Image Stack
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        height: 180.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 180.h,
                        width: double.infinity,
                        color: Colors.white10,
                        child: const Icon(Icons.image, color: Colors.white38),
                      ),
              ),
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: CustomText(
                    text: statusLabel,
                    color: statusTextColor,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          /// Card Details
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
                            text: title,
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                          SizedBox(height: 2.h),
                          CustomText(
                            text: idLabel,
                            color: Colors.white38,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    CustomText(
                      text: price,
                      color: priceColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                /// Specs Row
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
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.h),

                /// Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: isEditButton
                          ? CustomButton(
                              height: 38.h,
                              title: 'editListing'.tr,
                              fontSize: 11,
                              borderRadius: 6.r,
                              onTap: () {},
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
                                  Get.toNamed(
                                    AppRoutes.itemDetailScreen,
                                    arguments: {'id': id},
                                  );
                                },
                                borderRadius: BorderRadius.circular(6.r),
                                child: Center(
                                  child: CustomText(
                                    text: 'viewDetails'.tr,
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    Container(
                      height: 38.h,
                      width: 44.w,
                      decoration: BoxDecoration(
                        color: const Color(0xff1d1717),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Obx(
                        () => controller.isDeleting.value
                            ? const Center(
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                  size: 18,
                                ),
                                onPressed: () {
                                  controller.deleteListing(id);
                                },
                              ),
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

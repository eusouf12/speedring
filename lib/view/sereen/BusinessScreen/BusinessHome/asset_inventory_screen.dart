import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_text/custom_text.dart';
import 'business_navbar.dart';
import 'business_dashboard_controller.dart';

class AssetInventoryScreen extends StatelessWidget {
  const AssetInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<BusinessDashboardController>()
        ? Get.find<BusinessDashboardController>()
        : Get.put(BusinessDashboardController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "OPERATIONAL COMMAND",
                  color: AppColors.yellow,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: "ASSET INVENTORY",
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Horizontal Category Tabs
          _buildCategoryTabs(controller),
          SizedBox(height: 16.h),

          // Scrollable List of Assets
          Expanded(
            child: Obx(() {
              final activeTab = controller.rxActiveTab.value;
              final filteredAssets = controller.rxAssets.where((asset) {
                if (activeTab == "ALL") return true;
                return asset.type == activeTab;
              }).toList();

              if (filteredAssets.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, color: Colors.white24, size: 48.r),
                      SizedBox(height: 12.h),
                      CustomText(
                        text: "NO ASSETS RECORDED",
                        color: Colors.white38,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                itemCount: filteredAssets.length,
                itemBuilder: (context, index) {
                  final asset = filteredAssets[index];
                  return _buildAssetCard(asset, controller);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addAssetCategoryScreen),
        backgroundColor: AppColors.yellow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: const Icon(Icons.add, color: Colors.black, size: 28),
      ),
      bottomNavigationBar: const CustomBusinessNavBar(currentIndex: 1),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: const CircleAvatar(
          backgroundColor: Color(0xff222222),
          child: Icon(Icons.person, color: Colors.white, size: 20),
        ),
      ),
      title: CustomImage(
        imageSrc: AppImages.splashLogo,
        imageType: ImageType.png,
        height: 32.h,
        fit: BoxFit.contain,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.mail_outline_rounded, color: Colors.white, size: 22),
          onPressed: () => Get.toNamed(AppRoutes.messageScreen),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 22),
          onPressed: () => Get.toNamed(AppRoutes.notificationScreen),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildCategoryTabs(BusinessDashboardController controller) {
    final categories = ["ALL", "VEHICLES", "MOTORCYCLES", "PARTS", "SERVICES"];

    return SizedBox(
      height: 36.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Obx(() {
            final isSelected = controller.rxActiveTab.value == cat;
            return GestureDetector(
              onTap: () {
                controller.rxActiveTab.value = cat;
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.yellow : const Color(0xff111111),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected ? AppColors.yellow : Colors.white10,
                  ),
                ),
                child: Center(
                  child: CustomText(
                    text: cat,
                    color: isSelected ? Colors.black : Colors.white,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildAssetCard(AssetModel asset, BusinessDashboardController controller) {
    // Determine header code label (Chassis, VIN, Part, Service)
    String codeLabel = "CHASSIS";
    if (asset.type == "MOTORCYCLES") {
      codeLabel = "VIN";
    } else if (asset.type == "PARTS") {
      codeLabel = "PART";
    } else if (asset.type == "SERVICES") {
      codeLabel = "SERVICE";
    }

    // Determine status tag color
    Color tagColor = AppColors.yellow;
    if (asset.status == "LIVE") {
      tagColor = AppColors.green;
    } else if (asset.status == "RESERVED") {
      tagColor = Colors.orangeAccent;
    } else if (asset.status == "DRAFT") {
      tagColor = Colors.white38;
    } else if (asset.status == "SOLD") {
      tagColor = Colors.redAccent;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Banner with status tag
          Stack(
            children: [
              Image.network(
                asset.imageUrl,
                height: 160.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 160.h,
                  color: const Color(0xff222222),
                  child: Center(
                    child: Icon(Icons.broken_image_outlined, color: Colors.white24, size: 36.r),
                  ),
                ),
              ),
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: tagColor.withValues(alpha: 0.5), width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6.r,
                        height: 6.r,
                        decoration: BoxDecoration(color: tagColor, shape: BoxShape.circle),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        asset.status,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Code Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "$codeLabel: ${asset.code}",
                      color: AppColors.yellow,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                    const Icon(Icons.more_vert, color: Colors.white38),
                  ],
                ),
                SizedBox(height: 6.h),

                // Asset Title
                CustomText(
                  text: asset.title,
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                ),
                SizedBox(height: 16.h),

                // Info Matrix Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildMatrixColumn(
                        label: asset.type == "PARTS" ? "EST. VALUE" : "ASKING PRICE",
                        value: asset.price,
                        valueColor: AppColors.yellow,
                      ),
                    ),
                    Expanded(
                      child: _buildMatrixColumn(
                        label: "REGISTRY VIEWS",
                        value: asset.views,
                      ),
                    ),
                    Expanded(
                      child: _buildMatrixColumn(
                        label: "ACTIVE LEADS",
                        value: asset.leads,
                      ),
                    ),
                    Expanded(
                      child: _buildMatrixColumn(
                        label: "SHIPPING",
                        value: asset.shipping,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Manage Asset Button
                GestureDetector(
                  onTap: () {
                    controller.setAssetForEdit(asset);
                    Get.toNamed(AppRoutes.manageAssetScreen);
                  },
                  child: Container(
                    height: 40.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Center(
                      child: CustomText(
                        text: "MANAGE ASSET",
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatrixColumn({
    required String label,
    required String value,
    Color valueColor = Colors.white,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          color: Colors.white38,
          fontSize: 7.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: value,
          color: valueColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w900,
        ),
      ],
    );
  }
}

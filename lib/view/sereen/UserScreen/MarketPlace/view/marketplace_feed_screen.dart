import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/sereen/UserScreen/MarketPlace/controller/marketpace_controller.dart';
import '../../../../components/custom_appbar_user/custom_appbar_user.dart';
import '../../../../components/custom_button/custom_button.dart';
import '../../../../components/custom_nav_bar/navbar.dart';
import '../../../../../../core/app_routes/app_routes.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../widgets/marketplace_item_card.dart';

class MarketplaceListingFeedScreen extends StatelessWidget {
  const MarketplaceListingFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MarketplaceFeedController>();

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomAppBarUser(
          showSearchIcon: true,
          onSearchTap: () => controller.showSearchBar.toggle(),
          onNotificationTap: () {
            Get.toNamed(AppRoutes.notificationScreen);
          },
          onMailTap: () {
            Get.toNamed(AppRoutes.messageScreen);
          },
        ),
        body: Column(
          children: [
            Obx(() {
              if (controller.showSearchBar.value) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff1C1C1C),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: controller.searchController,
                      style: const TextStyle(color: Colors.white),
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'whatDoYouWantToBuy'.tr,
                        hintStyle: const TextStyle(color: Colors.white30),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white70,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white54),
                          onPressed: () {
                            controller.searchController.clear();
                            controller.searchQuery.value = "";
                            controller.showSearchBar.value = false;
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                      onChanged: (val) {
                        controller.searchQuery.value = val;
                      },
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            Obx(() {
              /// Hide completely when scrolling
              if (controller.isHeaderButtonHidden.value) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: CustomButton(
                  height: 40.h,
                  title: 'startListing'.tr,
                  fontSize: 12,
                  borderRadius: 8.r,

                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.black,
                    size: 16,
                  ),

                  onTap: () {
                    Get.toNamed(AppRoutes.selectCategoryScreen);
                  },
                ),
              );
            }),

            Expanded(
              child: Obx(() {
                if (controller.isLoadingFeed.value &&
                    controller.listings.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.yellow),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.yellow,
                  backgroundColor: Colors.black,
                  onRefresh: () async =>
                      controller.fetchListings(refresh: true),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: controller.scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    itemCount:
                        controller.listings.length +
                        (controller.isMoreLoadingFeed.value ? 1 : 0),
                    itemBuilder: (context, idx) {
                      if (idx == controller.listings.length) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final item = controller.listings[idx];

                      String imageUrl = "";
                      if (item.visualAssets != null &&
                          item.visualAssets!.isNotEmpty) {
                        imageUrl = item.visualAssets![0];
                      }

                      return MarketplaceItemCard(
                        imageUrl: imageUrl,
                        title: item.modelDesignation ?? 'noTitle'.tr,
                        price: "\$${item.askingPrice ?? '0'}",
                        subtitle: item.brand ?? "",
                        tag: item.itemType ?? "",
                        year: item.productionYear.toString(),

                        // ===================================
                        // VIEW DETAILS
                        // ===================================
                        onViewDetails: () {
                          if (item.id != null) {
                            controller.fetchListingDetails(item.id!);
                          }
                          Get.toNamed(
                            AppRoutes.itemDetailScreen,
                            arguments: {'id': item.id},
                          );
                        },

                        // ===================================
                        // CHAT
                        // ===================================
                        onChatTap: () {
                          Get.toNamed(
                            AppRoutes.inboxScreen,
                            arguments: {
                              "userName": "Anderson Racing",
                              "avatarUrl":
                                  "https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=100&fit=crop",
                              "isOnline": true,
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),

        // =====================================================
        // BOTTOM NAVIGATION
        // =====================================================
        bottomNavigationBar: const CustomNavBar(currentIndex: 3),
      ),
    );
  }
}

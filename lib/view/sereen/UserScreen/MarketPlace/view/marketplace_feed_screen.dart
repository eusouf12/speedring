import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/sereen/UserScreen/MarketPlace/controller/marketpace_controller.dart';
import '../../../../components/custom_button/custom_button.dart';
import '../../../../components/custom_nav_bar/navbar.dart';
import '../../../../../../core/app_routes/app_routes.dart';
import '../widgets/marketplace_item_card.dart';

class MarketplaceListingFeedScreen extends StatelessWidget {
  const MarketplaceListingFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MarketplaceFeedController>();

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,

        // =====================================================
        // APP BAR
        // =====================================================
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          titleSpacing: 0,

          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white38, size: 18),

                  SizedBox(width: 10.w),

                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "What do you want to buy?",
                        hintStyle: const TextStyle(
                          color: Colors.white24,
                          fontSize: 13,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // =====================================================
        // BODY
        // =====================================================
        body: Column(
          children: [
            // =================================================
            // HEADER BUTTONS
            // =================================================
            Obx(() {
              /// Hide completely when scrolling
              if (controller.isHeaderButtonHidden.value) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: CustomButton(
                  height: 40.h,
                  title: "START LISTING",
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

            // =================================================
            // FEED LIST
            // =================================================
            Expanded(
              child: Obx(() {
                if (controller.isLoadingFeed.value &&
                    controller.listings.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return RefreshIndicator(
                  onRefresh: () async =>
                      controller.fetchListings(refresh: true),
                  child: ListView.builder(
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
                      if (item["visualAssets"] != null &&
                          (item["visualAssets"] as List).isNotEmpty) {
                        imageUrl = item["visualAssets"][0];
                      }

                      return MarketplaceItemCard(
                        imageUrl: imageUrl,
                        title: item["title"]?.toString() ?? "No Title",
                        price: "\$${item["price"] ?? '0'}",
                        subtitle: item["condition"]?.toString() ?? "",
                        tag: item["category"]?.toString() ?? "",

                        // ===================================
                        // VIEW DETAILS
                        // ===================================
                        onViewDetails: () {
                          Get.toNamed(
                            AppRoutes.itemDetailScreen,
                            arguments: {'id': item["id"]},
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';

import '../../../../components/custom_button/custom_button.dart';
import '../../../../components/custom_nav_bar/navbar.dart';
import '../../../../../../core/app_routes/app_routes.dart';
import '../widgets/marketplace_item_card.dart';

class MarketplaceFeedController extends GetxController {
  /// Scroll Controller
  final ScrollController scrollController = ScrollController();

  /// Header buttons visibility
  final RxBool isHeaderButtonHidden = false.obs;

  /// Marketplace Listings
  final RxList<Map<String, String>> listings = [
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=600&fit=crop",
      "title": "APEX-7 TURBO S",
      "price": "\$245,000",
      "subtitle": "2024 PRODUCTION MODEL",
      "tag": "VEHICLE",
    },
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=600&fit=crop",
      "title": "V-CORE 1100R",
      "price": "\$42,900",
      "subtitle": "RACING SPECIFICATION",
      "tag": "MOTORCYCLE",
    },
    {
      "imageUrl": "https://picsum.photos/seed/stratosgt3/600/400",
      "title": "STRATOS GT3",
      "price": "\$510,000",
      "subtitle": "TRACK ONLY EDITION",
      "tag": "VEHICLE",
    },
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1486006920555-c77dce18193b?w=600&fit=crop",
      "title": "FORGED CARBON SET",
      "price": "\$18,500",
      "subtitle": "ULTRA-LIGHTWEIGHT COMPONENTS",
      "tag": "PARTS",
    },
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1486006920555-c77dce18193b?w=600&fit=crop",
      "title": "MASTER SUSPENSION TUNING",
      "price": "\$250/hr",
      "subtitle": "Pit Garage Service",
      "tag": "SERVICES",
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    /// Hide buttons when list starts scrolling
    if (scrollController.offset > 0) {
      if (!isHeaderButtonHidden.value) {
        isHeaderButtonHidden.value = true;
      }
    } else {
      /// Show buttons again when back to top
      if (isHeaderButtonHidden.value) {
        isHeaderButtonHidden.value = false;
      }
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();

    super.onClose();
  }
}

class MarketplaceListingFeedScreen extends StatelessWidget {
  const MarketplaceListingFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MarketplaceFeedController());

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
                child: Row(
                  children: [
                    // =======================================
                    // START LISTING
                    // =======================================
                    Expanded(
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
                    ),

                    SizedBox(width: 12.w),

                    // =======================================
                    // SELECT CATEGORY
                    // =======================================
                    Expanded(
                      child: CustomButton(
                        height: 40.h,
                        title: "SELECT CATEGORY",
                        fontSize: 12,
                        fillColor: const Color(0xff1e1e1e),
                        textColor: Colors.white70,
                        isBorder: true,
                        borderColor: Colors.white10,
                        borderRadius: 8.r,

                        onTap: () {
                          Get.toNamed(AppRoutes.selectCategoryScreen);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),

            // =================================================
            // FEED LIST
            // =================================================
            Expanded(
              child: Obx(
                () => ListView.builder(
                  controller: controller.scrollController,

                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),

                  itemCount: controller.listings.length,

                  itemBuilder: (context, idx) {
                    final item = controller.listings[idx];

                    return MarketplaceItemCard(
                      imageUrl: item["imageUrl"]!,
                      title: item["title"]!,
                      price: item["price"]!,
                      subtitle: item["subtitle"]!,
                      tag: item["tag"]!,

                      // ===================================
                      // VIEW DETAILS
                      // ===================================
                      onViewDetails: () {
                        Get.toNamed(AppRoutes.itemDetailScreen);
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
              ),
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

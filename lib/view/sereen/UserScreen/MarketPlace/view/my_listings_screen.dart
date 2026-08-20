import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../core/app_routes/app_routes.dart';

import '../controller/marketpace_controller.dart';
import '../widgets/marketplace_item_card.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MarketplaceFeedController>();
    
    // Scroll controller for pagination
    final ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        controller.fetchMyListings();
      }
    });

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomRoyelAppbar(titleName: "myListings".tr, leftIcon: true),
        body: Obx(() {
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

          return RefreshIndicator(
            color: AppColors.yellow,
            backgroundColor: Colors.black,
            onRefresh: () async => controller.fetchMyListings(isRefresh: true),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              itemCount: controller.myListings.length +
                  (controller.isLoadingMyListings.value ? 1 : 0),
              itemBuilder: (context, idx) {
                if (idx == controller.myListings.length) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator(color: AppColors.yellow)),
                  );
                }

                final item = controller.myListings[idx];

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
                  year: item.productionYear?.toString() ?? "",

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
                  onChatTap: null, 
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/navigation_utils.dart';

import '../../controller/home_controller.dart';

class ClubJoinRequestsScreen extends StatelessWidget {
  const ClubJoinRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final String clubId = args['id'] ?? '';

    // Fetch requests when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (clubId.isNotEmpty) {
        controller.getClubJoinRequests(clubId);
      }
    });

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
            onPressed: () => Get.back(),
          ),
          title: CustomText(
            text: "joinRequests".tr.toUpperCase(),
            color: AppColors.yellow,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isClubJoinRequestsLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }

          if (controller.clubJoinRequestsList.isEmpty) {
            return Center(
              child: CustomText(
                text: "noPendingRequests".tr,
                color: Colors.white54,
                fontSize: 14,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: controller.clubJoinRequestsList.length,
            itemBuilder: (context, index) {
              final requestData = controller.clubJoinRequestsList[index];
              final memberId = requestData['_id'] ?? requestData['id'] ?? "";

              final name =
                  requestData['name'] ?? requestData['userName'] ?? "Unknown";
              final profileImage = requestData['profileImage'] ?? "";

              String imageUrl = "";
              if (profileImage.isNotEmpty) {
                imageUrl = profileImage.startsWith('http')
                    ? profileImage
                    : "${ApiUrl.imageUrl}$profileImage";
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (memberId.isNotEmpty) {
                          NavigationUtils.navigateToUserProfile(memberId);
                        }
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white10,
                        backgroundImage: imageUrl.isNotEmpty
                            ? NetworkImage(imageUrl)
                            : null,
                        child: imageUrl.isEmpty
                            ? const Icon(Icons.person, color: Colors.white54)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (memberId.isNotEmpty) {
                            NavigationUtils.navigateToUserProfile(memberId);
                          }
                        },
                        child: CustomText(
                          text: name,
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (clubId.isNotEmpty && memberId.isNotEmpty) {
                              controller.handleJoinRequest(
                                clubId: clubId,
                                memberId: memberId,
                                action: "reject",
                              );
                            }
                          },
                          icon: const Icon(Icons.close, color: Colors.red),
                        ),
                        IconButton(
                          onPressed: () {
                            if (clubId.isNotEmpty && memberId.isNotEmpty) {
                              controller.handleJoinRequest(
                                clubId: clubId,
                                memberId: memberId,
                                action: "approve",
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.check,
                            color: AppColors.yellow,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

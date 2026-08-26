import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speedring/view/components/share/share_controller.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/utils/navigation_utils.dart';

class ShareBottomSheet extends StatelessWidget {
  final String shareText;
  final String shareSubject;
  final String shareLink;

  const ShareBottomSheet({
    Key? key,
    required this.shareText,
    required this.shareSubject,
    required this.shareLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller when sheet opens
    final ShareController controller = Get.put(ShareController());
    final TextEditingController searchController = TextEditingController();

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xff111111),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "shareToFriends".tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: searchController,
                  onChanged: controller.searchFriends,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "searchFriendsHint".tr,
                    hintStyle: const TextStyle(color: Colors.white30),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xff1C1C1C),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white12, height: 1),

              // Friends List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.followingList.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.yellow),
                    );
                  }

                  if (controller.filteredList.isEmpty) {
                    return Center(
                      child: Text(
                        "noFriendsFound".tr,
                        style: const TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  return ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: controller.filteredList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final user = controller.filteredList[index];
                      final name =
                          user['name'] ?? user['userName'] ?? "Unknown";
                      final profileImage = user['profileImage'];
                      final userId = user['_id'];

                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (userId != null) {
                                NavigationUtils.navigateToUserProfile(userId);
                              }
                            },
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: const Color(0xff2A2A2A),
                              backgroundImage: profileImage != null
                                  ? NetworkImage(profileImage)
                                  : null,
                              child: profileImage == null
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.white54,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (userId != null) {
                                  NavigationUtils.navigateToUserProfile(userId);
                                }
                              },
                              child: Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          // Send Button
                          Obx(() {
                            // Local state for each button if needed, but for simplicity
                            // we just disable all buttons while sending.
                            return ElevatedButton(
                              onPressed: controller.isSending.value
                                  ? null
                                  : () async {
                                      final success = await controller
                                          .sendShareMessage(
                                            userId,
                                            "$shareText\n\n$shareLink",
                                          );
                                      if (success) {
                                        // Optional: Close sheet after success
                                        // Navigator.pop(context);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.yellow,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                disabledBackgroundColor: AppColors.yellow
                                    .withValues(alpha: 0.5),
                              ),
                              child: Text(
                                "sendButton".tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  );
                }),
              ),

              // More Options (System Share)
              const Divider(color: Colors.white12, height: 1),
              SafeArea(
                bottom: true,
                top: false,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context); // Close bottom sheet
                    SharePlus.instance.share(
                      ShareParams(
                        text: "$shareText\n\n$shareLink",
                        subject: shareSubject,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.share,
                          color: Colors.white54,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "moreOptions".tr,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

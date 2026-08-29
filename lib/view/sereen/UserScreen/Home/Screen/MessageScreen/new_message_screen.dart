import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:speedring/view/components/share/share_controller.dart';
import 'controller/message_screen_controller.dart';

class NewMessageScreen extends StatelessWidget {
  const NewMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ShareController shareController = Get.find<ShareController>();
    final MessageScreenController controller = Get.find<MessageScreenController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "newMessage".tr, 
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Box
              TextField(
                onChanged: (val) => shareController.searchFriends(val),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "searchFriends".tr, // Translation added
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xff1d1d1d),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (shareController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.yellow));
                  }
                  if (shareController.filteredList.isEmpty) {
                    return Center(
                      child: Text(
                        "noFollowingFound".tr, // Translation added
                        style: const TextStyle(color: Colors.white54),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: shareController.filteredList.length,
                    itemBuilder: (context, index) {
                      final user = shareController.filteredList[index];
                      final isOnline = user['isOnline'] == true;
                      return ListTile(
                        leading: Stack(
                          children: [
                            CustomNetworkImage(
                              imageUrl: user['profileImage'] ??
                                  "https://ui-avatars.com/api/?name=${Uri.encodeComponent(user['name'] ?? 'User')}&format=png",
                              boxShape: BoxShape.circle,
                              height: 40,
                              width: 40,
                            ),
                            if (isOnline)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(user['name'] ?? "Unknown", style: const TextStyle(color: Colors.white)),
                        subtitle: Text("@${user['userName'] ?? ""}", style: const TextStyle(color: Colors.white54)),
                        onTap: () {
                          Get.back(); // Go back to messages screen before pushing chat
                          user['isOnline'] = isOnline; // pass isOnline state
                          controller.accessOrCreateChat(user);
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

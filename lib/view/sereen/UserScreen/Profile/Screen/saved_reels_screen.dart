import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import '../../Home/Screen/HomeScreen/controller/reels_controller.dart';

class SavedReelsScreen extends StatelessWidget {
  const SavedReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReelsController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const CustomText(
          text: "Saved Reels",
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isSavedReelsLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.yellow),
          );
        }

        if (controller.savedReels.isEmpty) {
          return const Center(
            child: CustomText(
              text: "No saved reels found.",
              color: Colors.white54,
              fontSize: 16,
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 9 / 16,
          ),
          itemCount: controller.savedReels.length,
          itemBuilder: (context, index) {
            final reel = controller.savedReels[index];
            String imageUrl = 'https://via.placeholder.com/150';

            // Try to extract a thumbnail from media array if available
            if (reel['media'] != null &&
                reel['media'] is List &&
                reel['media'].isNotEmpty) {
              // We'll just use a placeholder or video thumbnail if supported. For now, try to find an image or just show placeholder since video thumbnails require generation.
              imageUrl = reel['imageUrl'] ?? 'https://via.placeholder.com/150';
            }

            return GestureDetector(
              onTap: () {
                // Navigate to a dedicated reel viewer or the main reel screen passing the reel
                // For simplicity, we can just show a snackbar or navigate to Reel details
                Get.snackbar(
                  "Info",
                  "Full screen reel view coming soon!",
                  colorText: Colors.black,
                  backgroundColor: AppColors.yellow,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.bookmark_remove_rounded,
                          color: AppColors.yellow,
                          size: 20,
                        ),
                        onPressed: () {
                          controller.removeSavedReel(reel['_id'] ?? reel['id'] ?? '');
                        },
                      ),
                    ),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

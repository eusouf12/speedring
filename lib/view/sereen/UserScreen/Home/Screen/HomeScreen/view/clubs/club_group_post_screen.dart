import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/view/components/custom_text_field/custom_text_field.dart';
import '../../controller/home_controller.dart';

class ClubGroupPostScreen extends StatelessWidget {
  const ClubGroupPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final String clubId = args['id'] ?? '';
    final String mode = args['mode'] ?? 'CREATE_POST';
    final bool isShareMedia = mode == 'SHARE_MEDIA';

    void handlePost() async {
      if (controller.clubGroupPostTextCtrl.text.trim().isEmpty &&
          controller.clubGroupSelectedMedia.value == null) {
        Get.snackbar(
          "Error",
          "Please add some text or media to post.",
          colorText: Colors.red,
        );
        return;
      }

      final success = await controller.createClubSpecificPost(
        clubId: clubId,
        details: controller.clubGroupPostTextCtrl.text.trim(),
        mediaFile: controller.clubGroupSelectedMedia.value,
      );

      if (success) {
        Get.back();
      }
    }

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
            onPressed: () {
              controller.clubGroupPostTextCtrl.clear();
              controller.clubGroupSelectedMedia.value = null;
              Get.back();
            },
          ),
          title: CustomText(
            text: isShareMedia ? "SHARE MEDIA" : "CREATE POST",
            color: AppColors.yellow,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isPostCreating.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }

          final selectedMedia = controller.clubGroupSelectedMedia.value;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isShareMedia) ...[
                  CustomTextField(
                    textEditingController: controller.clubGroupPostTextCtrl,
                    hintText: "What's on your mind?",
                    maxLines: 5,
                    fillColor: const Color(0xff111111),
                  ),
                  const SizedBox(height: 20),
                ],

                if (selectedMedia != null) ...[
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child:
                            selectedMedia.path.toLowerCase().endsWith('.mp4') ||
                                selectedMedia.path.toLowerCase().endsWith(
                                  '.mov',
                                )
                            ? const Center(
                                child: Icon(
                                  Icons.play_circle_fill,
                                  size: 60,
                                  color: Colors.white54,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  selectedMedia,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.clubGroupSelectedMedia.value = null;
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],

                // Action Buttons for picking media
                if (isShareMedia ||
                    (!isShareMedia && selectedMedia == null)) ...[
                  const CustomText(
                    text: "Add to your post",
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _MediaButton(
                        icon: Icons.photo_library,
                        label: "Photo",
                        onTap: () => controller.pickClubGroupMedia(
                          ImageSource.gallery,
                          isVideo: false,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _MediaButton(
                        icon: Icons.videocam,
                        label: "Video",
                        onTap: () => controller.pickClubGroupMedia(
                          ImageSource.gallery,
                          isVideo: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _MediaButton(
                        icon: Icons.camera_alt,
                        label: "Camera",
                        onTap: () => controller.pickClubGroupMedia(
                          ImageSource.camera,
                          isVideo: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],

                CustomButton(
                  onTap: handlePost,
                  title: "POST",
                  fillColor: AppColors.yellow,
                  textColor: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _MediaButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MediaButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xff1B1B1B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.yellow, size: 28),
              const SizedBox(height: 8),
              CustomText(
                text: label,
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';

// ─── Controller ────────────────────────────────────────────────
class CreateStoryController extends GetxController {
  final Rxn<File> selectedFile = Rxn<File>();
  final RxBool isVideo = false.obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickMedia({required bool isVideoVal}) async {
    final XFile? picked = isVideoVal
        ? await _picker.pickVideo(source: ImageSource.gallery)
        : await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      selectedFile.value = File(picked.path);
      isVideo.value = isVideoVal;
    }
  }

  void reset() {
    selectedFile.value = null;
    isVideo.value = false;
  }
}

// ─── Screen ────────────────────────────────────────────────────
class CreateStoryScreen extends StatelessWidget {
  const CreateStoryScreen({super.key, this.profileImageUrl, this.userName});

  final String? profileImageUrl;
  final String? userName;

  void _showPickerSheet(BuildContext context, CreateStoryController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff1C1C1C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _SheetOption(
                icon: Icons.photo_library_outlined,
                label: "Choose Photo",
                onTap: () {
                  Navigator.pop(context);
                  controller.pickMedia(isVideoVal: false);
                },
              ),
              const SizedBox(height: 12),
              _SheetOption(
                icon: Icons.videocam_outlined,
                label: "Choose Video",
                onTap: () {
                  Navigator.pop(context);
                  controller.pickMedia(isVideoVal: true);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateStoryController());

    return Obx(() => Scaffold(
      backgroundColor: Colors.black,
      body: controller.selectedFile.value == null
          ? EmptyUploadView(onTap: () => _showPickerSheet(context, controller))
          : PreviewView(
              file: controller.selectedFile.value!,
              isVideo: controller.isVideo.value,
              profileImageUrl: profileImageUrl,
              onClose: () => controller.reset(),
              onShare: () {
                Navigator.pop(context);
              },
            ),
    ));
  }
}

/// ── Empty state: black bg + upload prompt ─────────────────────────────────────
class EmptyUploadView extends StatelessWidget {
  final VoidCallback onTap;

  const EmptyUploadView({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
        title: const Text(
          "Create Story",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.width * 0.65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.yellow.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.yellow.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cloud_upload_outlined,
                    color: AppColors.yellow,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Upload a photo or video",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Tap to browse gallery",
                  style: TextStyle(color: Colors.white30, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ─selected image fills screen ─────────────────────────────
class PreviewView extends StatelessWidget {
  final File file;
  final bool isVideo;
  final String? profileImageUrl;
  final VoidCallback onClose;
  final VoidCallback onShare;

  const PreviewView({
    super.key,
    required this.file,
    required this.isVideo,
    required this.onClose,
    required this.onShare,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
      
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white12,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
          title: const Text(
            "Create Story",
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      
        body: Stack(
          children: [
            /// Full Screen Media
            Positioned.fill(
              child: isVideo
                  ? Container(
                      color: Colors.black,
                      child: const Center(
                        child: Icon(
                          Icons.videocam,
                          color: Colors.white38,
                          size: 64,
                        ),
                      ),
                    )
                  : Image.file(file, fit: BoxFit.cover),
            ),
      
            /// Overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: .5),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha: .7),
                    ],
                    stops: const [0.0, 0.15, 0.7, 1.0],
                  ),
                ),
              ),
            ),
      
            /// Share Button
            Positioned(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).padding.bottom + 24,
              child: CustomButton(
                onTap: () {
                  Get.back();
                },
                title: "SHARE STORY",
                borderRadius: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ── Bottom sheet option row ────────────────────────────────────────────────
class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.yellow, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

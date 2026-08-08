import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/sereen/UserScreen/Home/Screen/HomeScreen/controller/home_controller.dart';

// ─── Screen ────────────────────────────────────────────────────
class CreateStoryScreen extends StatelessWidget {
  const CreateStoryScreen({super.key, this.profileImageUrl, this.userName});

  final String? profileImageUrl;
  final String? userName;

  void _showPickerSheet(BuildContext context, HomeController controller) {
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
                label: "choosePhoto".tr,
                onTap: () {
                  Navigator.pop(context);
                  controller.pickMedia(isVideoVal: false);
                },
              ),
              const SizedBox(height: 12),
              _SheetOption(
                icon: Icons.camera_alt_outlined,
                label: "takePhoto".tr,
                onTap: () {
                  Navigator.pop(context);
                  controller.pickMedia(isVideoVal: false, fromCamera: true);
                },
              ),
              const SizedBox(height: 12),
              _SheetOption(
                icon: Icons.videocam_outlined,
                label: "chooseVideo".tr,
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
    final controller = Get.find<HomeController>();

    return Obx(
      () => Scaffold(
        backgroundColor: Colors.black,
        body: controller.selectedFile.value == null
            ? EmptyUploadView(
                onTap: () => _showPickerSheet(context, controller),
              )
            : PreviewView(
                file: controller.selectedFile.value!,
                isVideo: controller.isVideo.value,
                profileImageUrl: profileImageUrl,
                onClose: () => controller.resetStory(),
                onShare: () {
                  controller.createStory();
                },
                isCreating: controller.isStoryCreating.value,
              ),
      ),
    );
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
        title: Text(
          "createStory".tr,
          style: const TextStyle(
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
                Text(
                  "uploadPhotoOrVideoHint".tr,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "tapToBrowseGallery".tr,
                  style: const TextStyle(color: Colors.white30, fontSize: 11),
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
  final bool isCreating;

  const PreviewView({
    super.key,
    required this.file,
    required this.isVideo,
    required this.onClose,
    required this.onShare,
    this.profileImageUrl,
    this.isCreating = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
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
          title: Text(
          "createStory".tr,
          style: const TextStyle(
            color: AppColors.yellow,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        ),

        body: Obx(
          () => Stack(
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
                    : Image.file(file, fit: BoxFit.contain),
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

              /// Music Sticker
              if (controller.selectedMusic.value != null)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.music_note,
                            color: Colors.black,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              controller.selectedMusic.value!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              /// Location Sticker
              if (controller.selectedLocation.value != null)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 110,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xffE1306C), Color(0xffF77737)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              controller.selectedLocation.value!.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              /// Floating Icons (Music & Location)
              Positioned(
                top: 100,
                right: 16,
                child: Column(
                  children: [
                    _StoryIconButton(
                      icon: Icons.music_note,
                      onTap: () {
                        _showMusicSelectionSheet(context, controller);
                      },
                    ),
                    const SizedBox(height: 16),
                    _StoryIconButton(
                      icon: Icons.location_on_outlined,
                      onTap: () {
                        _showLocationSelectionSheet(context, controller);
                      },
                    ),
                  ],
                ),
              ),

              /// Video Trimmer UI (mock for longer videos)
              if (isVideo)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).padding.bottom + 90,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "videoTrimmer".tr.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "00:15 / 00:30",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.yellow, width: 2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(width: 10, color: AppColors.yellow),
                            Container(width: 10, color: AppColors.yellow),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.equalizer,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "audioMixer".tr.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              /// Share Button
              Positioned(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).padding.bottom + 24,
                child: CustomButton(
                  onTap: isCreating ? () {} : onShare,
                  title: isCreating ? "sharing".tr.toUpperCase() : "shareStory".tr.toUpperCase(),
                  borderRadius: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StoryIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
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

void _showMusicSelectionSheet(BuildContext context, HomeController controller) {
  // Clear previous search and load something initial if needed
  controller.musicList.clear();
  controller.searchMusic("");

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xff1C1C1C),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "music".tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (val) => controller.searchMusic(val),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "searchMusicHint".tr,
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              filled: true,
              fillColor: Colors.white12,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isSearchingMusic.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.yellow),
                );
              }
              if (controller.musicList.isEmpty) {
                return Center(
                  child: Text(
                    "noMusicFound".tr,
                    style: const TextStyle(color: Colors.white54),
                  ),
                );
              }
              return ListView.builder(
                itemCount: controller.musicList.length,
                itemBuilder: (context, index) {
                  final music = controller.musicList[index];
                  final previewUrl = music["previewUrl"] ?? "";
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.music_note, color: Colors.white),
                    ),
                    title: Text(
                      music["title"] ?? "",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      music["artist"] ?? "",
                      style: const TextStyle(color: Colors.white54),
                    ),
                    trailing: previewUrl.isNotEmpty
                        ? Obx(() {
                            final isPlaying =
                                controller.currentlyPlayingUrl.value ==
                                previewUrl;
                            return IconButton(
                              icon: Icon(
                                isPlaying
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_fill,
                              ),
                              color: AppColors.yellow,
                              iconSize: 30,
                              onPressed: () {
                                controller.togglePlay(previewUrl);
                              },
                            );
                          })
                        : null,
                    onTap: () {
                      controller.stopAudio();
                      controller.selectedMusic.value = music["title"];
                      controller.selectedMusicUrl.value = music["previewUrl"];
                      Navigator.pop(context);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    ),
  ).whenComplete(() => controller.stopAudio());
}

void _showLocationSelectionSheet(
  BuildContext context,
  HomeController controller,
) {
  controller.locationList.clear();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xff1C1C1C),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "location".tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (val) => controller.searchLocation(val),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "searchLocationHint".tr,
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              filled: true,
              fillColor: Colors.white12,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.yellow.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.my_location, color: AppColors.yellow),
            ),
            title: Text(
              "useCurrentLocation".tr,
              style: const TextStyle(
                color: AppColors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              controller.getCurrentLocation();
            },
          ),
          const Divider(color: Colors.white24),
          Expanded(
            child: Obx(() {
              if (controller.isSearchingLocation.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.yellow),
                );
              }
              if (controller.locationList.isEmpty) {
                return Center(
                  child: Text(
                    "searchForLocationHint".tr,
                    style: const TextStyle(color: Colors.white54),
                  ),
                );
              }
              return ListView.builder(
                itemCount: controller.locationList.length,
                itemBuilder: (context, index) {
                  final location = controller.locationList[index];
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on, color: Colors.white),
                    ),
                    title: Text(
                      location,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      controller.selectedLocation.value = location;
                      Navigator.pop(context);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    ),
  );
}

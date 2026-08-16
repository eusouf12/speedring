import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/sereen/UserScreen/Home/Screen/HomeScreen/controller/home_controller.dart';
import 'package:video_player/video_player.dart';
import '../../controller/reels_controller.dart';
import 'trimmer_view.dart';

class CreateReelScreen extends StatefulWidget {
  const CreateReelScreen({super.key});

  @override
  State<CreateReelScreen> createState() => _CreateReelScreenState();
}

class _CreateReelScreenState extends State<CreateReelScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedVideo;
  bool _isPicking = false;

  final TextEditingController _captionController = TextEditingController();
  final ReelsController _reelsController = Get.find<ReelsController>();
  final HomeController _homeController = Get.find<HomeController>();

  String? _selectedMusicName;
  String? _selectedMusicUrl;
  File? _selectedLocalAudio;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    setState(() {
      _isPicking = true;
    });
    try {
      final XFile? picked = await _picker.pickVideo(
        source: ImageSource.gallery,
      );
      if (picked != null) {
        File file = File(picked.path);
        
        // Check file size (max 200MB)
        int sizeInBytes = await file.length();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        
        // Check duration
        VideoPlayerController controller = VideoPlayerController.file(file);
        await controller.initialize();
        Duration duration = controller.value.duration;
        await controller.dispose();
        
        if (sizeInMb > 200 || duration.inSeconds > 60) {
          // Ask user to trim
          bool? shouldTrim = await Get.defaultDialog<bool>(
            title: "Video Too Large",
            middleText: "Your video exceeds the 60-second or 200MB limit. Would you like to trim it?",
            backgroundColor: Colors.black87,
            titleStyle: const TextStyle(color: Colors.white),
            middleTextStyle: const TextStyle(color: Colors.white70),
            confirmTextColor: Colors.white,
            cancelTextColor: AppColors.yellow,
            buttonColor: AppColors.yellow,
            textConfirm: "Trim Video",
            textCancel: "Cancel",
            onConfirm: () => Get.back(result: true),
            onCancel: () => Get.back(result: false),
          );
          
          if (shouldTrim == true) {
            final trimmedPath = await Get.to(() => TrimmerView(file: file));
            if (trimmedPath != null && trimmedPath is String) {
              setState(() {
                _selectedVideo = File(trimmedPath);
              });
            }
          }
        } else {
          setState(() {
            _selectedVideo = file;
          });
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not select video: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isPicking = false;
      });
    }
  }

  void _showMusicSelectionSheet() {
    _homeController.musicList.clear();
    _homeController.searchMusic("");

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
              onChanged: (val) => _homeController.searchMusic(val),
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
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.yellow.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.folder, color: AppColors.yellow),
              ),
              title: const Text(
                "Select from Device",
                style: TextStyle(
                  color: AppColors.yellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                _homeController.stopAudio();
                FilePickerResult? result = await FilePicker.pickFiles(
                  type: FileType.audio,
                );
                if (result != null && result.files.single.path != null) {
                  setState(() {
                    _selectedLocalAudio = File(result.files.single.path!);
                    _selectedMusicName = result.files.single.name;
                    _selectedMusicUrl = null;
                  });
                }
                if (!mounted) return;
                Navigator.pop(context);
              },
            ),
            const Divider(color: Colors.white24),
            Expanded(
              child: Obx(() {
                if (_homeController.isSearchingMusic.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.yellow),
                  );
                }
                if (_homeController.musicList.isEmpty) {
                  return Center(
                    child: Text(
                      "noMusicFound".tr,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: _homeController.musicList.length,
                  itemBuilder: (context, index) {
                    final music = _homeController.musicList[index];
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
                              final isPlaying = _homeController
                                      .currentlyPlayingUrl.value ==
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
                                  _homeController.togglePlay(previewUrl);
                                },
                              );
                            })
                          : null,
                      onTap: () {
                        _homeController.stopAudio();
                        setState(() {
                          _selectedMusicName = music["title"];
                          _selectedMusicUrl = music["previewUrl"];
                          _selectedLocalAudio = null;
                        });
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
    ).whenComplete(() => _homeController.stopAudio());
  }

  void _publishReel() {
    final String caption = _captionController.text.trim();
    // Using selected sound text for description fallback, but primarily using the model
    final String sound = _selectedMusicName ?? "";

    if (_selectedVideo == null) {
      Get.snackbar(
        "VIDEO_REQUIRED".tr,
        "PLEASE_SELECT_VIDEO".tr,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (caption.isEmpty) {
      Get.snackbar(
        "CAPTION_REQUIRED".tr,
        "PLEASE_ADD_CAPTION".tr,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Call controller to add new reel at top of feed
    _reelsController
        .createReel(
          title: caption,
          description: sound,
          videoFile: _selectedVideo,
          audioFile: _selectedLocalAudio,
          musicName: _selectedMusicName,
          musicUrl: _selectedMusicUrl,
        )
        .then((_) {
          if (!_reelsController.isUploading.value) {
            Get.back();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: AppColors.yellow),
          title: Text(
            "CREATE_REEL".tr,
            style: const TextStyle(
              color: AppColors.yellow,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Media Picker Card
              GestureDetector(
                onTap: _pickVideo,
                child: Container(
                  height: 240,
                  decoration: BoxDecoration(
                    color: const Color(0xff121212),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: _selectedVideo != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                color: const Color(0xff1A1A1A),
                              ),
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.check_circle_outline_rounded,
                                      color: AppColors.yellow,
                                      size: 48,
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      "Video Selected",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                      ),
                                      child: Text(
                                        _selectedVideo!.path.split('/').last,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white60,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "CHANGE".tr,
                                    style: const TextStyle(
                                      color: AppColors.yellow,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: _isPicking
                              ? const CircularProgressIndicator(
                                  color: AppColors.yellow,
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.video_library_outlined,
                                      color: AppColors.yellow,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "UPLOAD_VIDEO".tr,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "TAP_TO_SELECT_VIDEO".tr,
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Caption Field
              Text(
                "CAPTION".tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _captionController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "WRITE_DESCRIPTION".tr,
                  hintStyle: const TextStyle(
                    color: Colors.white30,
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: const Color(0xff121212),
                  counterStyle: const TextStyle(color: Colors.white38),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.yellow),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Soundtrack Field
              Text(
                "ADD_SOUND_OPTIONAL".tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _showMusicSelectionSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xff121212),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.music_note_rounded,
                        color: Colors.white54,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedMusicName ?? "EG_ORIGINAL_AUDIO".tr,
                          style: TextStyle(
                            color: _selectedMusicName != null
                                ? Colors.white
                                : Colors.white30,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_selectedMusicName != null)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMusicName = null;
                              _selectedMusicUrl = null;
                              _selectedLocalAudio = null;
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.white54,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Publish Button
              Obx(
                () => CustomButton(
                  title: _reelsController.isUploading.value
                      ? "UPLOADING".tr
                      : "PUBLISH_REEL".tr,
                  onTap: _reelsController.isUploading.value
                      ? () {}
                      : _publishReel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'reels_controller.dart';

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
  final TextEditingController _soundController = TextEditingController();
  final ReelsController _reelsController = Get.find<ReelsController>();

  @override
  void dispose() {
    _captionController.dispose();
    _soundController.dispose();
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
        setState(() {
          _selectedVideo = File(picked.path);
        });
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

  void _publishReel() {
    final String caption = _captionController.text.trim();
    final String sound = _soundController.text.trim();

    if (_selectedVideo == null) {
      Get.snackbar(
        "Video Required",
        "Please select a video file before publishing.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (caption.isEmpty) {
      Get.snackbar(
        "Caption Required",
        "Please add a short caption for your reel.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Call controller to add new reel at top of feed
    _reelsController.addReel(
      username: 'MY_GARAGE',
      caption: caption,
      musicName: sound,
      videoFile: _selectedVideo,
    );

    Get.back();
    Get.snackbar(
      "Success",
      "Your Reel has been uploaded!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "CREATE REEL",
            style: TextStyle(
              color: Colors.white,
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
                              // Local placeholder image representation of selected video
                              Image.network(
                                'https://images.unsplash.com/photo-1544829099-b9a0c07fad1a?w=800&fit=crop',
                                fit: BoxFit.cover,
                              ),
                              Container(color: Colors.black45),
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
                                  child: const Text(
                                    "Change",
                                    style: TextStyle(
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
                                    const Text(
                                      "Select Video from Gallery",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "MP4 or MOV formats supported",
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Caption Field
              const Text(
                "CAPTION",
                style: TextStyle(
                  color: AppColors.yellow,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _captionController,
                maxLength: 150,
                maxLines: 3,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Write a catchy description for your reel...",
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
              const Text(
                "SOUND / MUSIC TITLE",
                style: TextStyle(
                  color: AppColors.yellow,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _soundController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "e.g., V8 Pure Sound, Drift Anthem, or leave empty",
                  hintStyle: const TextStyle(
                    color: Colors.white30,
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: const Color(0xff121212),
                  prefixIcon: const Icon(
                    Icons.music_note_rounded,
                    color: Colors.white54,
                    size: 20,
                  ),
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
              const SizedBox(height: 36),

              // Publish Button
              CustomButton(title: "PUBLISH REEL", onTap: _publishReel),
            ],
          ),
        ),
      ),
    );
  }
}

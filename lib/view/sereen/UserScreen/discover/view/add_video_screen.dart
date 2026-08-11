import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:speedring/view/sereen/UserScreen/discover/controller/discover_controller.dart';

class AddVideoScreen extends StatefulWidget {
  const AddVideoScreen({super.key});

  @override
  State<AddVideoScreen> createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  final DiscoverController controller = Get.find<DiscoverController>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String selectedClassification = "ONBOARD";

  File? _videoFile;
  File? _thumbnailFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickMedia(bool isVideo, ImageSource source) async {
    try {
      if (isVideo) {
        final XFile? video = await _picker.pickVideo(source: source);
        if (video != null) {
          setState(() {
            _videoFile = File(video.path);
          });
        }
      } else {
        final XFile? image = await _picker.pickImage(source: source);
        if (image != null) {
          setState(() {
            _thumbnailFile = File(image.path);
          });
        }
      }
    } catch (e) {
      debugPrint(('\$e'));
    }
  }

  void _showMediaPickerOptions(bool isVideo) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xff181818),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.yellow),
                title: Text('Camera'.tr, style: TextStyle(color: Colors.white)),
                onTap: () {
                  Get.back();
                  _pickMedia(isVideo, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.yellow,
                ),
                title: Text(
                  'Gallery'.tr,
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Get.back();
                  _pickMedia(isVideo, ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomRoyelAppbar(leftIcon: true, titleName: 'addNewVideo'.tr),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 1. PRIMARY MEDIA
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSectionHeader('primaryMedia'.tr),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: () => _showMediaPickerOptions(true),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.yellow.withValues(alpha: 0.4),
                      ),
                      borderRadius: BorderRadius.circular(4),
                      color: const Color(0xff111111),
                    ),
                    child: _videoFile != null
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                Icons.video_file,
                                color: Colors.white54,
                                size: 50,
                              ),
                              Positioned(
                                bottom: 10,
                                child: Text(
                                  _videoFile!.path.split('/').last,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _videoFile = null;
                                    });
                                  },
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.videocam_outlined,
                                color: AppColors.yellow,
                                size: 36,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'uploadVideo'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// 2. THUMBNAIL
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSectionHeader("THUMBNAIL"),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: () => _showMediaPickerOptions(false),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.yellow.withValues(alpha: 0.4),
                      ),
                      borderRadius: BorderRadius.circular(4),
                      color: const Color(0xff111111),
                    ),
                    child: _thumbnailFile != null
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.file(
                                  _thumbnailFile!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _thumbnailFile = null;
                                    });
                                  },
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: AppColors.yellow,
                                size: 36,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'uploadCustomThumbnail'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// 3. VIDEO IDENTITY
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: _buildCardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Inner Header tag
                      _buildInnerTag('videoIdentity'.tr),
                      const SizedBox(height: 16),

                      Text(
                        'videoTitleUpper'.tr,
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(_titleController, 'enterSessionName'.tr),
                      const SizedBox(height: 20),

                      Text(
                        'descriptionUpper'.tr,
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        _descController,
                        'addSessionNotes'.tr,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// 4. CLASSIFICATION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSectionHeader("CLASSIFICATION"),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: ["ONBOARD", "TECHNICAL", "VLOG", "RACE"].map((
                    type,
                  ) {
                    final bool isSelected = type == selectedClassification;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedClassification = type;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xff111111),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.yellow
                                  : Colors.white10,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              type,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.yellow
                                    : Colors.white60,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),

              /// Bottom Publish Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() {
                  final isUploading = controller.isVideoUploading.value;
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isUploading
                            ? Colors.grey
                            : AppColors.yellow,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: isUploading
                          ? null
                          : () {
                              if (_titleController.text.trim().isEmpty) {
                                Get.snackbar(
                                  'Error',
                                  'enterVideoTitle'.tr,
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                );
                                return;
                              }
                              if (_videoFile == null) {
                                Get.snackbar(
                                  'Error',
                                  'selectVideoUpload'.tr,
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                );
                                return;
                              }

                              final fields = {
                                'videoDetails.title': _titleController.text
                                    .trim(),
                                'videoDetails.description': _descController.text
                                    .trim(),
                                'videoDetails.classification':
                                    selectedClassification,
                              };

                              controller.createVideoPost(
                                fields: fields,
                                videoFile: XFile(_videoFile!.path),
                                thumbnailFile: _thumbnailFile != null
                                    ? XFile(_thumbnailFile!.path)
                                    : null,
                              );
                            },
                      child: isUploading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black,
                                ),
                              ),
                            )
                          : Text(
                              'publishVideo'.tr,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                              ),
                            ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xff181818),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: AppColors.yellow.withValues(alpha: 0.3)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.yellow,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildInnerTag(String title) {
    return Row(
      children: [
        Container(width: 3, height: 12, color: AppColors.yellow),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: const Color(0xff111111),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: Colors.white10),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

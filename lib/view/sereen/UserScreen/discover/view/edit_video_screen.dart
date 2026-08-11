import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/sereen/UserScreen/discover/controller/discover_controller.dart';
import 'package:speedring/view/sereen/UserScreen/discover/model/video_model.dart';

class EditVideoScreen extends StatefulWidget {
  final VideoPost video;
  const EditVideoScreen({super.key, required this.video});

  @override
  State<EditVideoScreen> createState() => _EditVideoScreenState();
}

class _EditVideoScreenState extends State<EditVideoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String selectedClassification = "ONBOARD";

  XFile? _selectedVideo;
  XFile? _selectedThumbnail;
  final ImagePicker _picker = ImagePicker();
  final DiscoverController _discoverController = Get.find<DiscoverController>();

  @override
  void initState() {
    super.initState();
    final details = widget.video.videoDetails;
    if (details != null) {
      _titleController.text = details.title ?? "";
      _descController.text = details.description ?? "";
      if (details.classification != null) {
        selectedClassification = details.classification!;
      }
    }
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _selectedVideo = video;
      });
    }
  }

  Future<void> _pickThumbnail() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedThumbnail = image;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final details = widget.video.videoDetails;

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.yellow,
              size: 24,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'editVideoUpper'.tr,
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 1. PRIMARY MEDIA
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSectionHeader('${'primaryMedia'.tr} (${'optional'.tr})'),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: _pickVideo,
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
                    child: _selectedVideo != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ('${'newVideoSelected'.tr}\\n${_selectedVideo!.name}'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.yellow,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.videocam_outlined,
                                color: Colors.white54,
                                size: 36,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'tapToReplaceVideo'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white54,
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
                child: _buildSectionHeader("THUMBNAIL (OPTIONAL)"),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: _pickThumbnail,
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
                    child: _selectedThumbnail != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.file(
                              File(_selectedThumbnail!.path),
                              fit: BoxFit.cover,
                            ),
                          )
                        : (details?.thumbnail != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    details!.thumbnail!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: Colors.white54,
                                      size: 36,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'tapToReplaceThumbnail'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                )),
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
                      _buildTextField(
                        _titleController,
                        'enterSessionName'.tr,
                      ),
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
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (_titleController.text.isEmpty) {
                        Get.snackbar(
                          "Required",
                          'enterVideoTitle'.tr,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xff181818),
                          colorText: Colors.red,
                        );
                        return;
                      }

                      _discoverController.editVideoPost(
                        videoId: widget.video.id!,
                        fields: {
                          'videoDetails.title': _titleController.text,
                          'videoDetails.description': _descController.text,
                          'videoDetails.classification': selectedClassification,
                        },
                        videoFile: _selectedVideo,
                        thumbnailFile: _selectedThumbnail,
                      );
                    },
                    child: Text(
                      'updateVideo'.tr,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
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

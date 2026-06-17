import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';

class AddVideoScreen extends StatefulWidget {
  const AddVideoScreen({super.key});

  @override
  State<AddVideoScreen> createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String selectedClassification = "ONBOARD";

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
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.yellow, size: 24),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "ADD NEW VIDEO",
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
                child: _buildSectionHeader("PRIMARY MEDIA"),
              ),
              const SizedBox(height: 8),
      
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.yellow.withValues(alpha:0.4)),
                    borderRadius: BorderRadius.circular(4),
                    color: const Color(0xff111111),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.videocam_outlined, color: AppColors.yellow, size: 36),
                      SizedBox(height: 12),
                      Text(
                        "DRAG & DROP OR TAP TO UPLOAD RAW/MP4 (MAX 2GB)",
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
              const SizedBox(height: 20),
      
              /// 2. THUMBNAIL
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSectionHeader("THUMBNAIL"),
              ),
              const SizedBox(height: 8),
      
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.yellow.withValues(alpha:0.4)),
                    borderRadius: BorderRadius.circular(4),
                    color: const Color(0xff111111),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_photo_alternate_outlined, color: AppColors.yellow, size: 36),
                      SizedBox(height: 12),
                      Text(
                        "UPLOAD CUSTOM THUMBNAIL",
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
                      _buildInnerTag("VIDEO IDENTITY"),
                      const SizedBox(height: 16),
      
                      const Text(
                        "VIDEO TITLE",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(_titleController, "ENTER SESSION NAME..."),
                      const SizedBox(height: 20),
      
                      const Text(
                        "DESCRIPTION",
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
                        "ADD SESSION NOTES, WEATHER CONDITIONS, OR LAP TIMES...",
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
                  children: ["ONBOARD", "TECHNICAL", "VLOG", "RACE"].map((type) {
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
                              color: isSelected ? AppColors.yellow : Colors.white10,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              type,
                              style: TextStyle(
                                color: isSelected ? AppColors.yellow : Colors.white60,
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
                      Get.back();
                      Get.snackbar(
                        "Video Published",
                        "Your motorsport video has been uploaded successfully.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xff181818),
                        colorText: Colors.white,
                        borderColor: AppColors.yellow,
                        borderWidth: 1,
                      );
                    },
                    child: const Text(
                      "PUBLISH VIDEO",
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
        border: Border.all(color: AppColors.yellow.withValues(alpha:0.3)),
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
        Container(
          width: 3,
          height: 12,
          color: AppColors.yellow,
        ),
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

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
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

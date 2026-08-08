import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/sereen/UserScreen/discover/controller/discover_controller.dart';
import 'package:speedring/view/sereen/UserScreen/discover/model/discover_model.dart';

class EditSpotScreen extends StatefulWidget {
  const EditSpotScreen({super.key});

  @override
  State<EditSpotScreen> createState() => _EditSpotScreenState();
}

class _EditSpotScreenState extends State<EditSpotScreen> {
  final DiscoverController _controller = Get.find<DiscoverController>();
  final ImagePicker _picker = ImagePicker();
  
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _engineController = TextEditingController();
  final TextEditingController _powerController = TextEditingController();
  final TextEditingController _zeroToHundredController =
      TextEditingController();
      
  DiscoverPost? post;

  // New selected files
  XFile? _primaryImage;
  XFile? _secondaryImage1;
  XFile? _secondaryImage2;

  // Existing network image URLs if they exist
  String? _existingPrimaryUrl;
  String? _existingSecondary1;
  String? _existingSecondary2;
  
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null && Get.arguments is DiscoverPost) {
      post = Get.arguments as DiscoverPost;
      _plateController.text = post?.spotDetails?.licensePlate ?? "";
      _regionController.text = post?.spotDetails?.region ?? "";
      _modelController.text = post?.spotDetails?.makeAndModel ?? "";
      _engineController.text = post?.spotDetails?.engine ?? "";
      _powerController.text = post?.spotDetails?.powerHp ?? "";
      _zeroToHundredController.text = post?.spotDetails?.zeroToHundred ?? "";
      
      // Load existing network images if available
      if (post?.media != null && post!.media!.isNotEmpty) {
        _existingPrimaryUrl = post!.media![0].url;
        if (post!.media!.length > 1) {
          _existingSecondary1 = post!.media![1].url;
        }
        if (post!.media!.length > 2) {
          _existingSecondary2 = post!.media![2].url;
        }
      }
    }
  }

  Future<void> _pickPrimaryImages() async {
    final List<XFile> picked = await _picker.pickMultiImage(imageQuality: 85);
    if (picked.isEmpty) return;
    setState(() {
      _primaryImage = picked.isNotEmpty ? picked[0] : null;
      _secondaryImage1 = picked.length > 1 ? picked[1] : null;
      _secondaryImage2 = picked.length > 2 ? picked[2] : null;
      // Reset existing URLs when new are selected
      if (picked.isNotEmpty) _existingPrimaryUrl = null;
      if (picked.length > 1) _existingSecondary1 = null;
      if (picked.length > 2) _existingSecondary2 = null;
    });
  }

  Future<void> _pickSecondaryImage(int slotIndex) async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() {
      if (slotIndex == 1) {
        _secondaryImage1 = picked;
        _existingSecondary1 = null;
      } else {
        _secondaryImage2 = picked;
        _existingSecondary2 = null;
      }
    });
  }

  Future<void> _submit() async {
    if (post?.id == null) {
      Get.snackbar("Error", "Post ID not found");
      return;
    }
    if (_modelController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation', 'Make & Model is required',
        backgroundColor: const Color(0xff1C1C1C),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final List<XFile> mediaFiles = [
      if (_primaryImage != null) _primaryImage!,
      if (_secondaryImage1 != null) _secondaryImage1!,
      if (_secondaryImage2 != null) _secondaryImage2!,
    ];

    await _controller.editDiscoverPost(
      postId: post!.id!,
      fields: {
        'spotDetails.licensePlate': _plateController.text.trim(),
        'spotDetails.region': _regionController.text.trim(),
        'spotDetails.makeAndModel': _modelController.text.trim(),
        'spotDetails.engine': _engineController.text.trim(),
        'spotDetails.powerHp': _powerController.text.trim(),
        'spotDetails.zeroToHundred': _zeroToHundredController.text.trim(),
      },
      mediaFiles: mediaFiles.isEmpty ? null : mediaFiles,
    );

    if (mounted) setState(() => _isSubmitting = false);
  }

  @override
  void dispose() {
    _plateController.dispose();
    _regionController.dispose();
    _modelController.dispose();
    _engineController.dispose();
    _powerController.dispose();
    _zeroToHundredController.dispose();
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
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.yellow,
              size: 24,
            ),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "EDIT VEHICLE SPOT",
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
              /// 1. MEDIA CAPTURE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSectionHeader("MEDIA CAPTURE"),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: _buildCardDecoration(),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickPrimaryImages,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: (_primaryImage != null || _existingPrimaryUrl != null)
                                  ? AppColors.yellow.withValues(alpha: 0.6)
                                  : Colors.white12,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _primaryImage != null
                              ? Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.file(
                                      File(_primaryImage!.path),
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 8, right: 8,
                                      child: GestureDetector(
                                        onTap: () => setState(() => _primaryImage = null),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.close, color: Colors.white, size: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : _existingPrimaryUrl != null
                                  ? Image.network(
                                      _existingPrimaryUrl!,
                                      fit: BoxFit.cover,
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.add_a_photo_outlined,
                                          color: AppColors.yellow,
                                          size: 32,
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          "UPLOAD PRIMARY ASSET",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "TAP TO SELECT FROM GALLERY",
                                          style: TextStyle(
                                            color: Colors.white38,
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// Secondary small upload row
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _pickSecondaryImage(1),
                              child: _buildSecondarySlot(_secondaryImage1, _existingSecondary1),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _pickSecondaryImage(2),
                              child: _buildSecondarySlot(_secondaryImage2, _existingSecondary2),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// 2. VEHICLE IDENTIFICATION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSectionHeader("VEHICLE IDENTIFICATION"),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: _buildCardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "LICENSE PLATE",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller: _plateController,
                        hint: "ENTER PLATE ID",
                        icon: Icons.tag,
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        "REGION / COUNTRY",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller: _regionController,
                        hint: "SELECT REGION",
                        icon: Icons.public,
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        "MAKE & MODEL",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller: _modelController,
                        hint: "E.G. PORSCHE 911 GT3 RS",
                        icon: Icons.directions_car,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// 3. SPECIFICATION OVERRIDE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSectionHeader("SPECIFICATION OVERRIDE"),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: _buildCardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Engine Field
                      const Text(
                        "ENGINE",
                        style: TextStyle(
                          color: AppColors.yellow,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSpecField(
                        controller: _engineController,
                        hint: "E.G. 4.0L FLAT-6",
                      ),
                      const SizedBox(height: 16),

                      /// Power Field
                      Row(
                        children: const [
                          Icon(
                            Icons.flash_on,
                            color: AppColors.yellow,
                            size: 10,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "POWER (HP)",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildSpecField(
                        controller: _powerController,
                        hint: "E.G. 525",
                      ),
                      const SizedBox(height: 16),

                      /// 0-100 Field
                      Row(
                        children: const [
                          Icon(
                            Icons.timer_outlined,
                            color: AppColors.yellow,
                            size: 10,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "0-100 KM/H (S)",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildSpecField(
                        controller: _zeroToHundredController,
                        hint: "E.G. 3.2",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              /// Bottom Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      foregroundColor: Colors.black,
                      disabledBackgroundColor: AppColors.yellow.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            "UPDATE SPOT",
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

  Widget _buildSecondarySlot(XFile? localImage, String? networkUrl) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (localImage != null || networkUrl != null)
              ? AppColors.yellow.withValues(alpha: 0.4)
              : Colors.transparent,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: localImage != null
          ? Image.file(File(localImage.path), fit: BoxFit.cover)
          : networkUrl != null
              ? Image.network(networkUrl, fit: BoxFit.cover)
              : const Center(
                  child: Icon(Icons.add, color: Colors.white24, size: 24),
                ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: const Color(0xff111111),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: Colors.white10),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.yellow, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 13),
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

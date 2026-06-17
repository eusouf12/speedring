import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_button/custom_button.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController(text: "MAX VERSTAPPEN");
  final handleController = TextEditingController(text: "max_verstappen_33");
  final bioController = TextEditingController(
    text: "3-time World Champion. Pushing the limits of engineering and performance.",
  );
  
  final instagramController = TextEditingController(text: "instagram.com/maxverstappen1");
  final tiktokController = TextEditingController();
  final youtubeController = TextEditingController();
  final facebookController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    handleController.dispose();
    bioController.dispose();
    instagramController.dispose();
    tiktokController.dispose();
    youtubeController.dispose();
    facebookController.dispose();
    super.onClose();
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "EDIT PROFILE",
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Banner & Avatar Stack
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  /// Cover Image
                  SizedBox(
                    height: 180.h,
                    width: double.infinity,
                    child: Image.network(
                      "https://picsum.photos/seed/editprofilebanner/800/400",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xff1C1C1C),
                        child: const Center(
                          child: Icon(Icons.image, color: Colors.white24, size: 48),
                        ),
                      ),
                    ),
                  ),
                  // Edit Cover Icon
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.yellow,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, color: Colors.black, size: 16),
                      ),
                    ),
                  ),
      
                  /// Profile Avatar overlapping
                  Positioned(
                    bottom: -50.h,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 4),
                            color: Colors.black,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              "https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=150&fit=crop",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: const Color(0xff222222),
                                child: const Center(
                                  child: Icon(Icons.person, color: Colors.white24, size: 40),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.yellow,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit, color: Colors.black, size: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 70.h),
      
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// BASIC IDENTITY
                    _buildSectionHeader("BASIC IDENTITY"),
                    _buildCardContainer([
                      _buildFieldLabel("FULL NAME"),
                      _buildTextField(
                        controller: controller.nameController,
                        hint: "Enter your full name",
                        prefixIcon: Icons.person_outline,
                      ),
                      SizedBox(height: 16.h),
                      _buildFieldLabel("HANDLE"),
                      _buildTextField(
                        controller: controller.handleController,
                        hint: "Enter your handle",
                        prefixIcon: Icons.alternate_email,
                      ),
                      SizedBox(height: 16.h),
                      _buildFieldLabel("BIOGRAPHY"),
                      _buildTextField(
                        controller: controller.bioController,
                        hint: "Tell us about yourself...",
                        maxLines: 3,
                      ),
                    ]),
                    SizedBox(height: 24.h),
      
                    /// SOCIAL CONNECTIVITY
                    _buildSectionHeader("SOCIAL CONNECTIVITY"),
                    _buildCardContainer([
                      _buildSocialField(
                        controller: controller.instagramController,
                        hint: "instagram.com/username",
                        icon: Icons.camera_alt_outlined,
                      ),
                      SizedBox(height: 12.h),
                      _buildSocialField(
                        controller: controller.tiktokController,
                        hint: "TikTok URL",
                        icon: Icons.video_library_outlined,
                      ),
                      SizedBox(height: 12.h),
                      _buildSocialField(
                        controller: controller.youtubeController,
                        hint: "YouTube URL",
                        icon: Icons.play_circle_outline,
                      ),
                      SizedBox(height: 12.h),
                      _buildSocialField(
                        controller: controller.facebookController,
                        hint: "Facebook URL",
                        icon: Icons.public_outlined,
                      ),
                    ]),
                    SizedBox(height: 32.h),
      
                    /// Deactivate Button
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.disabled_by_default_outlined, color: Colors.redAccent, size: 16),
                            SizedBox(width: 6.w),
                            const CustomText(
                              text: "DEACTIVATE DRIVER PROFILE",
                              color: Colors.redAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
      
                    /// Save changes button
                    CustomButton(
                      height: 50.h,
                      title: "SAVE CHANGES",
                      fontSize: 13,
                      borderRadius: 8.r,
                      onTap: () {
                        Get.back();
                        Get.snackbar(
                          "Profile Updated",
                          "Your profile changes have been successfully saved.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xff181818),
                          colorText: Colors.white,
                          borderColor: AppColors.yellow,
                          borderWidth: 1,
                        );
                      },
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: title,
        color: AppColors.yellow,
        fontSize: 9.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildCardContainer(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: label,
        color: Colors.white38,
        fontSize: 9.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? prefixIcon,
    int maxLines = 1,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: maxLines > 1 ? 8.h : 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withValues(alpha:0.03)),
      ),
      child: Row(
        children: [
          if (prefixIcon != null) ...[
            Icon(prefixIcon, color: Colors.white38, size: 16),
            SizedBox(width: 10.w),
          ],
          Expanded(
            child: TextFormField(
              controller: controller,
              maxLines: maxLines,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withValues(alpha:0.03)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 18),
          SizedBox(width: 12.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

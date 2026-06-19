import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_text/custom_text.dart';

class BusinessEditClubScreen extends StatelessWidget {
  const BusinessEditClubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve club info from arguments or use fallback defaults
    final Map<String, dynamic> clubArgs = Get.arguments as Map<String, dynamic>? ?? {
      'name': 'Porsche GT3 Collective',
      'members': '1,240 ACTIVE MEMBERS',
      'imageUrl': 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=800&fit=crop',
    };

    // Text controllers
    final nameController = TextEditingController(text: clubArgs['name'] as String);
    final aboutController = TextEditingController(
      text: "The Porsche GT3 Collective is dedicated to the purist pursuit of naturally aspirated performance. We focus on the intersection of driver mechanical empathy and track-optimized engineering. Members are expected to maintain technical telemetry logs and show driving precision.",
    );

    // Reactive states
    final RxString selectedSecurity = "PRIVATE".obs; // PUBLIC, PRIVATE, INVITE
    final RxList<String> technicalTags = <String>[
      "GT3",
      "Nürburgring",
      "Flat-Six",
      "9000-RPM"
    ].obs;

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
            "EDIT CLUB",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Photo Header
              _buildCoverPhotoHeader(clubArgs),

              // Profile Logo Section
              _buildProfileLogoSection(),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Core Identity Section
                    _buildSectionHeader("CORE IDENTITY"),
                    _buildFormCard([
                      _buildFieldLabel("CLUB DESIGNATION"),
                      _buildOutlineField(nameController, "Club Designation", prefixIcon: Icons.badge_outlined),
                      SizedBox(height: 16.h),
                      _buildFieldLabel("SECURITY PROTOCOL"),
                      _buildSecurityProtocolRadio(selectedSecurity, "PUBLIC", "PUBLIC", "OPEN ENTRY"),
                      SizedBox(height: 8.h),
                      _buildSecurityProtocolRadio(selectedSecurity, "PRIVATE", "PRIVATE", "APPROVAL REQ."),
                      SizedBox(height: 8.h),
                      _buildSecurityProtocolRadio(selectedSecurity, "INVITE", "INVITE ONLY", "STEALTH MODE"),
                    ]),
                    SizedBox(height: 24.h),

                    // About Section
                    _buildSectionHeader("ABOUT"),
                    _buildFormCard([
                      _buildFieldLabel("DETAILS"),
                      _buildOutlineField(aboutController, "About details", maxLines: 4),
                      SizedBox(height: 16.h),
                      _buildFieldLabel("TECHNICAL TAGS"),
                      Obx(() {
                        return Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: [
                            ...technicalTags.map((tag) => _buildTagChip(tag, technicalTags)),
                            _buildAddParameterChip(context, technicalTags),
                          ],
                        );
                      }),
                    ]),
                    SizedBox(height: 24.h),

                    // System Decommission Section
                    _buildSystemDecommission(context),
                    SizedBox(height: 32.h),

                    // Discard and Save Changes Buttons
                    _buildActionButtons(),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverPhotoHeader(Map<String, dynamic> club) {
    return SizedBox(
      height: 180.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Banner Image
          Container(
            height: 180.h,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(club['imageUrl'] as String),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withValues(alpha: 0.2),
            ),
          ),

          // Edit Cover Button
          Positioned(
            top: 14.h,
            right: 16.w,
            child: Container(
              height: 26.h,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: Colors.white24),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: InkWell(
                onTap: () {
                  Get.snackbar(
                    "Cover Media",
                    "Cover image uploading is currently in debug state.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xff111111),
                    colorText: Colors.white,
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.edit_square, color: Colors.white, size: 12.sp),
                    SizedBox(width: 4.w),
                    CustomText(
                      text: "EDIT COVER",
                      color: Colors.white,
                      fontSize: 7.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileLogoSection() {
    return Container(
      width: double.infinity,
      color: const Color(0xff0a0a0a),
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Circular carbon fiber style badge
            Container(
              width: 140.r,
              height: 140.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xff151515),
                border: Border.all(color: AppColors.yellow, width: 2.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(14.w),
              child: Center(
                child: Image.network(
                  "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=200&fit=crop",
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.shield_outlined,
                    color: AppColors.yellow,
                    size: 44,
                  ),
                ),
              ),
            ),

            // Edit Profile Button Overlay at top right of image bounds
            Positioned(
              top: 4.h,
              right: 4.w,
              child: Container(
                height: 24.h,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: Colors.white24),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: InkWell(
                  onTap: () {
                    Get.snackbar(
                      "Identity Logo",
                      "Logo upload interface currently locked.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: const Color(0xff111111),
                      colorText: Colors.white,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_square, color: Colors.white, size: 10.sp),
                      SizedBox(width: 4.w),
                      CustomText(
                        text: "EDIT PROFILE",
                        color: Colors.white,
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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

  Widget _buildFormCard(List<Widget> children) {
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
        fontSize: 8.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildOutlineField(TextEditingController textController, String hint, {IconData? prefixIcon, int maxLines = 1}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff0d0d0d),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: TextFormField(
        controller: textController,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 13, fontWeight: FontWeight.bold),
          isDense: true,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.white38, size: 16.sp) : null,
          prefixIconConstraints: const BoxConstraints(minWidth: 26, minHeight: 0),
        ),
      ),
    );
  }

  Widget _buildSecurityProtocolRadio(RxString groupVal, String value, String title, String subtitle) {
    return Obx(() {
      final isSelected = groupVal.value == value;
      return GestureDetector(
        onTap: () => groupVal.value = value,
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected ? AppColors.yellow : Colors.white10,
              width: isSelected ? 1.2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Custom radio indicator
              Container(
                width: 14.r,
                height: 14.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.yellow : Colors.white38,
                    width: isSelected ? 4 : 1,
                  ),
                  color: Colors.transparent,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: subtitle,
                    color: Colors.white38,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTagChip(String tag, RxList<String> tags) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xff1c1808),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.yellow.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: tag,
            color: AppColors.yellow,
            fontSize: 9.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(width: 6.w),
          GestureDetector(
            onTap: () => tags.remove(tag),
            child: const Icon(Icons.close, color: AppColors.yellow, size: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildAddParameterChip(BuildContext context, RxList<String> tags) {
    return GestureDetector(
      onTap: () {
        final paramController = TextEditingController();
        Get.dialog(
          AlertDialog(
            backgroundColor: const Color(0xff111111),
            title: const Text("Add Technical Tag", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            content: TextFormField(
              controller: paramController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "e.g. Aerodynamics",
                hintStyle: TextStyle(color: Colors.white24),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.yellow)),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("CANCEL", style: TextStyle(color: Colors.white54)),
              ),
              TextButton(
                onPressed: () {
                  final text = paramController.text.trim();
                  if (text.isNotEmpty && !tags.contains(text)) {
                    tags.add(text);
                  }
                  Get.back();
                },
                child: const Text("ADD", style: TextStyle(color: AppColors.yellow, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: Colors.white24, style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: "+ ADD PARAMETER",
              color: Colors.white54,
              fontSize: 9.sp,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemDecommission(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff0d0505),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "SYSTEM DECOMMISSION",
            color: Colors.redAccent,
            fontSize: 9.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
          SizedBox(height: 6.h),
          CustomText(
            text: "Deleting this club is irreversible. All telemetry data and squadron records will be purged.",
            color: Colors.white38,
            fontSize: 9.sp,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.start,
            height: 1.4,
          ),
          SizedBox(height: 14.h),
          GestureDetector(
            onTap: () {
              Get.dialog(
                AlertDialog(
                  backgroundColor: const Color(0xff111111),
                  title: const Text("Decommission Club?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  content: const Text("This action cannot be undone. Are you sure you want to permanently delete this club?", style: TextStyle(color: Colors.white70)),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("CANCEL", style: TextStyle(color: Colors.white54)),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back(); // Dismiss dialog
                        Get.back(); // Go back from edit screen
                        Get.back(); // Go back from details screen (decomissioned)
                        Get.snackbar(
                          "Club Terminated",
                          "Club has been completely decommissioned.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xff111111),
                          colorText: Colors.white,
                          borderColor: Colors.redAccent,
                          borderWidth: 1,
                        );
                      },
                      child: const Text("DECOMMISSION", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              height: 38.h,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
              ),
              child: const Center(
                child: CustomText(
                  text: "TERMINATE CLUB",
                  color: Colors.redAccent,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.white24),
              ),
              child: const Center(
                child: CustomText(
                  text: "DISCARD",
                  color: Colors.redAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.back();
              Get.snackbar(
                "Changes Saved",
                "Club specifications updated successfully.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xff111111),
                colorText: Colors.white,
                borderColor: AppColors.yellow,
                borderWidth: 1,
              );
            },
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: const Center(
                child: CustomText(
                  text: "SAVE CHANGES",
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

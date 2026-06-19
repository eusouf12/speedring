import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';

class BusinessCreateClubScreen extends StatelessWidget {
  const BusinessCreateClubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Form controllers
    final nameController = TextEditingController();
    final aboutController = TextEditingController();

    // Reactive states
    final RxString selectedClassification = "GT3 SERIES".obs;
    final RxString selectedVisibility = "PUBLIC".obs;
    final RxBool isTelemetryVerified = true.obs;

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
            "CREATE NEW CLUB",
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 01 - Identity
              _buildSectionHeader("SECTION 01 - IDENTITY"),
              _buildFormCard([
                _buildFieldLabel("CLUB NAME"),
                _buildOutlineField(nameController, "e.g., SYNDICATE RACING"),
                SizedBox(height: 14.h),
                _buildFieldLabel("INPUT DETAILS"),
                _buildOutlineField(aboutController, "Describe About Club", maxLines: 3),
              ]),
              SizedBox(height: 24.h),

              // Section 02 - Classification
              _buildSectionHeader("SECTION 02 - CLASSIFICATION"),
              _buildFormCard([
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: [
                    _buildClassificationChip(selectedClassification, "GT3 SERIES", Icons.emoji_events_outlined),
                    _buildClassificationChip(selectedClassification, "ENDURANCE", Icons.access_time_rounded),
                    _buildClassificationChip(selectedClassification, "STRATEGY", Icons.analytics_outlined),
                    _buildClassificationChip(selectedClassification, "TUNING", Icons.tune_rounded),
                  ],
                ),
              ]),
              SizedBox(height: 24.h),

              // Section 03 - Visibility
              _buildSectionHeader("SECTION 03 - VISIBILITY"),
              _buildFormCard([
                _buildFieldLabel("ACCESS TYPE"),
                CustomText(
                  text: "Define entry protocol",
                  color: Colors.white38,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(child: _buildVisibilityButton(selectedVisibility, "PUBLIC")),
                    SizedBox(width: 8.w),
                    Expanded(child: _buildVisibilityButton(selectedVisibility, "APPROVAL")),
                    SizedBox(width: 8.w),
                    Expanded(child: _buildVisibilityButton(selectedVisibility, "INVITE")),
                  ],
                ),
                const Divider(color: Colors.white10, height: 28),

                // Telemetry Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "TELEMETRY VERIFICATION",
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 2.h),
                        CustomText(
                          text: "Req. validated data logs",
                          color: Colors.white38,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    Obx(() {
                      return Switch(
                        value: isTelemetryVerified.value,
                        activeColor: AppColors.yellow,
                        activeTrackColor: AppColors.yellow.withValues(alpha: 0.3),
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: const Color(0xff222222),
                        onChanged: (val) {
                          isTelemetryVerified.value = val;
                        },
                      );
                    }),
                  ],
                ),
              ]),
              SizedBox(height: 24.h),

              // Section 04 - Visuals
              _buildSectionHeader("SECTION 04 - VISUALS"),
              _buildFormCard([
                _buildFieldLabel("IDENTITY LOGO (1:1)"),
                _buildUploadBox(
                  height: 140.h,
                  label: "SVG / PNG",
                  icon: Icons.file_upload_outlined,
                ),
                SizedBox(height: 16.h),
                _buildFieldLabel("CINEMATIC BANNER (16:9)"),
                _buildUploadBox(
                  height: 120.h,
                  label: "DEPLOY BANNER ASSET",
                  icon: Icons.add_photo_alternate_outlined,
                  bgUrl: "https://images.unsplash.com/photo-1544829099-b9a0c07fad1a?w=400&fit=crop",
                ),
              ]),
              SizedBox(height: 32.h),

              // Create & Cancel Actions
              CustomButton(
                height: 48.h,
                title: "CREATE CLUB",
                fontSize: 12.sp,
                fillColor: AppColors.yellow,
                textColor: Colors.black,
                borderRadius: 10.r,
                onTap: () {
                  Get.back();
                  Get.snackbar(
                    "Club Created",
                    "Club operations dashboard is ready for onboarding.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xff111111),
                    colorText: Colors.white,
                    borderColor: AppColors.yellow,
                    borderWidth: 1,
                  );
                },
              ),
              SizedBox(height: 16.h),
              Center(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: CustomText(
                    text: "CANCEL",
                    color: Colors.redAccent,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
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
        textAlign: TextAlign.start,
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
        fontSize: 9.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildOutlineField(TextEditingController textController, String hint, {int maxLines = 1}) {
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
        ),
      ),
    );
  }

  Widget _buildClassificationChip(RxString selected, String label, IconData icon) {
    return Obx(() {
      final bool isSelected = selected.value == label;
      return GestureDetector(
        onTap: () => selected.value = label,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected ? AppColors.yellow : Colors.white10,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? AppColors.yellow : Colors.white38, size: 14.sp),
              SizedBox(width: 6.w),
              CustomText(
                text: label,
                color: isSelected ? AppColors.yellow : Colors.white60,
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildVisibilityButton(RxString selected, String option) {
    return GestureDetector(
      onTap: () => selected.value = option,
      child: Obx(() {
        final bool isSelected = selected.value == option;
        return Container(
          height: 36.h,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: isSelected ? AppColors.yellow : Colors.white10,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: CustomText(
              text: option,
              color: isSelected ? AppColors.yellow : Colors.white60,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildUploadBox({
    required double height,
    required String label,
    required IconData icon,
    String? bgUrl,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10, style: BorderStyle.solid),
        image: bgUrl != null
            ? DecorationImage(
                image: NetworkImage(bgUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.5), BlendMode.dstATop),
              )
            : null,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white38, size: 24.sp),
            SizedBox(height: 8.h),
            CustomText(
              text: label,
              color: Colors.white38,
              fontSize: 9.sp,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';

class BusinessCreateSpotPostScreen extends StatefulWidget {
  const BusinessCreateSpotPostScreen({super.key});

  @override
  State<BusinessCreateSpotPostScreen> createState() => _BusinessCreateSpotPostScreenState();
}

class _BusinessCreateSpotPostScreenState extends State<BusinessCreateSpotPostScreen> {
  final locationController = TextEditingController(text: "Monaco, MC");
  final vehicleController = TextEditingController(text: "Ferrari SF90 Stradale");
  final captionController = TextEditingController(
    text: "Spotted this absolute masterpiece on the casino square. Incredible spec with carbon winglets and giallo highlights."
  );

  @override
  void dispose() {
    locationController.dispose();
    vehicleController.dispose();
    captionController.dispose();
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
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "CREATE SPOT",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: _onPublish,
              child: const Text(
                "PUBLISH",
                style: TextStyle(color: AppColors.yellow, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Photo section
              _buildAddPhotoSection(),
              SizedBox(height: 18.h),

              // Location Input
              _buildFieldLabel("LOCATION"),
              _buildOutlineIconField(locationController, Icons.location_on_outlined, "Detecting location..."),
              SizedBox(height: 8.h),
              Row(
                children: [
                  _buildSuggestionPill("Monaco, MC", (val) => setState(() => locationController.text = val)),
                  SizedBox(width: 8.w),
                  _buildSuggestionPill("Nürburgring, DE", (val) => setState(() => locationController.text = val)),
                ],
              ),
              SizedBox(height: 18.h),

              // Vehicle Model Input
              _buildFieldLabel("VEHICLE MODEL"),
              _buildOutlineIconField(vehicleController, Icons.search_rounded, "Search vehicle database"),
              SizedBox(height: 8.h),
              Row(
                children: [
                  _buildSuggestionPill("Hypercar", (val) => setState(() => vehicleController.text = "Ferrari SF90 Stradale")),
                  SizedBox(width: 8.w),
                  _buildSuggestionPill("GT3", (val) => setState(() => vehicleController.text = "Porsche 911 GT3 RS")),
                  SizedBox(width: 8.w),
                  _buildSuggestionPill("EV Sport", (val) => setState(() => vehicleController.text = "Audi e-tron GT")),
                ],
              ),
              SizedBox(height: 18.h),

              // Caption
              _buildFieldLabel("CAPTION / TECHNICAL SUMMARY"),
              _buildCaptionTextArea(),
              SizedBox(height: 24.h),

              // Auto-generated Feed Preview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "AUTO-GENERATED FEED PREVIEW",
                    color: Colors.white38,
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  const Icon(Icons.remove_red_eye_outlined, color: Colors.white38, size: 14),
                ],
              ),
              SizedBox(height: 12.h),
              _buildFeedPreviewCard(),
              SizedBox(height: 32.h),

              // Action button
              CustomButton(
                height: 46.h,
                title: "PUBLISH SPOT",
                fillColor: AppColors.yellow,
                textColor: Colors.black,
                borderRadius: 8.r,
                onTap: _onPublish,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddPhotoSection() {
    return Container(
      height: 160.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Stack(
        children: [
          // Faded sport car image mock
          Opacity(
            opacity: 0.2,
            child: Image.network(
              "https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=800&fit=crop",
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: Colors.black),
            ),
          ),
          // Badge
          Positioned(
            top: 12.h,
            left: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                "CINEMATIC MASTER",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 7.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: const BoxDecoration(
                    color: AppColors.yellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_a_photo_outlined, color: Colors.black),
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: "ADD PHOTO",
                  color: Colors.white60,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildOutlineIconField(TextEditingController controller, IconData icon, String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
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

  Widget _buildSuggestionPill(String label, Function(String) onTap) {
    return GestureDetector(
      onTap: () => onTap(label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xff1A1A1A),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white10),
        ),
        child: CustomText(
          text: label,
          color: Colors.white70,
          fontSize: 8.5.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCaptionTextArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: TextFormField(
        controller: captionController,
        maxLines: 3,
        style: const TextStyle(color: Colors.white, fontSize: 12),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Enter vehicle technical highlights, modifications, and rarity notes...",
          hintStyle: TextStyle(color: Colors.white24, fontSize: 12),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildFeedPreviewCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xff222222),
                radius: 12.r,
                child: const Icon(Icons.person, color: Colors.white, size: 12),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "EURO_SPOTTER",
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    SizedBox(height: 2.h),
                    CustomText(
                      text: locationController.text,
                      color: Colors.white38,
                      fontSize: 7.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Main image
          Container(
            height: 110.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              image: const DecorationImage(
                image: NetworkImage("https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=800&fit=crop"),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(8.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(2.r),
              ),
              child: Text(
                "RARE SPOT",
                style: TextStyle(color: Colors.white, fontSize: 6.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // Vehicle title
          CustomText(
            text: vehicleController.text.toUpperCase(),
            color: Colors.white,
            fontSize: 11.sp,
            fontWeight: FontWeight.w900,
          ),
          SizedBox(height: 4.h),

          // Caption
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "EURO_SPOTTER ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 9.sp,
                    fontFamily: 'Barlow Condensed',
                  ),
                ),
                TextSpan(
                  text: captionController.text,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 9.sp,
                    fontFamily: 'Barlow Condensed',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onPublish() {
    Get.back(); // Pop create spot screen
    Get.back(); // Pop choices screen
    Get.snackbar(
      "Spot Published",
      "Car spot added to active social feed.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff181818),
      colorText: Colors.white,
      borderColor: AppColors.yellow,
      borderWidth: 1,
    );
  }
}

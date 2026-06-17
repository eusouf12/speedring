import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';

class BusinessCreateTrackUpdateScreen extends StatefulWidget {
  const BusinessCreateTrackUpdateScreen({super.key});

  @override
  State<BusinessCreateTrackUpdateScreen> createState() => _BusinessCreateTrackUpdateScreenState();
}

class _BusinessCreateTrackUpdateScreenState extends State<BusinessCreateTrackUpdateScreen> {
  final detailsController = TextEditingController(
    text: "Turn 3 exit kerb is loose. Standing water at Copse. Track temperature dropping rapidly..."
  );

  String selectedCircuit = "Silverstone Circuit";
  String surfaceCondition = "DRY"; // DRY, DAMP, WET, FLOODED
  
  final List<String> activeHazards = ["Yellow Flag"]; // Yellow Flag, Red Flag, Oil on Track, Debris
  String visibility = "Public"; // Public, Followers, Club Only

  @override
  void dispose() {
    detailsController.dispose();
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
            "CREATE TRACK UPDATE",
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
              // Select Circuit
              _buildFieldLabel("SELECT CIRCUIT"),
              _buildCircuitDropdown(),
              SizedBox(height: 18.h),

              // Surface Conditions
              _buildFieldLabel("SURFACE CONDITIONS"),
              Row(
                children: [
                  Expanded(child: _buildSurfaceButton("DRY", Icons.wb_sunny_outlined)),
                  SizedBox(width: 8.w),
                  Expanded(child: _buildSurfaceButton("DAMP", Icons.water_drop_outlined)),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(child: _buildSurfaceButton("WET", Icons.cloudy_snowing)),
                  SizedBox(width: 8.w),
                  Expanded(child: _buildSurfaceButton("FLOODED", Icons.home_outlined)),
                ],
              ),
              SizedBox(height: 18.h),

              // Active Flags & Hazards
              _buildFieldLabel("ACTIVE FLAGS & HAZARDS"),
              Row(
                children: [
                  Expanded(child: _buildHazardButton("Yellow Flag", Icons.outlined_flag, Colors.yellow)),
                  SizedBox(width: 8.w),
                  Expanded(child: _buildHazardButton("Red Flag", Icons.error_outline, Colors.red)),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(child: _buildHazardButton("Oil on Track", Icons.opacity, Colors.orange)),
                  SizedBox(width: 8.w),
                  Expanded(child: _buildHazardButton("Debris", Icons.warning_amber_rounded, Colors.blue)),
                ],
              ),
              SizedBox(height: 18.h),

              // Telemetry & Visuals
              _buildFieldLabel("TELEMETRY & VISUALS"),
              _buildVisualUploadCard(),
              SizedBox(height: 18.h),

              // Details
              _buildFieldLabel("DETAILS / NOTES"),
              _buildDetailsTextArea(),
              SizedBox(height: 18.h),

              // Update Visibility
              _buildFieldLabel("UPDATE VISIBILITY"),
              _buildVisibilityCard(),
              SizedBox(height: 32.h),

              // Publish button (matching Image 5: "PUBLISH SESSION" yellow button)
              CustomButton(
                height: 46.h,
                title: "PUBLISH SESSION",
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

  Widget _buildCircuitDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          // mock track mini map image or dark square
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6.r),
              image: const DecorationImage(
                image: NetworkImage("https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=100&fit=crop"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: selectedCircuit,
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w900,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text: "Northamptonshire, UK",
                  color: Colors.white38,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white60),
        ],
      ),
    );
  }

  Widget _buildSurfaceButton(String label, IconData icon) {
    final bool isSelected = surfaceCondition == label;
    return GestureDetector(
      onTap: () => setState(() => surfaceCondition = label),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.yellow : const Color(0xff111111),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.black : Colors.white60, size: 14.sp),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white60,
                fontSize: 8.5.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHazardButton(String label, IconData icon, Color color) {
    final bool isSelected = activeHazards.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            activeHazards.remove(label);
          } else {
            activeHazards.add(label);
          }
        });
      },
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: const Color(0xff111111),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: isSelected ? color : Colors.white10, width: isSelected ? 1.5 : 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : Colors.white60, size: 14.sp),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontSize: 8.5.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualUploadCard() {
    return Container(
      height: 120.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10, style: BorderStyle.solid),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo_outlined, color: Colors.white24, size: 24),
            SizedBox(height: 8.h),
            CustomText(
              text: "Add Live Photo/Video",
              color: Colors.white70,
              fontSize: 10.sp,
              fontWeight: FontWeight.w900,
            ),
            SizedBox(height: 2.h),
            CustomText(
              text: "Support RAW and 4K Telemetry Overlays",
              color: Colors.white38,
              fontSize: 8.sp,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTextArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: TextFormField(
        controller: detailsController,
        maxLines: 3,
        style: const TextStyle(color: Colors.white, fontSize: 12),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white24, fontSize: 12),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildVisibilityCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          _buildVisibilityOption("Public", visibility == "Public"),
          const Divider(color: Colors.white10, height: 20),
          _buildVisibilityOption("Followers", visibility == "Followers"),
          const Divider(color: Colors.white10, height: 20),
          _buildVisibilityOption("Club Only(VIP)", visibility == "Club Only"),
        ],
      ),
    );
  }

  Widget _buildVisibilityOption(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => visibility = label == "Club Only(VIP)" ? "Club Only" : label),
      child: Row(
        children: [
          const Icon(Icons.public_rounded, color: Colors.white60, size: 16),
          SizedBox(width: 12.w),
          CustomText(
            text: label,
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
          const Spacer(),
          Container(
            width: 14.w,
            height: 14.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? AppColors.yellow : Colors.white30, width: 2),
            ),
            padding: EdgeInsets.all(2.r),
            child: isSelected
                ? Container(
                    decoration: const BoxDecoration(color: AppColors.yellow, shape: BoxShape.circle),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  void _onPublish() {
    Get.back(); // Pop create track update screen
    Get.back(); // Pop choices screen
    Get.snackbar(
      "Track Update Published",
      "Live track report added to active feed.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff181818),
      colorText: Colors.white,
      borderColor: AppColors.yellow,
      borderWidth: 1,
    );
  }
}

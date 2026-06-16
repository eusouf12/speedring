import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';

class CreateVehicleListingScreen extends StatefulWidget {
  const CreateVehicleListingScreen({super.key});

  @override
  State<CreateVehicleListingScreen> createState() => _CreateVehicleListingScreenState();
}

class _CreateVehicleListingScreenState extends State<CreateVehicleListingScreen> {
  String selectedTransmission = "PDK / AUTOMATIC";
  String selectedDrivetrain = "Rear-Wheel Drive (RWD)";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.yellow),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "CREATE LISTING: VEHICLES",
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
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Phase 01: Core Specifications
            _buildSectionHeader("PHASE 01: CORE SPECIFICATIONS"),
            _buildCardContainer([
              _buildFieldLabel("BRAND / MANUFACTURER"),
              _buildTextField("e.g. Porsche, Ferrari, McLaren"),
              SizedBox(height: 16.h),
              _buildFieldLabel("MODEL DESIGNATION"),
              _buildTextField("e.g. 911 GT3 RS"),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("PRODUCTION YEAR"),
                        _buildDropdown(["2024", "2023", "2022", "2021", "2020"]),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("ASKING PRICE (USD)"),
                        _buildTextField("0.00", keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _buildFieldLabel("VEHICLE LOCATION"),
              _buildLocationField("City, Country"),
            ]),

            SizedBox(height: 24.h),

            /// Phase 02: Telemetry & Metrics
            _buildSectionHeader("PHASE 02: TELEMETRY & METRICS"),
            _buildCardContainer([
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("POWER (HP)"),
                        _buildTextField("525", keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("0-100 KM/H"),
                        _buildTextField("3.2s"),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("TOP SPEED"),
                        _buildTextField("296 km/h"),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("WEIGHT (KG)"),
                        _buildTextField("1450", keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _buildFieldLabel("MILEAGE (KM)"),
              _buildTextField("1,240", keyboardType: TextInputType.number),
            ]),

            SizedBox(height: 24.h),

            /// Phase 03: Engineering Dossier
            _buildSectionHeader("PHASE 03: ENGINEERING DOSSIER"),
            _buildCardContainer([
              _buildFieldLabel("ENGINE CONFIGURATION"),
              _buildTextField("e.g. 4.0L Flat-Six Naturally Aspirated"),
              SizedBox(height: 16.h),
              _buildFieldLabel("TRANSMISSION"),
              Row(
                children: [
                  Expanded(child: _buildSegmentOption("PDK / AUTOMATIC", selectedTransmission == "PDK / AUTOMATIC")),
                  SizedBox(width: 12.w),
                  Expanded(child: _buildSegmentOption("MANUAL", selectedTransmission == "MANUAL")),
                ],
              ),
              SizedBox(height: 16.h),
              _buildFieldLabel("DRIVETRAIN"),
              _buildDropdown(["Rear-Wheel Drive (RWD)", "All-Wheel Drive (AWD)", "Front-Wheel Drive (FWD)"],
                  onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedDrivetrain = val;
                  });
                }
              }),
              SizedBox(height: 16.h),
              _buildFieldLabel("AERODYNAMICS / BODY"),
              _buildTextField("Active Aero, Carbon Fiber, Widebody...", maxLines: 2),
            ]),

            SizedBox(height: 24.h),

            /// Phase 04: Performance Narrative
            _buildSectionHeader("PHASE 04: PERFORMANCE NARRATIVE"),
            _buildCardContainer([
              _buildFieldLabel("DETAILED DESCRIPTION & PROVENANCE"),
              _buildTextField(
                "Describe the vehicle's track history, maintenance record, and unique modifications...",
                maxLines: 4,
              ),
            ]),

            SizedBox(height: 24.h),

            /// Phase 05: Visual Assets
            _buildSectionHeader("PHASE 05: VISUAL ASSETS"),
            _buildCardContainer([
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  _buildUploadTile(),
                  _buildImagePreview("https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=150&fit=crop"),
                  _buildImagePreview("https://images.unsplash.com/photo-1611245801312-51345985c6e8?w=150&fit=crop"),
                  _buildVideoPreview("https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=150&fit=crop"),
                ],
              ),
              SizedBox(height: 12.h),
              const Center(
                child: CustomText(
                  text: "RECOMMENDED: 1920X1080 PX | PNG, JPEG | MAX 12 PHOTOS (1 VIDEO MAX SUPPORTED)",
                  color: Colors.white38,
                  fontSize: 7.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),

            SizedBox(height: 32.h),

            /// Submit and Cancel Buttons
            CustomButton(
              height: 50.h,
              title: "PUBLISH LISTING",
              fontSize: 14,
              onTap: () {
                Get.back();
                Get.back();
                Get.snackbar(
                  "Listing Submitted",
                  "Your vehicle listing is now pending publication approval.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xff181818),
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
                child: const CustomText(
                  text: "CANCEL",
                  color: Colors.white38,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            SizedBox(height: 24.h),
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
        fontSize: 9,
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
        fontSize: 9,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField(String hint, {int maxLines = 1, TextInputType? keyboardType}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextFormField(
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildLocationField(String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: Colors.white38, size: 16),
          SizedBox(width: 8.w),
          Expanded(
            child: TextFormField(
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

  Widget _buildDropdown(List<String> items, {ValueChanged<String?>? onChanged}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.first,
          dropdownColor: const Color(0xff1d1d1d),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white60),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          items: items.map((val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSegmentOption(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTransmission = label;
        });
      },
      child: Container(
        height: 38.h,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.yellow : Colors.white10,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: CustomText(
            text: label,
            color: isSelected ? AppColors.yellow : Colors.white60,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadTile() {
    return Container(
      width: 70.w,
      height: 70.w,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10, style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_a_photo_outlined, color: Colors.white38, size: 20),
          SizedBox(height: 4.h),
          const CustomText(
            text: "ADD MEDIA",
            color: Colors.white38,
            fontSize: 7,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(String url) {
    return Stack(
      children: [
        Container(
          width: 70.w,
          height: 70.w,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8.r),
            image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
            child: const Icon(Icons.close, color: Colors.white, size: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPreview(String url) {
    return Stack(
      children: [
        Container(
          width: 70.w,
          height: 70.w,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8.r),
            image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover, opacity: 0.6),
          ),
          child: const Center(
            child: Icon(Icons.play_circle_outline, color: Colors.white, size: 24),
          ),
        ),
        Positioned(
          top: 4,
          left: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(color: AppColors.yellow, borderRadius: BorderRadius.circular(4.r)),
            child: const Text("VIDEO", style: TextStyle(color: Colors.black, fontSize: 6, fontWeight: FontWeight.bold)),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
            child: const Icon(Icons.close, color: Colors.white, size: 10),
          ),
        ),
      ],
    );
  }
}

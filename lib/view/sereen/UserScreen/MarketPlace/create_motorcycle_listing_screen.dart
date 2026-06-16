import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';

class CreateMotorcycleListingScreen extends StatefulWidget {
  const CreateMotorcycleListingScreen({super.key});

  @override
  State<CreateMotorcycleListingScreen> createState() => _CreateMotorcycleListingScreenState();
}

class _CreateMotorcycleListingScreenState extends State<CreateMotorcycleListingScreen> {
  String selectedEngineType = "V4 engine";
  String selectedTransmission = "6-Speed Quickshift";

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
          "CREATE LISTING: MOTORCYCLES",
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
            /// 01 / BASIC INFORMATION
            _buildSectionHeader("01 / BASIC INFORMATION"),
            _buildCardContainer([
              _buildFieldLabel("BRAND"),
              _buildTextField("e.g., Ducati"),
              SizedBox(height: 16.h),
              _buildFieldLabel("MODEL"),
              _buildTextField("e.g., Panigale V4 R"),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("YEAR"),
                        _buildDropdown(["2024", "2023", "2022", "2021", "2020"]),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("LOCATION"),
                        _buildTextField("City, Country"),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _buildFieldLabel("ASKING PRICE (USD)"),
              _buildTextField("\$ 0.00", keyboardType: TextInputType.number),
            ]),

            SizedBox(height: 24.h),

            /// 02 / PERFORMANCE DATA
            _buildSectionHeader("02 / PERFORMANCE DATA"),
            _buildCardContainer([
              _buildFieldLabel("ENGINE TYPE"),
              _buildDropdown(["V4 engine", "Parallel-Twin", "Inline-Four", "L-Twin", "Single-Cylinder"],
                  onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedEngineType = val;
                  });
                }
              }),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("POWER (HP)"),
                        _buildTextField("240", keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("TORQUE (NM)"),
                        _buildTextField("112", keyboardType: TextInputType.number),
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
                        _buildFieldLabel("WEIGHT (KG)"),
                        _buildTextField("172", keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("0-100 KM/H (S)"),
                        _buildTextField("2.9", keyboardType: TextInputType.number),
                      ],
                    ),
                  ),
                ],
              ),
            ]),

            SizedBox(height: 24.h),

            /// 04 / PERFORMANCE NARRATIVE
            _buildSectionHeader("04 / PERFORMANCE NARRATIVE"),
            _buildCardContainer([
              _buildTextField(
                "Describe the vehicle's racing history, maintenance records, and unique modifications...",
                maxLines: 4,
              ),
            ]),

            SizedBox(height: 24.h),

            /// 03 / TECHNICAL DOSSIER
            _buildSectionHeader("03 / TECHNICAL DOSSIER"),
            _buildCardContainer([
              _buildFieldLabel("DISPLACEMENT (CC)"),
              _buildTextField("998", keyboardType: TextInputType.number),
              SizedBox(height: 16.h),
              _buildFieldLabel("TRANSMISSION"),
              _buildDropdown(["6-Speed Quickshift", "6-Speed Manual", "Dual-Clutch Transmission (DCT)"],
                  onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedTransmission = val;
                  });
                }
              }),
              SizedBox(height: 16.h),
              _buildFieldLabel("SUSPENSION"),
              _buildTextField("Öhlins NPX 25/30"),
              SizedBox(height: 16.h),
              _buildFieldLabel("BRAKING SYSTEM"),
              _buildTextField("Brembo Stylema R"),
            ]),

            SizedBox(height: 24.h),

            /// 05 / MEDIA ASSETS
            _buildSectionHeader("05 / MEDIA ASSETS"),
            _buildCardContainer([
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  _buildUploadTile(),
                  _buildImagePreview("https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=150&fit=crop"),
                  _buildImagePreview("https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=150&fit=crop"),
                  _buildVideoPreview("https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=150&fit=crop"),
                ],
              ),
              SizedBox(height: 12.h),
              const Center(
                child: CustomText(
                  text: "MAX 12 PHOTOS / 1 VIDEO MAX SUPPORTED",
                  color: Colors.white38,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),

            SizedBox(height: 32.h),

            /// Actions
            CustomButton(
              height: 50.h,
              title: "PUBLISH LISTING",
              fontSize: 14,
              onTap: () {
                Get.back();
                Get.back();
                Get.snackbar(
                  "Listing Submitted",
                  "Your motorcycle listing is now pending publication approval.",
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

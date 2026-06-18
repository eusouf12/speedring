import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../components/custom_text_field/custom_text_field.dart';

class BusinessCreateVehicleListingScreen extends StatelessWidget {
  const BusinessCreateVehicleListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Final Controllers
    final brandController = TextEditingController();
    final modelController = TextEditingController();
    final priceController = TextEditingController();
    final locationController = TextEditingController();
    
    final powerController = TextEditingController();
    final zeroToSixtyController = TextEditingController();
    final topSpeedController = TextEditingController();
    final weightController = TextEditingController();
    final mileageController = TextEditingController();

    final engineController = TextEditingController();
    final aeroController = TextEditingController();
    final descController = TextEditingController();

    // Reactive states
    final RxString selectedYear = "2024".obs;
    final RxString selectedTransmission = "PDK / AUTOMATIC".obs;
    final RxString selectedDrivetrain = "Rear-Wheel Drive (RWD)".obs;
    final RxList<String> mockMedia = [
      "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=400&fit=crop",
      "https://images.unsplash.com/photo-1544829099-b9a0c07fad1a?w=400&fit=crop",
      "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=400&fit=crop",
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
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phase 01: Core Specifications
              _buildSectionHeader("PHASE 01: CORE SPECIFICATIONS"),
              _buildFormCard([
                _buildFieldLabel("BRAND / MANUFACTURER"),
                CustomTextField(
                  textEditingController: brandController,
                  hintText: "e.g. Porsche, Ferrari, McLaren",
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
                SizedBox(height: 14.h),

                _buildFieldLabel("MODEL DESIGNATION"),
                CustomTextField(
                  textEditingController: modelController,
                  hintText: "e.g. 911 GT3 RS",
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
                SizedBox(height: 14.h),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("PRODUCTION YEAR"),
                          Obx(
                            () => Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              decoration: BoxDecoration(
                                color: const Color(0xff111111),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedYear.value,
                                  isExpanded: true,
                                  dropdownColor: Colors.black,
                                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white60),
                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                  onChanged: (newValue) {
                                    if (newValue != null) selectedYear.value = newValue;
                                  },
                                  items: ["2026", "2025", "2024", "2023", "2022"].map((year) {
                                    return DropdownMenuItem<String>(
                                      value: year,
                                      child: Text(year),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("ASKING PRICE (USD)"),
                          CustomTextField(
                            textEditingController: priceController,
                            hintText: "0.00",
                            keyboardType: TextInputType.number,
                            fillColor: const Color(0xff111111),
                            fieldBorderColor: Colors.white10,
                            fieldBorderRadius: 10.r,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),

                _buildFieldLabel("VEHICLE LOCATION"),
                CustomTextField(
                  textEditingController: locationController,
                  hintText: "City, Country",
                  prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.white30, size: 18),
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
              ]),
              SizedBox(height: 20.h),

              // Phase 02: Telemetry & Metrics
              _buildSectionHeader("PHASE 02: TELEMETRY & METRICS"),
              _buildFormCard([
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("POWER (HP)"),
                          CustomTextField(
                            textEditingController: powerController,
                            hintText: "525",
                            keyboardType: TextInputType.number,
                            fillColor: const Color(0xff111111),
                            fieldBorderColor: Colors.white10,
                            fieldBorderRadius: 10.r,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("0-100 KM/H (S)"),
                          CustomTextField(
                            textEditingController: zeroToSixtyController,
                            hintText: "3.2s",
                            fillColor: const Color(0xff111111),
                            fieldBorderColor: Colors.white10,
                            fieldBorderRadius: 10.r,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("TOP SPEED"),
                          CustomTextField(
                            textEditingController: topSpeedController,
                            hintText: "296 km/h",
                            fillColor: const Color(0xff111111),
                            fieldBorderColor: Colors.white10,
                            fieldBorderRadius: 10.r,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("WEIGHT (KG)"),
                          CustomTextField(
                            textEditingController: weightController,
                            hintText: "1450",
                            keyboardType: TextInputType.number,
                            fillColor: const Color(0xff111111),
                            fieldBorderColor: Colors.white10,
                            fieldBorderRadius: 10.r,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),

                _buildFieldLabel("MILEAGE (KM)"),
                CustomTextField(
                  textEditingController: mileageController,
                  hintText: "1,240",
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
              ]),
              SizedBox(height: 20.h),

              // Phase 03: Engineering Dossier
              _buildSectionHeader("PHASE 03: ENGINEERING DOSSIER"),
              _buildFormCard([
                _buildFieldLabel("ENGINE CONFIGURATION"),
                CustomTextField(
                  textEditingController: engineController,
                  hintText: "e.g. 4.0L Flat-Six Naturally Aspirated",
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
                SizedBox(height: 14.h),

                _buildFieldLabel("TRANSMISSION"),
                Obx(
                  () => Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => selectedTransmission.value = "PDK / AUTOMATIC",
                            child: Container(
                              height: 38.h,
                              decoration: BoxDecoration(
                                color: selectedTransmission.value == "PDK / AUTOMATIC"
                                    ? AppColors.yellow.withValues(alpha: 0.15)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8.r),
                                border: selectedTransmission.value == "PDK / AUTOMATIC"
                                    ? Border.all(color: AppColors.yellow, width: 1)
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  "PDK / AUTOMATIC",
                                  style: TextStyle(
                                    color: selectedTransmission.value == "PDK / AUTOMATIC"
                                        ? AppColors.yellow
                                        : Colors.white60,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => selectedTransmission.value = "MANUAL",
                            child: Container(
                              height: 38.h,
                              decoration: BoxDecoration(
                                color: selectedTransmission.value == "MANUAL"
                                    ? AppColors.yellow.withValues(alpha: 0.15)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8.r),
                                border: selectedTransmission.value == "MANUAL"
                                    ? Border.all(color: AppColors.yellow, width: 1)
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  "MANUAL",
                                  style: TextStyle(
                                    color: selectedTransmission.value == "MANUAL"
                                        ? AppColors.yellow
                                        : Colors.white60,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 14.h),

                _buildFieldLabel("DRIVETRAIN"),
                Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: const Color(0xff111111),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedDrivetrain.value,
                        isExpanded: true,
                        dropdownColor: Colors.black,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white60),
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (newValue) {
                          if (newValue != null) selectedDrivetrain.value = newValue;
                        },
                        items: [
                          "Rear-Wheel Drive (RWD)",
                          "All-Wheel Drive (AWD)",
                          "Front-Wheel Drive (FWD)"
                        ].map((drivetrain) {
                          return DropdownMenuItem<String>(
                            value: drivetrain,
                            child: Text(drivetrain),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),

                _buildFieldLabel("AERODYNAMICS / BODY"),
                CustomTextField(
                  textEditingController: aeroController,
                  hintText: "Active Aero, Carbon Fiber, Widebody...",
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
              ]),
              SizedBox(height: 20.h),

              // Phase 04: Performance Narrative
              _buildSectionHeader("PHASE 04: PERFORMANCE NARRATIVE"),
              _buildFormCard([
                _buildFieldLabel("DETAILED DESCRIPTION & PROVENANCE"),
                CustomTextField(
                  textEditingController: descController,
                  hintText: "Describe the vehicle's track history, maintenance record, and unique modifications...",
                  maxLines: 4,
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
              ]),
              SizedBox(height: 20.h),

              // Phase 05: Visual Assets
              _buildSectionHeader("PHASE 05: VISUAL ASSETS"),
              _buildFormCard([
                Obx(
                  () => GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: mockMedia.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_a_photo_outlined, color: AppColors.yellow),
                              SizedBox(height: 6.h),
                              CustomText(
                                text: "ADD MEDIA",
                                color: Colors.white60,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomText(
                                text: "(Photos, Videos)",
                                color: Colors.white30,
                                fontSize: 8.sp,
                              ),
                            ],
                          ),
                        );
                      }
                      final imgUrl = mockMedia[index - 1];
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.network(
                              imgUrl,
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 6.h,
                            right: 6.w,
                            child: GestureDetector(
                              onTap: () => mockMedia.removeAt(index - 1),
                              child: Container(
                                padding: EdgeInsets.all(2.r),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 14),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 12.h),
                CustomText(
                  text: "RECOMMENDED: 1920X1080 PX | MAX 10MB PER FILE | SUPPORTED: JPG, PNG, MP4",
                  color: Colors.white24,
                  fontSize: 7.5.sp,
                  textAlign: TextAlign.start,
                ),
              ]),
              SizedBox(height: 32.h),

              // Bottom buttons
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      height: 44.h,
                      title: "CANCEL",
                      fontSize: 10.sp,
                      fillColor: const Color(0xff1E1E1E),
                      textColor: Colors.white60,
                      borderRadius: 10.r,
                      onTap: () => Get.back(),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    flex: 3,
                    child: CustomButton(
                      height: 44.h,
                      title: "PUBLISH LISTING",
                      fontSize: 10.sp,
                      fillColor: AppColors.yellow,
                      textColor: Colors.black,
                      borderRadius: 10.r,
                      onTap: () {
                        Get.back(); // Pop create screen
                        Get.back(); // Pop category selector
                        Get.snackbar(
                          "Listing Published",
                          "Your vehicle listing has been published to the marketplace.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xff111111),
                          colorText: Colors.white,
                          borderColor: AppColors.yellow,
                          borderWidth: 1,
                        );
                      },
                    ),
                  ),
                ],
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
}

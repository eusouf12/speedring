import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../components/custom_text_field/custom_text_field.dart';

class BusinessCreateMotorcycleListingScreen extends StatelessWidget {
  const BusinessCreateMotorcycleListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Final Controllers
    final brandController = TextEditingController();
    final modelController = TextEditingController();
    final locationController = TextEditingController();
    final priceController = TextEditingController();

    final powerController = TextEditingController();
    final torqueController = TextEditingController();
    final weightController = TextEditingController();
    final zeroToSixtyController = TextEditingController();

    final displacementController = TextEditingController();
    final suspensionController = TextEditingController();
    final brakesController = TextEditingController();

    final descController = TextEditingController();

    // Reactive states
    final RxString selectedYear = "2024".obs;
    final RxString selectedEngineType = "V4 engine".obs;
    final RxString selectedTransmission = "6-Speed Quickshift".obs;
    final RxList<String> mockMedia = [
      "https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=400&fit=crop",
      "https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=400&fit=crop",
      "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=400&fit=crop",
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
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 01 / Basic Information
              _buildSectionHeader("01 / BASIC INFORMATION"),
              _buildFormCard([
                _buildFieldLabel("BRAND"),
                CustomTextField(
                  textEditingController: brandController,
                  hintText: "e.g., Ducati",
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
                SizedBox(height: 14.h),

                _buildFieldLabel("MODEL"),
                CustomTextField(
                  textEditingController: modelController,
                  hintText: "e.g., Panigale V4 R",
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
                          _buildFieldLabel("YEAR"),
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
                          _buildFieldLabel("LOCATION"),
                          CustomTextField(
                            textEditingController: locationController,
                            hintText: "City, Country",
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

                _buildFieldLabel("ASKING PRICE (USD)"),
                CustomTextField(
                  textEditingController: priceController,
                  hintText: r"$ 0.00",
                  keyboardType: TextInputType.number,
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
              ]),
              SizedBox(height: 20.h),

              // 02 / Performance Data
              _buildSectionHeader("02 / PERFORMANCE DATA"),
              _buildFormCard([
                _buildFieldLabel("ENGINE TYPE"),
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
                        value: selectedEngineType.value,
                        isExpanded: true,
                        dropdownColor: Colors.black,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white60),
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (newValue) {
                          if (newValue != null) selectedEngineType.value = newValue;
                        },
                        items: ["V4 engine", "L-Twin engine", "Parallel-Twin", "Inline-Four"].map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("POWER (HP)"),
                          CustomTextField(
                            textEditingController: powerController,
                            hintText: "240",
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
                          _buildFieldLabel("TORQUE (NM)"),
                          CustomTextField(
                            textEditingController: torqueController,
                            hintText: "112",
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

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("WEIGHT (KG)"),
                          CustomTextField(
                            textEditingController: weightController,
                            hintText: "172",
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
                            hintText: "2.9",
                            fillColor: const Color(0xff111111),
                            fieldBorderColor: Colors.white10,
                            fieldBorderRadius: 10.r,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
              SizedBox(height: 20.h),

              // 03 / Technical Dossier
              _buildSectionHeader("03 / TECHNICAL DOSSIER"),
              _buildFormCard([
                _buildFieldLabel("DISPLACEMENT (CC)"),
                CustomTextField(
                  textEditingController: displacementController,
                  hintText: "998",
                  keyboardType: TextInputType.number,
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
                SizedBox(height: 14.h),

                _buildFieldLabel("TRANSMISSION"),
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
                        value: selectedTransmission.value,
                        isExpanded: true,
                        dropdownColor: Colors.black,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white60),
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (newValue) {
                          if (newValue != null) selectedTransmission.value = newValue;
                        },
                        items: ["6-Speed Quickshift", "6-Speed Manual", "CVT"].map((trans) {
                          return DropdownMenuItem<String>(
                            value: trans,
                            child: Text(trans),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),

                _buildFieldLabel("SUSPENSION"),
                CustomTextField(
                  textEditingController: suspensionController,
                  hintText: "Öhlins NPX 25/30",
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
                SizedBox(height: 14.h),

                _buildFieldLabel("BRAKING SYSTEM"),
                CustomTextField(
                  textEditingController: brakesController,
                  hintText: "Brembo Stylema R",
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
              ]),
              SizedBox(height: 20.h),

              // 04 / Performance Narrative
              _buildSectionHeader("04 / PERFORMANCE NARRATIVE"),
              _buildFormCard([
                _buildFieldLabel("DETAILED DESCRIPTION & PROVENANCE"),
                CustomTextField(
                  textEditingController: descController,
                  hintText: "Describe the vehicle's racing history, maintenance records, and unique modifications...",
                  maxLines: 4,
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
              ]),
              SizedBox(height: 20.h),

              // 05 / Media Assets
              _buildSectionHeader("05 / MEDIA ASSETS"),
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
                  text: "MAX 12 PHOTOS / 1 VIDEO (60S SUPPORTED)",
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
                          "Your motorcycle listing has been published to the marketplace.",
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

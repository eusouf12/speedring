import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../components/custom_text_field/custom_text_field.dart';

class BusinessCreatePartsListingScreen extends StatelessWidget {
  const BusinessCreatePartsListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Final Controllers
    final partNameController = TextEditingController();
    final brandController = TextEditingController();
    final compatibilityController = TextEditingController();

    final weightController = TextEditingController();
    final performanceController = TextEditingController();
    final materialController = TextEditingController();
    final skuController = TextEditingController();

    final provenanceController = TextEditingController();
    final priceController = TextEditingController();

    // Reactive states
    final RxString selectedCategory = "Braking Systems".obs;
    final RxString selectedCondition = "New (Sealed)".obs;
    final RxString selectedShipping = "Flat Rate International".obs;

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
            "CREATE LISTING: PERFORMANCE PARTS",
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
              // 01. Component Details
              _buildSectionHeader("01. COMPONENT DETAILS"),
              _buildFormCard([
                _buildFieldLabel("PART NAME"),
                CustomTextField(
                  textEditingController: partNameController,
                  hintText: "e.g. Brembo GTR 6-Piston Caliper System",
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
                SizedBox(height: 14.h),

                _buildFieldLabel("CATEGORY"),
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
                        value: selectedCategory.value,
                        isExpanded: true,
                        dropdownColor: Colors.black,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white60),
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (newValue) {
                          if (newValue != null) selectedCategory.value = newValue;
                        },
                        items: [
                          "Braking Systems",
                          "Suspension Components",
                          "Engine Components",
                          "Exhaust Systems",
                          "Aero & Bodywork",
                          "Wheels & Tires",
                          "Electronics & ECU",
                          "Other Parts"
                        ].map((cat) {
                          return DropdownMenuItem<String>(
                            value: cat,
                            child: Text(cat),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),

                _buildFieldLabel("BRAND"),
                CustomTextField(
                  textEditingController: brandController,
                  hintText: "e.g. Brembo Racing",
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
                SizedBox(height: 14.h),

                _buildFieldLabel("COMPATIBILITY"),
                CustomTextField(
                  textEditingController: compatibilityController,
                  hintText: "e.g. Porsche 911 (992) GT3",
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
                SizedBox(height: 14.h),

                _buildFieldLabel("CONDITION"),
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
                        value: selectedCondition.value,
                        isExpanded: true,
                        dropdownColor: Colors.black,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white60),
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (newValue) {
                          if (newValue != null) selectedCondition.value = newValue;
                        },
                        items: [
                          "New (Sealed)",
                          "Like New (Opened Box)",
                          "Used (Good Condition)",
                          "Refurbished",
                          "For Parts Only"
                        ].map((cond) {
                          return DropdownMenuItem<String>(
                            value: cond,
                            child: Text(cond),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 20.h),

              // 02. Engineering Data
              _buildSectionHeader("02. ENGINEERING DATA"),
              _buildFormCard([
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("WEIGHT REDUCTION (KG)"),
                          CustomTextField(
                            textEditingController: weightController,
                            hintText: "4.5 KG",
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
                          _buildFieldLabel("PERFORMANCE GAIN"),
                          CustomTextField(
                            textEditingController: performanceController,
                            hintText: "e.g. -15% Braking Distance",
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

                _buildFieldLabel("MATERIAL"),
                CustomTextField(
                  textEditingController: materialController,
                  hintText: "e.g. Carbon-Ceramic Composite",
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
                SizedBox(height: 14.h),

                _buildFieldLabel("PART NUMBER / SKU"),
                CustomTextField(
                  textEditingController: skuController,
                  hintText: "BR-992-GTR-001",
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
              ]),
              SizedBox(height: 20.h),

              // 03. Provenance
              _buildSectionHeader("03. PROVENANCE"),
              _buildFormCard([
                _buildFieldLabel("PART OVERVIEW & HISTORY"),
                CustomTextField(
                  textEditingController: provenanceController,
                  hintText: "Describe the part's history, previous vehicle installation, and usage cycles...",
                  maxLines: 4,
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
              ]),
              SizedBox(height: 20.h),

              // 04. Media Verification
              _buildSectionHeader("04. MEDIA VERIFICATION"),
              _buildFormCard([
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 1.3,
                  children: [
                    Container(
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
                            text: "UPLOAD IMAGE",
                            color: Colors.white60,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=400&fit=crop",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.video_call_outlined, color: AppColors.yellow),
                          SizedBox(height: 6.h),
                          CustomText(
                            text: "ADD VIDEO",
                            color: Colors.white60,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.analytics_outlined, color: AppColors.yellow),
                          SizedBox(height: 6.h),
                          CustomText(
                            text: "DYNO DATA",
                            color: Colors.white60,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
              SizedBox(height: 20.h),

              // 05. Pricing
              _buildSectionHeader("05. PRICING"),
              _buildFormCard([
                _buildFieldLabel("LISTING PRICE"),
                CustomTextField(
                  textEditingController: priceController,
                  hintText: r"$ 0.00",
                  keyboardType: TextInputType.number,
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
                SizedBox(height: 16.h),

                _buildFieldLabel("SHIPPING STRATEGY"),
                Obx(
                  () => RadioGroup<String>(
                    groupValue: selectedShipping.value,
                    onChanged: (val) {
                      if (val != null) selectedShipping.value = val;
                    },
                    child: Column(
                      children: [
                        "Flat Rate International",
                        "Calculate at Checkout",
                        "Local Pickup Only"
                      ].map((strategy) {
                        return RadioListTile<String>(
                          title: CustomText(
                            text: strategy,
                            color: Colors.white,
                            fontSize: 12.sp,
                            textAlign: TextAlign.start,
                          ),
                          value: strategy,
                          activeColor: AppColors.yellow,
                          contentPadding: EdgeInsets.zero,
                        );
                      }).toList(),
                    ),
                  ),
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
                          "Your parts listing has been published to the marketplace.",
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

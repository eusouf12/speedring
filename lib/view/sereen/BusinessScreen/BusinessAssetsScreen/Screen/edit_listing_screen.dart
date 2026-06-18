import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../BusinessHome/Controller/business_dashboard_controller.dart';

class EditListingScreen extends StatelessWidget {
  const EditListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<BusinessDashboardController>()
        ? Get.find<BusinessDashboardController>()
        : Get.put(BusinessDashboardController());

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _buildAppBar(controller),
        body: Obx(() {
          final asset = controller.rxSelectedAsset.value;
          if (asset == null) {
            return const Center(child: Text("NO ASSET SELECTED", style: TextStyle(color: Colors.white60)));
          }
      
          // Determine status tag color
          Color tagColor = AppColors.yellow;
          if (asset.status == "LIVE") {
            tagColor = AppColors.green;
          } else if (asset.status == "RESERVED") {
            tagColor = Colors.orangeAccent;
          } else if (asset.status == "DRAFT") {
            tagColor = Colors.white38;
          } else if (asset.status == "SOLD") {
            tagColor = Colors.redAccent;
          }
      
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Quick Asset Card Preview
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff111111),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          asset.imageUrl,
                          width: 70.w,
                          height: 70.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 70.w,
                            height: 70.w,
                            color: const Color(0xff222222),
                            child: const Icon(Icons.broken_image, color: Colors.white24),
                          ),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(color: tagColor.withValues(alpha: 0.5), width: 1),
                                  ),
                                  child: Text(
                                    asset.status,
                                    style: TextStyle(color: Colors.white, fontSize: 7.sp, fontWeight: FontWeight.w900),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                CustomText(
                                  text: "UID: ${asset.code}",
                                  color: Colors.white38,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            CustomText(
                              text: asset.title,
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
      
                // Phase 01: Core Specifications
                _buildSectionHeader("PHASE 01: CORE SPECIFICATIONS"),
                _buildCardContainer([
                  _buildFieldLabel("Brand / Manufacturer"),
                  _buildTextField(controller.manufacturerController, "Porsche, Ducati, etc."),
                  SizedBox(height: 12.h),
                  _buildFieldLabel("Model Designation"),
                  _buildTextField(controller.modelController, "911 GT3 RS, Panigale V4 R"),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel("Production Year"),
                            _buildTextField(controller.productionYearController, "2024", keyboardType: TextInputType.number),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel(r"Asking Price ($)"),
                            _buildTextField(controller.askingPriceController, "289500", keyboardType: TextInputType.number),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
                SizedBox(height: 20.h),
      
                // Phase 02: Telemetry & Metrics
                _buildSectionHeader("PHASE 02: TELEMETRY & METRICS"),
                _buildCardContainer([
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel("Power Output (HP)"),
                            _buildTextField(controller.powerController, "518 HP"),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel("Torque (NM)"),
                            _buildTextField(controller.torqueController, "465 NM"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  _buildFieldLabel("0-60 MPH (SEC)"),
                  _buildTextField(controller.zeroToSixtyController, "3.0 SEC"),
                ]),
                SizedBox(height: 20.h),
      
                // Phase 03: Engineering Design
                _buildSectionHeader("PHASE 03: ENGINEERING DESIGN"),
                _buildCardContainer([
                  _buildFieldLabel("Engine Configuration"),
                  _buildDropdownDirect(
                    selectedValue: controller.selectedEngineConfig.value,
                    items: ["4.0L Flat-6", "3.8L Flat-6", "998cc V4", "N/A"],
                    onChanged: (val) {
                      if (val != null) controller.selectedEngineConfig.value = val;
                    },
                  ),
                  SizedBox(height: 12.h),
                  _buildFieldLabel("Transmission"),
                  _buildDropdownDirect(
                    selectedValue: controller.selectedTransmission.value,
                    items: ["7-Speed PDK", "6-Speed Manual", "6-Speed Quickshift", "N/A"],
                    onChanged: (val) {
                      if (val != null) controller.selectedTransmission.value = val;
                    },
                  ),
                  SizedBox(height: 12.h),
                  _buildFieldLabel("Drivetrain"),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDrivetrainOption(
                          controller,
                          "RWD",
                          controller.selectedDrivetrain.value == "RWD",
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildDrivetrainOption(
                          controller,
                          "AWD",
                          controller.selectedDrivetrain.value == "AWD",
                        ),
                      ),
                    ],
                  ),
                ]),
                SizedBox(height: 20.h),
      
                // Phase 04: Performance Narrative
                _buildSectionHeader("PHASE 04: PERFORMANCE NARRATIVE"),
                _buildCardContainer([
                  _buildFieldLabel("Listing Description"),
                  _buildTextField(controller.descriptionController, "Description...", maxLines: 4),
                ]),
                SizedBox(height: 20.h),
      
                // Phase 05: Visual Assets
                _buildSectionHeader("PHASE 05: VISUAL ASSETS"),
                _buildCardContainer([
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildImagePreview(asset.imageUrl),
                        SizedBox(width: 10.w),
                        _buildVideoPreview(asset.imageUrl),
                        SizedBox(width: 10.w),
                        _buildAddMediaTile(),
                      ],
                    ),
                  ),
                ]),
                SizedBox(height: 32.h),
      
                // Save & Discard Action Buttons
                GestureDetector(
                  onTap: () {
                    controller.saveAssetChanges();
                    Get.back();
                    Get.snackbar(
                      "Changes Saved",
                      "Asset details updated successfully.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: const Color(0xff181818),
                      colorText: Colors.white,
                      borderColor: AppColors.yellow,
                      borderWidth: 1,
                    );
                  },
                  child: Container(
                    height: 48.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: CustomText(
                        text: "SAVE CHANGES",
                        color: Colors.black,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 48.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xff222222),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Center(
                      child: CustomText(
                        text: "DISCARD",
                        color: Colors.white70,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  AppBar _buildAppBar(BusinessDashboardController controller) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        "EDIT LISTING",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.check, color: AppColors.yellow),
          onPressed: () {
            controller.saveAssetChanges();
            Get.back();
            Get.snackbar(
              "Changes Saved",
              "Asset details updated successfully.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xff181818),
              colorText: Colors.white,
              borderColor: AppColors.yellow,
              borderWidth: 1,
            );
          },
        ),
        SizedBox(width: 8.w),
      ],
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

  Widget _buildTextField(TextEditingController textController, String hint, {int maxLines = 1, TextInputType? keyboardType}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextFormField(
        controller: textController,
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

  Widget _buildDropdownDirect({
    required String selectedValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(selectedValue) ? selectedValue : items.first,
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

  Widget _buildDrivetrainOption(BusinessDashboardController controller, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        controller.selectedDrivetrain.value = label;
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
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
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
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xff222222),
                child: const Icon(Icons.broken_image, color: Colors.white24, size: 20),
              ),
            ),
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
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Opacity(
              opacity: 0.6,
              child: Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xff222222),
                  child: const Icon(Icons.broken_image, color: Colors.white24, size: 20),
                ),
              ),
            ),
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

  Widget _buildAddMediaTile() {
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
}

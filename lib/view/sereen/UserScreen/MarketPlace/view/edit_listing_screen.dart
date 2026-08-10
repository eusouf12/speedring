import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_button/custom_button.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../controller/marketpace_controller.dart';
import 'dart:io';

class EditListingScreen extends StatelessWidget {
  final String listingId;
  final String itemType;

  const EditListingScreen({
    super.key,
    required this.listingId,
    required this.itemType,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MarketplaceFeedController>();

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: const SizedBox.shrink(),
          title: const Text(
            "EDIT LISTING",
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.yellow),
              onPressed: () => Get.back(),
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 01 / BASIC IDENTIFICATION
              _buildPhaseHeader("01 / BASIC IDENTIFICATION"),
              _buildSectionCard([
                _buildFieldLabel("MANUFACTURER / BRAND"),
                _buildOutlineIconField(
                  controller.brandController,
                  Icons.motorcycle_outlined,
                  "e.g. Ducati",
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel("MODEL NAME"),
                _buildOutlineField(controller.modelDesignationController, "e.g. Panigale V4 S"),
                SizedBox(height: 14.h),
                _buildFieldLabel("PRODUCTION YEAR"),
                _buildOutlineIconField(
                  controller.productionYearController,
                  Icons.calendar_today_outlined,
                  "2024",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel("ASKING PRICE (USD)"),
                _buildOutlineIconField(
                  controller.askingPriceController,
                  Icons.payments_outlined,
                  "32,000",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel("VEHICLE LOCATION"),
                _buildOutlineIconField(
                  controller.locationController,
                  Icons.location_on_outlined,
                  "City, State, Country",
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel("DESCRIPTION"),
                _buildOutlineField(
                  controller.descriptionController,
                  "Details about the motorcycle",
                ),
              ]),
              SizedBox(height: 24.h),

              // 02 / PERFORMANCE METRICS
              _buildPhaseHeader("02 / PERFORMANCE METRICS"),
              _buildSectionCard([
                _buildFieldLabel("ENGINE TYPE"),
                _buildOutlineField(
                  controller.engineTypeController,
                  "e.g. Desmosedici Stradale 90° V4",
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel("MAX OUTPUT (HP)"),
                _buildOutlineIconField(
                  controller.powerHpController,
                  Icons.bolt_outlined,
                  "215",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel("DISPLACEMENT (CC)"),
                _buildOutlineIconField(
                  controller.displacementCcController,
                  Icons.speed_outlined,
                  "1103",
                  keyboardType: TextInputType.number,
                ),
              ]),
              SizedBox(height: 24.h),

              // 03 / MEDIA ASSETS
              _buildPhaseHeader("03 / MEDIA ASSETS"),
              _buildSectionCard([
                GestureDetector(
                  onTap: controller.pickImages,
                  child: Container(
                    height: 140.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_a_photo_outlined,
                            color: AppColors.yellow,
                            size: 24,
                          ),
                          SizedBox(height: 6.h),
                          CustomText(
                            text: "ADD IMAGES",
                            color: Colors.white60,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                Obx(() => Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: List.generate(controller.selectedImages.length, (index) {
                    return Stack(
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            image: DecorationImage(
                              image: FileImage(File(controller.selectedImages[index].path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () => controller.removeImage(index),
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 12),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                )),
              ]),
              SizedBox(height: 32.h),

              // Bottom Actions
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.cancel_outlined,
                            color: Colors.white60,
                            size: 16,
                          ),
                          SizedBox(width: 6.w),
                          CustomText(
                            text: "CANCEL",
                            color: Colors.white60,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    flex: 3,
                    child: Obx(() => CustomButton(
                      height: 44.h,
                      title: controller.isEditing.value ? "SAVING..." : "SAVE CHANGES",
                      fontSize: 11.sp,
                      fillColor: AppColors.yellow,
                      textColor: Colors.black,
                      borderRadius: 8.r,
                      isImageRight: true,
                      icon: controller.isEditing.value 
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                          : const Icon(
                        Icons.save_rounded,
                        color: Colors.black,
                        size: 16,
                      ),
                      onTap: () {
                        if (controller.isEditing.value) return;
                        controller.editListing(listingId, itemType);
                      },
                    )),
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

  Widget _buildPhaseHeader(String title) {
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

  Widget _buildSectionCard(List<Widget> children) {
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

  Widget _buildOutlineField(TextEditingController textController, String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff0d0d0d),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: TextFormField(
        controller: textController,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.white24,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildOutlineIconField(
    TextEditingController textController,
    IconData icon,
    String hint, {
    TextInputType? keyboardType,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff0d0d0d),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 16),
          SizedBox(width: 8.w),
          Expanded(
            child: TextFormField(
              controller: textController,
              keyboardType: keyboardType,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Colors.white24,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

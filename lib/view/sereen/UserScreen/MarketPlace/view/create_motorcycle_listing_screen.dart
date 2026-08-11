import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_button/custom_button.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../controller/marketpace_controller.dart';
import 'dart:io';

class CreateMotorcycleListingScreen extends StatelessWidget {
  const CreateMotorcycleListingScreen({super.key});

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
          title: Text(
            'createListingMotorcycles'.tr,
            style: const TextStyle(
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
              _buildPhaseHeader('phase01BasicId'.tr),
              _buildSectionCard([
                _buildFieldLabel('manufacturerBrand'.tr),
                _buildOutlineIconField(
                  controller.brandController,
                  Icons.motorcycle_outlined,
                  'egDucati'.tr,
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel('modelName'.tr),
                _buildOutlineField(
                  controller.modelDesignationController,
                  'egPanigaleV4S'.tr,
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel('productionYear'.tr),
                _buildOutlineIconField(
                  controller.productionYearController,
                  Icons.calendar_today_outlined,
                  "2024",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel('askingPriceUsd'.tr),
                _buildOutlineIconField(
                  controller.askingPriceController,
                  Icons.payments_outlined,
                  "32,000",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel('vehicleLocation'.tr),
                _buildOutlineIconField(
                  controller.locationController,
                  Icons.location_on_outlined,
                  'cityStateCountry'.tr,
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel('descriptionUpper'.tr),
                _buildOutlineField(
                  controller.descriptionController,
                  'detailsAboutMotorcycle'.tr,
                  maxLines: 4,
                ),
              ]),
              SizedBox(height: 24.h),

              // 02 / PERFORMANCE METRICS
              _buildPhaseHeader('phase02PerfMetrics'.tr),
              _buildSectionCard([
                _buildFieldLabel('engineType'.tr),
                _buildOutlineField(
                  controller.engineTypeController,
                  'egDesmosedici'.tr,
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel('maxOutputHp'.tr),
                _buildOutlineIconField(
                  controller.powerHpController,
                  Icons.bolt_outlined,
                  "215",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel('displacementCc'.tr),
                _buildOutlineIconField(
                  controller.displacementCcController,
                  Icons.speed_outlined,
                  "1103",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel('torqueNm'.tr),
                _buildOutlineIconField(
                  controller.torqueNmController,
                  Icons.speed_outlined,
                  "123",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel('weightKg'.tr),
                _buildOutlineIconField(
                  controller.weightKgController,
                  Icons.fitness_center_outlined,
                  "195",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel('zeroToHundredSec'.tr),
                _buildOutlineIconField(
                  controller.zeroToHundredController,
                  Icons.timer_outlined,
                  "3.0",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel('transmissionUpper'.tr),
                _buildOutlineField(
                  controller.transmissionController,
                  'eg6Speed'.tr,
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel('suspensionUpper'.tr),
                _buildOutlineField(
                  controller.suspensionController,
                  'egOhlins'.tr,
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel('brakingSystem'.tr),
                _buildOutlineField(
                  controller.brakingSystemController,
                  'egBrembo'.tr,
                ),
              ]),
              SizedBox(height: 24.h),

              // 03 / MEDIA ASSETS
              _buildPhaseHeader('phase03MediaAssets'.tr),
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
                            text: 'addImages'.tr,
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

                Obx(
                  () => Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: List.generate(controller.selectedImages.length, (
                      index,
                    ) {
                      return Stack(
                        children: [
                          Container(
                            width: 60.w,
                            height: 60.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              image: DecorationImage(
                                image: FileImage(
                                  File(controller.selectedImages[index].path),
                                ),
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
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ]),
              SizedBox(height: 32.h),

              // Bottom Actions
              Obx(
                () => CustomButton(
                  height: 44.h,
                  title: controller.isCreating.value
                      ? 'publishing'.tr
                      : 'publishListing'.tr,
                  fontSize: 11.sp,
                  fillColor: AppColors.yellow,
                  textColor: Colors.black,
                  borderRadius: 8.r,
                  isImageRight: true,
                  icon: controller.isCreating.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.publish_rounded,
                          color: Colors.black,
                          size: 16,
                        ),
                  onTap: () {
                    if (controller.isCreating.value) return;
                    controller.createListing('MOTORCYCLES');
                  },
                ),
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

  Widget _buildOutlineField(
    TextEditingController textController,
    String hint, {
    int maxLines = 1,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff0d0d0d),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: TextFormField(
        controller: textController,
        keyboardType: maxLines > 1 ? TextInputType.multiline : null,
        maxLines: maxLines,
        minLines: 1,
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
              inputFormatters: keyboardType == TextInputType.number
                  ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
                  : null,
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

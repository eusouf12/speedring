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

class CreateVehicleListingScreen extends StatelessWidget {
  const CreateVehicleListingScreen({super.key});

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
            'createListingVehicles'.tr,
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
              // Basic Specifications Section
              _buildSectionHeader(
                'basicSpecifications'.tr,
                'coreIdentityParamsDesc'.tr,
              ),
              SizedBox(height: 12.h),
              _buildFormCard([
                _buildFieldLabel('brandManufacturer'.tr),
                _buildWhiteTextField(
                  'egPorsche'.tr,
                  controller: controller.brandController,
                ),
                SizedBox(height: 16.h),
                _buildFieldLabel('modelVariant'.tr),
                _buildWhiteTextField(
                  'eg911Gt3Rs'.tr,
                  controller: controller.modelDesignationController,
                ),
                SizedBox(height: 16.h),
                _buildFieldLabel('productionYear'.tr),
                _buildWhiteTextField(
                  "2024",
                  keyboardType: TextInputType.number,
                  controller: controller.productionYearController,
                ),
                SizedBox(height: 16.h),
                _buildFieldLabel('listingPriceUsd'.tr),
                _buildWhitePriceField(
                  "0.00",
                  controller: controller.askingPriceController,
                ),
                SizedBox(height: 16.h),
                _buildFieldLabel('locationDepot'.tr),
                _buildWhiteLocationField(
                  'cityCountry'.tr,
                  controller: controller.locationController,
                ),
              ]),
              SizedBox(height: 28.h),

              _buildFieldLabel('descriptionUpper'.tr),
              _buildWhiteTextField(
                'detailsAboutVehicle'.tr,
                controller: controller.descriptionController,
                maxLines: 4,
              ),
              SizedBox(height: 28.h),

              // Performance Telemetry Section
              _buildSectionHeader(
                'performanceTelemetry'.tr,
                'precisionEngDataDesc'.tr,
              ),
              SizedBox(height: 12.h),
              _buildTelemetryCard(controller),
              SizedBox(height: 28.h),

              // Media Assets Section
              _buildSectionHeader(
                'mediaAssets'.tr,
                'highFidelityImageryDesc'.tr,
              ),
              SizedBox(height: 12.h),
              _buildMediaAssetsCard(controller),
              SizedBox(height: 32.h),

              // Actions Bottom Bar
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
                    controller.createListing('VEHICLES');
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

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w900,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: subtitle,
          color: Colors.white38,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 6.h),
        Container(height: 2.h, width: 40.w, color: AppColors.yellow),
      ],
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
        color: Colors.white60,
        fontSize: 9.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildWhiteTextField(
    String hint, {
    TextInputType? keyboardType,
    TextEditingController? controller,
    int maxLines = 1,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: maxLines > 1 ? TextInputType.multiline : keyboardType,
        maxLines: maxLines,
        minLines: 1,
        inputFormatters: keyboardType == TextInputType.number
            ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
            : null,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.black38,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildWhitePriceField(
    String hint, {
    TextEditingController? controller,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          const Text(
            "\$ ",
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Colors.black38,
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

  Widget _buildWhiteLocationField(
    String hint, {
    TextEditingController? controller,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: Colors.black38,
            size: 16,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Colors.black38,
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

  Widget _buildTelemetryCard(MarketplaceFeedController controller) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          _buildTelemetryRow('powerOutputHp'.tr, controller.powerHpController),
          SizedBox(height: 12.h),
          _buildTelemetryRow(
            'zeroToHundredSec'.tr,
            controller.zeroToHundredController,
            hint: "0.0",
          ),
          SizedBox(height: 12.h),
          _buildTelemetryRow('topSpeedKmh'.tr, controller.topSpeedController),
          SizedBox(height: 12.h),
          _buildTelemetryRow('weightKg'.tr, controller.weightKgController),
          SizedBox(height: 12.h),
          _buildTelemetryRow('mileageKm'.tr, controller.mileageKmController),
        ],
      ),
    );
  }

  Widget _buildTelemetryRow(
    String label,
    TextEditingController? controller, {
    String hint = "000",
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          color: Colors.white38,
          fontSize: 9.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        Container(
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              fontFamily: 'Courier',
              letterSpacing: 1.5,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white24),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaAssetsCard(MarketplaceFeedController controller) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: controller.pickImages,
            child: Container(
              height: 120.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.white10,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_a_photo_outlined,
                    color: AppColors.yellow,
                    size: 28,
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    text: 'addImages'.tr,
                    color: Colors.white60,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
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
        ],
      ),
    );
  }
}

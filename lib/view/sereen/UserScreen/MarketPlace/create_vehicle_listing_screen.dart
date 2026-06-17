import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';

class CreateVehicleListingScreen extends StatelessWidget {
  const CreateVehicleListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: const SizedBox.shrink(),
          title: const Text(
            "CREATE LISTING: VEHICLES",
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
              // Basic Specifications Section
              _buildSectionHeader("BASIC SPECIFICATIONS", "Core identity parameters for the vehicle record."),
              SizedBox(height: 12.h),
              _buildFormCard([
                _buildFieldLabel("BRAND / MANUFACTURER"),
                _buildWhiteTextField("e.g. Porsche"),
                SizedBox(height: 16.h),
                _buildFieldLabel("MODEL VARIANT"),
                _buildWhiteTextField("e.g. 911 GT3 RS"),
                SizedBox(height: 16.h),
                _buildFieldLabel("PRODUCTION YEAR"),
                _buildWhiteTextField("2024", keyboardType: TextInputType.number),
                SizedBox(height: 16.h),
                _buildFieldLabel("LISTING PRICE (USD)"),
                _buildWhitePriceField("0.00"),
                SizedBox(height: 16.h),
                _buildFieldLabel("LOCATION / DEPOT"),
                _buildWhiteLocationField("City, Country"),
              ]),
              SizedBox(height: 28.h),

              // Performance Telemetry Section
              _buildSectionHeader("PERFORMANCE TELEMETRY", "Precision engineering data points for verified enthusiasts."),
              SizedBox(height: 12.h),
              _buildTelemetryCard(),
              SizedBox(height: 28.h),

              // Media Assets Section
              _buildSectionHeader("MEDIA ASSETS", "High-fidelity imagery and kinematic content."),
              SizedBox(height: 12.h),
              _buildMediaAssetsCard(),
              SizedBox(height: 32.h),

              // Actions Bottom Bar
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cancel_outlined, color: Colors.white60, size: 16),
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
                    child: CustomButton(
                      height: 44.h,
                      title: "PUBLISH LISTING",
                      fontSize: 11.sp,
                      fillColor: AppColors.yellow,
                      textColor: Colors.black,
                      borderRadius: 8.r,
                      isImageRight: true,
                      icon: const Icon(Icons.publish_rounded, color: Colors.black, size: 16),
                      onTap: () {
                        // Navigate to asset configuration flow
                        Get.toNamed(AppRoutes.configureAssetScreen);
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
        Container(
          height: 2.h,
          width: 40.w,
          color: AppColors.yellow,
        ),
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

  Widget _buildWhiteTextField(String hint, {TextInputType? keyboardType}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 13, fontWeight: FontWeight.bold),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildWhitePriceField(String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          const Text("\$ ", style: TextStyle(color: AppColors.yellow, fontSize: 13, fontWeight: FontWeight.bold)),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.black38, fontSize: 13, fontWeight: FontWeight.bold),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteLocationField(String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: Colors.black38, size: 16),
          SizedBox(width: 8.w),
          Expanded(
            child: TextFormField(
              style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.black38, fontSize: 13, fontWeight: FontWeight.bold),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          _buildTelemetryRow("POWER OUTPUT (HP)", "000"),
          SizedBox(height: 12.h),
          _buildTelemetryRow("0-100 KM/H (SEC)", "0.0"),
          SizedBox(height: 12.h),
          _buildTelemetryRow("TOP SPEED (KM/H)", "000"),
        ],
      ),
    );
  }

  Widget _buildTelemetryRow(String label, String value) {
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
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: const Color(0xff4A5260),
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              fontFamily: 'Courier', // Monospace digital-like font
              letterSpacing: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaAssetsCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          // Main studio image box
          Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.white10, style: BorderStyle.solid),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_a_photo_outlined, color: AppColors.yellow, size: 28),
                SizedBox(height: 8.h),
                CustomText(
                  text: "MAIN STUDIO SHOT",
                  color: Colors.white60,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Upload tiles row
          Row(
            children: [
              Expanded(child: _buildSmallMediaUploadTile("INTERIOR")),
              SizedBox(width: 8.w),
              Expanded(child: _buildSmallMediaUploadTile("REAR VIEW")),
              SizedBox(width: 8.w),
              Expanded(child: _buildSmallMediaUploadTile("ENGINE")),
              SizedBox(width: 8.w),
              Expanded(child: _buildSmallMediaUploadTile("VIDEO REEL")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallMediaUploadTile(String label) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.upload_file_outlined, color: Colors.white24, size: 16),
          SizedBox(height: 4.h),
          CustomText(
            text: label,
            color: Colors.white38,
            fontSize: 7.sp,
            fontWeight: FontWeight.bold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

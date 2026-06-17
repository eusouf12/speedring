import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';

class BusinessCreateSessionPostScreen extends StatefulWidget {
  const BusinessCreateSessionPostScreen({super.key});

  @override
  State<BusinessCreateSessionPostScreen> createState() => _BusinessCreateSessionPostScreenState();
}

class _BusinessCreateSessionPostScreenState extends State<BusinessCreateSessionPostScreen> {
  final trackNameController = TextEditingController(text: "Grand Prix Loop");
  final lapTimeController = TextEditingController(text: "01:28.442");
  final summaryController = TextEditingController(
    text: "Perfect morning session. The SF90 felt incredibly planted through Maggotts and Becketts. Optimized tire pressures to 1.8 bar cold. Track surface was green but gripping up well by lap 12."
  );

  String selectedVehicle = "Ferrari SF90 Stradale";
  String selectedCircuit = "Silverstone Circuit";
  String topSpeed = "342";

  @override
  void dispose() {
    trackNameController.dispose();
    lapTimeController.dispose();
    summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "CREATE SESSION",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: _onPublish,
              child: const Text(
                "PUBLISH",
                style: TextStyle(color: AppColors.yellow, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Media container
              _buildAddMediaSection(),
              SizedBox(height: 16.h),

              // Selectors
              _buildSelectorCard("VEHICLE", selectedVehicle, Icons.directions_car_outlined),
              SizedBox(height: 12.h),
              _buildSelectorCard("CIRCUIT", selectedCircuit, Icons.location_on_outlined),
              SizedBox(height: 16.h),

              // Inputs
              _buildFieldCard([
                _buildFieldLabel("TRACK NAME"),
                _buildOutlineField(trackNameController, "Grand Prix Loop"),
                SizedBox(height: 14.h),
                _buildFieldLabel("BEST LAP TIME"),
                _buildOutlineIconField(lapTimeController, Icons.timer_outlined, "01:28.442"),
              ]),
              SizedBox(height: 16.h),

              // Top speed achieved
              _buildTopSpeedCard(),
              SizedBox(height: 16.h),

              // Summary
              _buildFieldCard([
                _buildFieldLabel("DRIVER SESSION SUMMARY"),
                _buildSummaryTextArea(),
              ]),
              SizedBox(height: 16.h),

              // Live Telemetry
              _buildLiveTelemetryCard(),
              SizedBox(height: 16.h),

              // Add Music, Location actions
              Row(
                children: [
                  Expanded(child: _buildActionButton(Icons.music_note_outlined, "ADD MUSIC")),
                  SizedBox(width: 12.w),
                  Expanded(child: _buildActionButton(Icons.location_on_outlined, "LOCATION")),
                ],
              ),
              SizedBox(height: 24.h),

              // Feed Preview section
              CustomText(
                text: "FEED PREVIEW",
                color: Colors.white38,
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 12.h),
              _buildFeedPreviewCard(),
              SizedBox(height: 32.h),

              // Action button
              CustomButton(
                height: 46.h,
                title: "PUBLISH SESSION",
                fillColor: AppColors.yellow,
                textColor: Colors.black,
                borderRadius: 8.r,
                onTap: _onPublish,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddMediaSection() {
    return Container(
      height: 150.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Stack(
        children: [
          // Faded F1 car image mock
          Opacity(
            opacity: 0.15,
            child: Image.network(
              "https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?w=800&fit=crop",
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: Colors.black),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: const BoxDecoration(
                    color: AppColors.yellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_a_photo_outlined, color: Colors.black),
                ),
                SizedBox(height: 8.h),
                CustomText(
                  text: "ADD MEDIA",
                  color: Colors.white60,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorCard(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 18.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: label,
                  color: Colors.white38,
                  fontSize: 7.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text: value,
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 14),
        ],
      ),
    );
  }

  Widget _buildFieldCard(List<Widget> children) {
    return Container(
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
        fontSize: 8.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildOutlineField(TextEditingController controller, String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildOutlineIconField(TextEditingController controller, IconData icon, String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
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

  Widget _buildTopSpeedCard() {
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
          CustomText(
            text: "TOP SPEED ACHIEVED",
            color: Colors.white38,
            fontSize: 7.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                topSpeed,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Courier',
                ),
              ),
              SizedBox(width: 8.w),
              CustomText(
                text: "KM/H",
                color: Colors.white38,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTextArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: TextFormField(
        controller: summaryController,
        maxLines: 4,
        style: const TextStyle(color: Colors.white, fontSize: 12),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Enter your track session summary...",
          hintStyle: TextStyle(color: Colors.white24, fontSize: 12),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildLiveTelemetryCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "LIVE TELEMETRY",
                color: AppColors.yellow,
                fontSize: 8.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
              Row(
                children: [
                  Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: const BoxDecoration(color: AppColors.yellow, shape: BoxShape.circle),
                  ),
                  SizedBox(width: 4.w),
                  Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                  ),
                ],
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 24),
          _buildTelemetryRow(Icons.playlist_add_check_rounded, "Total Laps", "18"),
          SizedBox(height: 10.h),
          _buildTelemetryRow(Icons.speed_outlined, "Avg Speed", "214 KM/H"),
          SizedBox(height: 10.h),
          _buildTelemetryRow(Icons.thermostat_outlined, "Track Temp", "28°C"),
        ],
      ),
    );
  }

  Widget _buildTelemetryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white38, size: 16.sp),
        SizedBox(width: 10.w),
        CustomText(
          text: label,
          color: Colors.white70,
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
        ),
        const Spacer(),
        CustomText(
          text: value,
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w900,
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.yellow, size: 14.sp),
          SizedBox(width: 6.w),
          CustomText(
            text: label,
            color: Colors.white70,
            fontSize: 9.sp,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedPreviewCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xff222222),
                radius: 12.r,
                child: const Icon(Icons.person, color: Colors.white, size: 12),
              ),
              SizedBox(width: 8.w),
              CustomText(
                text: "CHASE_PERFORMANCE",
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Main image
          Container(
            height: 110.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              image: const DecorationImage(
                image: NetworkImage("https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=800&fit=crop"),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.all(8.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined, color: AppColors.yellow, size: 10),
                  SizedBox(width: 4.w),
                  Text(
                    "01:28.442",
                    style: TextStyle(color: Colors.white, fontSize: 8.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // Caption
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "CHASE_PERFORMANCE ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 9.sp,
                    fontFamily: 'Barlow Condensed',
                  ),
                ),
                TextSpan(
                  text: summaryController.text,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 9.sp,
                    fontFamily: 'Barlow Condensed',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onPublish() {
    Get.back(); // Pop create session screen
    Get.back(); // Pop choices screen
    Get.snackbar(
      "Session Published",
      "Lap session added to active social feed.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff181818),
      colorText: Colors.white,
      borderColor: AppColors.yellow,
      borderWidth: 1,
    );
  }
}

import 'dart:ui';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:speedring/service/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';

import '../../../../../utils/app_colors/app_colors.dart';

// ── Dashed Border Painter for Document Uploads ──────────────────────────────
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  DashedBorderPainter({
    this.color = Colors.white24,
    this.strokeWidth = 1,
    this.gap = 4,
    this.dashLength = 6,
    this.borderRadius = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    final dashPath = _buildDashedPath(path, dashLength, gap);
    canvas.drawPath(dashPath, paint);
  }

  Path _buildDashedPath(Path source, double dashLength, double gap) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double len = draw ? dashLength : gap;
        final double end = (distance + len).clamp(0.0, metric.length);
        if (draw) {
          dest.addPath(metric.extractPath(distance, end), Offset.zero);
        }
        distance = end;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── GetX Business Registration Controller ────────────────────────────────────
class BusinessRegistrationController extends GetxController {
  // Step 1: Identity fields
  final step1FormKey = GlobalKey<FormState>();
  final businessNameCtrl = TextEditingController();
  final ownerRepCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final category = "".obs;
  final websiteCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final RxBool isPasswordVisible = false.obs;

  // Step 2: Verification fields
  final vatNumberCtrl = TextEditingController();
  final RxString businessLicenseName = "".obs;
  final RxBool isLicenseUploading = false.obs;

  final RxString tradeRegName = "".obs;
  final RxBool isTradeRegUploading = false.obs;

  final RxString logoFileName = "".obs;
  final RxBool isLogoUploading = false.obs;

  // Step 3: Setup public identity
  final RxString bannerFileName = "".obs;
  final RxBool isBannerUploading = false.obs;

  final RxString brandLogoName = "".obs;
  final RxBool isBrandLogoUploading = false.obs;

  final philosophyCtrl = TextEditingController();
  final hqCtrl = TextEditingController();
  final hqFocusNode = FocusNode();
  final commCtrl = TextEditingController();
  final digitalHqCtrl = TextEditingController();
  final RxString startTime = "08:00".obs;
  final RxString endTime = "18:00".obs;
  final RxString selectedDays = "Mon-Fri".obs;
  final RxString scheduleText = "Configure Schedule".obs;

  final instagramCtrl = TextEditingController();
  final youtubeCtrl = TextEditingController();
  final tiktokCtrl = TextEditingController();
  final facebookCtrl = TextEditingController();

  // Step 4: Asset Class selection
  final RxList<int> selectedAssetClasses = <int>[].obs;

  // File Upload Handlers
  Future<void> uploadLicense() async {
    isLicenseUploading.value = true;
    try {
      FilePickerResult? result = await FilePicker.pickFiles();
      if (result != null) {
        businessLicenseName.value = result.files.single.path ?? "";
      }
    } finally {
      isLicenseUploading.value = false;
    }
  }

  Future<void> uploadTradeReg() async {
    isTradeRegUploading.value = true;
    try {
      FilePickerResult? result = await FilePicker.pickFiles();
      if (result != null) {
        tradeRegName.value = result.files.single.path ?? "";
      }
    } finally {
      isTradeRegUploading.value = false;
    }
  }

  Future<void> uploadLogo() async {
    isLogoUploading.value = true;
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        logoFileName.value = result.files.single.path ?? "";
      }
    } finally {
      isLogoUploading.value = false;
    }
  }

  Future<void> uploadBanner() async {
    isBannerUploading.value = true;
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        bannerFileName.value = result.files.single.path ?? "";
      }
    } finally {
      isBannerUploading.value = false;
    }
  }

  Future<void> uploadBrandLogo() async {
    isBrandLogoUploading.value = true;
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        brandLogoName.value = result.files.single.path ?? "";
      }
    } finally {
      isBrandLogoUploading.value = false;
    }
  }

  void configureSchedule() {
    final context = Get.context!;
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 20.r,
          right: 20.r,
          top: 20.r,
          bottom: 20.r + MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff111111),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          border: Border.all(color: Colors.white10),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              CustomText(
                text: "Configure Operational Hours",
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 20.h),
              CustomText(
                text: "Select Working Days",
                color: Colors.white60,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8.h),
              Obx(
                () => Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: ["Mon-Fri", "Mon-Sat", "Mon-Sun", "Sat-Sun"].map((
                    dayOpt,
                  ) {
                    final isSel = selectedDays.value == dayOpt;
                    return GestureDetector(
                      onTap: () => selectedDays.value = dayOpt,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.yellow : Colors.white10,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: CustomText(
                          text: dayOpt,
                          color: isSel ? Colors.black : Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Start Time",
                          color: Colors.white60,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: const TimeOfDay(hour: 8, minute: 0),
                              builder: (context, child) => Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: AppColors.yellow,
                                    onPrimary: Colors.black,
                                    surface: Color(0xff1c1c1c),
                                    onSurface: Colors.white,
                                  ),
                                ),
                                child: child!,
                              ),
                            );
                            if (picked != null) {
                              final hr = picked.hour.toString().padLeft(2, '0');
                              final min = picked.minute.toString().padLeft(
                                2,
                                '0',
                              );
                              startTime.value = "$hr:$min";
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Obx(
                              () => CustomText(
                                text: startTime.value,
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "End Time",
                          color: Colors.white60,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: const TimeOfDay(hour: 18, minute: 0),
                              builder: (context, child) => Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: AppColors.yellow,
                                    onPrimary: Colors.black,
                                    surface: Color(0xff1c1c1c),
                                    onSurface: Colors.white,
                                  ),
                                ),
                                child: child!,
                              ),
                            );
                            if (picked != null) {
                              final hr = picked.hour.toString().padLeft(2, '0');
                              final min = picked.minute.toString().padLeft(
                                2,
                                '0',
                              );
                              endTime.value = "$hr:$min";
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Obx(
                              () => CustomText(
                                text: endTime.value,
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: () {
                    scheduleText.value =
                        "${selectedDays.value}, ${startTime.value} - ${endTime.value}";
                    Get.back();
                  },
                  child: CustomText(
                    text: "Save Hours",
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<List<String>> getPlaceSuggestions(String query) async {
    if (query.isEmpty) return [];
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=${ApiUrl.mapKey}',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          return (data['predictions'] as List)
              .map((p) => p['description'] as String)
              .toList();
        }
      }
    } catch (e) {
      debugPrint("Error fetching location suggestions: $e");
    }
    return [];
  }

  final RxBool isLoading = false.obs;

  void clearAllFields() {
    businessNameCtrl.clear();
    ownerRepCtrl.clear();
    emailCtrl.clear();
    contactCtrl.clear();
    category.value = "";
    websiteCtrl.clear();
    passwordCtrl.clear();
    vatNumberCtrl.clear();
    philosophyCtrl.clear();
    hqCtrl.clear();
    commCtrl.clear();
    digitalHqCtrl.clear();
    instagramCtrl.clear();
    youtubeCtrl.clear();
    tiktokCtrl.clear();
    facebookCtrl.clear();
    scheduleText.value = "Configure Schedule";
    businessLicenseName.value = "";
    tradeRegName.value = "";
    logoFileName.value = "";
    bannerFileName.value = "";
    brandLogoName.value = "";
    selectedAssetClasses.clear();
  }

  Future<void> registerBusiness() async {
    if (businessNameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        passwordCtrl.text.isEmpty) {
      showCustomSnackBar("Please fill required fields", isError: true);
      return;
    }

    isLoading.value = true;

    Map<String, String> body = {
      'businessName': businessNameCtrl.text.trim(),
      'name': ownerRepCtrl.text.trim(),
      'email': emailCtrl.text.trim(),
      'phone': contactCtrl.text.trim(),
      'businessCategory': category.value,
      'digitalPresence': websiteCtrl.text.trim(),
      'password': passwordCtrl.text,
      'vatNumber': vatNumberCtrl.text.trim(),
      'engineeringPhilosophy': philosophyCtrl.text.trim(),
      'physicalHQ': hqCtrl.text.trim(),
      'communicationLine': commCtrl.text.trim(),
      'digitalHQ': digitalHqCtrl.text.trim(),
      'operationalHours': scheduleText.value,
      'assetInitialization': selectedAssetClasses.join(','),
      'instagram': instagramCtrl.text.trim(),
      'youtube': youtubeCtrl.text.trim(),
      'tiktok': tiktokCtrl.text.trim(),
      'facebook': facebookCtrl.text.trim(),
    };

    List<MultipartBody> files = [];
    if (businessLicenseName.value.isNotEmpty) {
      files.add(
        MultipartBody('businessLicense', File(businessLicenseName.value)),
      );
    }
    if (tradeRegName.value.isNotEmpty) {
      files.add(MultipartBody('tradeRegistration', File(tradeRegName.value)));
    }
    if (logoFileName.value.isNotEmpty) {
      files.add(MultipartBody('businessLogo', File(logoFileName.value)));
    }
    if (bannerFileName.value.isNotEmpty) {
      files.add(MultipartBody('businessBanner', File(bannerFileName.value)));
    }
    if (brandLogoName.value.isNotEmpty) {
      files.add(MultipartBody('officialLogo', File(brandLogoName.value)));
    }

    try {
      var response = await ApiClient.postMultipartData(
        ApiUrl.registerBusiness,
        body,
        multipartBody: files,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);
        showCustomSnackBar(
          jsonResponse['message'] ?? "Business account created",
          isError: false,
        );

        // Clear all fields so they are empty if the user registers again
        clearAllFields();

        // Clear the route stack and go to login
        Get.offAllNamed(AppRoutes.loginScreen);
      } else {
        var errorResponse = jsonDecode(response.body);
        showCustomSnackBar(
          errorResponse['message'] ?? "Registration failed",
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar("Something went wrong", isError: true);
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    businessNameCtrl.dispose();
    ownerRepCtrl.dispose();
    emailCtrl.dispose();
    contactCtrl.dispose();
    websiteCtrl.dispose();
    passwordCtrl.dispose();
    vatNumberCtrl.dispose();
    philosophyCtrl.dispose();
    hqCtrl.dispose();
    hqFocusNode.dispose();
    commCtrl.dispose();
    digitalHqCtrl.dispose();
    instagramCtrl.dispose();
    youtubeCtrl.dispose();
    tiktokCtrl.dispose();
    facebookCtrl.dispose();
    super.onClose();
  }
}

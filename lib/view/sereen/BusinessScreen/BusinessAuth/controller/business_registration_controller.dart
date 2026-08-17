import 'dart:ui';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import 'package:speedring/core/app_routes/app_routes.dart';

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
  final commCtrl = TextEditingController();
  final digitalHqCtrl = TextEditingController();
  final RxString scheduleText = "Configure Schedule".obs;

  final instagramCtrl = TextEditingController();
  final youtubeCtrl = TextEditingController();
  final tiktokCtrl = TextEditingController();
  final facebookCtrl = TextEditingController();

  // Step 4: Asset Class selection
  final RxInt selectedAssetClass =
      0.obs; // 0: Vehicle, 1: Motorcycle, 2: Technical Part, 3: Expert Service

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
    scheduleText.value = "Mon-Fri, 08:00 - 18:00 (Configured)";
  }

  final RxBool isLoading = false.obs;

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
      'assetInitialization': selectedAssetClass.value.toString(),
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

        // Auto login or proceed to verification
        Get.toNamed(
          AppRoutes.loginScreen,
        ); // User can login with the credentials
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
    commCtrl.dispose();
    digitalHqCtrl.dispose();
    instagramCtrl.dispose();
    youtubeCtrl.dispose();
    tiktokCtrl.dispose();
    facebookCtrl.dispose();
    super.onClose();
  }
}

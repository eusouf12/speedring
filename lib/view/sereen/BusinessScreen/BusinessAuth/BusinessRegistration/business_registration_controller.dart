import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

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
          dest.addPath(
            metric.extractPath(distance, end),
            Offset.zero,
          );
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
  final RxInt selectedAssetClass = 0.obs; // 0: Vehicle, 1: Motorcycle, 2: Technical Part, 3: Expert Service

  // Simulating document uploads with artificial delay
  void uploadLicense() {
    isLicenseUploading.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      businessLicenseName.value = "business_license_v2.pdf";
      isLicenseUploading.value = false;
    });
  }

  void uploadTradeReg() {
    isTradeRegUploading.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      tradeRegName.value = "incorporation_cert.pdf";
      isTradeRegUploading.value = false;
    });
  }

  void uploadLogo() {
    isLogoUploading.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      logoFileName.value = "apex_brand_logo.png";
      isLogoUploading.value = false;
    });
  }

  void uploadBanner() {
    isBannerUploading.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      bannerFileName.value = "garage_header_banner.jpg";
      isBannerUploading.value = false;
    });
  }

  void uploadBrandLogo() {
    isBrandLogoUploading.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      brandLogoName.value = "official_brand_logo.png";
      isBrandLogoUploading.value = false;
    });
  }

  void configureSchedule() {
    scheduleText.value = "Mon-Fri, 08:00 - 18:00 (Configured)";
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

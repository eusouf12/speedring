import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_images/app_images.dart';

class SetupProfileController extends GetxController {
  final displayNameCtrl = TextEditingController();
  final bioCtrl = TextEditingController();
  final roleCtrl = TextEditingController();
  final instagramCtrl = TextEditingController();
  final tiktokCtrl = TextEditingController();
  final youtubeCtrl = TextEditingController();
  final facebookCtrl = TextEditingController();

  // Vehicle details (Step 3)
  final vehicleNameCtrl = TextEditingController();
  final brandCtrl = TextEditingController();
  final modelCtrl = TextEditingController();
  final yearCtrl = TextEditingController();
  final hpCtrl = TextEditingController();

  final RxBool displayRolePublicly = true.obs;
  final RxString nationality = 'Germany'.obs;
  final RxInt selectedCategory =
      0.obs; // 0=Combustion, 1=Electric, 2=Motorcycle, 3=Karting, 4=Old Timer
  final RxList<String> selectedInterests = <String>[].obs;
  final RxList<String> selectedNotifications = <String>[].obs;
  final RxString engineType = 'combustion'.obs;

  // Auto swap preview images every 5 seconds
  final RxInt currentPreviewIndex = 0.obs;
  late final List<String> previewImages = [
    AppImages.oldtimerBg,
    AppImages.combustionBg,
    AppImages.electricBg,
  ];
  Timer? _previewTimer;

  @override
  void onInit() {
    super.onInit();
    startPreviewTimer();
  }

  void startPreviewTimer() {
    _previewTimer?.cancel();
    _previewTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      currentPreviewIndex.value =
          (currentPreviewIndex.value + 1) % previewImages.length;
    });
  }

  void stopPreviewTimer() {
    _previewTimer?.cancel();
  }

  @override
  void onClose() {
    stopPreviewTimer();
    displayNameCtrl.dispose();
    bioCtrl.dispose();
    roleCtrl.dispose();
    instagramCtrl.dispose();
    tiktokCtrl.dispose();
    youtubeCtrl.dispose();
    facebookCtrl.dispose();
    vehicleNameCtrl.dispose();
    brandCtrl.dispose();
    modelCtrl.dispose();
    yearCtrl.dispose();
    hpCtrl.dispose();
    super.onClose();
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../service/api_client.dart';
import '../../../service/api_url.dart';
import '../../../utils/ToastMsg/toast_message.dart';
import '../../../utils/app_images/app_images.dart';
import 'model/plan_model.dart';

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
  final vehicleNumberPlate = TextEditingController();
  final brandCtrl = TextEditingController();
  final modelCtrl = TextEditingController();
  final yearCtrl = TextEditingController();
  final hpCtrl = TextEditingController();

  final RxBool displayRolePublicly = true.obs;
  final RxString nationality = 'Germany'.obs;
  final RxInt selectedCategory = 0.obs;
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

  // Profile and Vehicle Images
  final Rx<File?> profileImage = Rx<File?>(null);
  final Rx<File?> vehicleImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    startPreviewTimer();
    getAllPlans();
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

  Future<void> pickProfileImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
      }
    } catch (e) {
      debugPrint("Error picking profile image: $e");
    }
  }

  Future<void> pickVehicleImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        vehicleImage.value = File(pickedFile.path);
      }
    } catch (e) {
      debugPrint("Error picking vehicle image: $e");
    }
  }

  Future<void> setupUserProfile() async {
    isLoading.value = true;

    // Prepare nested data object according to user requirements
    Map<String, dynamic> data = {
      "displayName": displayNameCtrl.text.isNotEmpty
          ? displayNameCtrl.text
          : "Sebastian V.",
      "bio": bioCtrl.text,
      "driverRole": roleCtrl.text.isNotEmpty ? roleCtrl.text : "Racer",
      "isRolePublic": displayRolePublicly.value,
      "nationality": nationality.value,
      "socialLinks": {
        if (instagramCtrl.text.isNotEmpty) "instagram": instagramCtrl.text,
        if (youtubeCtrl.text.isNotEmpty) "youtube": youtubeCtrl.text,
        if (tiktokCtrl.text.isNotEmpty) "tiktok": tiktokCtrl.text,
        if (facebookCtrl.text.isNotEmpty) "facebook": facebookCtrl.text,
      },
      "favoriteVehicles": ["Combustion", "Electric", "Motorcycle"],
      "vehicles": [],
      "notificationPreferences": {
        "liveTelemetry": selectedNotifications.contains('track_alerts'),
        "social": selectedNotifications.contains('new_followers'),
        "locationBased": selectedNotifications.contains('live_sessions'),
        "marketplace": selectedNotifications.contains('marketplace'),
        "proTour": selectedNotifications.contains('event_updates'),
      },
    };

    // If vehicle form was partially filled, add it
    if (vehicleNameCtrl.text.isNotEmpty ||
        brandCtrl.text.isNotEmpty ||
        modelCtrl.text.isNotEmpty) {
      data["vehicles"] = [
        {
          "vehicleName": vehicleNameCtrl.text,
          "numberPlate": vehicleNumberPlate.text,
          "brand": brandCtrl.text,
          "model": modelCtrl.text,
          "year": yearCtrl.text,
          "hp": hpCtrl.text,
          "engineType": engineType.value.capitalizeFirst,
        },
      ];
    }

    List<MultipartBody> multipartData = [];
    if (profileImage.value != null) {
      multipartData.add(MultipartBody('profileImage', profileImage.value!));
    }
    if (vehicleImage.value != null) {
      multipartData.add(MultipartBody('vehicleImage', vehicleImage.value!));
    }

    try {
      Map<String, String> body = {'data': jsonEncode(data)};

      var response = await ApiClient.postMultipartData(
        ApiUrl.setupUserProfile,
        body,
        multipartBody: multipartData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Profile setup complete!", isError: false);
        Get.offAllNamed(AppRoutes.preview); // Or navigate to dashboard
      } else {
        showCustomSnackBar("Failed to setup profile.", isError: true);
      }
    } catch (e) {
      debugPrint("Setup profile error: $e");
      showCustomSnackBar("Something went wrong", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  //================== Get plan  controller ====================
  final RxList<PlanModel> plansList = <PlanModel>[].obs;
  final RxBool isPlansLoading = false.obs;

  Future<void> getAllPlans() async {
    isPlansLoading.value = true;
    try {
      var response = await ApiClient.getData(ApiUrl.allPlans);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var body = response.body;
        if (body != null && body['data'] != null) {
          plansList.value = (body['data'] as List)
              .map((e) => PlanModel.fromJson(e))
              .toList();
        } else if (body != null && body is List) {
          plansList.value = (body).map((e) => PlanModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      debugPrint("Error fetching plans: $e");
    } finally {
      isPlansLoading.value = false;
    }
  }

  //================== Buy Plan ====================
  final RxBool isBuyPlanLoading = false.obs;

  Future<String?> buyPlan(String planId) async {
    isBuyPlanLoading.value = true;
    try {
      // Typically empty body, but can be updated if the API needs extra fields
      var response = await ApiClient.postData(
        ApiUrl.buyPlan(planId: planId),
        jsonEncode({}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Checkout session created!", isError: false);

        // Parse the URL from the response
        String? checkoutUrl;
        var body = response.body;
        if (body != null && body is Map && body['data'] != null) {
          if (body['data'] is Map) {
            checkoutUrl = body['data']['url']?.toString();
          }
        }
        return checkoutUrl;
      } else {
        // You might want to parse response.body['message'] here
        showCustomSnackBar("Failed to create checkout session.", isError: true);
        return null;
      }
    } catch (e) {
      debugPrint("Buy plan error: $e");
      showCustomSnackBar("Something went wrong", isError: true);
      return null;
    } finally {
      isBuyPlanLoading.value = false;
    }
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

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../model/profile_model.dart';

class ProfileScreenController extends GetxController {
  final _activeTab = 0.obs;

  int get activeTab => _activeTab.value;

  set activeTab(int val) => _activeTab.value = val;

  final Rx<ProfileData?> profileData = Rx<ProfileData?>(null);

  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;

  final nameController = TextEditingController();
  final displayNameController = TextEditingController();
  final handleController = TextEditingController();
  final bioController = TextEditingController();

  final instagramController = TextEditingController();
  final tiktokController = TextEditingController();
  final youtubeController = TextEditingController();
  final facebookController = TextEditingController();

  final nationalityController = TextEditingController();
  final driverRoleController = TextEditingController();

  final RxBool isRolePublic = false.obs;

  final RxList<String> favoriteVehicles = <String>[].obs;

  final RxBool liveTelemetry = false.obs;
  final RxBool socialNotification = false.obs;
  final RxBool locationBased = false.obs;
  final RxBool marketplace = false.obs;
  final RxBool proTour = false.obs;

  final RxList<Vehicle> vehicles = <Vehicle>[].obs;

  // Selected image files for upload
  final Rx<File?> selectedProfileImage = Rx<File?>(null);
  final Rx<File?> selectedBannerImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    getMyProfile();
  }

  void initEditProfile(ProfileData profile) {
    nameController.text = profile.name ?? '';

    displayNameController.text =
        profile.driverInfo?.displayName ?? profile.name ?? '';

    handleController.text = profile.userName ?? '';

    bioController.text = profile.driverInfo?.bio ?? '';

    instagramController.text = profile.driverInfo?.socialLinks?.instagram ?? '';

    youtubeController.text = profile.driverInfo?.socialLinks?.youtube ?? '';

    tiktokController.text = profile.driverInfo?.socialLinks?.tiktok ?? '';

    facebookController.text = profile.driverInfo?.socialLinks?.facebook ?? '';

    nationalityController.text = profile.driverInfo?.nationality ?? '';

    driverRoleController.text = profile.driverInfo?.driverRole ?? '';

    isRolePublic.value = profile.driverInfo?.isRolePublic ?? false;

    favoriteVehicles.assignAll(profile.driverInfo?.favoriteVehicles ?? []);

    final notification = profile.driverInfo?.notificationPreferences;

    liveTelemetry.value = notification?.liveTelemetry ?? false;

    socialNotification.value = notification?.social ?? false;

    locationBased.value = notification?.locationBased ?? false;

    marketplace.value = notification?.marketplace ?? false;

    proTour.value = notification?.proTour ?? false;

    vehicles.assignAll(profile.driverInfo?.vehicles ?? []);

    // Clear previously selected images when re-initializing
    selectedProfileImage.value = null;
    selectedBannerImage.value = null;
  }

  Future<void> pickProfileImage() async {
    final file = await _pickImageFromGallery();
    if (file != null) selectedProfileImage.value = file;
  }

  Future<void> pickBannerImage() async {
    final file = await _pickImageFromGallery();
    if (file != null) selectedBannerImage.value = file;
  }

  Future<File?> _pickImageFromGallery() async {
    // Request gallery permission
    PermissionStatus status;

    if (Platform.isAndroid) {
      // Android 13+ uses READ_MEDIA_IMAGES, older uses READ_EXTERNAL_STORAGE
      status = await Permission.photos.request();
      if (status.isDenied) {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.photos.request();
    }

    if (status.isPermanentlyDenied) {
      Get.snackbar(
        'Permission Required',
        'Please enable gallery access in app settings.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff1A1A1A),
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () => openAppSettings(),
          child: const Text('SETTINGS', style: TextStyle(color: Color(0xffD4FB54))),
        ),
      );
      return null;
    }

    if (status.isDenied) {
      Get.snackbar(
        'Permission Denied',
        'Gallery access is needed to change your photo.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff1A1A1A),
        colorText: Colors.white,
      );
      return null;
    }

    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );
      if (picked != null) return File(picked.path);
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
    return null;
  }

  Future<void> getMyProfile() async {
    isLoading.value = true;

    try {
      final response = await ApiClient.getData(ApiUrl.myProfile);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final ProfileResponse profileResponse = ProfileResponse.fromJson(
          response.body,
        );

        if (profileResponse.success == true && profileResponse.data != null) {
          profileData.value = profileResponse.data;

          initEditProfile(profileResponse.data!);
        } else {
          debugPrint(
            'Profile response unsuccessful: ${profileResponse.message}',
          );
        }
      } else {
        debugPrint('Failed to fetch profile: ${response.statusText}');
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserProfile() async {
    if (isUpdating.value) return;

    isUpdating.value = true;

    try {
      final Map<String, dynamic> data = {
        "name": nameController.text.trim(),
        "userName": handleController.text.trim(),
        "driverInfo": {
          "displayName": displayNameController.text.trim(),
          "bio": bioController.text.trim(),
          "driverRole": driverRoleController.text.trim(),
          "isRolePublic": isRolePublic.value,
          "nationality": nationalityController.text.trim(),
          "favoriteVehicles": favoriteVehicles.toList(),
          "socialLinks": {
            "instagram": instagramController.text.trim(),
            "youtube": youtubeController.text.trim(),
            "tiktok": tiktokController.text.trim(),
            "facebook": facebookController.text.trim(),
          },
          "notificationPreferences": {
            "liveTelemetry": liveTelemetry.value,
            "social": socialNotification.value,
            "locationBased": locationBased.value,
            "marketplace": marketplace.value,
            "proTour": proTour.value,
          },
          "vehicles": vehicles.map((vehicle) => vehicle.toJson()).toList(),
        },
      };

      // Build multipart files list from any picked images
      final List<MultipartBody> files = [];
      if (selectedProfileImage.value != null) {
        files.add(MultipartBody('profileImage', selectedProfileImage.value!));
      }
      if (selectedBannerImage.value != null) {
        files.add(MultipartBody('uploadBanner', selectedBannerImage.value!));
      }

      final response = await ApiClient.patchMultipartData(
        ApiUrl.updateProfile,
        {'data': jsonEncode(data)},
        multipartBody: files,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();

        await getMyProfile();

        Get.snackbar(
          "Profile Updated",
          "Your profile changes have been successfully saved.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xff181818),
          colorText: Colors.white,
          borderColor: const Color(0xffD4FB54),
          borderWidth: 1,
        );
      } else {
        debugPrint('Update profile failed: ${response.body}');

        Get.snackbar(
          "Error",
          "Failed to update profile",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Update Profile error: $e");

      Get.snackbar(
        "Error",
        "Something went wrong while updating profile.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  void toggleFavoriteVehicle(String vehicleType) {
    if (favoriteVehicles.contains(vehicleType)) {
      favoriteVehicles.remove(vehicleType);
    } else {
      favoriteVehicles.add(vehicleType);
    }
  }

  void showVehicleDialog({Vehicle? vehicle, int? index}) {
    final vNameCtrl = TextEditingController(text: vehicle?.vehicleName ?? '');

    final vBrandCtrl = TextEditingController(text: vehicle?.brand ?? '');

    final vModelCtrl = TextEditingController(text: vehicle?.model ?? '');

    final vYearCtrl = TextEditingController(text: vehicle?.year ?? '');

    final vHpCtrl = TextEditingController(text: vehicle?.hp ?? '');

    final vEngineCtrl = TextEditingController(text: vehicle?.engineType ?? '');

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xff1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                vehicle == null ? "ADD VEHICLE" : "EDIT VEHICLE",
                style: const TextStyle(
                  color: Color(0xffD4FB54),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: vNameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Vehicle Name (e.g. My Beast)",
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffD4FB54)),
                  ),
                ),
              ),

              TextField(
                controller: vBrandCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Brand",
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffD4FB54)),
                  ),
                ),
              ),

              TextField(
                controller: vModelCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Model",
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffD4FB54)),
                  ),
                ),
              ),

              TextField(
                controller: vYearCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Year",
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffD4FB54)),
                  ),
                ),
              ),

              TextField(
                controller: vHpCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Horsepower (HP)",
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffD4FB54)),
                  ),
                ),
              ),

              TextField(
                controller: vEngineCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Engine Type (e.g. V8, Electric)",
                  labelStyle: TextStyle(color: Colors.white54),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffD4FB54)),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffD4FB54),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  final newVehicle = Vehicle(
                    id: vehicle?.id,
                    vehicleName: vNameCtrl.text.trim(),
                    brand: vBrandCtrl.text.trim(),
                    model: vModelCtrl.text.trim(),
                    year: vYearCtrl.text.trim(),
                    hp: vHpCtrl.text.trim(),
                    engineType: vEngineCtrl.text.trim(),
                    vehicleImage: vehicle?.vehicleImage,
                  );

                  if (index != null) {
                    vehicles[index] = newVehicle;
                  } else {
                    vehicles.add(newVehicle);
                  }

                  Get.back();
                },
                child: const Text(
                  "SAVE VEHICLE",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void clearEditProfileData() {
    nameController.clear();
    displayNameController.clear();
    handleController.clear();
    bioController.clear();

    instagramController.clear();
    tiktokController.clear();
    youtubeController.clear();
    facebookController.clear();

    nationalityController.clear();
    driverRoleController.clear();

    isRolePublic.value = false;

    favoriteVehicles.clear();

    liveTelemetry.value = false;
    socialNotification.value = false;
    locationBased.value = false;
    marketplace.value = false;
    proTour.value = false;

    vehicles.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    displayNameController.dispose();
    handleController.dispose();
    bioController.dispose();

    instagramController.dispose();
    tiktokController.dispose();
    youtubeController.dispose();
    facebookController.dispose();

    nationalityController.dispose();
    driverRoleController.dispose();

    super.onClose();
  }
}

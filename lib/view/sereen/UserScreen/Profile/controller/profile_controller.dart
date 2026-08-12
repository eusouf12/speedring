import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../model/profile_model.dart';
import '../../../../../utils/ToastMsg/toast_message.dart';

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

  // Selected image files for upload
  final Rx<File?> selectedProfileImage = Rx<File?>(null);
  final Rx<File?> selectedBannerImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    getMyProfile();
    getMyVehicles();
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
          child: const Text(
            'SETTINGS',
            style: TextStyle(color: Color(0xffD4FB54)),
          ),
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

        showCustomSnackBar(
          "Your profile changes have been successfully saved.",
          isError: false,
        );
      } else {
        debugPrint('Update profile failed: ${response.body}');

        showCustomSnackBar("Failed to update profile", isError: true);
      }
    } catch (e) {
      debugPrint("Update Profile error: $e");

      showCustomSnackBar(
        "Something went wrong while updating profile.",
        isError: true,
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
  }

  final RxList<Vehicle> vehicles = <Vehicle>[].obs;
  int vehiclePage = 1;
  final RxBool isVehicleLoadingMore = false.obs;
  final RxBool isVehicleLoading = false.obs;
  bool hasNextVehiclePage = true;
  Future<void> getMyVehicles({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (!hasNextVehiclePage || isVehicleLoadingMore.value) return;
      vehiclePage++;
      isVehicleLoadingMore.value = true;
    } else {
      vehiclePage = 1;
      hasNextVehiclePage = true;
      isVehicleLoading.value = true;
    }

    try {
      final response = await ApiClient.getData(
        ApiUrl.myVehicles(page: vehiclePage),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final meta = response.body['meta'];
        if (meta != null) {
          final totalPages = meta['totalPages'] ?? 1;
          hasNextVehiclePage = vehiclePage < totalPages;
        }

        final data = response.body['data'];
        if (data != null && data is List) {
          final fetchedVehicles = data.map((v) => Vehicle.fromJson(v)).toList();
          if (isLoadMore) {
            vehicles.addAll(fetchedVehicles);
          } else {
            vehicles.assignAll(fetchedVehicles);
          }
        }
      } else {
        debugPrint('Failed to fetch vehicles: ${response.statusText}');
      }
    } catch (e) {
      debugPrint('Error fetching vehicles: $e');
    } finally {
      isVehicleLoading.value = false;
      isVehicleLoadingMore.value = false;
    }
  }

  Future<bool> addVehicle(Vehicle vehicle) async {
    isUpdating.value = true;
    try {
      final Map<String, dynamic> vehicleData = vehicle.toJson();

      final Map<String, String> data = {"data": jsonEncode(vehicleData)};

      final List<MultipartBody> files = [];
      if (vehicle.localImageFile != null) {
        files.add(MultipartBody('vehicleImage', vehicle.localImageFile!));
      }

      final response = await ApiClient.postMultipartData(
        ApiUrl.addVehicle,
        data,
        multipartBody: files,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Vehicle added successfully", isError: false);
        await getMyVehicles(); // Refresh the list
        return true;
      } else {
        String errMsg = "Failed to add vehicle";
        if (response.body is Map) {
          errMsg = response.body['message'] ?? errMsg;
        }
        showCustomSnackBar(errMsg, isError: true);
        return false;
      }
    } catch (e) {
      debugPrint('Error adding vehicle: $e');
      showCustomSnackBar("Error adding vehicle", isError: true);
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  Future<bool> updateVehicle(String vehicleId, Vehicle vehicle) async {
    isUpdating.value = true;
    try {
      final Map<String, dynamic> vehicleData = vehicle.toJson();
      // Remove nulls so we don't overwrite with nulls unnecessarily
      vehicleData.removeWhere((key, value) => value == null);

      final Map<String, String> data = {"data": jsonEncode(vehicleData)};

      final List<MultipartBody> files = [];
      if (vehicle.localImageFile != null) {
        files.add(MultipartBody('vehicleImage', vehicle.localImageFile!));
      }

      final response = await ApiClient.postMultipartData(
        ApiUrl.updateVehicle(vehicleId),
        data,
        multipartBody: files,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Vehicle updated successfully", isError: false);
        await getMyVehicles(); // Refresh the list
        return true;
      } else {
        String errMsg = "Failed to update vehicle";
        if (response.body is Map) {
          errMsg = response.body['message'] ?? errMsg;
        }
        showCustomSnackBar(errMsg, isError: true);
        return false;
      }
    } catch (e) {
      debugPrint('Error updating vehicle: $e');
      showCustomSnackBar("Error updating vehicle", isError: true);
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  Future<bool> deleteVehicle(String vehicleId) async {
    isUpdating.value = true;
    try {
      final response = await ApiClient.deleteData(
        ApiUrl.deleteVehicle(vehicleId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Vehicle deleted successfully", isError: false);
        // Remove from local list to avoid full refresh, or just refresh
        vehicles.removeWhere((v) => v.id == vehicleId);
        return true;
      } else {
        String errMsg = "Failed to delete vehicle";
        if (response.body is Map) {
          errMsg = response.body['message'] ?? errMsg;
        }
        showCustomSnackBar(errMsg, isError: true);
        return false;
      }
    } catch (e) {
      debugPrint('Error deleting vehicle: $e');
      showCustomSnackBar("Error deleting vehicle", isError: true);
      return false;
    } finally {
      isUpdating.value = false;
    }
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../model/profile_model.dart';

class ProfileScreenController extends GetxController {
  final _activeTab = 0.obs;
  int get activeTab => _activeTab.value;
  set activeTab(int val) => _activeTab.value = val;

  final Rx<ProfileData?> profileData = Rx<ProfileData?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getMyProfile();
  }

  Future<void> getMyProfile() async {
    isLoading.value = true;
    try {
      var response = await ApiClient.getData(ApiUrl.myProfile);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ProfileResponse profileResponse = ProfileResponse.fromJson(response.body);
        if (profileResponse.success == true && profileResponse.data != null) {
          profileData.value = profileResponse.data;
        }
      } else {
        debugPrint("Failed to fetch profile: ${response.statusText}");
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

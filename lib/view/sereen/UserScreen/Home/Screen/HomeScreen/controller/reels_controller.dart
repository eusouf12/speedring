import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../../../../../service/api_client.dart';
import '../../../../../../../../service/api_url.dart';
import '../../../../../../../../utils/ToastMsg/toast_message.dart';
import '../../../../../../../helper/shared_prefe/shared_prefe.dart'
    show SharePrefsHelper;
import '../../../../../../../utils/app_const/app_const.dart';

class ReelsController extends GetxController {
  RxList<Map<String, dynamic>> reels = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  RxBool isUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllReels();
  }

  Future<void> fetchAllReels() async {
    isLoading.value = true;
    try {
      var response = await ApiClient.getData(ApiUrl.getAllVideos as String);
      if (response.statusCode == 200) {
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;
        if (body['data'] != null) {
          final List list = body['data'];
          reels.assignAll(list.map((e) => e as Map<String, dynamic>).toList());
        }
      }
    } catch (e) {
      debugPrint("Error fetching reels: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createReel({
    required String title,
    required String description,
    required dynamic videoFile,
  }) async {
    isUploading.value = true;
    try {
      String? token = await SharePrefsHelper.getString(
        AppConstants.bearerToken,
      );
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiUrl.baseUrl + ApiUrl.createVideoPost),
      );
      request.headers.addAll({'Authorization': token ?? ''});
      request.fields['videoDetails[title]'] = title;
      request.fields['videoDetails[description]'] = description;
      request.fields['videoDetails[classification]'] = 'VLOG'; // Default

      request.files.add(
        await http.MultipartFile.fromPath('media', videoFile.path),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        showCustomSnackBar("Reel created successfully", isError: false);
        Get.back(); // Go back to Reels screen
        fetchAllReels(); // Refresh the list
      } else {
        final body = jsonDecode(response.body);
        showCustomSnackBar(body['message'] ?? "Upload failed", isError: true);
      }
    } catch (e) {
      showCustomSnackBar("An error occurred during upload", isError: true);
    } finally {
      isUploading.value = false;
    }
  }

  //   Future<void> deleteReel(String id) async {
  //     try {
  //       var response = await ApiClient.deleteData(ApiUrl.deleteVideo(id));
  //       if (response.statusCode == 200) {
  //         showCustomSnackBar("Reel deleted successfully");
  //         reels.removeWhere((element) => element['_id'] == id);
  //       } else {
  //         showCustomSnackBar("Failed to delete reel", isError: true);
  //       }
  //     } catch (e) {
  //       showCustomSnackBar("Error deleting reel", isError: true);
  //     }
  //   }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import 'package:speedring/view/sereen/UserScreen/discover/model/discover_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speedring/utils/app_const/app_const.dart';
import 'package:speedring/helper/shared_prefe/shared_prefe.dart';
import 'package:speedring/service/api_client.dart';

class DiscoverController extends GetxController {
  var isDiscoverLoading = false.obs;
  var isMoreLoading = false.obs;
  int currentPage = 1;
  int totalPages = 1;

  var discoverPosts = <DiscoverPost>[].obs;
  var currentUserId = "".obs;

  var activeSubTab = 0.obs; // 0: Spotting, 1: Videos, 2: Network
  var activeTag = "Trending".obs;
  var activeVideoTag = "All".obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserId();
    getAllDiscoverPosts();
  }

  Future<void> _loadUserId() async {
    try {
      String token = await SharePrefsHelper.getString(AppConstants.bearerToken);
      String? myUserId = _getUserIdFromToken(token);
      if (myUserId != null && myUserId.isNotEmpty) {
        currentUserId.value = myUserId;
      }
    } catch (e) {
      debugPrint("Error reading userId in DiscoverController: $e");
    }
  }

  String? _getUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = parts[1];
      var normalized = base64Url.normalize(payload);
      var resp = utf8.decode(base64Url.decode(normalized));
      final decoded = json.decode(resp);
      return decoded['userId']?.toString() ?? decoded['id']?.toString();
    } catch (e) {
      return null;
    }
  }

  Future<void> getAllDiscoverPosts({bool refresh = false}) async {
    if (refresh) {
      currentPage = 1;
      totalPages = 1;
    }

    if (currentPage > totalPages) return;

    if (currentPage == 1) {
      isDiscoverLoading.value = true;
    } else {
      isMoreLoading.value = true;
    }

    try {
      var response = await ApiClient.getData(
        ApiUrl.getAllDiscoverPosts(page: currentPage),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body is String
            ? json.decode(response.body)
            : response.body;
        final res = DiscoverPostResponse.fromJson(data);
        final newPosts = res.data ?? [];
        final meta = res.meta;

        totalPages = meta != null && meta.totalPage != null
            ? meta.totalPage!
            : 1;

        if (currentPage == 1) discoverPosts.clear();
        discoverPosts.addAll(newPosts);

        currentPage++;
      } else {
        showCustomSnackBar("Failed to fetch discover posts", isError: true);
      }
    } catch (e, stack) {
      debugPrint("--- Error fetching discover posts: $e");
      debugPrint(stack.toString());
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isDiscoverLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  Future<void> createDiscoverPost({
    required Map<String, String> fields,
    List<XFile>? mediaFiles,
  }) async {
    try {
      // Build spotDetails body object (only non-empty fields)
      final Map<String, dynamic> spotDetails = {};
      fields.forEach((key, value) {
        if (value.isNotEmpty) {
          // key format: "spotDetails.licensePlate" → strip prefix
          final fieldName = key.replaceFirst('spotDetails.', '');
          spotDetails[fieldName] = value;
        }
      });

      final Map<String, dynamic> body = {'spotDetails': spotDetails};

      // Build multipart files list (field name must be 'media')
      final List<MultipartBody> multipartFiles =
          mediaFiles
              ?.map((xf) => MultipartBody('media', File(xf.path)))
              .toList() ??
          [];

      dynamic response;
      if (multipartFiles.isNotEmpty) {
        response = await ApiClient.postMultipartData(
          ApiUrl.createDiscoverPost,
          {'data': jsonEncode(body)},
          multipartBody: multipartFiles,
        );
      } else {
        response = await ApiClient.postData(
          ApiUrl.createDiscoverPost,
          jsonEncode(body),
        );
      }

      Map<String, dynamic> jsonResponse = {};
      try {
        jsonResponse = response.body is String
            ? jsonDecode(response.body)
            : response.body as Map<String, dynamic>;
      } catch (_) {}

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(
          jsonResponse['message']?.toString() ?? "Spot published successfully!",
          isError: false,
        );
        getAllDiscoverPosts(refresh: true);
        Get.back();
      } else {
        showCustomSnackBar(
          jsonResponse['message']?.toString() ?? "Failed to create spot",
          isError: true,
        );
      }
    } catch (e, stack) {
      debugPrint("--- createDiscoverPost error: $e");
      debugPrint(stack.toString());
      showCustomSnackBar(e.toString(), isError: true);
    }
  }

  Future<void> editDiscoverPost({
    required String postId,
    required Map<String, String> fields,
    List<XFile>? mediaFiles,
  }) async {
    try {
      final Map<String, dynamic> spotDetails = {};
      fields.forEach((key, value) {
        if (value.isNotEmpty) {
          final fieldName = key.replaceFirst('spotDetails.', '');
          spotDetails[fieldName] = value;
        }
      });

      final Map<String, dynamic> body = {'spotDetails': spotDetails};

      final List<MultipartBody> multipartFiles =
          mediaFiles
              ?.map((xf) => MultipartBody('media', File(xf.path)))
              .toList() ??
          [];

      dynamic response;
      if (multipartFiles.isNotEmpty) {
        response = await ApiClient.patchMultipartData(
          ApiUrl.editDiscoverPost(postId: postId),
          {'data': jsonEncode(body)},
          multipartBody: multipartFiles,
        );
      } else {
        response = await ApiClient.patchData(
          ApiUrl.editDiscoverPost(postId: postId),
          jsonEncode(body),
        );
      }

      Map<String, dynamic> jsonResponse = {};
      try {
        jsonResponse = response.body is String
            ? jsonDecode(response.body)
            : response.body as Map<String, dynamic>;
      } catch (_) {}

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(
          jsonResponse['message']?.toString() ?? "Spot updated successfully!",
          isError: false,
        );
        getAllDiscoverPosts(refresh: true);
        Get.back();
      } else {
        showCustomSnackBar(
          jsonResponse['message']?.toString() ?? "Failed to update spot",
          isError: true,
        );
      }
    } catch (e, stack) {
      debugPrint("--- editDiscoverPost error: $e");
      debugPrint(stack.toString());
      showCustomSnackBar(e.toString(), isError: true);
    }
  }

  Future<void> deleteDiscoverPost(String id) async {
    try {
      final response = await ApiClient.deleteData(
        ApiUrl.deleteDiscoverPost(postId: id),
      );

      if (response.statusCode == 200) {
        discoverPosts.removeWhere((p) => p.id == id);
        showCustomSnackBar("Post deleted successfully", isError: false);
      } else {
        showCustomSnackBar("Failed to delete post", isError: true);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), colorText: Colors.white);
    }
  }
}

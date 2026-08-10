import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import 'package:speedring/view/sereen/UserScreen/discover/model/discover_model.dart';
import 'package:speedring/view/sereen/UserScreen/discover/model/video_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speedring/utils/app_const/app_const.dart';
import 'package:speedring/helper/shared_prefe/shared_prefe.dart';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/view/sereen/UserScreen/discover/model/network_user_model.dart';

class DiscoverController extends GetxController {
  // ─── Search ───
  var showSearchBar = false.obs;
  var discoverSearchTerm = "".obs;
  var videoSearchTerm = "".obs;
  var networkSearchTerm = "".obs;
  var activeSubTab = 0.obs; // 0: Spotting, 1: Videos, 2: Network
  var activeTag = "Trending".obs;
  var activeVideoTag = "All".obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserId();
    getAllDiscoverPosts();
    getAllVideoPosts();
    getNetworkUsers();
    // Reactive: reload videos when tag changes
    ever(activeVideoTag, (_) => getAllVideoPosts(refresh: true));
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

  // ─── Videos ───
  var isVideoLoading = false.obs;
  var isMoreVideoLoading = false.obs;
  var isVideoUploading = false.obs;
  int _videoPage = 1;
  int _videoTotalPages = 1;
  var videoPosts = <VideoPost>[].obs;
  Future<void> getAllVideoPosts({bool refresh = false}) async {
    if (refresh) {
      _videoPage = 1;
      _videoTotalPages = 1;
    }
    if (_videoPage > _videoTotalPages) return;

    _videoPage == 1
        ? isVideoLoading.value = true
        : isMoreVideoLoading.value = true;

    try {
      var response = await ApiClient.getData(
        ApiUrl.getAllVideos(
          page: _videoPage,
          classification: activeVideoTag.value,
          searchTerm: videoSearchTerm.value,
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body is String
            ? json.decode(response.body)
            : response.body;
        final res = VideoPostResponse.fromJson(data);
        _videoTotalPages = res.meta?.totalPage ?? 1;
        if (_videoPage == 1) videoPosts.clear();
        videoPosts.addAll(res.data ?? []);
        _videoPage++;
      } else {
        showCustomSnackBar("Failed to fetch videos", isError: true);
      }
    } catch (e, stack) {
      debugPrint("--- Error fetching videos: $e");
      debugPrint(stack.toString());
    } finally {
      isVideoLoading.value = false;
      isMoreVideoLoading.value = false;
    }
  }

  void searchVideoPosts(String term) {
    videoSearchTerm.value = term;
    getAllVideoPosts(refresh: true);
  }

  Future<void> deleteVideo(String id) async {
    try {
      final response = await ApiClient.deleteData(
        ApiUrl.deleteVideo(videoId: id),
      );
      if (response.statusCode == 200) {
        videoPosts.removeWhere((v) => v.id == id);
        showCustomSnackBar("Video deleted successfully", isError: false);
      } else {
        showCustomSnackBar("Failed to delete video", isError: true);
      }
    } catch (e) {
      showCustomSnackBar(e.toString(), isError: true);
    }
  }

  Future<void> shareVideoPost(String id) async {
    try {
      await ApiClient.postData(ApiUrl.shareVideo(videoId: id), '');
    } catch (_) {}
  }

  Future<void> incrementVideoViews(String id) async {
    try {
      await ApiClient.patchData(ApiUrl.incrementVideoViews(videoId: id), '');
    } catch (_) {}
  }

  Future<void> createVideoPost({
    required Map<String, String> fields,
    XFile? videoFile,
    XFile? thumbnailFile,
  }) async {
    isVideoUploading.value = true;
    try {
      final Map<String, dynamic> videoDetails = {};
      fields.forEach((key, value) {
        if (value.isNotEmpty) {
          final fieldName = key.replaceFirst('videoDetails.', '');
          videoDetails[fieldName] = value;
        }
      });

      final Map<String, dynamic> body = {'videoDetails': videoDetails};

      final List<MultipartBody> multipartFiles = [];
      if (videoFile != null) {
        multipartFiles.add(MultipartBody('media', File(videoFile.path)));
      }
      if (thumbnailFile != null) {
        multipartFiles.add(
          MultipartBody('thumbnail', File(thumbnailFile.path)),
        );
      }

      dynamic response;
      if (multipartFiles.isNotEmpty) {
        response = await ApiClient.postMultipartData(ApiUrl.createVideoPost, {
          'data': jsonEncode(body),
        }, multipartBody: multipartFiles);
      } else {
        response = await ApiClient.postData(
          ApiUrl.createVideoPost,
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
          jsonResponse['message']?.toString() ??
              "Video published successfully!",
          isError: false,
        );
        await getAllVideoPosts(refresh: true);
        Get.back();
      } else {
        showCustomSnackBar(
          jsonResponse['message']?.toString() ?? "Failed to publish video",
          isError: true,
        );
      }
    } catch (e, stack) {
      debugPrint("--- createVideoPost error: $e");
      debugPrint(stack.toString());
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isVideoUploading.value = false;
    }
  }

  Future<void> editVideoPost({
    required String videoId,
    required Map<String, String> fields,
    XFile? videoFile,
    XFile? thumbnailFile,
  }) async {
    isVideoUploading.value = true;
    try {
      final Map<String, dynamic> videoDetails = {};
      fields.forEach((key, value) {
        if (value.isNotEmpty) {
          final fieldName = key.replaceFirst('videoDetails.', '');
          videoDetails[fieldName] = value;
        }
      });

      final Map<String, dynamic> body = {'videoDetails': videoDetails};

      final List<MultipartBody> multipartFiles = [];
      if (videoFile != null) {
        multipartFiles.add(MultipartBody('media', File(videoFile.path)));
      }
      if (thumbnailFile != null) {
        multipartFiles.add(
          MultipartBody('thumbnail', File(thumbnailFile.path)),
        );
      }

      dynamic response;
      if (multipartFiles.isNotEmpty) {
        response = await ApiClient.patchMultipartData(
          ApiUrl.editVideo(videoId: videoId),
          {'data': jsonEncode(body)},
          multipartBody: multipartFiles,
        );
      } else {
        response = await ApiClient.patchData(
          ApiUrl.editVideo(videoId: videoId),
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
          jsonResponse['message']?.toString() ?? "Video updated successfully!",
          isError: false,
        );
        await getAllVideoPosts(refresh: true);
        Navigator.pop(Get.context!);
      } else {
        showCustomSnackBar(
          jsonResponse['message']?.toString() ?? "Failed to update video",
          isError: true,
        );
      }
    } catch (e, stack) {
      debugPrint("--- editVideoPost error: $e");
      debugPrint(stack.toString());
      showCustomSnackBar(e.toString(), isError: true);
    } finally {
      isVideoUploading.value = false;
    }
  }

  //======================= Discover post ================================
  var isDiscoverLoading = false.obs;
  var isMoreLoading = false.obs;
  int currentPage = 1;
  int totalPages = 1;
  var discoverPosts = <DiscoverPost>[].obs;
  var currentUserId = "".obs;
  Future<void> getAllDiscoverPosts({bool refresh = false}) async {
    if (refresh) {
      currentPage = 1;
      totalPages = 1;
    }
    if (currentPage > totalPages) return;

    currentPage == 1
        ? isDiscoverLoading.value = true
        : isMoreLoading.value = true;

    try {
      var response = await ApiClient.getData(
        ApiUrl.getAllDiscoverPosts(
          page: currentPage,
          searchTerm: discoverSearchTerm.value,
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body is String
            ? json.decode(response.body)
            : response.body;
        final res = DiscoverPostResponse.fromJson(data);
        totalPages = res.meta?.totalPage ?? 1;
        if (currentPage == 1) discoverPosts.clear();
        discoverPosts.addAll(res.data ?? []);
        currentPage++;
      } else {
        showCustomSnackBar("Failed to fetch discover posts", isError: true);
      }
    } catch (e, stack) {
      debugPrint("--- Error fetching discover posts: $e");
      debugPrint(stack.toString());
    } finally {
      isDiscoverLoading.value = false;
      isMoreLoading.value = false;
    }
  }

  void searchDiscoverPosts(String term) {
    discoverSearchTerm.value = term;
    getAllDiscoverPosts(refresh: true);
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

  // ======================= Network Users ================================
  var isNetworkLoading = false.obs;
  var isMoreNetworkLoading = false.obs;
  int _networkPage = 1;
  int _networkTotalPages = 1;
  var networkUsers = <NetworkUser>[].obs;

  Future<void> getNetworkUsers({bool refresh = false}) async {
    if (isNetworkLoading.value || isMoreNetworkLoading.value) return;

    if (refresh) {
      _networkPage = 1;
      _networkTotalPages = 1;
    }
    if (_networkPage > _networkTotalPages) return;

    _networkPage == 1
        ? isNetworkLoading.value = true
        : isMoreNetworkLoading.value = true;

    try {
      var response = await ApiClient.getData(
        ApiUrl.getDiscoverNetworkUsers(
          page: _networkPage,
          searchTerm: networkSearchTerm.value,
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body is String
            ? json.decode(response.body)
            : response.body;
        final res = NetworkUserResponse.fromJson(data);
        _networkTotalPages = res.meta?.totalPage ?? 1;
        if (_networkPage == 1) networkUsers.clear();
        
        final newUsers = res.data ?? [];
        for (var user in newUsers) {
          if (!networkUsers.any((u) => u.id == user.id)) {
            networkUsers.add(user);
          }
        }
        
        _networkPage++;
      } else {
        showCustomSnackBar("Failed to fetch network users", isError: true);
      }
    } catch (e, stack) {
      debugPrint("--- Error fetching network users: $e");
      debugPrint(stack.toString());
    } finally {
      isNetworkLoading.value = false;
      isMoreNetworkLoading.value = false;
    }
  }

  void searchNetworkUsers(String term) {
    networkSearchTerm.value = term;
    getNetworkUsers(refresh: true);
  }

  Future<void> toggleFollowUser(String userId) async {
    try {
      // Optimistic UI update
      final index = networkUsers.indexWhere((u) => u.id == userId);
      if (index != -1) {
        networkUsers[index].isFollowing = !networkUsers[index].isFollowing;
        networkUsers.refresh();
      }

      final response = await ApiClient.patchData(
        ApiUrl.toggleFollow(userId: userId),
        jsonEncode({}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Map<String, dynamic> body = response.body is String ? jsonDecode(response.body) : response.body;
        // String message = body['message'] ?? "Updated follow status";
        // showCustomSnackBar(message, isError: false);
      } else {
        // Revert UI update if failed
        if (index != -1) {
          networkUsers[index].isFollowing = !networkUsers[index].isFollowing;
          networkUsers.refresh();
        }
        showCustomSnackBar("Failed to follow/unfollow user", isError: true);
      }
    } catch (e) {
      // Revert UI update if failed
      final index = networkUsers.indexWhere((u) => u.id == userId);
      if (index != -1) {
        networkUsers[index].isFollowing = !networkUsers[index].isFollowing;
        networkUsers.refresh();
      }
      showCustomSnackBar(e.toString(), isError: true);
    }
  }
}

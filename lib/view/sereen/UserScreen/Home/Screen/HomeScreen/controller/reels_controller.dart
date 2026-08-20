import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import '../../../../../../../../service/api_client.dart';
import '../../../../../../../../service/api_url.dart';
import '../../../../../../../../utils/ToastMsg/toast_message.dart';
import '../../../../../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../../../../../utils/app_const/app_const.dart';

class ReelsController extends GetxController {
  RxList<Map<String, dynamic>> reels = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> savedReels = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadMoreReels = false.obs;
  RxBool isSavedReelsLoading = false.obs;
  RxBool isUploading = false.obs;
  String? myUserId;
  int _reelPage = 1;
  bool _hasMoreReels = true;

  @override
  void onInit() {
    super.onInit();
    _fetchUserId();
    fetchAllReels();
    fetchSavedReels();
  }

  Future<void> _fetchUserId() async {
    try {
      String? token = await SharePrefsHelper.getString(
        AppConstants.bearerToken,
      );
      if (token.isNotEmpty) {
        final parts = token.split('.');
        if (parts.length == 3) {
          final payload = parts[1];
          var normalized = base64Url.normalize(payload);
          var resp = utf8.decode(base64Url.decode(normalized));
          final decoded = json.decode(resp);
          myUserId = decoded['userId'];
        }
      }
    } catch (e) {
      debugPrint("Error fetching user id: $e");
    }
  }

  Future<void> fetchAllReels({bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (!_hasMoreReels || isLoadMoreReels.value) return;
      isLoadMoreReels.value = true;
    } else {
      isLoading.value = true;
      _reelPage = 1;
      _hasMoreReels = true;
    }

    try {
      var response = await ApiClient.getData(
        ApiUrl.getAllPosts(page: _reelPage, limit: 10, category: "REEL"),
      );
      if (response.statusCode == 200) {
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;
        if (body['data'] != null) {
          final List list = body['data'];
          if (list.length < 10) {
            _hasMoreReels = false;
          }
          final newReels = list.map((e) => e as Map<String, dynamic>).toList();
          
          if (isLoadMore) {
            reels.addAll(newReels);
          } else {
            reels.assignAll(newReels);
          }
          _reelPage++;
        } else {
           _hasMoreReels = false;
        }
      }
    } catch (e) {
      debugPrint("Error fetching reels: $e");
    } finally {
      isLoading.value = false;
      isLoadMoreReels.value = false;
    }
  }

  Future<void> fetchSavedReels() async {
    isSavedReelsLoading.value = true;
    try {
      var response = await ApiClient.getData(
        ApiUrl.getSavedPosts(page: 1, limit: 20),
      );
      if (response.statusCode == 200) {
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;
        if (body['data'] != null) {
          final List list = body['data'];
          // Filter to only show REELs if needed, or just show all saved posts
          savedReels.assignAll(
            list.map((e) => e as Map<String, dynamic>).toList(),
          );
        }
      }
    } catch (e) {
      debugPrint("Error fetching saved reels: $e");
    } finally {
      isSavedReelsLoading.value = false;
    }
  }

  Future<void> removeSavedReel(String postId) async {
    try {
      var response = await ApiClient.postData(
        ApiUrl.toggleSavePost(postId: postId),
        "",
      );
      if (response.statusCode == 200) {
        savedReels.removeWhere(
          (element) => (element['_id'] == postId) || (element['id'] == postId),
        );
        // Also update the main reels list if it's there
        final index = reels.indexWhere(
          (element) => (element['_id'] == postId) || (element['id'] == postId),
        );
        if (index != -1) {
          reels[index]['isBookmarked'] = false;
          reels[index] = reels[index];
        }
        showCustomSnackBar("Removed from saved", isError: false);
      } else {
        showCustomSnackBar("Failed to remove", isError: true);
      }
    } catch (e) {
      debugPrint("Error removing saved reel: $e");
    }
  }

  Future<void> createReel({
    required String title,
    required String description,
    required dynamic videoFile,
    File? audioFile,
    String? musicName,
    String? musicUrl,
  }) async {
    isUploading.value = true;
    try {
      final Map<String, dynamic> bodyData = {
        "category": "REEL",
        "visibility": "Public",
        "clubPostDetails": {"title": title, "details": description},
      };

      if (musicName != null && musicName.isNotEmpty) {
        bodyData["music"] = {"name": musicName, "url": musicUrl};
      }

      Map<String, String> fields = {'data': jsonEncode(bodyData)};

      List<MultipartBody> multipartBody = [MultipartBody('media', videoFile)];
      if (audioFile != null) {
        multipartBody.add(MultipartBody('audio', audioFile));
      }

      var response = await ApiClient.postMultipartData(
        ApiUrl.createPost,
        fields,
        multipartBody: multipartBody,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchAllReels();
        showCustomSnackBar("Reel created successfully", isError: false);
        Get.offNamed(AppRoutes.reelsScreen); // Go back to Reels screen
        // Refresh the list
      } else {
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;
        showCustomSnackBar(body['message'] ?? "Upload failed", isError: true);
      }
    } catch (e) {
      showCustomSnackBar("An error occurred during upload", isError: true);
    } finally {
      isUploading.value = false;
    }
  }

  // --- Interaction Methods with Optimistic UI Updates ---

  void toggleLike(int index) {
    if (index < 0 || index >= reels.length) return;

    final reel = reels[index];
    final bool isCurrentlyReacted = reel['isReacted'] ?? false;
    final int currentReactCount = reel['reactCount'] ?? 0;

    // Optimistic update
    reel['isReacted'] = !isCurrentlyReacted;
    reel['reactCount'] = isCurrentlyReacted
        ? (currentReactCount - 1)
        : (currentReactCount + 1);
    reels[index] = reel; // trigger Rx update

    // Call API
    reactToReel(
      reel['_id'] ?? reel['id'] ?? '',
      "LIKE",
      index,
      isCurrentlyReacted,
      currentReactCount,
    );
  }

  Future<void> reactToReel(
    String reelId,
    String reactType,
    int index,
    bool previousReactedState,
    int previousReactCount,
  ) async {
    if (reelId.isEmpty) return;
    try {
      var response = await ApiClient.patchData(
        ApiUrl.reactPost(postId: reelId),
        jsonEncode({"reactType": reactType}),
      );
      if (response.statusCode != 200) {
        // Revert on failure
        if (index >= 0 && index < reels.length) {
          reels[index]['isReacted'] = previousReactedState;
          reels[index]['reactCount'] = previousReactCount;
          reels[index] = reels[index];
        }
        showCustomSnackBar("Failed to react to reel", isError: true);
      }
    } catch (e) {
      debugPrint("Error reacting to reel: $e");
    }
  }

  Future<void> toggleBookmark(int index, String postId) async {
    if (index < 0 || index >= reels.length || postId.isEmpty) return;

    final reel = reels[index];
    final bool isBookmarked = reel['isBookmarked'] ?? false;

    // Optimistic UI update
    reel['isBookmarked'] = !isBookmarked;
    reels[index] = reel;

    try {
      var response = await ApiClient.postData(
        ApiUrl.toggleSavePost(postId: postId),
        "",
      );
      if (response.statusCode != 200) {
        // Revert on failure
        reels[index]['isBookmarked'] = isBookmarked;
        reels[index] = reels[index];
        showCustomSnackBar("Failed to save post", isError: true);
      }
    } catch (e) {
      debugPrint("Error toggling bookmark: $e");
    }
  }

  Future<void> toggleFollow(int index, String targetUserId) async {
    if (index < 0 || index >= reels.length || targetUserId.isEmpty) return;

    final reel = reels[index];
    final bool isFollowing = reel['isFollowing'] ?? false;

    // Optimistic update
    reel['isFollowing'] = !isFollowing;
    reels[index] = reel;

    try {
      var response = await ApiClient.patchData(
        ApiUrl.toggleFollow(userId: targetUserId),
        jsonEncode({}),
      );
      if (response.statusCode == 200) {
        // Success
      } else {
        // Revert on failure
        reels[index]['isFollowing'] = isFollowing;
        reels[index] = reels[index];
        showCustomSnackBar("Failed to follow user", isError: true);
      }
    } catch (e) {
      debugPrint("Error following user: $e");
    }
  }

  // --- Comments ---
  RxList<Map<String, dynamic>> currentComments = <Map<String, dynamic>>[].obs;
  RxBool isLoadingComments = false.obs;

  Future<void> getReelInteractions(String reelId) async {
    if (reelId.isEmpty) return;
    isLoadingComments.value = true;
    currentComments.clear();
    try {
      var response = await ApiClient.getData(
        ApiUrl.getPostInteractions(postId: reelId),
      );
      if (response.statusCode == 200) {
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;
        if (body['data'] != null && body['data']['comments'] != null) {
          final List list = body['data']['comments'];
          currentComments.assignAll(
            list.map((e) => e as Map<String, dynamic>).toList(),
          );
        }
      }
    } catch (e) {
      debugPrint("Error fetching interactions: $e");
    } finally {
      isLoadingComments.value = false;
    }
  }

  Future<void> commentOnReel(
    String reelId,
    int reelIndex,
    String comment,
  ) async {
    if (reelId.isEmpty || comment.trim().isEmpty) return;
    try {
      var response = await ApiClient.postData(
        ApiUrl.commentPost(postId: reelId),
        jsonEncode({"comment": comment}),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;

        fetchAllReels();
        // Immediately update comments list from response data
        if (body['data'] != null && body['data']['comments'] != null) {
          final List list = body['data']['comments'];
          currentComments.assignAll(
            list.map((e) => e as Map<String, dynamic>).toList(),
          );
        } else {
          getReelInteractions(reelId);
        }

        // Increment comment count locally
        if (reelIndex >= 0 && reelIndex < reels.length) {
          var val =
              reels[reelIndex]['commentCount'] ?? reels[reelIndex]['comments'];
          int count = 0;
          if (val is int) {
            count = val;
          } else if (val is List) {
            count = val.length;
          } else if (val is String) {
            count = int.tryParse(val) ?? 0;
          }
          reels[reelIndex]['commentCount'] = count + 1;
          reels[reelIndex] = reels[reelIndex];
        }
      } else {
        showCustomSnackBar("Failed to add comment", isError: true);
      }
    } catch (e) {
      debugPrint("Error commenting on reel: $e");
    }
  }

  Future<void> replyToComment(
    String reelId,
    String commentId,
    String reply,
  ) async {
    if (reelId.isEmpty || commentId.isEmpty || reply.trim().isEmpty) return;
    try {
      var response = await ApiClient.postData(
        ApiUrl.commentPostReply(postId: reelId, commentId: commentId),
        jsonEncode({"comment": reply}),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;

        fetchAllReels();
        // Immediately update comments list from response data to show the reply instantly
        if (body['data'] != null && body['data']['comments'] != null) {
          final List list = body['data']['comments'];
          currentComments.assignAll(
            list.map((e) => e as Map<String, dynamic>).toList(),
          );
        } else {
          // Fallback
          getReelInteractions(reelId);
        }
      } else {
        showCustomSnackBar("Failed to add reply", isError: true);
      }
    } catch (e) {
      debugPrint("Error replying to comment: $e");
    }
  }

  Future<void> deleteComment(String reelId, String commentId) async {
    if (reelId.isEmpty || commentId.isEmpty) return;
    try {
      var response = await ApiClient.deleteData(
        ApiUrl.deleteComment(postId: reelId, commentId: commentId),
      );
      if (response.statusCode == 200) {
        // Refresh comments
        fetchAllReels();
        getReelInteractions(reelId);
      } else {
        showCustomSnackBar("Failed to delete comment", isError: true);
      }
    } catch (e) {
      debugPrint("Error deleting comment: $e");
    }
  }

  Future<void> deleteReel(String reelId) async {
    if (reelId.isEmpty) return;
    try {
      var response = await ApiClient.deleteData(
        ApiUrl.deletePost(postId: reelId),
      );
      if (response.statusCode == 200) {
        showCustomSnackBar("Reel deleted successfully", isError: false);
        fetchAllReels();
        reels.removeWhere(
          (element) => element['_id'] == reelId || element['id'] == reelId,
        );
      } else {
        showCustomSnackBar("Failed to delete reel", isError: true);
      }
    } catch (e) {
      debugPrint("Error deleting reel: $e");
    }
  }
}

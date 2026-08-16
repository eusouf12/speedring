import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../service/api_client.dart';
import '../../../../../../../../service/api_url.dart';
import '../../../../../../../../utils/ToastMsg/toast_message.dart';

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
      // Use the new Posts API with category=REEL
      var response = await ApiClient.getData(
        ApiUrl.getAllPosts(page: 1, limit: 10, category: "REEL"),
      );
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
      final Map<String, dynamic> bodyData = {
        "category": "REEL",
        "visibility": "Public",
        "clubPostDetails": {"title": title, "details": description},
      };

      Map<String, String> fields = {'data': jsonEncode(bodyData)};

      List<MultipartBody> multipartBody = [MultipartBody('media', videoFile)];

      var response = await ApiClient.postMultipartData(
        ApiUrl.createPost,
        fields,
        multipartBody: multipartBody,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        showCustomSnackBar("Reel created successfully", isError: false);
        Get.back(); // Go back to Reels screen
        fetchAllReels(); // Refresh the list
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
    final bool isCurrentlyLiked = reel['isLiked'] ?? false;
    final int currentLikes = reel['likes'] ?? 0;

    // Optimistic update
    reel['isLiked'] = !isCurrentlyLiked;
    reel['likes'] = isCurrentlyLiked ? (currentLikes - 1) : (currentLikes + 1);
    reels[index] = reel; // trigger Rx update

    // Call API
    reactToReel(
      reel['_id'] ?? reel['id'] ?? '',
      "LIKE",
      index,
      isCurrentlyLiked,
      currentLikes,
    );
  }

  Future<void> reactToReel(
    String reelId,
    String reactType,
    int index,
    bool previousLikedState,
    int previousLikes,
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
          reels[index]['isLiked'] = previousLikedState;
          reels[index]['likes'] = previousLikes;
          reels[index] = reels[index];
        }
        showCustomSnackBar("Failed to react to reel", isError: true);
      }
    } catch (e) {
      debugPrint("Error reacting to reel: $e");
    }
  }

  void toggleBookmark(int index) {
    if (index < 0 || index >= reels.length) return;
    final reel = reels[index];
    final bool isBookmarked = reel['isBookmarked'] ?? false;
    reel['isBookmarked'] = !isBookmarked;
    reels[index] = reel;
    // Add API call for bookmark if available in the backend later
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
        // Increment comment count locally
        if (reelIndex >= 0 && reelIndex < reels.length) {
          int count = reels[reelIndex]['comments'] ?? 0;
          reels[reelIndex]['comments'] = count + 1;
          reels[reelIndex] = reels[reelIndex];
        }
        // Refresh comments
        getReelInteractions(reelId);
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
        // Refresh comments
        getReelInteractions(reelId);
      } else {
        showCustomSnackBar("Failed to add reply", isError: true);
      }
    } catch (e) {
      debugPrint("Error replying to comment: $e");
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

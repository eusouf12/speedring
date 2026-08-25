import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../model/profile_model.dart';
import '../../Home/Screen/HomeScreen/model/post_model.dart';
import 'package:speedring/helper/guest_checker.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import '../../Home/Screen/HomeScreen/controller/home_controller.dart';

class SingleProfileController extends GetxController {
  final _activeTab = 0.obs;
  int get activeTab => _activeTab.value;
  set activeTab(int val) => _activeTab.value = val;

  final Rx<ProfileData?> profileData = Rx<ProfileData?>(null);
  final RxBool isLoading = false.obs;

  late String targetUserId;

  @override
  void onInit() {
    super.onInit();
    targetUserId = Get.arguments as String;
    getProfile(targetUserId);
    getVehicles(targetUserId);
    getPosts(targetUserId);
  }

  Future<void> getProfile(String userId) async {
    isLoading.value = true;
    try {
      final response = await ApiClient.getData("/users/singleUser/$userId");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body['data'];
        if (data != null) {
          profileData.value = ProfileData.fromJson(data);
        }
      } else {
        debugPrint('Failed to load user profile: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error getting user profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ================= VEHICLES =================
  final RxList<Vehicle> vehicles = <Vehicle>[].obs;
  int vehiclePage = 1;
  final RxBool isVehicleLoadingMore = false.obs;
  final RxBool isVehicleLoading = false.obs;
  bool hasNextVehiclePage = true;

  Future<void> getVehicles(String userId, {bool isLoadMore = false}) async {
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
        ApiUrl.getUserVehicles(userId: userId, page: vehiclePage),
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
      }
    } catch (e) {
      debugPrint('Error fetching vehicles: $e');
    } finally {
      isVehicleLoading.value = false;
      isVehicleLoadingMore.value = false;
    }
  }

  // ================= POSTS =================
  final RxList<PostModel> posts = <PostModel>[].obs;
  int postPage = 1;
  final RxBool isPostLoadingMore = false.obs;
  final RxBool isPostLoading = false.obs;
  bool hasNextPostPage = true;

  Future<void> getPosts(String userId, {bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (!hasNextPostPage || isPostLoadingMore.value) return;
      postPage++;
      isPostLoadingMore.value = true;
    } else {
      postPage = 1;
      hasNextPostPage = true;
      isPostLoading.value = true;
    }

    try {
      final response = await ApiClient.getData(
        ApiUrl.getUserPosts(userId: userId, page: postPage, limit: 10),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final meta = response.body['meta'];
        if (meta != null) {
          final totalPages = meta['totalPage'] ?? 1;
          hasNextPostPage = postPage < totalPages;
        }

        final data = response.body['data'];
        if (data != null && data is List) {
          final fetchedPosts = data.map((e) => PostModel.fromJson(e)).toList();
          if (isLoadMore) {
            posts.addAll(fetchedPosts);
          } else {
            posts.assignAll(fetchedPosts);
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching posts: $e');
    } finally {
      isPostLoading.value = false;
      isPostLoadingMore.value = false;
    }
  }

  void toggleLikeLocally(String postId) {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final old = posts[index];
      final isReacted = old.isReacted ?? false;
      final count = old.reactCount ?? 0;
      final newReacted = !isReacted;
      final newCount = isReacted ? (count > 0 ? count - 1 : 0) : count + 1;

      posts[index] = PostModel(
        id: old.id,
        category: old.category,
        visibility: old.visibility,
        status: old.status,
        user: old.user,
        club: old.club,
        clubPostDetails: old.clubPostDetails,
        businessPostDetails: old.businessPostDetails,
        sessionDetails: old.sessionDetails,
        spotDetails: old.spotDetails,
        trackUpdateDetails: old.trackUpdateDetails,
        media: old.media,
        reacts: old.reacts,
        commentCount: old.commentCount,
        reactCount: newCount,
        isReacted: newReacted,
        myReactType: old.myReactType,
        comments: old.comments,
        createdAt: old.createdAt,
        updatedAt: old.updatedAt,
      );
    }
  }

  void updatePostFromJson(String postId, Map<String, dynamic> json) {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      posts[index] = PostModel.fromJson(json);
    }
  }

  Future<void> toggleFollow() async {
    if (GuestChecker.showLoginDialogIfGuest()) return;
    final currentStatus = profileData.value?.isFollow ?? false;
    final newStatus = !currentStatus;

    // Optimistic update on profile
    profileData.value?.isFollow = newStatus;
    profileData.refresh();

    try {
      final res = await ApiClient.patchData(
        ApiUrl.toggleFollow(userId: targetUserId),
        jsonEncode({}),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        // Sync the feed: update all posts by this user in HomeController.postsList
        _syncFeedFollowStatus(targetUserId, newStatus);
      } else {
        // Revert on fail
        profileData.value?.isFollow = currentStatus;
        profileData.refresh();
        showCustomSnackBar("Failed to follow/unfollow user", isError: true);
      }
    } catch (e) {
      // Revert on error
      profileData.value?.isFollow = currentStatus;
      profileData.refresh();
    }
  }

  /// Updates the isFollow status on all posts in the feed by [userId]
  void _syncFeedFollowStatus(String userId, bool newIsFollow) {
    try {
      final homeCtrl = Get.find<HomeController>();
      bool changed = false;
      for (int i = 0; i < homeCtrl.postsList.length; i++) {
        final post = homeCtrl.postsList[i];
        if (post.user?.id == userId) {
          post.user?.isFollow = newIsFollow;
          changed = true;
        }
      }
      if (changed) homeCtrl.postsList.refresh();
    } catch (_) {
      // HomeController may not be registered yet — safe to ignore
    }
  }
}

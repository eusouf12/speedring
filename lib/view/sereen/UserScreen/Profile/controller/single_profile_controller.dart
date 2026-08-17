import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../service/api_client.dart';
import '../../../../../service/api_url.dart';
import '../model/profile_model.dart';
import '../../Home/Screen/HomeScreen/model/post_model.dart';

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
}

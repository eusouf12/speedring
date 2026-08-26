import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import 'package:speedring/view/sereen/UserScreen/Home/Screen/HomeScreen/controller/home_controller.dart';
import 'package:speedring/view/sereen/UserScreen/Profile/controller/profile_controller.dart';

class FollowUserModel {
  final String id;
  final String name;
  final String userName;
  final String profileImage;
  final String role;
  bool isFollow;

  FollowUserModel({
    required this.id,
    required this.name,
    required this.userName,
    required this.profileImage,
    required this.role,
    required this.isFollow,
  });

  factory FollowUserModel.fromJson(Map<String, dynamic> json) {
    return FollowUserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      userName: json['userName'] ?? '',
      profileImage: json['profileImage'] ?? '',
      role: json['role'] ?? '',
      isFollow: json['isFollow'] ?? false,
    );
  }
}

class ShareController extends GetxController {
  RxList<Map<String, dynamic>> followingList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredList = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  RxBool isSending = false.obs;

  // State for FollowListScreen
  var isFollowUsersLoading = true.obs;
  var followUsersList = <FollowUserModel>[].obs;
  var followPage = 1;
  var hasMoreFollowUsers = true.obs;
  var isFollowLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFollowingList();
  }

  Future<void> fetchFollowingList() async {
    isLoading.value = true;
    try {
      var response = await ApiClient.getData(ApiUrl.getMyFollowing);
      if (response.statusCode == 200) {
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;
        if (body['data'] != null) {
          final List list = body['data'];
          followingList.assignAll(
            list.map((e) => e as Map<String, dynamic>).toList(),
          );
          filteredList.assignAll(followingList);
        }
      }
    } catch (e) {
      debugPrint("Error fetching following: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void searchFriends(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(followingList);
    } else {
      filteredList.assignAll(
        followingList.where((user) {
          final name = (user['name'] ?? user['userName'] ?? '')
              .toString()
              .toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList(),
      );
    }
  }

  Future<bool> sendShareMessage(String targetUserId, String messageText) async {
    isSending.value = true;
    try {
      // 1. Access or create chat
      var chatResponse = await ApiClient.postData(
        ApiUrl.accessChat,
        jsonEncode({"targetId": targetUserId}),
      );

      if (chatResponse.statusCode != 200 && chatResponse.statusCode != 201) {
        showCustomSnackBar("Failed to access chat", isError: true);
        return false;
      }

      final chatBody = chatResponse.body is String
          ? jsonDecode(chatResponse.body)
          : chatResponse.body;
      final chatId = chatBody['data']['_id'];

      // 2. Send message
      var msgResponse = await ApiClient.postData(
        ApiUrl.sendMessage,
        jsonEncode({"chatId": chatId, "content": messageText}),
      );

      if (msgResponse.statusCode == 200 || msgResponse.statusCode == 201) {
        showCustomSnackBar("Sent successfully", isError: false);
        return true;
      } else {
        showCustomSnackBar("Failed to send message", isError: true);
        return false;
      }
    } catch (e) {
      debugPrint("Error sharing message: $e");
      showCustomSnackBar("An error occurred", isError: true);
      return false;
    } finally {
      isSending.value = false;
    }
  }

  // ================= Follow List Logic ================= //

  Future<void> fetchFollowUsers(String userId, String listType) async {
    isFollowUsersLoading.value = true;
    followPage = 1;
    String url = listType == 'followers'
        ? ApiUrl.getUserFollowers(userId)
        : ApiUrl.getUserFollowing(userId);

    url += "?page=$followPage&limit=20";

    final response = await ApiClient.getData(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.body is String
          ? jsonDecode(response.body)
          : response.body;
      final List list = body['data'] ?? [];
      followUsersList.value = list.map((e) {
        var user = FollowUserModel.fromJson(e);
        return user;
      }).toList();

      final meta = body['meta'];
      if (meta != null) {
        hasMoreFollowUsers.value = followPage < (meta['totalPage'] ?? 1);
      }
    }
    isFollowUsersLoading.value = false;
  }

  Future<void> loadMoreFollowUsers(String userId, String listType) async {
    if (isFollowLoadingMore.value || !hasMoreFollowUsers.value) return;
    isFollowLoadingMore.value = true;
    followPage++;

    String url = listType == 'followers'
        ? ApiUrl.getUserFollowers(userId)
        : ApiUrl.getUserFollowing(userId);

    url += "?page=$followPage&limit=20";

    final response = await ApiClient.getData(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.body is String
          ? jsonDecode(response.body)
          : response.body;
      final List list = body['data'] ?? [];
      final newUsers = list.map((e) {
        var user = FollowUserModel.fromJson(e);
        return user;
      }).toList();
      followUsersList.addAll(newUsers);

      final meta = body['meta'];
      if (meta != null) {
        hasMoreFollowUsers.value = followPage < (meta['totalPage'] ?? 1);
      } else {
        hasMoreFollowUsers.value = false;
      }
    }
    isFollowLoadingMore.value = false;
  }

  Future<void> toggleFollowUser(String targetUserId, {String? listType}) async {
    try {
      // Optimistic UI update
      int index = followUsersList.indexWhere((u) => u.id == targetUserId);
      FollowUserModel? removedUser;

      if (index != -1) {
        if (listType == 'following') {
          removedUser = followUsersList.removeAt(index);
        } else {
          followUsersList[index].isFollow = !followUsersList[index].isFollow;
        }
        followUsersList.refresh();
      }

      final response = await ApiClient.patchData(
        ApiUrl.toggleFollow(userId: targetUserId),
        jsonEncode({}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success, nothing to do here as UI is optimistically updated.
        // Refresh home posts if registered
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().getPost();
        }
        // Refresh profile if registered
        if (Get.isRegistered<ProfileScreenController>()) {
          Get.find<ProfileScreenController>().getMyProfile();
        }
      } else {
        // Revert UI update if failed
        if (listType == 'following' && removedUser != null) {
          followUsersList.insert(index, removedUser);
        } else if (index != -1 && listType != 'following') {
          followUsersList[index].isFollow = !followUsersList[index].isFollow;
        }
        followUsersList.refresh();
        showCustomSnackBar("Failed to follow/unfollow user", isError: true);
      }
    } catch (e) {
      // Revert UI update if failed
      int index = followUsersList.indexWhere((u) => u.id == targetUserId);
      if (listType == 'following') {
        // We can't easily revert if we don't have the removed user, but we'll try to refetch
        fetchFollowUsers(targetUserId, listType!); // fallback
      } else if (index != -1) {
        followUsersList[index].isFollow = !followUsersList[index].isFollow;
        followUsersList.refresh();
      }
      showCustomSnackBar(e.toString(), isError: true);
    }
  }
}

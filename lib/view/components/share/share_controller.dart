import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';

class ShareController extends GetxController {
  RxList<Map<String, dynamic>> followingList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredList = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  RxBool isSending = false.obs;

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
      filteredList.assignAll(followingList.where((user) {
        final name = (user['name'] ?? user['userName'] ?? '').toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList());
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
        jsonEncode({
          "chatId": chatId,
          "content": messageText,
        }),
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
}

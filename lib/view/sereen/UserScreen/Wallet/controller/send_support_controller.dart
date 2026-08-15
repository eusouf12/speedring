import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import '../../../../../core/app_routes/app_routes.dart';

class SendSupportController extends GetxController {
  RxList<Map<String, dynamic>> followingList = <Map<String, dynamic>>[].obs;
  Rx<Map<String, dynamic>?> selectedUser = Rx<Map<String, dynamic>?>(null);

  final TextEditingController amountController = TextEditingController();
  RxDouble supportAmount = 0.0.obs;

  RxBool isLoading = false.obs;
  RxBool isSending = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFollowingList();
    amountController.addListener(() {
      supportAmount.value = double.tryParse(amountController.text) ?? 0.0;
    });
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
          if (followingList.isNotEmpty) {
            selectedUser.value = followingList.first;
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching following: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void proceedToVerification() {
    if (selectedUser.value == null) {
      showCustomSnackBar("Select a user to support", isError: true);
      return;
    }
    if (supportAmount.value <= 0) {
      showCustomSnackBar("Enter a valid amount", isError: true);
      return;
    }
    Get.toNamed(AppRoutes.transactionVerificationScreen);
  }

  Future<void> confirmAndSendSupport() async {
    if (selectedUser.value == null || supportAmount.value <= 0) return;

    isSending.value = true;
    try {
      var response = await ApiClient.postData(ApiUrl.supportDriver, jsonEncode({
        "recipientId": selectedUser.value!['_id'],
        "amount": supportAmount.value,
      }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.offNamed(AppRoutes.transactionReportScreen);
      } else {
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;
        showCustomSnackBar(
          body['message'] ?? "Failed to send support",
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar("An error occurred", isError: true);
    } finally {
      isSending.value = false;
    }
  }
}

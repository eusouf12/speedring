import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import 'package:speedring/utils/app_const/app_const.dart';
import 'package:speedring/helper/shared_prefe/shared_prefe.dart';
import 'package:speedring/service/socket_service.dart';
import '../model/message_model.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class InboxController extends GetxController {
  final String chatId;
  InboxController({required this.chatId});

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final TextEditingController messageController = TextEditingController();
  String? currentUserId;

  @override
  void onInit() {
    super.onInit();
    _loadUserIdAndFetchMessages();
  }

  @override
  void onClose() {
    SocketApi.emit('leave_chat', chatId);
    SocketApi.off('receive_message');
    messageController.dispose();
    super.onClose();
  }

  Future<void> _loadUserIdAndFetchMessages() async {
    currentUserId = await SharePrefsHelper.getString(AppConstants.userId);
    final token = await SharePrefsHelper.getString(AppConstants.bearerToken);
    
    // Initialize socket connection
    SocketApi.init(ApiUrl.socketUrl, currentUserId ?? "", token: token);
    
    await fetchMessages();

    // Join socket room
    SocketApi.emit('join_chat', chatId);
    SocketApi.on('receive_message', (data) {
      debugPrint("Inbox received message: $data");
      try {
        final newMsg = MessageModel.fromJson(data);
        if (newMsg.chat == chatId) {
          messages.add(newMsg);
        }
      } catch (e) {
        debugPrint("Error parsing incoming message: $e");
      }
    });
  }

  Future<void> fetchMessages() async {
    isLoading.value = true;
    try {
      var response = await ApiClient.getData(ApiUrl.allMessages(chatId));
      if (response.statusCode == 200) {
        var data = response.body['data'] as List;
        messages.value = data
            .map((json) => MessageModel.fromJson(json))
            .toList();
      } else {
        showCustomSnackBar("Failed to load messages", isError: true);
      }
    } catch (e) {
      showCustomSnackBar("Error: $e", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage({File? imageFile}) async {
    final text = messageController.text.trim();
    if (text.isEmpty && imageFile == null) return;

    isSending.value = true;
    try {
      final token = await SharePrefsHelper.getString(AppConstants.bearerToken);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiUrl.baseUrl + ApiUrl.sendMessage),
      );
      final authHeader = token.startsWith('Bearer ') ? token : 'Bearer $token';
      request.headers.addAll({'Authorization': authHeader});
      request.fields['chatId'] = chatId;
      if (text.isNotEmpty) {
        request.fields['content'] = text;
      }

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('files', imageFile.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint("====> Send Message API Response: [${response.statusCode}]");
      debugPrint("====> Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        messageController.clear();
        try {
          final responseBody = jsonDecode(response.body);
          if (responseBody['data'] != null) {
            final newMsg = MessageModel.fromJson(responseBody['data']);
            // Add immediately for snappier UI, but check to avoid duplicates from socket
            if (!messages.any((m) => m.id == newMsg.id)) {
              messages.add(newMsg);
            }
          }
        } catch (e) {
          debugPrint("Failed to parse sent message: $e");
        }
      } else {
        showCustomSnackBar("Failed to send message", isError: true);
      }
    } catch (e) {
      showCustomSnackBar("Error sending message: $e", isError: true);
    } finally {
      isSending.value = false;
    }
  }
}

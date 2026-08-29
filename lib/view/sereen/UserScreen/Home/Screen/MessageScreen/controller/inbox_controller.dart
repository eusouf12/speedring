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
import '../model/chat_model.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class InboxController extends GetxController {
  final String chatId;
  InboxController({required this.chatId});

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  String? currentUserId;

  @override
  void onInit() {
    super.onInit();
    _loadUserIdAndFetchMessages();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onReceiveMessage(dynamic data) {
    debugPrint("Inbox received message: $data");
    try {
      final newMsg = MessageModel.fromJson(data);
      if (newMsg.chat == chatId) {
        if (!messages.any((m) => m.id == newMsg.id)) {
          // Also remove any dummy text messages that match
          messages.removeWhere((m) => m.id?.startsWith('temp_') == true && m.content == newMsg.content);
          messages.add(newMsg);
        }
        
        scrollToBottom();

        // Mark as seen immediately if we are in this chat
        if (newMsg.id != null) {
          SocketApi.emit('mark_seen', {'messageId': newMsg.id, 'chatId': chatId});
        }
      }
    } catch (e) {
      debugPrint("Error parsing incoming message: $e");
    }
  }

  Future<void> _loadUserIdAndFetchMessages() async {
    currentUserId = await SharePrefsHelper.getString(AppConstants.userId);
    final token = await SharePrefsHelper.getString(AppConstants.bearerToken);
    
    // Initialize socket connection
    SocketApi.init(ApiUrl.socketUrl, currentUserId ?? "", token: token);
    
    await fetchMessages();
    scrollToBottom();

    // Join socket room
    SocketApi.emit('join_chat', chatId);
    SocketApi.on('receive_message', _onReceiveMessage);
  }

  @override
  void onClose() {
    SocketApi.emit('leave_chat', chatId);
    SocketApi.off('receive_message', _onReceiveMessage);
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
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

    // Optimistic UI: append dummy message and clear text immediately
    if (text.isNotEmpty) {
      final dummyMessage = MessageModel(
        id: "temp_${DateTime.now().millisecondsSinceEpoch}",
        content: text,
        chat: chatId,
        sender: ChatUser(id: currentUserId), 
      );
      messages.add(dummyMessage);
      messageController.clear();
      scrollToBottom();
    }

    if (imageFile != null) {
      isSending.value = true;
    }
    
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
        try {
          final responseBody = jsonDecode(response.body);
          if (responseBody['data'] != null) {
            final newMsg = MessageModel.fromJson(responseBody['data']);
            if (!messages.any((m) => m.id == newMsg.id)) {
              // Remove any dummy message with the same content (to prevent duplication of text messages)
              messages.removeWhere((m) => m.id?.startsWith('temp_') == true && m.content == newMsg.content);
              messages.add(newMsg);
              scrollToBottom();
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

  Future<void> blockUser(String targetUserId) async {
    try {
      var response = await ApiClient.postData('/users/block/$targetUserId', "{}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("User block status updated", isError: false);
      } else {
        showCustomSnackBar("Failed to block user", isError: true);
      }
    } catch (e) {
      showCustomSnackBar("Error: $e", isError: true);
    }
  }

  Future<void> clearChat() async {
    try {
      var response = await ApiClient.postData('/chats/clear-chat/$chatId', "{}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        messages.clear();
        showCustomSnackBar("Chat cleared successfully", isError: false);
      } else {
        showCustomSnackBar("Failed to clear chat", isError: true);
      }
    } catch (e) {
      showCustomSnackBar("Error: $e", isError: true);
    }
  }

  Future<void> deleteMessage(String messageId, {bool deleteForEveryone = false}) async {
    try {
      var response = await ApiClient.postData('/messages/delete-message/$messageId', jsonEncode({
        "deleteForEveryone": deleteForEveryone,
      }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        messages.removeWhere((m) => m.id == messageId);
        showCustomSnackBar("Message deleted", isError: false);
      } else {
        showCustomSnackBar("Failed to delete message", isError: true);
      }
    } catch (e) {
      showCustomSnackBar("Error: $e", isError: true);
    }
  }
}

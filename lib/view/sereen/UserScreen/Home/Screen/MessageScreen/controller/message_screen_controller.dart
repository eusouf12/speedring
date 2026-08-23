import 'package:get/get.dart';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import 'package:speedring/utils/app_const/app_const.dart';
import 'package:speedring/helper/shared_prefe/shared_prefe.dart';
import 'package:speedring/service/socket_service.dart';
import '../model/chat_model.dart';
import 'package:flutter/foundation.dart';

class MessageScreenController extends GetxController {
  final RxList<ChatModel> chats = <ChatModel>[].obs;
  final RxBool isLoading = false.obs;
  String? currentUserId;

  @override
  void onInit() {
    super.onInit();
    _loadUserIdAndFetchChats();
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    SocketApi.on('receive_message', (data) {
      debugPrint("MessageScreenController received message: $data");
      fetchChats(); // Quick refresh when new message arrives
    });
  }

  Future<void> _loadUserIdAndFetchChats() async {
    currentUserId = await SharePrefsHelper.getString(AppConstants.userId);
    final token = await SharePrefsHelper.getString(AppConstants.bearerToken);
    SocketApi.init(ApiUrl.socketUrl, currentUserId ?? "", token: token);
    fetchChats();
  }

  Future<void> fetchChats({String query = ""}) async {
    isLoading.value = true;
    try {
      final endpoint = query.isNotEmpty ? "${ApiUrl.allChats}?search=$query" : ApiUrl.allChats;
      var response = await ApiClient.getData(endpoint);
      if (response.statusCode == 200) {
        var data = response.body['data'] as List;
        chats.value = data.map((json) => ChatModel.fromJson(json)).toList();
      } else {
        showCustomSnackBar("Failed to fetch chats", isError: true);
      }
    } catch (e) {
      showCustomSnackBar("An error occurred: $e", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    // Basic local debounce could be added here, for now directly fetch
    fetchChats(query: query);
  }

  ChatUser? getOtherUser(ChatModel chat) {
    if (chat.isGroupChat == true || chat.users == null) return null;
    try {
      return chat.users!.firstWhere((u) => u.id != currentUserId);
    } catch (e) {
      return null;
    }
  }
}

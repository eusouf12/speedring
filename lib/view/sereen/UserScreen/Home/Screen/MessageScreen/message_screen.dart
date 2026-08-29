import 'package:flutter/material.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/share/share_controller.dart';
import 'package:speedring/view/components/custom_netwrok_image/custom_network_image.dart';
import '../../../../../../core/app_routes/app_routes.dart';
import 'controller/message_screen_controller.dart';
import 'package:intl/intl.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessageScreenController>();
    final ShareController shareController = Get.find<ShareController>();

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: const Text(
            "MESSAGES",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                await shareController.fetchFollowingList();
                shareController.searchFriends(''); // reset search
                Get.toNamed(AppRoutes.newMessageScreen);
              },
              icon: const Icon(
                Icons.edit_note,
                color: AppColors.yellow,
                size: 24,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            /// Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff151515),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white38, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        onChanged: controller.onSearchChanged,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Search drivers or chats...",
                          hintStyle: TextStyle(
                            color: Colors.white24,
                            fontSize: 13,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// Chats List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.yellow),
                  );
                }

                if (controller.chats.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Chats Found",
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: controller.chats.length,
                  itemBuilder: (context, index) {
                    final chat = controller.chats[index];
                    final otherUser = controller.getOtherUser(chat);

                    final displayImage = chat.isGroupChat == true
                        ? "https://ui-avatars.com/api/?name=${chat.chatName}&background=random"
                        : (otherUser?.profileImage ??
                              "https://ui-avatars.com/api/?name=User");

                    final displayName = chat.isGroupChat == true
                        ? (chat.chatName ?? "Group")
                        : (otherUser?.name ?? "Unknown");

                    final displayUsername = chat.isGroupChat == true
                        ? ""
                        : "@${otherUser?.userName ?? ""}";

                    final content = chat.latestMessage?.content;
                    final latestMessage = (content != null && content.isNotEmpty)
                        ? content
                        : (chat.latestMessage?.imageUrl != null ? "Sent an image" : "");
                    String latestMessageText = latestMessage;
                    if (chat.latestMessage?.senderName != null &&
                        latestMessageText.isNotEmpty) {
                      latestMessageText =
                          "${chat.latestMessage!.senderName}: $latestMessageText";
                    }
                    final isOnline =
                        chat.isGroupChat != true &&
                        otherUser?.isOnline == true;
                    final isOffline = chat.isGroupChat != true && !isOnline;

                    final isUnread = chat.latestMessage != null &&
                        chat.latestMessage?.sender != controller.currentUserId &&
                        (chat.latestMessage?.readBy == null ||
                            !chat.latestMessage!.readBy!.contains(controller.currentUserId));

                    String displayTime = "";
                    if (chat.createdAt != null) {
                      try {
                        DateTime parsedTime = DateTime.parse(
                          chat.createdAt!,
                        ).toLocal();
                        displayTime = DateFormat('hh:mm a').format(parsedTime);
                      } catch (e) {
                        displayTime = chat.createdAt!.length > 16
                            ? chat.createdAt!.substring(11, 16)
                            : "";
                      }
                    }

                    return ListTile(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.inboxScreen,
                          arguments: {
                            'chatId': chat.id,
                            'userName': displayName,
                            'avatarUrl': displayImage,
                            'isOnline': isOnline,
                            'userId': otherUser?.id,
                          },
                        )?.then((_) {
                          controller.fetchChats();
                        });
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: Stack(
                        children: [
                          CustomNetworkImage(
                            imageUrl: displayImage,
                            boxShape: BoxShape.circle,
                            height: 48,
                            width: 48,
                          ),
                          if (isOnline || isOffline)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: isOnline ? Colors.green : Colors.grey,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    displayName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (displayUsername.isNotEmpty) ...[
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      displayUsername,
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Text(
                            displayTime,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          latestMessageText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isUnread ? Colors.white : Colors.white70,
                            fontSize: 13,
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

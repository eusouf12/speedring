import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_netwrok_image/custom_network_image.dart';
import '../../../../../../utils/navigation_utils.dart';
import 'controller/inbox_controller.dart';
import 'package:speedring/view/components/custom_loader/custom_loader.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'video_player_screen.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  late final InboxController controller;
  late final String userName;
  late final String avatarUrl;
  late final bool isOnline;
  late final String? userId;
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final chatId = args['chatId'] ?? '';
    userName = args['userName'] ?? 'Chat';
    avatarUrl = args['avatarUrl'] ?? '';
    isOnline = args['isOnline'] ?? false;
    userId = args['userId'];

    controller = Get.put(InboxController(chatId: chatId), tag: chatId);
  }

  Future<void> _pickMedia(bool isVideo) async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = isVideo
        ? await picker.pickVideo(source: ImageSource.gallery)
        : await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _selectedFile = File(file.path);
      });
    }
  }

  void _sendMessage() {
    controller.sendMessage(imageFile: _selectedFile);
    setState(() {
      _selectedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,

        /// ── AppBar ─────────────────────────────────────────────────────────
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          titleSpacing: 0,
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (userId != null) {
                    NavigationUtils.navigateToUserProfile(userId!);
                  }
                },
                child: avatarUrl.isNotEmpty
                    ? CustomNetworkImage(
                        imageUrl: avatarUrl,
                        boxShape: BoxShape.circle,
                        height: 40,
                        width: 40,
                      )
                    : const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xff1A1A1A),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isOnline)
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "activeNow".tr,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.info_outline, color: Colors.white70),
              color: const Color(0xff1A1A1A),
              onSelected: (value) {
                if (value == 'block') {
                  Get.defaultDialog(
                    title: "blockUser".tr,
                    middleText: "areYouSureBlock".tr,
                    textConfirm: "yes".tr,
                    textCancel: "no".tr,
                    confirmTextColor: Colors.white,
                    buttonColor: AppColors.primary,
                    onConfirm: () {
                      Get.back();
                      controller.blockUser(userId ?? "");
                    },
                  );
                } else if (value == 'delete') {
                  Get.defaultDialog(
                    title: "deleteChat".tr,
                    middleText: "areYouSureDeleteChat".tr,
                    textConfirm: "yes".tr,
                    textCancel: "no".tr,
                    confirmTextColor: Colors.white,
                    buttonColor: AppColors.primary,
                    onConfirm: () {
                      Get.back();
                      controller.clearChat();
                    },
                  );
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    "deleteChat".tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                PopupMenuItem(
                  value: 'block',
                  child: Text(
                    "blockUser".tr,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            ),
          ],
        ),

        /// ── Body ───────────────────────────────────────────────────────────
        body: Column(
          children: [
            /// Message List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CustomLoader());
                }

                if (controller.messages.isEmpty) {
                  return Center(
                    child: Text(
                      "startNewChat".tr,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  reverse: false,
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    final isMe = msg.sender?.id == controller.currentUserId;
                    final text = msg.content ?? "";
                    final time = msg.createdAt != null
                        ? msg.createdAt!.substring(11, 16)
                        : "";

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (!isMe) ...[
                                CircleAvatar(
                                  radius: 14,
                                  backgroundImage:
                                      msg.sender?.profileImage != null
                                      ? NetworkImage(msg.sender!.profileImage!)
                                      : const NetworkImage(
                                          "https://ui-avatars.com/api/?name=User",
                                        ),
                                  backgroundColor: const Color(0xff1A1A1A),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Flexible(
                                child: GestureDetector(
                                  onLongPress: msg.isDeletedForEveryone == true ? null : () {
                                    Get.bottomSheet(
                                      Material(
                                        color: const Color(0xff1A1A1A),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                          child: SafeArea(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Center(
                                                  child: Container(
                                                    width: 40,
                                                    height: 5,
                                                    margin: const EdgeInsets.only(bottom: 20),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white24,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "deleteMessage".tr,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  "areYouSureDeleteMsg".tr,
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 24),
                                                if (isMe)
                                                  ListTile(
                                                    onTap: () {
                                                      Get.back();
                                                      controller.deleteMessage(
                                                        msg.id!,
                                                        deleteForEveryone: true,
                                                      );
                                                    },
                                                    leading: Container(
                                                      padding: const EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        color: Colors.redAccent.withValues(alpha: 0.1),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(Icons.delete_forever, color: Colors.redAccent),
                                                    ),
                                                    title: Text(
                                                      "deleteForEveryone".tr,
                                                      style: const TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.w600),
                                                    ),
                                                    contentPadding: EdgeInsets.zero,
                                                  ),
                                                ListTile(
                                                  onTap: () {
                                                    Get.back();
                                                    controller.deleteMessage(
                                                      msg.id!,
                                                      deleteForEveryone: false,
                                                    );
                                                  },
                                                  leading: Container(
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: const BoxDecoration(
                                                      color: Colors.white10,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(Icons.delete_outline, color: Colors.white),
                                                  ),
                                                  title: Text(
                                                    "deleteForMe".tr,
                                                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                                  ),
                                                  contentPadding: EdgeInsets.zero,
                                                ),
                                                const SizedBox(height: 8),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: (msg.isDeletedForEveryone != true && (msg.imageUrl != null || msg.videoUrl != null)) ? 4 : 16,
                                      vertical: (msg.isDeletedForEveryone != true && (msg.imageUrl != null || msg.videoUrl != null)) ? 4 : 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isMe
                                          ? AppColors.yellow
                                          : const Color(0xff1A1A1A),
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(20),
                                        topRight: const Radius.circular(20),
                                        bottomLeft: Radius.circular(
                                          isMe ? 20 : 4,
                                        ),
                                        bottomRight: Radius.circular(
                                          isMe ? 4 : 20,
                                        ),
                                      ),
                                      border: msg.isDeletedForEveryone == true
                                          ? Border.all(color: Colors.white24)
                                          : null,
                                    ),
                                    child: msg.isDeletedForEveryone == true
                                        ? Text(
                                            isMe ? "youUnsentMessage".tr : "thisMessageWasUnsent".tr,
                                            style: TextStyle(
                                              color: isMe ? Colors.black54 : Colors.white54,
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          )
                                        : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (msg.imageUrl != null || msg.videoUrl != null) ...[
                                          GestureDetector(
                                            onTap: () {
                                              if (msg.videoUrl != null) {
                                                Get.to(() => VideoPlayerScreen(videoUrl: msg.videoUrl!));
                                              } else {
                                                Get.to(
                                                  () => Scaffold(
                                                    backgroundColor: Colors.black,
                                                    appBar: AppBar(
                                                      backgroundColor: Colors.black,
                                                      iconTheme: const IconThemeData(color: Colors.white),
                                                    ),
                                                    body: Center(
                                                      child: InteractiveViewer(
                                                        child: Image.network(msg.imageUrl!),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(isMe ? 18 : 4),
                                              child: msg.videoUrl != null
                                                  ? Container(
                                                      width: 150,
                                                      height: 150,
                                                      color: Colors.black87,
                                                      child: const Center(
                                                        child: Icon(Icons.play_circle_outline, color: Colors.white, size: 40),
                                                      ),
                                                    )
                                                  : Image.network(
                                                      msg.imageUrl!,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                          if (text.isNotEmpty) const SizedBox(height: 8),
                                        ],
                                        if (text.isNotEmpty)
                                          Padding(
                                            padding: (msg.imageUrl != null || msg.videoUrl != null)
                                                ? const EdgeInsets.only(left: 8, right: 8, bottom: 4)
                                                : EdgeInsets.zero,
                                            child: Text(
                                              text,
                                              style: TextStyle(
                                                color: isMe ? Colors.black : Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: EdgeInsets.only(
                              left: isMe ? 0 : 36,
                              right: isMe ? 4 : 0,
                            ),
                            child: Row(
                              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                              children: [
                                Text(
                                  time,
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (isMe) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    (msg.readBy != null && msg.readBy!.contains(userId)) ? Icons.done_all : Icons.check,
                                    size: 14,
                                    color: (msg.readBy != null && msg.readBy!.contains(userId)) ? Colors.blue : Colors.white38,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),

            /// Message Input Area
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(
                  top: BorderSide(color: Colors.white10, width: 1),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    if (_selectedFile != null)
                      Stack(
                        children: [
                          Container(
                            height: 100,
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade900,
                              image: !_selectedFile!.path.endsWith('.mp4')
                                  ? DecorationImage(
                                      image: FileImage(_selectedFile!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _selectedFile!.path.endsWith('.mp4')
                                ? const Center(
                                    child: Icon(
                                      Icons.videocam,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  )
                                : null,
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedFile = null;
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              Material(
                                color: const Color(0xff1A1A1A),
                                child: SafeArea(
                                  child: Wrap(
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.image, color: Colors.white),
                                          title: Text('image'.tr, style: const TextStyle(color: Colors.white)),
                                          onTap: () {
                                            Get.back();
                                            _pickMedia(false);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.videocam, color: Colors.white),
                                          title: Text('video'.tr, style: const TextStyle(color: Colors.white)),
                                          onTap: () {
                                            Get.back();
                                            _pickMedia(true);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            );
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xff1A1A1A),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white54,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff1A1A1A),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: controller.messageController,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "typeMessage".tr,
                                      hintStyle: const TextStyle(
                                        color: Colors.white38,
                                        fontSize: 14,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Obx(() {
                          if (controller.isSending.value) {
                            return const SizedBox(
                              width: 40,
                              height: 40,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.yellow,
                                ),
                              ),
                            );
                          }
                          return GestureDetector(
                            onTap: _sendMessage,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                color: AppColors.yellow,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.send,
                                color: Colors.black,
                                size: 18,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

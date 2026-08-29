import os

file_path = r'c:\Users\Eusouf\Projects\Speeding\speedring\lib\view\sereen\UserScreen\Home\Screen\MessageScreen\inbox_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Imports
content = content.replace("import 'package:image_picker/image_picker.dart';", "import 'package:image_picker/image_picker.dart';\nimport 'video_player_screen.dart';")

# 2. _selectedImage to _selectedFile & _pickMedia
content = content.replace('File? _selectedImage;', 'File? _selectedFile;')
content = content.replace('''  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }''', '''  Future<void> _pickMedia(bool isVideo) async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = isVideo
        ? await picker.pickVideo(source: ImageSource.gallery)
        : await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _selectedFile = File(file.path);
      });
    }
  }''')

# 3. sendMessage
content = content.replace('controller.sendMessage(imageFile: _selectedImage);', 'controller.sendMessage(imageFile: _selectedFile);')
content = content.replace('_selectedImage = null;', '_selectedFile = null;')
content = content.replace('if (_selectedImage != null)', 'if (_selectedFile != null)')
content = content.replace('image: FileImage(_selectedImage!),', 'image: FileImage(_selectedFile!),')

# 4. Input area preview video
content = content.replace('''                              image: DecorationImage(
                                image: FileImage(_selectedFile!),
                                fit: BoxFit.cover,
                              ),''', '''                              color: Colors.grey.shade900,
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
                                : null,''')

# 5. Input area pick Media
content = content.replace('''GestureDetector(
                          onTap: _pickImage,''', '''GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              Material(
                                color: Colors.transparent,
                                child: Container(
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
                              ),
                            );
                          },''')

content = content.replace('decoration: const InputDecoration(', 'decoration: InputDecoration(')
content = content.replace('hintStyle: TextStyle(', 'hintStyle: const TextStyle(')
content = content.replace('contentPadding: EdgeInsets.symmetric(', 'contentPadding: const EdgeInsets.symmetric(')
content = content.replace('"Type a message..."', '"typeMessage".tr')

# 6. Active Now
content = content.replace('''                    if (isOnline)
                      const Text(
                        "Active now",
                        style: TextStyle(color: Colors.white54, fontSize: 11),
                      ),''', '''                    if (isOnline)
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
                      ),''')

# 7. PopupMenuButton
content = content.replace('''            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.info_outline, color: Colors.white70),
            ),''', '''            PopupMenuButton<String>(
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
            ),''')

# 8. Delete message bottom sheet & Video Bubble
bubble_old = '''                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: msg.imageUrl != null ? 4 : 16,
                                    vertical: msg.imageUrl != null ? 4 : 12,
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
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (msg.imageUrl != null) ...[
                                        GestureDetector(
                                          onTap: () {
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
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              isMe ? 18 : 4,
                                            ),
                                            child: Image.network(
                                              msg.imageUrl!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        if (text.isNotEmpty) const SizedBox(height: 8),
                                      ],
                                      if (text.isNotEmpty)
                                        Padding(
                                          padding: msg.imageUrl != null
                                              ? const EdgeInsets.only(left: 8, right: 8, bottom: 4)
                                              : EdgeInsets.zero,
                                          child: Text(
                                            text,
                                            style: TextStyle(
                                              color: isMe
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),'''

bubble_new = '''                                child: GestureDetector(
                                  onLongPress: () {
                                    Get.bottomSheet(
                                      Material(
                                        color: Colors.transparent,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                          decoration: const BoxDecoration(
                                            color: Color(0xff1A1A1A),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
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
                                                        color: Colors.redAccent.withOpacity(0.1),
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
                                      horizontal: (msg.imageUrl != null || msg.videoUrl != null) ? 4 : 16,
                                      vertical: (msg.imageUrl != null || msg.videoUrl != null) ? 4 : 12,
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
                                    ),
                                    child: Column(
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
                                ),'''
content = content.replace(bubble_old, bubble_new)

# 9. Time logic
time_old = '''                            child: Text(
                              time,
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),'''
time_new = '''                            child: Row(
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
                            ),'''
content = content.replace(time_old, time_new)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

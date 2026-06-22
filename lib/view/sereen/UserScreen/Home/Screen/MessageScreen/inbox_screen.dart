import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../../../core/app_routes/app_routes.dart';

class InboxScreen extends StatefulWidget {
  final String userName;
  final String avatarUrl;
  final bool isOnline;

  const InboxScreen({
    super.key,
    required this.userName,
    required this.avatarUrl,
    required this.isOnline,
  });

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  late final List<Map<String, dynamic>> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      {
        "text": "Hey! Did you check out my latest lap session video?",
        "isMe": false,
        "time": "10:30 AM",
        "likes": 0,
        "loves": 0,
        "isLiked": false,
        "isLoved": false,
      },
      {
        "text": "Yeah, your line through Maggotts was spot on. Very smooth transition.",
        "isMe": true,
        "time": "10:32 AM",
        "likes": 0,
        "loves": 0,
        "isLiked": false,
        "isLoved": false,
      },
      {
        "text": "Thanks! I've been experimenting with the rebound settings on the front damper.",
        "isMe": false,
        "time": "10:35 AM",
        "likes": 0,
        "loves": 0,
        "isLiked": false,
        "isLoved": false,
      },
      {
        "text": "Are you experiencing higher thermal deg in the Bus Stop chicane?",
        "isMe": false,
        "time": "10:36 AM",
        "likes": 2,
        "loves": 8,
        "isLiked": false,
        "isLoved": false,
      },
      {
        "text": "Definitely! I'll register my session on the app. Let's compare telemetry data after the run.",
        "isMe": true,
        "time": "10:38 AM",
        "likes": 0,
        "loves": 0,
        "isLiked": false,
        "isLoved": false,
      },
    ];
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
              Stack(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(widget.avatarUrl),
                    backgroundColor: const Color(0xff1A1A1A),
                  ),
                  if (widget.isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.isOnline ? "Online" : "Offline",
                    style: TextStyle(
                      color: widget.isOnline ? Colors.green : Colors.white30,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.info_outline, color: Colors.white70),
            ),
          ],
        ),
      
        /// ── Body ───────────────────────────────────────────────────────────
        body: Column(
          children: [
            const Divider(color: Colors.white10, height: 1),
      
            /// Message List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isMe = msg["isMe"] == true;
      
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      decoration: BoxDecoration(
                        color: isMe ? AppColors.yellow : const Color(0xff1A1A1A),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isMe ? 16 : 4),
                          bottomRight: Radius.circular(isMe ? 4 : 16),
                        ),
                        border: isMe ? null : Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg["text"],
                            style: TextStyle(
                              color: isMe ? Colors.black : Colors.white,
                              fontSize: 12.5,
                              fontWeight: isMe ? FontWeight.w700 : FontWeight.w500,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            msg["time"],
                            style: TextStyle(
                              color: isMe ? Colors.black45 : Colors.white30,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (!isMe) ...[
                            const SizedBox(height: 8),
                            if (msg["likes"] > 0 || msg["loves"] > 0) ...[
                              Row(
                                children: [
                                  if (msg["likes"] > 0) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff2A2A2A),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.thumb_up, color: Colors.white70, size: 12),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${msg["likes"]}",
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  if (msg["loves"] > 0) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff2A2A2A),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.favorite, color: Colors.white70, size: 12),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${msg["loves"]}",
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                            const Divider(color: Colors.white10, height: 1),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      msg["isLiked"] = !msg["isLiked"];
                                      if (msg["isLiked"]) {
                                        msg["likes"] += 1;
                                      } else {
                                        msg["likes"] -= 1;
                                      }
                                    });
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        msg["isLiked"] ? Icons.thumb_up : Icons.thumb_up_outlined,
                                        color: msg["isLiked"] ? AppColors.yellow : Colors.white70,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "LIKE",
                                        style: TextStyle(
                                          color: msg["isLiked"] ? AppColors.yellow : Colors.white70,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      msg["isLoved"] = !msg["isLoved"];
                                      if (msg["isLoved"]) {
                                        msg["loves"] += 1;
                                      } else {
                                        msg["loves"] -= 1;
                                      }
                                    });
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        msg["isLoved"] ? Icons.favorite : Icons.favorite_border,
                                        color: msg["isLoved"] ? Colors.red : Colors.white70,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "LOVE",
                                        style: TextStyle(
                                          color: msg["isLoved"] ? Colors.red : Colors.white70,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(
                                      AppRoutes.supportMemberScreen,
                                      arguments: {
                                        "userName": widget.userName,
                                        "avatarUrl": widget.avatarUrl,
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.yellow, width: 1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: AppColors.yellow,
                                            shape: BoxShape.circle,
                                          ),
                                          padding: const EdgeInsets.all(1.5),
                                          child: const Icon(
                                            Icons.star,
                                            color: Colors.black,
                                            size: 9,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Text(
                                          "SUPPORT",
                                          style: TextStyle(
                                            color: AppColors.yellow,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      
            /// Input field bar
            Container(
              padding: EdgeInsets.fromLTRB(
                16,
                8,
                16,
                MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: const BoxDecoration(
                color: Color(0xff0A0A0A),
                border: Border(top: BorderSide(color: Colors.white10)),
              ),
              child: Row(
                children: [
                  /// Attachment
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xff151515),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white70, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
      
                  /// Text Field Box
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xff151515),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
      
                  /// Send Button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.yellow,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.black, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

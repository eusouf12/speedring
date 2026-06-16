import 'package:flutter/material.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';

class InboxScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> messages = [
      {
        "text": "Hey! Did you check out my latest lap session video?",
        "isMe": false,
        "time": "10:30 AM"
      },
      {
        "text": "Yeah, your line through Maggotts was spot on. Very smooth transition.",
        "isMe": true,
        "time": "10:32 AM"
      },
      {
        "text": "Thanks! I've been experimenting with the rebound settings on the front damper.",
        "isMe": false,
        "time": "10:35 AM"
      },
      {
        "text": "Are you down for the Silverstone track day next weekend?",
        "isMe": false,
        "time": "10:36 AM"
      },
      {
        "text": "Definitely! I'll register my session on the app. Let's compare telemetry data after the run.",
        "isMe": true,
        "time": "10:38 AM"
      },
    ];

    return Scaffold(
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
                  backgroundImage: NetworkImage(avatarUrl),
                  backgroundColor: const Color(0xff1A1A1A),
                ),
                if (isOnline)
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
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isOnline ? "Online" : "Offline",
                  style: TextStyle(
                    color: isOnline ? Colors.green : Colors.white30,
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
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg["isMe"] == true;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
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
    );
  }
}

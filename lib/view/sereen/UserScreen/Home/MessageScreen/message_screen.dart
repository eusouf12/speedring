import 'package:flutter/material.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'inbox_screen.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> chats = [
      {
        "name": "Alex Racer",
        "username": "@alex_racer",
        "lastMsg": "Are you down for the Silverstone track day next weekend?",
        "time": "12m ago",
        "unreadCount": 2,
        "isOnline": true,
        "avatarUrl": "https://picsum.photos/seed/alex/100/100"
      },
      {
        "name": "Speed Master",
        "username": "@speedmaster",
        "lastMsg": "That lap time was absolutely insane! How did you optimize Copse?",
        "time": "1h ago",
        "unreadCount": 0,
        "isOnline": true,
        "avatarUrl": "https://picsum.photos/seed/speedmaster/100/100"
      },
      {
        "name": "Clara Ferrari",
        "username": "@clara_f",
        "lastMsg": "Just posted the specifications for the new suspension setup.",
        "time": "4h ago",
        "unreadCount": 0,
        "isOnline": false,
        "avatarUrl": "https://picsum.photos/seed/clara/100/100"
      },
      {
        "name": "Track King",
        "username": "@track_king",
        "lastMsg": "We need to check the tyre pressures before the next session.",
        "time": "Yesterday",
        "unreadCount": 0,
        "isOnline": false,
        "avatarUrl": "https://picsum.photos/seed/trackking/100/100"
      },
    ];

    return Scaffold(
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
            onPressed: () {},
            icon: const Icon(Icons.edit_note, color: AppColors.yellow, size: 24),
          ),
        ],
      ),
      body: Column(
        children: [
          /// Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
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
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: "Search drivers or chats...",
                        hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
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
            child: ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1, indent: 70),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InboxScreen(
                          userName: chat["name"],
                          avatarUrl: chat["avatarUrl"],
                          isOnline: chat["isOnline"],
                        ),
                      ),
                    );
                  },
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(chat["avatarUrl"]),
                        backgroundColor: const Color(0xff1A1A1A),
                      ),
                      if (chat["isOnline"])
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat["name"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        chat["time"],
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat["lastMsg"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (chat["unreadCount"] > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.yellow,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              chat["unreadCount"].toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

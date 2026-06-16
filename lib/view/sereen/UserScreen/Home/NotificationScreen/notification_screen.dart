import 'package:flutter/material.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          "NOTIFICATIONS",
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
            icon: const Icon(Icons.done_all, color: AppColors.yellow, size: 20),
            tooltip: "Mark all as read",
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: const [
          _SectionHeader(title: "TODAY"),
          _NotificationItem(
            icon: Icons.speed,
            iconColor: AppColors.yellow,
            title: "Lap Time Beaten",
            description: "Your best lap time of 61:28.442 at Silverstone was beaten by @speedmaster (61:27.108).",
            time: "2h ago",
            isUnread: true,
          ),
          _NotificationItem(
            icon: Icons.favorite,
            iconColor: Colors.redAccent,
            title: "New Like",
            description: "@alex_racer and 4 others liked your spot post: Ferrari SF90 Stradale.",
            time: "4h ago",
            isUnread: true,
          ),
          _NotificationItem(
            icon: Icons.comment,
            iconColor: Colors.blueAccent,
            title: "New Comment",
            description: "@track_king commented: 'What tyre pressure did you run on the hot lap?'",
            time: "6h ago",
            isUnread: false,
          ),

          _SectionHeader(title: "YESTERDAY"),
          _NotificationItem(
            icon: Icons.flag,
            iconColor: Colors.orangeAccent,
            title: "Track Hazard Cleared",
            description: "Yellow flag cleared at Silverstone Circuit (Grand Prix Loop). Surface condition is now DRY.",
            time: "1d ago",
            isUnread: false,
          ),
          _NotificationItem(
            icon: Icons.group_add,
            iconColor: Colors.greenAccent,
            title: "Club Invitation",
            description: "@Scuderia Club invited you to join their private weekend track run.",
            time: "1d ago",
            isUnread: false,
            hasAction: true,
            actionLabel: "VIEW INVITE",
          ),

          _SectionHeader(title: "THIS WEEK"),
          _NotificationItem(
            icon: Icons.workspace_premium,
            iconColor: AppColors.yellow,
            title: "Account Verified",
            description: "Congratulations! Your driver profile has been successfully verified. You now have the verified badge.",
            time: "4d ago",
            isUnread: false,
          ),
          _NotificationItem(
            icon: Icons.work,
            iconColor: Colors.purpleAccent,
            title: "Business Update",
            description: "Apex Tuning updated their pricing catalog for Precision Suspension Services.",
            time: "6d ago",
            isUnread: false,
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 10, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String time;
  final bool isUnread;
  final bool hasAction;
  final String? actionLabel;

  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.time,
    required this.isUnread,
    this.hasAction = false,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUnread ? const Color(0xff151515) : const Color(0xff0d0d0d),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnread ? AppColors.yellow.withOpacity(0.15) : Colors.white10,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Status / Unread indicator dot
          if (isUnread)
            Container(
              margin: const EdgeInsets.only(top: 6, right: 8),
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.yellow,
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(width: 14),

          /// Icon Container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),

          /// Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
                if (hasAction && actionLabel != null) ...[
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        actionLabel!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}

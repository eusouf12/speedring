import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.userName,
    required this.location,
    required this.imageUrl,
    required this.caption,
    this.profileImage,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onMore,
  });

  final String userName;
  final String location;
  final String imageUrl;
  final String caption;
  final String? profileImage;

  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xff1C1C1C),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Header
            ListTile(
              leading: CircleAvatar(
                backgroundImage: profileImage != null
                    ? NetworkImage(profileImage!)
                    : null,
                child: profileImage == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              title: Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                location,
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: GestureDetector(
                onTap: onMore,
                child: const Icon(Icons.more_horiz, color: Colors.white),
              ),
            ),

            /// Post Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 12),

            /// Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onLike,
                    child: const Icon(Icons.favorite_border, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: onComment,
                    child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: onShare,
                    child: const Icon(Icons.share, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// Caption
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                caption,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

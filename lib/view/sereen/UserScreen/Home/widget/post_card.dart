import 'package:flutter/material.dart';
import '../../../../../utils/navigation_utils.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.userName,
    required this.location,
    required this.imageUrl,
    required this.caption,
    this.userId,
    this.profileImage,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onMore,
    this.reactCount,
    this.commentCount,
    this.isLiked = false,
    this.detailsWidget,
  });

  final String userName;
  final String location;
  final String imageUrl;
  final String caption;
  final String? userId;
  final String? profileImage;
  final int? reactCount;
  final int? commentCount;
  final bool isLiked;
  final Widget? detailsWidget;

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
              leading: GestureDetector(
                onTap: () => NavigationUtils.navigateToUserProfile(userId),
                child: CircleAvatar(
                  backgroundImage: profileImage != null
                      ? NetworkImage(profileImage!)
                      : null,
                  child: profileImage == null ? const Icon(Icons.person) : null,
                ),
              ),
              title: GestureDetector(
                onTap: () => NavigationUtils.navigateToUserProfile(userId),
                child: Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              subtitle: Text(
                location,
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: onMore != null
                  ? GestureDetector(
                      onTap: onMore,
                      child: const Icon(Icons.more_horiz, color: Colors.white),
                    )
                  : null,
            ),

            /// Post Image
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),

            const SizedBox(height: 12),

            if (detailsWidget != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: detailsWidget!,
              ),

            /// caption
            if (caption.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  caption,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            /// Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: onLike,
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.white,
                        ),
                      ),
                      if (reactCount != null && reactCount! > 0) ...[
                        const SizedBox(width: 6),
                        Text(
                          "$reactCount",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(width: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: onComment,
                        child: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                        ),
                      ),
                      if (commentCount != null && commentCount! > 0) ...[
                        const SizedBox(width: 6),
                        Text(
                          "$commentCount",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: onShare,
                    child: const Icon(Icons.share, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

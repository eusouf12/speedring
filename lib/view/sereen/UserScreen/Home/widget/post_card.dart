import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_netwrok_image/custom_network_image.dart';
import '../../../../../utils/navigation_utils.dart';
import '../../../../../helper/guest_checker.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.userName,
    required this.location,
    required this.imageUrl,
    required this.caption,
    this.mediaType,
    this.userId,
    this.profileImage,
    this.onTap,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onMore,
    this.onProfileTap,
    this.onFollow,
    this.isFollow,
    this.reactCount,
    this.commentCount,
    this.isLiked = false,
    this.detailsWidget,
    this.subtitleWidget,
  });

  final String userName;
  final String location;
  final String imageUrl;
  final String caption;
  final String? mediaType;
  final String? userId;
  final String? profileImage;
  final int? reactCount;
  final int? commentCount;
  final bool isLiked;
  final Widget? detailsWidget;
  final Widget? subtitleWidget;

  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onMore;
  final VoidCallback? onProfileTap;
  final VoidCallback? onFollow;
  final bool? isFollow;

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
                onTap: onProfileTap ?? () => NavigationUtils.navigateToUserProfile(userId),
                child: CircleAvatar(
                  backgroundImage: profileImage != null
                      ? NetworkImage(profileImage!)
                      : null,
                  child: profileImage == null ? const Icon(Icons.person) : null,
                ),
              ),
              title: Row(
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: onProfileTap ?? () => NavigationUtils.navigateToUserProfile(userId),
                      child: Text(
                        userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  if (isFollow == false && onFollow != null) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        if (GuestChecker.showLoginDialogIfGuest()) return;
                        onFollow!();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'follow'.tr,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              subtitle: subtitleWidget ?? Text(
                location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: onMore != null
                  ? GestureDetector(
                      onTap: onMore,
                      child: const Icon(Icons.more_horiz, color: Colors.white),
                    )
                  : null,
            ),

            /// Post Image or Video
            if (imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: mediaType == 'video'
                    ? _InlineVideoPlayer(videoUrl: imageUrl)
                    : CustomNetworkImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
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
                        onTap: () {
                          if (GuestChecker.showLoginDialogIfGuest()) return;
                          if (onLike != null) onLike!();
                        },
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
                        onTap: () {
                          if (GuestChecker.showLoginDialogIfGuest()) return;
                          if (onComment != null) onComment!();
                        },
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

class _InlineVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const _InlineVideoPlayer({required this.videoUrl});

  @override
  State<_InlineVideoPlayer> createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<_InlineVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
        _controller.setVolume(0.0);
      }).catchError((e) {
        debugPrint('Error initializing inline video: $e');
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: Colors.amber),
        ),
      );
    }
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) {
          _controller.play();
        } else {
          _controller.pause();
        }
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(_controller),
              if (!_controller.value.isPlaying)
                const Icon(
                  Icons.play_circle_fill,
                  color: Colors.white70,
                  size: 50,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import '../../controller/reels_controller.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final ReelsController controller = Get.put(ReelsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Reels vertical page view
          Obx(() {
            if (controller.reels.isEmpty) {
              return Center(
                child: Text(
                  "NO_REELS_AVAILABLE_YET".tr,
                  style: const TextStyle(color: Colors.white60, fontSize: 16),
                ),
              );
            }
            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: controller.reels.length,
              itemBuilder: (context, index) {
                return ReelItemWidget(
                  index: index,
                  reelData: controller.reels[index],
                  controller: controller,
                );
              },
            );
          }),

          // Premium App Header Overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button with circular blur background
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                // Title
                Text(
                  "REELS".tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                // Create Reel button
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.createReelScreen),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.yellow.withValues(alpha: 0.4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.black,
                      size: 20,
                    ),
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

class ReelItemWidget extends StatefulWidget {
  final int index;
  final Map<String, dynamic> reelData;
  final ReelsController controller;

  const ReelItemWidget({
    super.key,
    required this.index,
    required this.reelData,
    required this.controller,
  });

  @override
  State<ReelItemWidget> createState() => _ReelItemWidgetState();
}

class _ReelItemWidgetState extends State<ReelItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  bool _isPlaying = true;
  bool _showPlayPauseIndicator = false;
  bool _showDoubleTapLikeAnimation = false;

  @override
  void initState() {
    super.initState();
    // Simulate video playing progress (15 seconds loop)
    _progressController =
        AnimationController(vsync: this, duration: const Duration(seconds: 15))
          ..addListener(() {
            setState(() {});
          });
    _progressController.repeat();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _progressController.stop();
      } else {
        _progressController.repeat();
      }
      _isPlaying = !_isPlaying;
      _showPlayPauseIndicator = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _showPlayPauseIndicator = false;
        });
      }
    });
  }

  void _handleDoubleTap() {
    if (!widget.reelData['isLiked']) {
      widget.controller.toggleLike(widget.index);
    }
    setState(() {
      _showDoubleTapLikeAnimation = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showDoubleTapLikeAnimation = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLiked = widget.reelData['isLiked'] ?? false;
    final bool isBookmarked = widget.reelData['isBookmarked'] ?? false;

    return GestureDetector(
      onTap: _togglePlayPause,
      onDoubleTap: _handleDoubleTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Reel simulated video background (high resolution motor image)
          Image.network(
            widget.reelData['videoUrl'] ??
                widget.reelData['imageUrl'] ??
                'https://picsum.photos/400/800',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.grey[900]),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.yellow),
                ),
              );
            },
          ),

          // Dark gradient overlays for readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.54),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.85),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.25, 0.7, 1.0],
              ),
            ),
          ),

          // Double Tap Like Animation Overlay
          if (_showDoubleTapLikeAnimation)
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value * 1.5,
                    child: Opacity(
                      opacity: value > 0.8 ? (1.0 - value) / 0.2 : 1.0,
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.red,
                        size: 80,
                      ),
                    ),
                  );
                },
              ),
            ),

          // Play/Pause Status Indicator Overlay
          if (_showPlayPauseIndicator)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isPlaying ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),

          // Bottom Left: Content details (User, Description, Sound)
          Positioned(
            left: 16,
            bottom: 30,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // User info row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white24,
                      backgroundImage: NetworkImage(
                        widget.reelData['user']?['profileImage'] ??
                            widget.reelData['avatar'] ??
                            'https://via.placeholder.com/150',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "@${widget.reelData['user']?['name'] ?? widget.reelData['username']}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.yellow, width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "FOLLOW".tr,
                        style: const TextStyle(
                          color: AppColors.yellow,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Caption
                Text(
                  widget.reelData['videoDetails']?['title'] ??
                      widget.reelData['caption'] ??
                      '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                // Music Track info
                Row(
                  children: [
                    const Icon(
                      Icons.music_note_rounded,
                      color: Colors.white70,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: SizedBox(
                        height: 20,
                        child: Text(
                          widget.reelData['videoDetails']?['description'] ??
                              widget.reelData['musicName'] ??
                              "ORIGINAL_SOUND".tr,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Right: Actions bar (Like, Comment, Share, Bookmark)
          Positioned(
            right: 16,
            bottom: 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Like Button
                _buildActionButton(
                  icon: isLiked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isLiked ? Colors.red : Colors.white,
                  label: _formatCount(widget.reelData['likes']),
                  onTap: () => widget.controller.toggleLike(widget.index),
                ),
                const SizedBox(height: 18),

                // Comment Button
                _buildActionButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  color: Colors.white,
                  label: _formatCount(widget.reelData['comments']),
                  onTap: () => _showCommentsSheet(context),
                ),
                const SizedBox(height: 18),

                // Share Button
                _buildActionButton(
                  icon: Icons.send_rounded,
                  color: Colors.white,
                  label: _formatCount(
                    widget.reelData['shareCount'] ??
                        widget.reelData['shares'] ??
                        0,
                  ),
                  onTap: () {
                    Get.snackbar(
                      "SHARED".tr,
                      "REEL_LINK_COPIED".tr,
                      backgroundColor: Colors.black87,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
                const SizedBox(height: 18),
                // // Delete Button
                // _buildActionButton(
                //   icon: Icons.delete_outline,
                //   color: Colors.red,
                //   label: "DELETE".tr,
                //   onTap: () {
                //     if (widget.reelData['_id'] != null) {
                //       widget.controller.deleteReel(widget.reelData['_id']);
                //     }
                //   },
                // ),
                // const SizedBox(height: 18),

                // Bookmark Button
                _buildActionButton(
                  icon: isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: isBookmarked ? AppColors.yellow : Colors.white,
                  label: "BOOKMARK".tr,
                  onTap: () => widget.controller.toggleBookmark(widget.index),
                ),
                const SizedBox(height: 24),

                // Rotating Vinyl Disk Simulation
                RotationTransition(
                  turns: _progressController,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24, width: 2),
                      gradient: const RadialGradient(
                        colors: [Colors.black, Colors.grey, Colors.black],
                        stops: [0.2, 0.6, 1.0],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.audiotrack_rounded,
                        color: Colors.white70,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Video Progress Bar at the very bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LinearProgressIndicator(
              value: _progressController.value,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.yellow),
              minHeight: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return "${(count / 1000000).toStringAsFixed(1)}M";
    } else if (count >= 1000) {
      return "${(count / 1000).toStringAsFixed(1)}k";
    }
    return count.toString();
  }

  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff121212),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Comments",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Divider(color: Colors.white12, height: 24),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white12,
                          backgroundImage: NetworkImage(
                            "https://picsum.photos/seed/commenter$index/100/100",
                          ),
                        ),
                        title: Text(
                          "Racer_X$index",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        subtitle: Text(
                          "This lap looks incredible! Loving the sound of that engine. 🔥 #Speedring",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Add a comment...",
                            hintStyle: const TextStyle(color: Colors.white38),
                            filled: true,
                            fillColor: Colors.white12,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.send_rounded,
                          color: AppColors.yellow,
                        ),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

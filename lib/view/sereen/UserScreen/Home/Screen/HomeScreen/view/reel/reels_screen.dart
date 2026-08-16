import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../controller/reels_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../model/post_model.dart';
import '../post/comment_screen.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final ReelsController controller = Get.find<ReelsController>();

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Reels vertical page view
            Obx(() {
              if (controller.isLoading.value && controller.reels.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.yellow),
                );
              }
              if (controller.reels.isEmpty) {
                return Center(
                  child: Text(
                    "NO_REELS_AVAILABLE_YET".tr,
                    style: const TextStyle(color: Colors.white60, fontSize: 16),
                  ),
                );
              }
              return PageView.builder(
                controller: PageController(initialPage: 0),
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
                  BackButton(color: AppColors.yellow),
                  // Title
                  Text(
                    "REELS".tr,
                    style: const TextStyle(
                      color: AppColors.yellow,
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
  VideoPlayerController? _videoController;
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  bool _showPlayPauseIndicator = false;
  bool _showDoubleTapLikeAnimation = false;
  bool _isAudioInitialized = false;
  bool _isSeekingAudio = false;
  Duration _lastVideoPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Simulate vinyl record rotation
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
    _initializeVideoPlayer();
    _initializeAudioPlayer();
  }

  void _initializeAudioPlayer() {
    final audioUrl = _getAudioUrl();
    if (audioUrl != null && audioUrl.isNotEmpty) {
      _audioPlayer = AudioPlayer();
      _audioPlayer!
          .setUrl(audioUrl)
          .then((_) {
            _audioPlayer!.setLoopMode(LoopMode.one);
            if (mounted) {
              setState(() {
                _isAudioInitialized = true;
              });
              if (_isPlaying) {
                _audioPlayer!.play();
              }
            }
          })
          .catchError((e) {
            debugPrint("Error loading audio URL ($audioUrl): $e");
          });
    }
  }

  void _syncAudioWithVideo() async {
    if (!mounted || _videoController == null || _audioPlayer == null || !_isAudioInitialized || _isSeekingAudio) return;

    final videoValue = _videoController!.value;
    if (!videoValue.isInitialized) return;

    final isVideoPlaying = videoValue.isPlaying;
    final isAudioPlaying = _audioPlayer!.playing;

    // 1. Sync play/pause state
    if (isVideoPlaying && !isAudioPlaying) {
      _audioPlayer!.play();
    } else if (!isVideoPlaying && isAudioPlaying) {
      _audioPlayer!.pause();
    }

    // 2. Sync seeking only when a major jump is detected (scrubbing or looping)
    final videoPosition = videoValue.position;
    final diffFromLastVideoPos = (videoPosition - _lastVideoPosition).inMilliseconds.abs();
    _lastVideoPosition = videoPosition;

    if (diffFromLastVideoPos > 1200) {
      _isSeekingAudio = true;
      try {
        await _audioPlayer!.seek(videoPosition);
      } catch (e) {
        debugPrint("Error seeking audio: $e");
      } finally {
        _isSeekingAudio = false;
      }
    }
  }

  String? _getAudioUrl() {
    // Check for iTunes music url
    final music = widget.reelData['music'];
    if (music != null &&
        music['url'] != null &&
        music['url'].toString().isNotEmpty) {
      return music['url'];
    }
    // Check for uploaded audio file
    final media = widget.reelData['media'];
    if (media != null && media is List) {
      for (var item in media) {
        if (item['type'] == 'audio') {
          return item['url'];
        }
      }
    }
    return null;
  }

  void _initializeVideoPlayer() {
    final videoUrl = _getVideoUrl();
    if (videoUrl != null && videoUrl.isNotEmpty) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize()
            .then((_) {
              if (mounted) {
                setState(() {});

                // Mute video if we have custom audio
                final audioUrl = _getAudioUrl();
                if (audioUrl != null && audioUrl.isNotEmpty) {
                  _videoController!.setVolume(0.0);
                } else {
                  _videoController!.setVolume(1.0);
                }

                _videoController!.setLooping(true);
                if (_isPlaying) {
                  _videoController!.play();
                }
                
                // Listen to video events to sync audio
                _videoController!.addListener(_syncAudioWithVideo);
              }
            })
            .catchError((e) {
              debugPrint("Error loading video URL ($videoUrl): $e");
            });
    }
  }

  String? _getVideoUrl() {
    final media = widget.reelData['media'];
    if (media != null && media is List && media.isNotEmpty) {
      return media[0]['url'];
    }
    return widget.reelData['videoUrl'];
  }

  @override
  void dispose() {
    _videoController?.removeListener(_syncAudioWithVideo);
    _progressController.dispose();
    _videoController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_videoController != null) {
        if (_videoController!.value.isPlaying) {
          _videoController!.pause();
          _audioPlayer?.pause();
          _isPlaying = false;
        } else {
          _videoController!.play();
          _audioPlayer?.play();
          _isPlaying = true;
        }
      } else if (_audioPlayer != null) {
        // Fallback if there is audio but no video
        if (_audioPlayer!.playing) {
          _audioPlayer!.pause();
          _isPlaying = false;
        } else {
          _audioPlayer!.play();
          _isPlaying = true;
        }
      }
      _showPlayPauseIndicator = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showPlayPauseIndicator = false;
        });
      }
    });
  }

  void _handleDoubleTap(bool isReacted) {
    setState(() {
      _showDoubleTapLikeAnimation = true;
    });

    if (!isReacted) {
      widget.controller.toggleLike(widget.index);
    }

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _showDoubleTapLikeAnimation = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.index >= widget.controller.reels.length)
        return const SizedBox.shrink();
      final reelData = widget.controller.reels[widget.index];
      final bool isReacted = reelData['isReacted'] ?? false;
      final bool isBookmarked = reelData['isBookmarked'] ?? false;
      final String reelUserId =
          reelData['user']?['_id'] ?? reelData['user']?['id'] ?? '';
      final bool isMyReel = widget.controller.myUserId == reelUserId;

      return VisibilityDetector(
        key: Key('reel_${widget.index}'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.8) {
            if (!_isPlaying && mounted) {
              setState(() {
                _isPlaying = true;
                _videoController?.play();
                _audioPlayer?.play();
              });
            }
          } else {
            if (_isPlaying && mounted) {
              setState(() {
                _isPlaying = false;
                _videoController?.pause();
                _audioPlayer?.pause();
              });
            }
          }
        },
        child: GestureDetector(
          onTap: _togglePlayPause,
          onDoubleTap: () => _handleDoubleTap(isReacted),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Actual video rendering
              if (_videoController != null &&
                  _videoController!.value.isInitialized)
                SizedBox.expand(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                )
              else
                Image.network(
                  widget.reelData['imageUrl'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey[900]),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.yellow,
                        ),
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
                      _isPlaying
                          ? Icons.play_arrow_rounded
                          : Icons.pause_rounded,
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
                        if (!isMyReel)
                          GestureDetector(
                            onTap: () => widget.controller.toggleFollow(
                              widget.index,
                              reelUserId,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      (widget.reelData['isFollowing'] == true)
                                      ? Colors.grey
                                      : AppColors.yellow,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                                color: (widget.reelData['isFollowing'] == true)
                                    ? Colors.grey.withValues(alpha: 0.2)
                                    : Colors.transparent,
                              ),
                              child: Text(
                                (widget.reelData['isFollowing'] == true)
                                    ? "FOLLOWING".tr
                                    : "FOLLOW".tr,
                                style: TextStyle(
                                  color:
                                      (widget.reelData['isFollowing'] == true)
                                      ? Colors.white
                                      : AppColors.yellow,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
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
                      icon: isReacted
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isReacted ? Colors.red : Colors.white,
                      label: _formatCount(reelData['reactCount']),
                      onTap: () => widget.controller.toggleLike(widget.index),
                    ),
                    const SizedBox(height: 18),

                    // Comment Button
                    _buildActionButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      color: Colors.white,
                      label: _formatCount(
                        reelData['commentCount'] ?? reelData['comments'],
                      ),
                      onTap: () {
                        widget.controller.getReelInteractions(
                          reelData['_id'] ?? reelData['id'],
                        );
                        showCommentSheet(
                          context,
                          post: PostModel.fromJson(reelData),
                          isReel: true,
                          reelIndex: widget.index,
                        );
                      },
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

                    if (isMyReel)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildActionButton(
                            icon: Icons.delete_outline_rounded,
                            color: Colors.redAccent,
                            label: "DELETE".tr,
                            onTap: () {
                              Get.defaultDialog(
                                title: "DELETE_REEL".tr,
                                middleText: "ARE_YOU_SURE_DELETE_REEL".tr,
                                backgroundColor: Colors.black87,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                middleTextStyle: const TextStyle(
                                  color: Colors.white70,
                                ),
                                confirmTextColor: Colors.white,
                                cancelTextColor: AppColors.yellow,
                                buttonColor: Colors.redAccent,
                                textConfirm: "YES".tr,
                                textCancel: "NO".tr,
                                onConfirm: () {
                                  Get.back();
                                  if (widget.reelData['_id'] != null) {
                                    widget.controller.deleteReel(
                                      widget.reelData['_id'],
                                    );
                                  } else if (widget.reelData['id'] != null) {
                                    widget.controller.deleteReel(
                                      widget.reelData['id'],
                                    );
                                  }
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),

                    // Bookmark Button
                    _buildActionButton(
                      icon: isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: isBookmarked ? AppColors.yellow : Colors.white,
                      label: "BOOKMARK".tr,
                      onTap: () => widget.controller.toggleBookmark(
                        widget.index,
                        widget.reelData['_id'] ?? widget.reelData['id'] ?? '',
                      ),
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
                child:
                    _videoController != null &&
                        _videoController!.value.isInitialized
                    ? VideoProgressIndicator(
                        _videoController!,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: AppColors.yellow,
                          backgroundColor: Colors.white12,
                        ),
                      )
                    : const LinearProgressIndicator(
                        value: 0,
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.yellow,
                        ),
                        minHeight: 2,
                      ),
              ),
            ],
          ),
        ),
      );
    });
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

  String _formatCount(dynamic value) {
    int count = 0;
    if (value is int) {
      count = value;
    } else if (value is String) {
      count = int.tryParse(value) ?? 0;
    } else if (value is List) {
      count = value.length;
    }

    if (count >= 1000000) {
      return "${(count / 1000000).toStringAsFixed(1)}M";
    } else if (count >= 1000) {
      return "${(count / 1000).toStringAsFixed(1)}k";
    }
    return count.toString();
  }
}

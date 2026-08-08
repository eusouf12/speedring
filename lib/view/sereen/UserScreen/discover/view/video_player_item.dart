import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/sereen/UserScreen/discover/model/video_model.dart';
import 'package:speedring/view/sereen/UserScreen/discover/controller/discover_controller.dart';
import 'package:speedring/view/sereen/UserScreen/discover/view/full_screen_video.dart';

class VideoPlayerItem extends StatefulWidget {
  final VideoPost video;
  final bool isMine;
  final String postedTime;

  const VideoPlayerItem({
    super.key,
    required this.video,
    required this.isMine,
    required this.postedTime,
  });

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isExpanded = false;
  bool _hasError = false;
  bool _isInitializing = false;
  final DiscoverController _discoverController = Get.find<DiscoverController>();

  @override
  void initState() {
    super.initState();
    // Video will be initialized lazily when it becomes visible
  }

  Future<void> _initializeVideo() async {
    if (_isInitializing || _isInitialized || _hasError) return;
    if (widget.video.videoUrl == null || widget.video.videoUrl!.isEmpty) return;

    _isInitializing = true;
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.video.videoUrl!),
      );
      await _controller!.initialize();
      _controller!.addListener(() {
        if (mounted) setState(() {});
      });
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isInitializing = false;
        });
      }
    } catch (e) {
      debugPrint("Video init error for ${widget.video.id}: $e");
      if (mounted) {
        setState(() {
          _hasError = true;
          _isInitializing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // formatting elapsed time
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void _togglePlay() {
    if (_controller == null || !_isInitialized) return;
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final details = widget.video.videoDetails;
    final thumbnailUrl = details?.thumbnail ??
        "https://picsum.photos/seed/${widget.video.id ?? 'video'}/600/350";

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Video Player / Thumbnail Stack
          VisibilityDetector(
            key: Key('video_${widget.video.id}'),
            onVisibilityChanged: (visibilityInfo) {
              if (visibilityInfo.visibleFraction > 0.6) {
                // Lazy init: start loading only when visible
                if (!_isInitialized && !_isInitializing && !_hasError) {
                  _initializeVideo();
                }
                if (_isInitialized && _controller != null && !_controller!.value.isPlaying) {
                  _controller!.play();
                }
              } else {
                if (_isInitialized && _controller != null && _controller!.value.isPlaying) {
                  _controller!.pause();
                }
              }
            },
            child: Stack(
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                    image: (!_isInitialized || _controller == null)
                        ? DecorationImage(
                            image: NetworkImage(thumbnailUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _isInitialized && _controller != null
                        ? GestureDetector(
                            onTap: _togglePlay,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: _controller!.value.size.width,
                                height: _controller!.value.size.height,
                                child: VideoPlayer(_controller!),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                // Play/Pause Overlay
                if (_isInitialized && _controller != null && !_controller!.value.isPlaying)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _togglePlay,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),

                if (!_isInitialized || _controller == null)
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),

                // Loading indicator if initializing
                if (_controller != null && !_isInitialized)
                  const Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.yellow),
                    ),
                  ),

                // Classification badge top-left
                if (details?.classification != null)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.yellow.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        details!.classification!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),

                // 3-dot menu for own videos
                if (widget.isMine)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: PopupMenuButton<String>(
                      icon: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      color: const Color(0xff1C1C1C),
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'delete') {
                          _showDeleteDialog(widget.video.id!);
                        }
                      },
                    ),
                  ),

                // Full Screen Button bottom-right
                if (_isInitialized)
                  Positioned(
                    bottom: 12,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => FullScreenVideoScreen(
                              controller: _controller!,
                              videoTitle: details?.title ?? "Video",
                            ));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.fullscreen,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),

                // Play Line (Progress) bottom
                if (_isInitialized && _controller != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 4,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        child: VideoProgressIndicator(
                          _controller!,
                          allowScrubbing: true,
                          colors: const VideoProgressColors(
                            playedColor: AppColors.yellow,
                            bufferedColor: Colors.white24,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Elapsed time
                if (_isInitialized && _controller != null)
                  Positioned(
                    bottom: 12,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _formatDuration(_controller!.value.position),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// Title and Description
          if (details?.title != null)
            Text(
              details!.title!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

          if (details?.description != null && details!.description!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final textSpan = TextSpan(
                      text: details.description!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    );
                    final textPainter = TextPainter(
                      text: textSpan,
                      maxLines: 2,
                      textDirection: TextDirection.ltr,
                    )..layout(maxWidth: constraints.maxWidth);
                    final exceedsMaxLines = textPainter.didExceedMaxLines;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          details.description!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                          maxLines: _isExpanded ? null : 2,
                          overflow: _isExpanded ? null : TextOverflow.ellipsis,
                        ),
                        if (exceedsMaxLines)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                _isExpanded ? "Show less" : "Show more",
                                style: const TextStyle(
                                  color: AppColors.yellow,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),

          const SizedBox(height: 12),

          /// User Info Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white12,
                backgroundImage: widget.video.user?.profileImage != null
                    ? NetworkImage(widget.video.user!.profileImage!)
                    : null,
                child: widget.video.user?.profileImage == null
                    ? const Icon(Icons.person, color: Colors.white54)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.video.user?.name ?? "Unknown",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            "@${widget.video.user?.userName ?? widget.video.user?.name ?? 'Unknown'}",
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.visibility, color: Colors.white38, size: 12),
                        const SizedBox(width: 3),
                        Text(
                          "${widget.video.views ?? 0}",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.postedTime,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Share button
              GestureDetector(
                onTap: () {
                  final link =
                      "https://speedring.com/discover/${widget.video.id}";
                  SharePlus.instance.share(
                    ShareParams(
                      text: "Check out this video on Speedring:\n\n$link",
                      subject: "Speedring Video",
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xff1C1C1C),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.share_outlined,
                    color: Colors.white70,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String id) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xff181818),
        title: const Text(
          "Delete Video",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Are you sure you want to delete this video?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back(); // close dialog
              _discoverController.deleteVideo(id);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}

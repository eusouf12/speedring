import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:video_player/video_player.dart';

import '../../controller/home_controller.dart';
import '../../model/story_model.dart';
import '../../model/view_story_model.dart';

class StoryViewScreen extends StatefulWidget {
  const StoryViewScreen({super.key, required this.storyGroup});

  final StoryUserGroup storyGroup;

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  final TextEditingController _messageCtrl = TextEditingController();
  int currentIndex = 0;
  List<Story> _localStories = [];
  final List<int> _floatingHearts = [];
  int _heartCounter = 0;
  bool _isLikedLocally = false;

  // Audio (background music)
  AudioPlayer? _audioPlayer;

  // Video
  VideoPlayerController? _videoController;
  bool _isVideoReady = false;

  // State flags
  bool _isPausedByLongPress = false;
  bool _isMediaLoading = true;

  // Whether current story is video
  bool get _isVideo {
    if (currentIndex < 0 || currentIndex >= _localStories.length) return false;
    final media = _localStories[currentIndex].media;
    if (media == null || media.isEmpty) return false;
    final type = media.first.type?.toLowerCase() ?? '';
    return type == 'video' || type == 'mp4' || type == 'mov';
  }

  @override
  void initState() {
    super.initState();
    _localStories = List.from(widget.storyGroup.stories ?? []);
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });

    _audioPlayer = AudioPlayer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerStoryView(currentIndex);
      _initMedia(currentIndex);
    });
  }

  // ── Media Initialization ───────────────────────────────────────────────────

  Future<void> _initMedia(int index) async {
    if (!mounted) return;
    setState(() {
      _isMediaLoading = true;
      _isVideoReady = false;
    });

    // Stop previous video
    await _videoController?.pause();
    await _videoController?.dispose();
    _videoController = null;

    // Stop audio
    await _audioPlayer?.stop();

    if (index < 0 || index >= _localStories.length) return;
    final story = _localStories[index];
    final media = story.media;

    if (media != null && media.isNotEmpty) {
      final url = media.first.url ?? '';
      final type = media.first.type?.toLowerCase() ?? '';
      final isVideo = type == 'video' || type == 'mp4' || type == 'mov' ||
          url.endsWith('.mp4') || url.endsWith('.mov');

      if (isVideo && url.isNotEmpty) {
        await _initVideo(url, story);
        return;
      }
    }

    // It's an image — play background music if available
    await _playStoryMusic(story);
    // Image loading handled by CachedNetworkImage callbacks
  }

  Future<void> _initVideo(String url, Story story) async {
    try {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
      await _videoController!.initialize();
      if (!mounted) return;

      final duration = _videoController!.value.duration;
      // Set progress timer to video duration (min 3s, max 30s)
      final seconds = duration.inSeconds.clamp(3, 30).toDouble();
      _progressController.duration = Duration(seconds: seconds.toInt());

      _videoController!.addListener(_onVideoListener);
      _videoController!.setLooping(false);

      setState(() {
        _isVideoReady = true;
        _isMediaLoading = false;
      });

      if (!_isPausedByLongPress) {
        _videoController!.play();
        _progressController.forward();
      }

      // Play background music if story also has music
      await _playStoryMusic(story);
    } catch (e) {
      debugPrint('Video init error: $e');
      if (mounted) {
        setState(() => _isMediaLoading = false);
        if (!_isPausedByLongPress) _progressController.forward();
      }
    }
  }

  void _onVideoListener() {
    if (!mounted) return;
    final controller = _videoController;
    if (controller == null) return;
    if (controller.value.position >= controller.value.duration &&
        controller.value.duration > Duration.zero) {
      _nextStory();
    }
  }

  Future<void> _playStoryMusic(Story story) async {
    try {
      final musicUrl = story.music?.url;
      if (musicUrl != null && musicUrl.isNotEmpty) {
        await _audioPlayer?.setUrl(musicUrl);
        if (!_isPausedByLongPress) {
          await _audioPlayer?.play();
        }
      }
    } catch (e) {
      debugPrint('Music error: $e');
    }
  }

  // Called by CachedNetworkImage when image is fully loaded
  void _onImageLoaded() {
    if (!mounted || !_isMediaLoading) return;
    setState(() => _isMediaLoading = false);
    if (!_isPausedByLongPress) {
      _progressController.duration = const Duration(seconds: 8);
      _progressController.forward();
      _audioPlayer?.play();
    }
  }

  // Called if image fails to load
  void _onImageError() {
    if (!mounted) return;
    setState(() => _isMediaLoading = false);
    if (!_isPausedByLongPress) {
      _progressController.duration = const Duration(seconds: 8);
      _progressController.forward();
    }
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  void _triggerStoryView(int index) {
    if (index >= 0 && index < _localStories.length) {
      final story = _localStories[index];
      if (story.id != null) {
        final homeController = Get.find<HomeController>();
        homeController.postViewStory(story.id!);
      }
    }
  }

  void _nextStory() {
    if (!mounted) return;
    if (currentIndex < _localStories.length - 1) {
      setState(() {
        currentIndex++;
        _isLikedLocally = false;
      });
      _progressController.reset();
      _triggerStoryView(currentIndex);
      _initMedia(currentIndex);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _previousStory() {
    if (!mounted) return;
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        _isLikedLocally = false;
      });
      _progressController.reset();
      _triggerStoryView(currentIndex);
      _initMedia(currentIndex);
    }
  }

  void _pauseAll() {
    _isPausedByLongPress = true;
    _progressController.stop();
    _videoController?.pause();
    _audioPlayer?.pause();
  }

  void _resumeAll() {
    _isPausedByLongPress = false;
    if (!_isMediaLoading) {
      _progressController.forward();
      if (_isVideo && _isVideoReady) _videoController?.play();
      _audioPlayer?.play();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _messageCtrl.dispose();
    _videoController?.removeListener(_onVideoListener);
    _videoController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  // ── Story Viewers Sheet ───────────────────────────────────────────────────

  void _showStoryViewersSheet(BuildContext context, String storyId) {
    final controller = Get.find<HomeController>();
    _pauseAll();
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: const Color(0xff1C1C1C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return FutureBuilder<StoryViewersResponse?>(
          future: controller.getStoryViewers(storyId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 250,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            }
            if (snapshot.hasError || snapshot.data == null) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'Failed to load viewers',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              );
            }

            final viewersData = snapshot.data!.data;
            final viewers = viewersData?.viewers ?? [];

            if (viewers.isEmpty) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'No views yet',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              );
            }

            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Viewers (${viewersData?.viewCount ?? viewers.length})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: viewers.length,
                      itemBuilder: (context, index) {
                        final viewer = viewers[index];
                        final user = viewer.user;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[800],
                            backgroundImage:
                                user?.profileImage != null &&
                                    user!.profileImage!.isNotEmpty
                                ? NetworkImage(user.profileImage!)
                                : null,
                            child: user?.profileImage == null ||
                                    user!.profileImage!.isEmpty
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                          ),
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                user?.name ?? 'User',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (viewer.reaction != null &&
                                  viewer.reaction!.type == 'like') ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.redAccent,
                                  size: 16,
                                ),
                              ],
                            ],
                          ),
                          trailing: Text(
                            _formatViewedTime(viewer.viewedAt),
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      if (mounted && !_progressController.isAnimating && !_isMediaLoading) {
        _resumeAll();
      }
    });
  }

  String _formatViewedTime(DateTime? time) {
    if (time == null) return '';
    final localTime = time.toLocal();
    final diff = DateTime.now().difference(localTime);
    if (diff.isNegative || diff.inSeconds < 60) return 'JUST NOW';
    if (diff.inMinutes < 60) return '${diff.inMinutes}M AGO';
    if (diff.inHours < 24) return '${diff.inHours}H AGO';
    return '${localTime.day}/${localTime.month}';
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final isMyStory =
        widget.storyGroup.user?.id == controller.currentUserId.value;
    final stories = _localStories;
    final currentStory = stories.isNotEmpty ? stories[currentIndex] : null;
    final user = widget.storyGroup.user;

    // Media URL
    String? mediaUrl;
    if (currentStory?.media != null && currentStory!.media!.isNotEmpty) {
      mediaUrl = currentStory.media!.first.url;
    }

    final userName = user?.name ?? 'User';
    final profileImageUrl = user?.profileImage;

    // Time ago
    String timeAgo = '';
    if (currentStory?.createdAt != null) {
      final diff = DateTime.now().difference(currentStory!.createdAt!.toLocal());
      if (diff.isNegative || diff.inSeconds < 60) {
        timeAgo = 'JUST NOW';
      } else if (diff.inMinutes < 60) {
        timeAgo = '${diff.inMinutes}M AGO';
      } else if (diff.inHours < 24) {
        timeAgo = '${diff.inHours}H AGO';
      } else if (diff.inDays < 30) {
        timeAgo = '${diff.inDays}D AGO';
      } else {
        final t = currentStory.createdAt!.toLocal();
        timeAgo = '${t.day}/${t.month}/${t.year}';
      }
    }

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // ── Full-screen media ───────────────────────────────────────────
            Positioned.fill(
              child: GestureDetector(
                onTapDown: (details) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  if (details.globalPosition.dx < screenWidth / 3) {
                    _previousStory();
                  } else {
                    _nextStory();
                  }
                },
                onLongPressStart: (_) => _pauseAll(),
                onLongPressEnd: (_) => _resumeAll(),
                child: _buildMediaWidget(mediaUrl),
              ),
            ),

            // ── Dark gradient overlay ────────────────────────────────────────
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.55),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      stops: const [0.0, 0.25, 0.65, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // ── Loading indicator (while media loads) ───────────────────────
            if (_isMediaLoading)
              const Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),

            // ── Progress bars ───────────────────────────────────────────────
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 12,
              right: 12,
              child: Row(
                children: List.generate(stories.length, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, _) {
                          double value = 0.0;
                          if (index < currentIndex) {
                            value = 1.0;
                          } else if (index == currentIndex) {
                            value = _progressController.value;
                          }
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: value,
                              backgroundColor: Colors.white30,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.yellow,
                              ),
                              minHeight: 2.5,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ),
            ),

            // ── Top bar — avatar + name + close ──────────────────────────────
            Positioned(
              top: MediaQuery.of(context).padding.top + 22,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.yellow, width: 2),
                    ),
                    child: ClipOval(
                      child: profileImageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: profileImageUrl,
                              fit: BoxFit.cover,
                              errorWidget: (_, _, _) => const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.person, color: Colors.white),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Name + time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              timeAgo,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                            if (currentStory?.location?.name != null &&
                                currentStory!.location!.name!.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.location_on,
                                color: AppColors.yellow,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  currentStory.location!.name!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (currentStory?.music?.name != null &&
                            currentStory!.music!.name!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.music_note,
                                color: AppColors.yellow,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  currentStory.music!.name!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Colors.white12,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Bottom bar ─────────────────────────────────────────────────
            Positioned(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).padding.bottom + 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Viewer count (my story)
                  if (isMyStory && currentStory != null)
                    GestureDetector(
                      onTap: () {
                        _progressController.stop();
                        _showStoryViewersSheet(context, currentStory.id!);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.visibility,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${currentStory.viewCount ?? 0}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox.shrink(),

                  // Like / More buttons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isMyStory && currentStory != null) ...[
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              _isLikedLocally = true;
                              _floatingHearts.add(_heartCounter++);
                            });
                            await controller.likeStory(currentStory.id!);
                          },
                          child: Icon(
                            _isLikedLocally
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _isLikedLocally
                                ? Colors.redAccent
                                : Colors.white,
                            size: 26,
                          ),
                        ),
                      ],
                      if (isMyStory) ...[
                        const SizedBox(width: 16),
                        // More (delete) button
                        GestureDetector(
                          onTap: () {
                            _pauseAll();
                            showModalBottomSheet(
                              context: context,
                              useSafeArea: true,
                              backgroundColor: const Color(0xff1C1C1C),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (sheetContext) {
                                return SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 12),
                                      Container(
                                        width: 36,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: Colors.white24,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.redAccent,
                                        ),
                                        title: const Text(
                                          'Delete Story',
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pop(sheetContext, 'delete');
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (dialogContext) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    const Color(0xff1C1C1C),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                title: const Text(
                                                  'Delete Story?',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                content: const Text(
                                                  'Are you sure you want to delete this story?',
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          dialogContext);
                                                      _resumeAll();
                                                    },
                                                    child: const Text(
                                                      'NO',
                                                      style: TextStyle(
                                                        color: Colors.white54,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      Navigator.pop(
                                                          dialogContext);
                                                      if (currentStory?.id !=
                                                          null) {
                                                        bool success =
                                                            await controller
                                                                .deleteStory(
                                                                    currentStory!
                                                                        .id!);
                                                        if (success && mounted) {
                                                          setState(() {
                                                            _localStories
                                                                .removeWhere(
                                                              (s) =>
                                                                  s.id ==
                                                                  currentStory.id,
                                                            );
                                                            if (_localStories
                                                                .isEmpty) {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            } else {
                                                              if (currentIndex >=
                                                                  _localStories
                                                                      .length) {
                                                                currentIndex =
                                                                    _localStories
                                                                            .length -
                                                                        1;
                                                              }
                                                              _progressController
                                                                  .reset();
                                                              _initMedia(
                                                                  currentIndex);
                                                            }
                                                          });
                                                        } else {
                                                          _resumeAll();
                                                        }
                                                      } else {
                                                        _resumeAll();
                                                      }
                                                    },
                                                    child: const Text(
                                                      'YES',
                                                      style: TextStyle(
                                                        color: Colors.redAccent,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                  ),
                                );
                              },
                            ).then((value) {
                              if (value != 'delete') _resumeAll();
                            });
                          },
                          child: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // ── Floating hearts ─────────────────────────────────────────────
            ..._floatingHearts.map((heartId) {
              return Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 26,
                right: 20,
                child: IgnorePointer(
                  child: _FloatingHeartWidget(
                    key: ValueKey(heartId),
                    onAnimationComplete: () {
                      if (mounted) {
                        setState(() => _floatingHearts.remove(heartId));
                      }
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ── Media Widget ──────────────────────────────────────────────────────────

  Widget _buildMediaWidget(String? mediaUrl) {
    if (mediaUrl == null || mediaUrl.isEmpty) {
      return Container(color: const Color(0xff1a1a1a));
    }

    if (_isVideo) {
      return _buildVideoWidget();
    }

    return _buildImageWidget(mediaUrl);
  }

  Widget _buildVideoWidget() {
    if (!_isVideoReady || _videoController == null) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Blurred background
        Container(color: Colors.black),
        // Video centered
        Center(
          child: AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
        ),
      ],
    );
  }

  Widget _buildImageWidget(String imageUrl) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Blurred background
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) =>
                Container(color: const Color(0xff1a1a1a)),
          ),
        ),
        // Dark overlay
        Container(color: Colors.black.withValues(alpha: 0.35)),
        // Main image
        CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          progressIndicatorBuilder: (_, _, _) => const SizedBox.shrink(),
          imageBuilder: (context, imageProvider) {
            // Call after frame so setState is safe
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _onImageLoaded();
            });
            return Image(image: imageProvider, fit: BoxFit.contain);
          },
          errorWidget: (_, _, _) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _onImageError();
            });
            return Container(color: const Color(0xff1a1a1a));
          },
        ),
      ],
    );
  }
}

// ── Floating Heart Animation ────────────────────────────────────────────────

class _FloatingHeartWidget extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const _FloatingHeartWidget({super.key, required this.onAnimationComplete});

  @override
  State<_FloatingHeartWidget> createState() => _FloatingHeartWidgetState();
}

class _FloatingHeartWidgetState extends State<_FloatingHeartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _yAnim;
  late Animation<double> _xAnim;
  late Animation<double> _opacityAnim;
  late Animation<double> _scaleAnim;
  late double _randomX;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _randomX =
        (double.tryParse(
                  (DateTime.now().microsecondsSinceEpoch % 100).toString(),
                ) ??
                0.0) /
            100.0 *
            60.0 -
        30.0;

    _yAnim = Tween<double>(begin: 0, end: -200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _xAnim = Tween<double>(begin: 0, end: _randomX).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _opacityAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 15),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 55),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_controller);
    _scaleAnim = Tween<double>(begin: 0.4, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward().then((_) => widget.onAnimationComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(_xAnim.value, _yAnim.value),
          child: Opacity(
            opacity: _opacityAnim.value,
            child: Transform.scale(
              scale: _scaleAnim.value,
              child: const Icon(
                Icons.favorite,
                color: Colors.redAccent,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }
}

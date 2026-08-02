import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';

import '../controller/home_controller.dart';
import '../model/story_model.dart';
import '../model/view_story_model.dart';

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

  @override
  void initState() {
    super.initState();
    _localStories = List.from(widget.storyGroup.stories ?? []);
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..forward();

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerStoryView(currentIndex);
    });
  }

  void _triggerStoryView(int index) {
    debugPrint("--- _triggerStoryView called for index: $index");
    if (index >= 0 && index < _localStories.length) {
      final story = _localStories[index];
      debugPrint("--- Story ID: ${story.id}");
      if (story.id != null) {
        final homeController = Get.find<HomeController>();
        homeController.postViewStory(story.id!);
      }
    } else {
      debugPrint("--- Index out of range in _triggerStoryView");
    }
  }

  void _nextStory() {
    if (currentIndex < _localStories.length - 1) {
      setState(() {
        currentIndex++;
      });
      _triggerStoryView(currentIndex);
      _progressController.reset();
      _progressController.forward();
    } else {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _previousStory() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      _triggerStoryView(currentIndex);
      _progressController.reset();
      _progressController.forward();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _showStoryViewersSheet(BuildContext context, String storyId) {
    final controller = Get.find<HomeController>();
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
                    "Failed to load viewers",
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
                    "No views yet",
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Viewers (${viewersData?.count ?? viewers.length})",
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
                            backgroundImage: user?.profileImage != null &&
                                    user!.profileImage!.isNotEmpty
                                ? NetworkImage(user.profileImage!)
                                : null,
                            child: user?.profileImage == null ||
                                    user!.profileImage!.isEmpty
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                          ),
                          title: Text(
                            user?.name ?? "User",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
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
      if (mounted && !_progressController.isAnimating) {
        _progressController.forward();
      }
    });
  }

  String _formatViewedTime(DateTime? time) {
    if (time == null) return "";
    final localTime = time.toLocal();
    final diff = DateTime.now().difference(localTime);
    if (diff.isNegative) return "JUST NOW";
    if (diff.inSeconds < 60) return "JUST NOW";
    if (diff.inMinutes < 60) return "${diff.inMinutes}M AGO";
    if (diff.inHours < 24) return "${diff.inHours}H AGO";
    return "${localTime.day}/${localTime.month}";
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final isMyStory =
        widget.storyGroup.user?.id == controller.currentUserId.value;
    final stories = _localStories;
    final currentStory = stories.isNotEmpty ? stories[currentIndex] : null;
    final user = widget.storyGroup.user;

    String? storyImageUrl;
    if (currentStory?.media != null && currentStory!.media!.isNotEmpty) {
      storyImageUrl = currentStory.media!.first.url;
    }

    String userName = user?.name ?? 'User';
    String? profileImageUrl = user?.profileImage;

    String timeAgo = "";
    if (currentStory != null && currentStory.createdAt != null) {
      DateTime localTime = currentStory.createdAt!.toLocal();
      Duration diff = DateTime.now().difference(localTime);
      if (diff.isNegative) {
        timeAgo = "JUST NOW";
      } else if (diff.inSeconds < 60) {
        timeAgo = "JUST NOW";
      } else if (diff.inMinutes < 60) {
        timeAgo = "${diff.inMinutes}M AGO";
      } else if (diff.inHours < 24) {
        timeAgo = "${diff.inHours}H AGO";
      } else if (diff.inDays < 30) {
        timeAgo = "${diff.inDays}D AGO";
      } else {
        timeAgo = "${localTime.day}/${localTime.month}/${localTime.year}";
      }
    } else {
      timeAgo = "";
    }

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            /// ── Full-screen story background ──────────────────────────────
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
                onLongPressDown: (_) => _progressController.stop(),
                onLongPressUp: () => _progressController.forward(),
                child: storyImageUrl != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          // Blurred background (fills the screen, hides black bars)
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(
                              sigmaX: 20,
                              sigmaY: 20,
                            ),
                            child: Image.network(
                              storyImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  Container(color: const Color(0xff1a1a1a)),
                            ),
                          ),
                          // Dark dim over the blur
                          Container(
                            color: Colors.black.withValues(alpha: 0.35),
                          ),
                          // Full image without cropping
                          Image.network(
                            storyImageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) =>
                                Container(color: const Color(0xff1a1a1a)),
                          ),
                        ],
                      )
                    : Container(color: const Color(0xff1a1a1a)),
              ),
            ),

            /// Dark gradient overlay — top & bottom
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

            /// ── Progress bar ──────────────────────────────────────────────
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 12,
              right: 12,
              child: Row(
                children: List.generate(stories.length, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) {
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

            /// ── Top bar — avatar + name + close ──────────────────────────
            Positioned(
              top: MediaQuery.of(context).padding.top + 22,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  /// Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.yellow, width: 2),
                    ),
                    child: ClipOval(
                      child: profileImageUrl != null
                          ? Image.network(profileImageUrl, fit: BoxFit.cover)
                          : const Icon(Icons.person, color: Colors.white),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// Name + time
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
                        Text(
                          timeAgo,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Close button
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

            /// ── Bottom bar — message + actions ───────────────────────────
            Positioned(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).padding.bottom + 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side: Viewer count / Activity (Only for my story)
                  if (isMyStory && currentStory != null)
                    GestureDetector(
                      onTap: () {
                        _progressController.stop();
                        _showStoryViewersSheet(context, currentStory!.id!);
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
                            "${currentStory!.viewCount ?? 0}",
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

                  // Right side: Actions
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isMyStory && currentStory != null) ...[
                        GestureDetector(
                          onTap: () async {
                            bool success =
                                await controller.likeStory(currentStory!.id!);
                            if (success) {
                              setState(() {
                                if (currentStory!.reacts != null) {
                                  final myId = controller.currentUserId.value;
                                  if (currentStory!.reacts!.contains(myId)) {
                                    currentStory!.reacts!.remove(myId);
                                  } else {
                                    currentStory!.reacts!.add(myId);
                                  }
                                }
                              });
                            }
                          },
                          child: Icon(
                            (currentStory!.reacts?.contains(
                                      controller.currentUserId.value,
                                    ) ??
                                    false)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: (currentStory!.reacts?.contains(
                                      controller.currentUserId.value,
                                    ) ??
                                    false)
                                ? Colors.redAccent
                                : Colors.white,
                            size: 26,
                          ),
                        ),
                      ],
                      if (isMyStory) ...[
                        const SizedBox(width: 16),

                        /// More
                        GestureDetector(
                          onTap: () {
                            // Pause progress bar
                            _progressController.stop();

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
                                          "Delete Story",
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pop(
                                            sheetContext,
                                            'delete',
                                          ); // Close bottom sheet with result

                                          // Show confirmation dialog (Yes / No)
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (dialogContext) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    const Color(0xff1C1C1C),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        16,
                                                      ),
                                                ),
                                                title: const Text(
                                                  "Delete Story?",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                content: const Text(
                                                  "Are you sure you want to delete this story?",
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                        dialogContext,
                                                      ); // Close dialog
                                                      _progressController
                                                          .forward(); // Resume progress
                                                    },
                                                    child: const Text(
                                                      "NO",
                                                      style: TextStyle(
                                                        color: Colors.white54,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      Navigator.pop(
                                                        dialogContext,
                                                      ); // Close dialog
                                                      if (currentStory?.id !=
                                                          null) {
                                                        bool success =
                                                            await controller
                                                                .deleteStory(
                                                                  currentStory!
                                                                      .id!,
                                                                );
                                                        if (success &&
                                                            mounted) {
                                                          setState(() {
                                                            _localStories
                                                                .removeWhere(
                                                                  (story) =>
                                                                      story
                                                                          .id ==
                                                                      currentStory!
                                                                          .id,
                                                                );
                                                            if (_localStories
                                                                .isEmpty) {
                                                              Navigator.of(
                                                                context,
                                                              ).pop();
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
                                                              _progressController
                                                                  .forward();
                                                            }
                                                          });
                                                        } else {
                                                          _progressController
                                                              .forward();
                                                        }
                                                      } else {
                                                        _progressController
                                                            .forward();
                                                      }
                                                    },
                                                    child: const Text(
                                                      "YES",
                                                      style: TextStyle(
                                                        color:
                                                            Colors.redAccent,
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
                              if (value != 'delete') {
                                if (mounted &&
                                    !_progressController.isAnimating) {
                                  _progressController.forward();
                                }
                              }
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
          ],
        ),
      ),
    );
  }
}

/// ── Pulsing yellow dot ────────────────────────────────────────────────────────

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => Opacity(
        opacity: _anim.value,
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.yellow,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

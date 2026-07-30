import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';

import '../model/story_model.dart';

class StoryViewScreen extends StatefulWidget {
  const StoryViewScreen({
    super.key,
    required this.storyGroup,
  });

  final StoryUserGroup storyGroup;

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  final TextEditingController _messageCtrl = TextEditingController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..forward();

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });
  }

  void _nextStory() {
    final stories = widget.storyGroup.stories ?? [];
    if (currentIndex < stories.length - 1) {
      setState(() {
        currentIndex++;
      });
      _progressController.reset();
      _progressController.forward();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _previousStory() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
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

  @override
  Widget build(BuildContext context) {
    final stories = widget.storyGroup.stories ?? [];
    final currentStory = stories.isNotEmpty ? stories[currentIndex] : null;
    final user = widget.storyGroup.user;

    String? storyImageUrl;
    if (currentStory?.media != null && currentStory!.media!.isNotEmpty) {
      storyImageUrl = currentStory.media!.first.url;
    }

    String userName = user?.name ?? 'User';
    String? profileImageUrl = user?.profileImage;
    String timeAgo = "14M AGO"; // You can calculate this from currentStory.createdAt if desired

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
                            imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Image.network(
                              storyImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  Container(color: const Color(0xff1a1a1a)),
                            ),
                          ),
                          // Dark dim over the blur
                          Container(color: Colors.black.withValues(alpha: 0.35)),
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
                          ? Image.network(
                              profileImageUrl,
                              fit: BoxFit.cover,
                            )
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
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  MediaQuery.of(context).padding.bottom + 16,
                ),
                child: Row(
                  children: [
                    /// Message field
                    Expanded(
                      child: Container(
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: TextField(
                          controller: _messageCtrl,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Send Message...",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 13,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// Like
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),

                    const SizedBox(width: 16),

                    /// More
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ],
                ),
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

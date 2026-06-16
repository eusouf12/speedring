import 'package:flutter/material.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';


void showCommentSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _CommentSheet(),
  );
}

class _CommentSheet extends StatelessWidget {
  const _CommentSheet();

  // ── Static comments data ────────────────────────────────────────────────
  static const String _pinnedBy = "MAX_VERSTAPPEN_33";
  static const String _commentCount = "482";

  static const List<_CommentData> _comments = [
    _CommentData(
      initials: "LH",
      userName: "LEWIS_H7",
      isVerified: false,
      text:
          "The telemetry data from Sector 3 shows incredible stability through the high-speed chicane. This setup change is exactly what we needed for the qualifying session tomorrow.",
      timeAgo: "2H AGO",
      likeCount: "1.2K",
      replyCount: 0,
      isPinned: true,
    ),
    _CommentData(
      initials: "CE",
      userName: "CHIEF_ENGINEER_P",
      isVerified: false,
      text:
          "Agreed. If you look at the brake bias migration curve, it's much more predictable under heavy load.",
      timeAgo: "4H AGO",
      likeCount: "42",
      replyCount: 12,
      isPinned: false,
    ),
    _CommentData(
      initials: "SM",
      userName: "STRATEGY_MAVEN",
      isVerified: true,
      text:
          "Are we considering the tire deg for the long stint? The surface temp on the left-rear looks slightly higher than the simulation predicted.",
      timeAgo: "5H AGO",
      likeCount: "156",
      replyCount: 0,
      isPinned: false,
    ),
    _CommentData(
      initials: "TL",
      userName: "TRACK_LIMITS_99",
      isVerified: false,
      text:
          "That exit on Turn 4 was absolutely clinical. Speeding telemetry shows +4kph compared to the previous lap. Mastery.",
      timeAgo: "8H AGO",
      likeCount: "89",
      replyCount: 0,
      isPinned: false,
    ),
    _CommentData(
      initials: "JD",
      userName: "JACK_DATA",
      isVerified: false,
      text:
          "Does anyone have the CSV for these sector times? Looking to run a comparison against last year's pole lap.",
      timeAgo: "18H AGO",
      likeCount: "12",
      replyCount: 0,
      isPinned: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xff111111),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              /// ── Drag handle ──────────────────────────────────────────
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),

              /// ── Header ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      "COMMENTS ($_commentCount)",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white, size: 22),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              /// ── Pinned label ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.push_pin, color: Colors.white38, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      "PINNED BY $_pinnedBy",
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              const Divider(color: Colors.white12, height: 1),

              /// ── Comment list ─────────────────────────────────────────
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: _comments.length,
                  separatorBuilder: (_, __) => const Divider(
                    color: Colors.white12,
                    height: 24,
                  ),
                  itemBuilder: (_, i) => _CommentTile(data: _comments[i]),
                ),
              ),

              /// ── Bottom input bar ─────────────────────────────────────
              const _CommentInputBar(),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CommentTile
// ─────────────────────────────────────────────────────────────────────────────

class _CommentTile extends StatefulWidget {
  final _CommentData data;

  const _CommentTile({required this.data});

  @override
  State<_CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<_CommentTile> {
  bool _liked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Avatar
        _Avatar(initials: widget.data.initials),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Username row
              Row(
                children: [
                  Text(
                    widget.data.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (widget.data.isVerified) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      color: AppColors.yellow,
                      size: 11,
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 4),

              /// Comment text
              Text(
                widget.data.text,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 8),

              /// Actions row
              Row(
                children: [
                  Text(
                    widget.data.timeAgo,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                    ),
                  ),

                  const SizedBox(width: 16),

                  /// Like
                  GestureDetector(
                    onTap: () => setState(() => _liked = !_liked),
                    child: Row(
                      children: [
                        Icon(
                          _liked ? Icons.favorite : Icons.favorite_border,
                          color: _liked ? Colors.red : Colors.white38,
                          size: 13,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          widget.data.likeCount,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  /// Reply
                  GestureDetector(
                    onTap: () {},
                    child: const Row(
                      children: [
                        Icon(Icons.reply, color: Colors.white38, size: 13),
                        SizedBox(width: 3),
                        Text(
                          "REPLY",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /// View replies
              if (widget.data.replyCount > 0) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "VIEW ${widget.data.replyCount} REPLIES",
                    style: const TextStyle(
                      color: AppColors.yellow,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _Avatar
// ─────────────────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final String initials;

  const _Avatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xff2A2A2A),
        border: Border.all(color: Colors.white12),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CommentInputBar — bottom text field
// ─────────────────────────────────────────────────────────────────────────────

class _CommentInputBar extends StatefulWidget {
  const _CommentInputBar();

  @override
  State<_CommentInputBar> createState() => _CommentInputBarState();
}

class _CommentInputBarState extends State<_CommentInputBar> {
  final TextEditingController _ctrl = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() {
      final has = _ctrl.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Color(0xff1A1A1A),
          border: Border(top: BorderSide(color: Colors.white12)),
        ),
        child: Row(
          children: [
            /// Text field
            Expanded(
              child: TextField(
                controller: _ctrl,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: "Write a comment...",
                  hintStyle: const TextStyle(
                    color: Colors.white38,
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: const Color(0xff2A2A2A),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            /// Send button
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _hasText ? AppColors.yellow : Colors.white12,
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                onTap: _hasText
                    ? () {
                        _ctrl.clear();
                        FocusScope.of(context).unfocus();
                      }
                    : null,
                child: Icon(
                  Icons.arrow_upward_rounded,
                  color: _hasText ? Colors.black : Colors.white38,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CommentData — immutable data class
// ─────────────────────────────────────────────────────────────────────────────

class _CommentData {
  final String initials;
  final String userName;
  final bool isVerified;
  final String text;
  final String timeAgo;
  final String likeCount;
  final int replyCount;
  final bool isPinned;

  const _CommentData({
    required this.initials,
    required this.userName,
    required this.isVerified,
    required this.text,
    required this.timeAgo,
    required this.likeCount,
    required this.replyCount,
    required this.isPinned,
  });
}

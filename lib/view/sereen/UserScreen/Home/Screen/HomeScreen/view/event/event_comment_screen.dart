import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../../../../utils/navigation_utils.dart';
import '../../controller/home_controller.dart';
import '../../model/event_model.dart';

// ─── Public entry points ───────────────────────────────────────────────────────

void showEventCommentSheet(BuildContext context, EventModel event) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _EventCommentSheet(event: event),
  );
}

void shareEventLink(EventModel event) {
  final link = "https://speedring.com/event/${event.id}";
  SharePlus.instance.share(
    ShareParams(
      text:
          "Check out this event on Speedring:\n${event.eventName ?? 'Event'}\n\n$link",
      subject: "Speedring Event",
    ),
  );
}

// ─── Comment Sheet ─────────────────────────────────────────────────────────────

class _EventCommentSheet extends StatelessWidget {
  final EventModel event;
  const _EventCommentSheet({required this.event});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

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
              const SizedBox(height: 10),
              // ── Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Obx(() {
                      final updated = controller.eventsList.firstWhere(
                        (e) => e.id == event.id,
                        orElse: () => event,
                      );
                      return Text(
                        "COMMENTS (${updated.commentCount ?? 0})",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      );
                    }),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Divider(color: Colors.white12, height: 1),

              // ── Comment List ──
              Expanded(
                child: Obx(() {
                  final updated = controller.eventsList.firstWhere(
                    (e) => e.id == event.id,
                    orElse: () => event,
                  );
                  final comments = updated.comments ?? [];

                  if (comments.isEmpty) {
                    return const Center(
                      child: Text(
                        "No comments yet. Be the first!",
                        style: TextStyle(color: Colors.white30, fontSize: 13),
                      ),
                    );
                  }

                  return ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: comments.length,
                    separatorBuilder: (_, _) =>
                        const Divider(color: Colors.white12, height: 24),
                    itemBuilder: (_, i) {
                      return _EventCommentTile(
                        eventId: event.id!,
                        comment: comments[i],
                      );
                    },
                  );
                }),
              ),

              // ── Input Bar ──
              _EventCommentInputBar(eventId: event.id!),
            ],
          ),
        );
      },
    );
  }
}

// ─── Comment Tile ──────────────────────────────────────────────────────────────

class _EventCommentTileController extends GetxController {
  final RxBool showReplies = false.obs;
}

class _EventCommentTile extends StatelessWidget {
  final String eventId;
  final EventComment comment;

  const _EventCommentTile({required this.eventId, required this.comment});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    final inputBarCtrl = Get.find<_EventCommentInputBarController>(
      tag: eventId,
    );
    final tileCtrl = Get.put(
      _EventCommentTileController(),
      tag: 'evt_c_${comment.id}',
    );

    final isMyComment = comment.user?.id == homeCtrl.currentUserId.value;
    final replyCount = comment.replies?.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            GestureDetector(
              onTap: () {
                if (comment.user?.id != null) {
                  NavigationUtils.navigateToUserProfile(comment.user!.id);
                }
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xff2A2A2A),
                backgroundImage: comment.user?.profileImage != null
                    ? NetworkImage(comment.user!.profileImage!)
                    : null,
                child: comment.user?.profileImage == null
                    ? const Icon(Icons.person, size: 18, color: Colors.white54)
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name row + delete
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (comment.user?.id != null) {
                            NavigationUtils.navigateToUserProfile(
                              comment.user!.id,
                            );
                          }
                        },
                        child: Text(
                          comment.user?.name ??
                              comment.user?.userName ??
                              "User",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (isMyComment)
                        GestureDetector(
                          onTap: () => _confirmDeleteComment(
                            context,
                            homeCtrl,
                            eventId,
                            comment.id!,
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Comment text
                  Text(
                    comment.comment ?? "",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Action row: Reply
                  Row(
                    children: [
                      // Reply
                      GestureDetector(
                        onTap: () {
                          inputBarCtrl.replyingToComment.value = comment;
                          inputBarCtrl.focusNode.requestFocus();
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.reply, size: 14, color: Colors.white38),
                            SizedBox(width: 4),
                            Text(
                              "Reply",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        // ── Replies toggle ──
        if (replyCount > 0) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 46),
            child: GestureDetector(
              onTap: () => tileCtrl.showReplies.toggle(),
              child: Obx(
                () => Text(
                  tileCtrl.showReplies.value
                      ? "Hide replies"
                      : "View $replyCount ${replyCount == 1 ? 'reply' : 'replies'}",
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            if (!tileCtrl.showReplies.value) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(left: 46, top: 10),
              child: Column(
                children: comment.replies!.map((reply) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (reply.user?.id != null) {
                              NavigationUtils.navigateToUserProfile(
                                reply.user!.id,
                              );
                            }
                          },
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: const Color(0xff2A2A2A),
                            backgroundImage: reply.user?.profileImage != null
                                ? NetworkImage(reply.user!.profileImage!)
                                : null,
                            child: reply.user?.profileImage == null
                                ? const Icon(
                                    Icons.person,
                                    size: 12,
                                    color: Colors.white54,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (reply.user?.id != null) {
                                    NavigationUtils.navigateToUserProfile(
                                      reply.user!.id,
                                    );
                                  }
                                },
                                child: Text(
                                  reply.user?.name ??
                                      reply.user?.userName ??
                                      "User",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                reply.comment ?? "",
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 11,
                                ),
                              ),
                              // Reply react count removed
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ],
    );
  }

  void _confirmDeleteComment(
    BuildContext context,
    HomeController homeCtrl,
    String eventId,
    String commentId,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xff1C1C1C),
        title: Text("deleteComment".tr, style: TextStyle(color: Colors.white)),
        content: const Text(
          "Are you sure you want to delete this comment?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "cancel".tr,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              homeCtrl.deleteEventComment(
                eventId: eventId,
                commentId: commentId,
              );
            },
            child: Text("delete".tr, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ─── Input Bar Controller ──────────────────────────────────────────────────────

class _EventCommentInputBarController extends GetxController {
  final TextEditingController ctrl = TextEditingController();
  final RxBool hasText = false.obs;
  final Rxn<EventComment> replyingToComment = Rxn<EventComment>();
  final FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    ctrl.addListener(() {
      hasText.value = ctrl.text.trim().isNotEmpty;
    });
  }

  @override
  void onClose() {
    ctrl.dispose();
    focusNode.dispose();
    super.onClose();
  }
}

// ─── Input Bar ─────────────────────────────────────────────────────────────────

class _EventCommentInputBar extends StatelessWidget {
  final String eventId;
  const _EventCommentInputBar({required this.eventId});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(_EventCommentInputBarController(), tag: eventId);
    final homeCtrl = Get.find<HomeController>();
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Replying to indicator
          Obx(() {
            final replyTo = ctrl.replyingToComment.value;
            if (replyTo == null) return const SizedBox.shrink();
            final name = replyTo.user?.name ?? replyTo.user?.userName ?? "User";
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xff1C1C1C),
              child: Row(
                children: [
                  Text(
                    "Replying to @$name",
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => ctrl.replyingToComment.value = null,
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            );
          }),

          // Text field + Post button
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: bottom > 0 ? 8 : (8 + safeBottom),
            ),
            color: const Color(0xff1A1A1A),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xff1C1C1C),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white24, width: 1),
                    ),
                    child: TextField(
                      controller: ctrl.ctrl,
                      focusNode: ctrl.focusNode,
                      cursorColor: Colors.yellow,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "addComment".tr,
                        hintStyle: TextStyle(color: Colors.white30),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(
                  () => ctrl.hasText.value
                      ? TextButton(
                          onPressed: () async {
                            final text = ctrl.ctrl.text.trim();
                            if (ctrl.replyingToComment.value != null) {
                              final commentId =
                                  ctrl.replyingToComment.value!.id!;
                              await homeCtrl.replyToEventComment(
                                eventId: eventId,
                                commentId: commentId,
                                replyText: text,
                              );

                              try {
                                final tileCtrl =
                                    Get.find<_EventCommentTileController>(
                                      tag: 'evt_c_$commentId',
                                    );
                                tileCtrl.showReplies.value = true;
                              } catch (_) {}

                              ctrl.replyingToComment.value = null;
                            } else {
                              await homeCtrl.commentOnEvent(
                                eventId: eventId,
                                comment: text,
                              );
                            }
                            ctrl.ctrl.clear();
                          },
                          child: const Text(
                            "Post",
                            style: TextStyle(color: Colors.yellow),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

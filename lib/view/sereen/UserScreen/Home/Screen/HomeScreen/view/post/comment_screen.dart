import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../utils/navigation_utils.dart'
    show NavigationUtils;
import '../../controller/home_controller.dart';
import '../../controller/reels_controller.dart';
import '../../model/post_model.dart';

void showCommentSheet(
  BuildContext context, {
  PostModel? post,
  bool isReel = false,
  int reelIndex = -1,
}) {
  if (post == null) return;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) =>
        _CommentSheet(post: post, isReel: isReel, reelIndex: reelIndex),
  );
}

class _CommentSheet extends StatelessWidget {
  final PostModel post;
  final bool isReel;
  final int reelIndex;
  const _CommentSheet({
    required this.post,
    this.isReel = false,
    this.reelIndex = -1,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController? homeController = isReel
        ? null
        : Get.find<HomeController>();
    final ReelsController? reelsController = isReel
        ? Get.find<ReelsController>()
        : null;

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Obx(() {
                      int count = 0;
                      if (isReel && reelsController != null) {
                        count = reelsController.currentComments.length;
                      } else if (homeController != null) {
                        final updatedPost = homeController.postsList.firstWhere(
                          (element) => element.id == post.id,
                          orElse: () => post,
                        );
                        count = updatedPost.comments?.length ?? 0;
                      }
                      return Text(
                        "COMMENTS ($count)",
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
              Expanded(
                child: Obx(() {
                  List<PostComment> commentsList = [];
                  if (isReel && reelsController != null) {
                    commentsList = reelsController.currentComments
                        .map((e) => PostComment.fromJson(e))
                        .toList();
                  } else if (homeController != null) {
                    final updatedPost = homeController.postsList.firstWhere(
                      (element) => element.id == post.id,
                      orElse: () => post,
                    );
                    commentsList = updatedPost.comments ?? [];
                  }

                  if (commentsList.isEmpty) {
                    return const Center(
                      child: Text(
                        "No comments yet",
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
                    itemCount: commentsList.length,
                    separatorBuilder: (_, _) =>
                        const Divider(color: Colors.white12, height: 24),
                    itemBuilder: (_, i) {
                      final comment = commentsList[i];
                      return _CommentTile(
                        postId: post.id!,
                        comment: comment,
                        isReel: isReel,
                      );
                    },
                  );
                }),
              ),
              _CommentInputBar(
                postId: post.id!,
                isReel: isReel,
                reelIndex: reelIndex,
              ),
            ],
          ),
        );
      },
    );
  }
}

class CommentTileController extends GetxController {
  final RxBool showReplies = false.obs;
}

class CommentInputBarController extends GetxController {
  final TextEditingController ctrl = TextEditingController();
  final RxBool hasText = false.obs;
  final Rxn<PostComment> replyingToComment = Rxn<PostComment>();
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

class _CommentTile extends StatelessWidget {
  final String postId;
  final PostComment comment;
  final bool isReel;

  const _CommentTile({
    required this.postId,
    required this.comment,
    this.isReel = false,
  });

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : null;
    final reelsController = isReel && Get.isRegistered<ReelsController>()
        ? Get.find<ReelsController>()
        : null;

    final inputBarController = Get.find<CommentInputBarController>(tag: postId);
    final tileController = Get.put(CommentTileController(), tag: comment.id);

    final currentUserId = homeController?.currentUserId.value ?? '';
    final isMyComment =
        currentUserId.isNotEmpty && comment.user?.id == currentUserId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                            size: 14,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: const Color(0xff1C1C1C),
                                title: const Text(
                                  "Delete Comment",
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: const Text(
                                  "Are you sure you want to delete this comment?",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      if (isReel && reelsController != null) {
                                        reelsController.deleteComment(
                                          postId,
                                          comment.id!,
                                        );
                                      } else if (homeController != null) {
                                        homeController.deleteComment(
                                          postId,
                                          comment.id!,
                                        );
                                      }
                                    },
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment.comment ?? "",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Reply action under comment (only if not own comment)
                  if (!isMyComment)
                    GestureDetector(
                      onTap: () {
                        inputBarController.replyingToComment.value = comment;
                        inputBarController.focusNode.requestFocus();
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.reply, size: 12, color: Colors.white54),
                          SizedBox(width: 4),
                          Text(
                            "Reply",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),

        // Replies list toggle and nested list view
        if (comment.replies != null && comment.replies!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 46, top: 8),
            child: GestureDetector(
              onTap: () => tileController.showReplies.toggle(),
              child: Obx(
                () => Text(
                  tileController.showReplies.value
                      ? "Hide replies"
                      : "View ${comment.replies!.length} replies",
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
            if (tileController.showReplies.value) {
              return Padding(
                padding: const EdgeInsets.only(left: 46, top: 10),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comment.replies!.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final reply = comment.replies![index];
                    return Row(
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
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ],
    );
  }
}

class _CommentInputBar extends StatelessWidget {
  final String postId;
  final bool isReel;
  final int reelIndex;
  const _CommentInputBar({
    required this.postId,
    this.isReel = false,
    this.reelIndex = -1,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommentInputBarController(), tag: postId);
    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : null;
    final reelsController = isReel && Get.isRegistered<ReelsController>()
        ? Get.find<ReelsController>()
        : null;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Replying to bar indicator
          Obx(() {
            if (controller.replyingToComment.value != null) {
              final commentUser =
                  controller.replyingToComment.value!.user?.name ??
                  controller.replyingToComment.value!.user?.userName ??
                  "User";
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: const Color(0xff1C1C1C),
                child: Row(
                  children: [
                    Text(
                      "Replying to @$commentUser",
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => controller.replyingToComment.value = null,
                      child: const Icon(
                        Icons.close,
                        size: 14,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

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
                      controller: controller.ctrl,
                      focusNode: controller.focusNode,
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
                  () => controller.hasText.value
                      ? TextButton(
                          onPressed: () {
                            final text = controller.ctrl.text.trim();
                            if (controller.replyingToComment.value != null) {
                              if (isReel && reelsController != null) {
                                reelsController.replyToComment(
                                  postId,
                                  controller.replyingToComment.value!.id!,
                                  text,
                                );
                              } else if (homeController != null) {
                                homeController.replyToComment(
                                  postId,
                                  controller.replyingToComment.value!.id!,
                                  text,
                                );
                              }
                              controller.replyingToComment.value = null;
                            } else {
                              if (isReel && reelsController != null) {
                                reelsController.commentOnReel(
                                  postId,
                                  reelIndex,
                                  text,
                                );
                              } else if (homeController != null) {
                                homeController.commentOnPost(postId, text);
                              }
                            }
                            controller.ctrl.clear();
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

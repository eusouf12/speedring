import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../controller/home_controller.dart';
import '../user_home_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'comment_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PostDetailScreen — Static data, no constructor params
// ─────────────────────────────────────────────────────────────────────────────

class PostDetailScreen extends StatefulWidget {
  final String postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final HomeController controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getSinglePost(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: const Color(0xff111111),
        appBar: CustomRoyelAppbar(leftIcon: true, titleName: "Details"),
        body: Obx(() {
          if (controller.isPostDetailLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }
          final post = controller.currentPostDetail.value;
          if (post == null) {
            return const Center(
              child: CustomText(text: "Post not found", color: Colors.white),
            );
          }

          final userName = post.user?.userName ?? post.user?.name ?? "Unknown";
          final profileImage = post.user?.profileImage;
          final imageUrls = (post.media ?? [])
              .map((e) => e.url ?? "")
              .where((u) => u.isNotEmpty)
              .toList();
          final likeCount = "${post.reactCount ?? 0}";
          final commentCount = "${post.commentCount ?? 0}";
          final isMyPost =
              post.user?.id != null &&
              post.user!.id == controller.currentUserId.value;

          final categoryLabel = post.category != null
              ? post.category!.replaceAll('_', ' ').toUpperCase()
              : '';
          final loc =
              post.spotDetails?.region ??
              post.trackUpdateDetails?.circuit ??
              post.sessionDetails?.trackName;

          String subtitle = loc != null && loc.isNotEmpty
              ? (categoryLabel.isNotEmpty ? "$categoryLabel • $loc" : loc)
              : (categoryLabel.isNotEmpty ? categoryLabel : '');

          // Get specific caption
          String caption = "";
          if (post.sessionDetails != null) {
            caption = post.sessionDetails!.summary ?? "";
          } else if (post.spotDetails != null) {
            caption = post.spotDetails!.region ?? "";
          } else if (post.businessPostDetails != null) {
            caption = post.businessPostDetails!.description ?? "";
          } else if (post.trackUpdateDetails != null) {
            caption = post.trackUpdateDetails!.notes ?? "";
          } else if (post.clubPostDetails != null) {
            caption =
                post.clubPostDetails!.details ??
                post.clubPostDetails!.title ??
                "";
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ── Image Carousel ───────────────────────────────────
                    if (imageUrls.isNotEmpty)
                      _ImageCarousel(imageUrls: imageUrls),
                    if (imageUrls.isNotEmpty) const SizedBox(height: 16),

                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ── User info row ──────────────────────────────
                          Row(
                            children: [
                              /// Avatar
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.yellow,
                                    width: 1.5,
                                  ),
                                ),
                                child: ClipOval(
                                  child:
                                      profileImage != null &&
                                          profileImage.isNotEmpty
                                      ? Image.network(
                                          profileImage,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                ),
                              ),

                              const SizedBox(width: 10),

                              /// Name + subtitle
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CustomText(
                                          text: userName,
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                        ),
                                      ],
                                    ),
                                    if (subtitle.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      CustomText(
                                        text: subtitle,
                                        color: Colors.white54,
                                        fontSize: 11,
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              /// More options
                              if (isMyPost)
                                IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: const Color(0xff1C1C1C),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (context) {
                                        return SafeArea(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                title: const CustomText(
                                                  text: "Delete Post",
                                                  color: Colors.red,
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      backgroundColor:
                                                          const Color(
                                                            0xff1C1C1C,
                                                          ),
                                                      title: const CustomText(
                                                        text: "Delete Post",
                                                        color: Colors.white,
                                                      ),
                                                      content: const CustomText(
                                                        text:
                                                            "Are you sure you want to delete this post?",
                                                        color: Colors.white70,
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                context,
                                                              ),
                                                          child:
                                                              const CustomText(
                                                                text: "Cancel",
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                            Navigator.pop(
                                                              context,
                                                            ); // Go back from detail screen
                                                            controller
                                                                .deletePost(
                                                                  post.id!,
                                                                );
                                                          },
                                                          child:
                                                              const CustomText(
                                                                text: "Delete",
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          /// ── Caption ──────────────────────────────────
                          if (caption.isNotEmpty) ...[
                            _CaptionText(caption: caption),
                            const SizedBox(height: 14),
                          ],

                          if (buildPostDetails(post) != null) ...[
                            buildPostDetails(post)!,
                            const SizedBox(height: 16),
                          ],

                          /// ── Engagement row ───────────────────────────
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => controller.reactToPost(post.id!),
                                child: Row(
                                  children: [
                                    Icon(
                                      post.isReacted == true
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: post.isReacted == true
                                          ? Colors.red
                                          : Colors.white,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 6),
                                    CustomText(
                                      text: likeCount,
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 20),

                              GestureDetector(
                                onTap: () => showCommentSheet(context, post),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.chat_bubble_outline,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 6),
                                    CustomText(
                                      text: commentCount,
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),

                              const Spacer(),

                              GestureDetector(
                                onTap: () {
                                  final postLink =
                                      "https://speedring.com/post/${post.id}";
                                  SharePlus.instance.share(
                                    ShareParams(
                                      text:
                                          "Check out this post on Speedring:\n\n$postLink",
                                      subject: "Speedring Post",
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.share_outlined,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class ImageCarouselController extends GetxController {
  final RxInt currentIndex = 0.obs;
}

class _ImageCarousel extends StatelessWidget {
  final List<String> imageUrls;

  const _ImageCarousel({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    final tag = imageUrls.join(',');
    final controller = Get.put(ImageCarouselController(), tag: tag);

    return Stack(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            itemCount: imageUrls.length,
            onPageChanged: (i) => controller.currentIndex.value = i,
            itemBuilder: (_, i) => Image.network(
              imageUrls[i],
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (_, _, _) => Container(
                color: const Color(0xff1C1C1C),
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.white24,
                  size: 48,
                ),
              ),
            ),
          ),
        ),

        /// Dot indicators
        if (imageUrls.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  imageUrls.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == controller.currentIndex.value ? 22 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: i == controller.currentIndex.value
                          ? AppColors.yellow
                          : Colors.white38,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CaptionText extends StatelessWidget {
  final String caption;

  const _CaptionText({required this.caption});

  @override
  Widget build(BuildContext context) {
    final words = caption.split(' ');
    return RichText(
      text: TextSpan(
        children: words.map((word) {
          final isHashtag = word.startsWith('#');
          return TextSpan(
            text: '$word ',
            style: TextStyle(
              color: isHashtag ? AppColors.yellow : Colors.white,
              fontSize: 13.5,
              height: 1.55,
              fontWeight: isHashtag ? FontWeight.w600 : FontWeight.normal,
            ),
          );
        }).toList(),
      ),
    );
  }
}

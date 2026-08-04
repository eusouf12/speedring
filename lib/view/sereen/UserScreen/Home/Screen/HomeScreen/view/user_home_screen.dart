import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../../../../core/app_routes/app_routes.dart';
import '../../../../../../components/custom_appbar_user/custom_appbar_user.dart';
import '../controller/home_controller.dart';
import '../model/post_model.dart';
import 'post/comment_screen.dart' show showCommentSheet;
import 'event/event_comment_screen.dart'
    show showEventCommentSheet, shareEventLink;
import 'story/create_story_screen.dart';
import 'story/story_view_screen.dart';
import 'post/post_detail_screen.dart';
import '../../../widget/story_item.dart';
import '../../../widget/add_post_button.dart';
import '../../../widget/post_card.dart';
import '../../../../../../components/custom_nav_bar/navbar.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomAppBarUser(
          showSearchIcon: true,
          onSearchTap: () => controller.showSearchBar.toggle(),
          onNotificationTap: () {
            Get.toNamed(AppRoutes.notificationScreen);
          },
          onMailTap: () {
            Get.toNamed(AppRoutes.messageScreen);
          },
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Obx(() {
                    if (controller.showSearchBar.value) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff1C1C1C),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: controller.rxActiveTab.value == 1
                                  ? "Search events..."
                                  : "Search posts...",
                              hintStyle: const TextStyle(color: Colors.white30),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white70,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.white54,
                                ),
                                onPressed: () {
                                  if (controller.rxActiveTab.value == 0) {
                                    controller.getPost(searchTerm: "");
                                  } else if (controller.rxActiveTab.value ==
                                      1) {
                                    controller.getEvents(searchTerm: "");
                                  }
                                  controller.showSearchBar.value = false;
                                },
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            onChanged: (val) {
                              if (controller.rxActiveTab.value == 0) {
                                controller.searchPost(val);
                              } else if (controller.rxActiveTab.value == 1) {
                                controller.searchEvents(val);
                              }
                            },
                            onSubmitted: (val) {
                              controller.showSearchBar.value = false;
                            },
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  const SizedBox(height: 10),

                  /// ── STORIES ──────────────────────────────────────────────────
                  SizedBox(
                    height: 110,
                    child: Obx(() {
                      if (controller.isStoriesLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.yellow,
                          ),
                        );
                      }

                      final storiesList = controller.allStories;

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: storiesList.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CreateStoryScreen(),
                                  ),
                                );
                              },
                              child: const StoryItem(
                                isMe: true,
                                name: 'CREATE',
                                imageSrc: null,
                                icon: Icons.add,
                              ),
                            );
                          }

                          final storyGroup = storiesList[index - 1];
                          String? imageUrl;
                          if (storyGroup.stories != null &&
                              storyGroup.stories!.isNotEmpty) {
                            final mediaList = storyGroup.stories!.last.media;
                            if (mediaList != null && mediaList.isNotEmpty) {
                              imageUrl = mediaList.first.url;
                            }
                          }
                          if (imageUrl == null || imageUrl.isEmpty) {
                            imageUrl = storyGroup.user?.profileImage;
                          }

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      StoryViewScreen(storyGroup: storyGroup),
                                ),
                              );
                            },
                            child: StoryItem(
                              isMe: false,
                              name: storyGroup.user?.name ?? 'Unknown',
                              imageSrc: imageUrl,
                              icon: null,
                            ),
                          );
                        },
                      );
                    }),
                  ),

                  const Divider(color: Colors.white24),
                ],
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                controller,
                (title, selected, onTap) => _tab(title, selected, onTap),
              ),
            ),
          ],
          body: Obx(
            () => IndexedStack(
              index: controller.rxActiveTab.value,
              children: [
                /// Tab 0: POST Feed
                controller.isPostLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.yellow,
                        ),
                      )
                    : RefreshIndicator(
                        color: AppColors.yellow,
                        backgroundColor: Colors.black,
                        onRefresh: () => controller.getPost(),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: controller.postsList.length + 2,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  AddPostButton(
                                    label: "ADD POST",
                                    onTap: () =>
                                        Get.toNamed(AppRoutes.createPostScreen),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            }

                            if (index == controller.postsList.length + 1) {
                              if (controller.isLoadMoreLoading.value) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              } else if (controller.hasMorePosts) {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  controller.getPost(isLoadMore: true);
                                });
                                return const SizedBox(height: 50);
                              } else {
                                return const SizedBox(height: 30);
                              }
                            }

                            final post = controller.postsList[index - 1];
                            final categoryLabel = post.category != null
                                ? post.category!
                                      .replaceAll('_', ' ')
                                      .toUpperCase()
                                : '';
                            final userName =
                                post.user?.name ??
                                post.user?.userName ??
                                'User';
                            final profileImage = post.user?.profileImage;

                            final loc =
                                post.spotDetails?.region ??
                                post.trackUpdateDetails?.circuit ??
                                post.sessionDetails?.trackName;

                            final location = loc != null && loc.isNotEmpty
                                ? (categoryLabel.isNotEmpty
                                      ? "$categoryLabel • $loc"
                                      : loc)
                                : (categoryLabel.isNotEmpty
                                      ? categoryLabel
                                      : 'Unknown Location');
                            final imageUrl =
                                post.media != null && post.media!.isNotEmpty
                                ? post.media!.first.url ?? ''
                                : '';
                            final caption =
                                post.clubPostDetails?.details ??
                                post.businessPostDetails?.description ??
                                post.sessionDetails?.summary ??
                                post.trackUpdateDetails?.notes ??
                                '';

                            final isMyPost =
                                post.user?.id != null &&
                                post.user!.id == controller.currentUserId.value;

                            return Column(
                              children: [
                                PostCard(
                                  userName: userName,
                                  location: location,
                                  imageUrl: imageUrl,
                                  caption: caption,
                                  profileImage: profileImage,
                                  reactCount: post.reactCount,
                                  commentCount: post.commentCount,
                                  isLiked: post.isReacted ?? false,
                                  detailsWidget: buildPostDetails(post),
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PostDetailScreen(postId: post.id!),
                                    ),
                                  ),
                                  onLike: () =>
                                      controller.reactToPost(post.id!),
                                  onComment: () =>
                                      showCommentSheet(context, post),
                                  onShare: () {
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
                                  onMore: isMyPost
                                      ? () {
                                          showModalBottomSheet(
                                            context: context,
                                            useRootNavigator: true,
                                            isScrollControlled: true,
                                            useSafeArea: true,
                                            backgroundColor: const Color(
                                              0xff1C1C1C,
                                            ),
                                            builder: (context) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(
                                                    context,
                                                  ).viewPadding.bottom,
                                                ),
                                                child: Wrap(
                                                  children: [
                                                    ListTile(
                                                      leading: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                      title: const Text(
                                                        "Delete Post",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
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
                                                            title: const Text(
                                                              "Delete Post",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                            content: const Text(
                                                              "Are you sure you want to delete this post?",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white70,
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                    ),
                                                                child: const Text(
                                                                  "Cancel",
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                  controller
                                                                      .deletePost(
                                                                        post.id!,
                                                                      );
                                                                },
                                                                child: const Text(
                                                                  "Delete",
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                  ),
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
                                        }
                                      : null,
                                ),
                                const SizedBox(height: 12),
                              ],
                            );
                          },
                        ),
                      ),

                /// Tab 1: EVENTS Feed
                controller.isEventsLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.yellow,
                        ),
                      )
                    : controller.eventsList.isEmpty
                    ? const Center(
                        child: Text(
                          "No events found",
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : RefreshIndicator(
                        color: AppColors.yellow,
                        backgroundColor: Colors.black,
                        onRefresh: () => controller.getEvents(),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: controller.eventsList.length + 2,
                          itemBuilder: (context, index) {
                            // index 0 → ADD EVENT button
                            if (index == 0) {
                              return Column(
                                children: [
                                  AddPostButton(
                                    label: "ADD EVENT",
                                    onTap: () {
                                      Get.toNamed(AppRoutes.createEventScreen);
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            }

                            // Last item → load-more indicator / trigger
                            if (index == controller.eventsList.length + 1) {
                              if (controller.isEventsLoadMoreLoading.value) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              } else if (controller.hasMoreEvents) {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  controller.getEvents(isLoadMore: true);
                                });
                                return const SizedBox(height: 50);
                              } else {
                                return const SizedBox(height: 30);
                              }
                            }

                            final event = controller.eventsList[index - 1];
                            final isMyEvent =
                                event.user?.id != null &&
                                event.user!.id ==
                                    controller.currentUserId.value;

                            // Build proper image URL
                            String bannerUrl = event.bannerImage ?? "";
                            if (bannerUrl.isNotEmpty &&
                                !bannerUrl.startsWith("http")) {
                              bannerUrl = "http://10.10.28.90:4050$bannerUrl";
                            }

                            return _EventCard(
                              imageUrl: bannerUrl.isNotEmpty
                                  ? bannerUrl
                                  : "https://picsum.photos/seed/event_${event.id}/600/300",
                              organizer: event.user?.name ?? "ORGANIZER",
                              organizerImage: event.user?.profileImage,
                              title: event.eventName ?? "UNTITLED EVENT",
                              date: event.deploymentDate != null
                                  ? event.deploymentDate!.split('T')[0]
                                  : "UNKNOWN",
                              type: event.missionType ?? "EVENT",
                              location: event.locationCircuit ?? "UNKNOWN",
                              slots:
                                  "${event.joinCount ?? 0}/${event.maxCapacity ?? 0}",
                              likes: "${event.reactCount ?? 0}",
                              comments: "${event.commentCount ?? 0}",
                              isJoined: event.isEventJoined ?? false,
                              isReacted: event.isReacted ?? false,
                              isMyEvent: isMyEvent,
                              eventId: event.id ?? "",
                              onJoin: () =>
                                  controller.joinEvent(eventId: event.id!),
                              onLike: () =>
                                  controller.reactToEvent(eventId: event.id!),
                              onComment: () =>
                                  showEventCommentSheet(context, event),
                              onShare: () {
                                controller.shareEvent(eventId: event.id!);
                                shareEventLink(event);
                              },
                              onDelete: isMyEvent
                                  ? () => controller.deleteEvent(
                                      eventId: event.id!,
                                    )
                                  : null,
                            );
                          },
                        ),
                      ),

                /// Tab 2: CLUBS Feed
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const SizedBox(height: 16),

                    /// YOUR CLUBS Header
                    const Text(
                      "YOUR CLUBS",
                      style: TextStyle(
                        color: AppColors.yellow,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 14),

                    /// Your Clubs List (Horizontal scroll)
                    Obx(() {
                      if (controller.isMyClubsLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.yellow,
                          ),
                        );
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Add New Club Button
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: GestureDetector(
                                onTap: () =>
                                    Get.toNamed(AppRoutes.createClubScreen),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.yellow,
                                          width: 1.5,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.add,
                                          color: AppColors.yellow,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "NEW CLUB",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ...controller.myClubs.map((club) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: _buildCircularClubItem(
                                  name: club.clubName ?? "Unknown",
                                  imageUrl:
                                      club.logo != null && club.logo!.isNotEmpty
                                      ? (club.logo!.startsWith('http')
                                            ? club.logo!
                                            : "${ApiUrl.imageUrl}${club.logo}")
                                      : "", // Fallback
                                  onTap: () => Get.toNamed(
                                    AppRoutes.clubDetailsScreen,
                                    arguments: {"id": club.id},
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 28),

                    /// BROWSE ALL CLUBS Header
                    const Text(
                      "BROWSE ALL CLUBS",
                      style: TextStyle(
                        color: AppColors.yellow,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Browse Clubs List
                    Obx(() {
                      if (controller.isClubsLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.yellow,
                          ),
                        );
                      }
                      if (controller.allClubs.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              "No clubs found.",
                              style: TextStyle(color: Colors.white54),
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: controller.allClubs.map((club) {
                          return _buildBrowseClubCard(
                            name: club.clubName ?? "Unknown",
                            members: "${club.members?.length ?? 0}",
                            imageUrl: club.logo != null && club.logo!.isNotEmpty
                                ? (club.logo!.startsWith('http')
                                      ? club.logo!
                                      : "${ApiUrl.imageUrl}${club.logo}")
                                : "", // Fallback
                            onTap: () => Get.toNamed(
                              AppRoutes.clubDetailsScreen,
                              arguments: {"id": club.id},
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    const SizedBox(height: 30),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomNavBar(currentIndex: 0),
      ),
    );
  }

  Widget _tab(String title, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.yellow : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white60,
            fontWeight: FontWeight.w900,
            fontSize: 11,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildCircularClubItem({
    required String name,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 1.5),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrowseClubCard({
    required String name,
    required String members,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xff181818),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            /// Logo
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 14),

            /// Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        members,
                        style: const TextStyle(
                          color: AppColors.yellow,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "ACTIVE MEMBERS",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Join Button
            Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text(
                  "JOIN CLUB",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared UI components for Events & Clubs ──────────────────────────────────

class _EventCard extends StatelessWidget {
  final String imageUrl;
  final String organizer;
  final String title;
  final String date;
  final String type;
  final String location;
  final String slots;
  final String likes;
  final String comments;
  final bool isJoined;
  final bool isReacted;
  final bool isMyEvent;
  final String eventId;
  final VoidCallback onJoin;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback? onDelete;
  final String? organizerImage;

  const _EventCard({
    required this.imageUrl,
    required this.organizer,
    required this.title,
    required this.date,
    required this.type,
    required this.location,
    required this.slots,
    required this.likes,
    required this.comments,
    required this.isJoined,
    required this.isReacted,
    required this.isMyEvent,
    required this.eventId,
    required this.onJoin,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    this.onDelete,
    this.organizerImage,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFull =
        slots.split('/').length == 2 &&
        slots.split('/')[0] == slots.split('/')[1];

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.eventDetailScreen,
          arguments: {'eventId': eventId},
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xff0d0d0d),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Event Banner
            Image.network(
              imageUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, _, _) =>
                  Container(height: 160, color: const Color(0xff1A1A1A)),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Organizer
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white24,
                        backgroundImage:
                            organizerImage != null && organizerImage!.isNotEmpty
                            ? NetworkImage(
                                organizerImage!.startsWith('http')
                                    ? organizerImage!
                                    : ApiUrl.baseUrl + organizerImage!,
                              )
                            : null,
                        child: organizerImage == null || organizerImage!.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 10,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        organizer,
                        style: const TextStyle(
                          color: AppColors.yellow,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                  const SizedBox(height: 10),

                  /// Title
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Metadata Box Grid
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xff151515),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _metaRow(Icons.calendar_today_outlined, date),
                              const SizedBox(height: 6),
                              _metaRow(Icons.location_on_outlined, location),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _metaRow(Icons.sports_motorsports_outlined, type),
                              const SizedBox(height: 6),
                              _metaRow(
                                Icons.people_outline,
                                slots,
                                color: isFull
                                    ? Colors.redAccent
                                    : AppColors.yellow,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  /// Footer (Likes, comments, join action)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: Row(
                      children: [
                        // Like button
                        GestureDetector(
                          onTap: onLike,
                          child: Icon(
                            isReacted ? Icons.favorite : Icons.favorite_border,
                            color: isReacted
                                ? Colors.redAccent
                                : Colors.white38,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          likes,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Comment button
                        GestureDetector(
                          onTap: onComment,
                          child: const Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white38,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          comments,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Share button
                        GestureDetector(
                          onTap: onShare,
                          child: const Icon(
                            Icons.share_outlined,
                            color: Colors.white38,
                            size: 16,
                          ),
                        ),
                        // Delete button (only for my events)
                        if (isMyEvent && onDelete != null) ...[
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Get.dialog(
                                AlertDialog(
                                  backgroundColor: const Color(0xff1C1C1C),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: const Text(
                                    "Delete Event",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: const Text(
                                    "Are you sure you want to delete this event?",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text(
                                        "NO",
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back(); // close dialog
                                        onDelete?.call();
                                      },
                                      child: const Text(
                                        "YES",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                              size: 16,
                            ),
                          ),
                        ],
                        const Spacer(),

                        /// Join / Joined Button
                        if (!isMyEvent)
                          GestureDetector(
                            onTap: isJoined ? null : onJoin,
                            child: Container(
                              height: 36,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              decoration: BoxDecoration(
                                color: isJoined
                                    ? const Color(0xff222222)
                                    : AppColors.yellow,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  isJoined ? "JOINED" : "JOIN",
                                  style: TextStyle(
                                    color: isJoined
                                        ? Colors.white60
                                        : Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
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
      ),
    );
  }

  Widget _metaRow(IconData icon, String label, {Color color = Colors.white60}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1.0),
          child: Icon(icon, color: Colors.white24, size: 12),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

Widget? buildPostDetails(PostModel post) {
  final category = post.category;
  if (category == "SPOT_POST" && post.spotDetails != null) {
    final spot = post.spotDetails!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDetailRow(
            Icons.credit_card,
            "License Plate",
            spot.licensePlate ?? "N/A",
          ),
          const SizedBox(height: 6),
          buildDetailRow(Icons.public, "Region", spot.region ?? "N/A"),
          const SizedBox(height: 6),
          buildDetailRow(Icons.settings, "Engine", spot.engine ?? "N/A"),
          const SizedBox(height: 6),
          buildDetailRow(
            Icons.flash_on,
            "Power",
            "${spot.powerHp ?? 'N/A'} HP",
          ),
          const SizedBox(height: 6),
          buildDetailRow(
            Icons.directions_car,
            "Model",
            spot.makeAndModel ?? "N/A",
          ),
        ],
      ),
    );
  } else if (category == "SESSION_POST" && post.sessionDetails != null) {
    final session = post.sessionDetails!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDetailRow(
            Icons.sports_motorsports,
            "Vehicle",
            session.vehicle ?? "N/A",
          ),
          const SizedBox(height: 6),
          buildDetailRow(Icons.map, "Circuit", session.circuit ?? "N/A"),
          const SizedBox(height: 6),
          buildDetailRow(Icons.flag, "Track", session.trackName ?? "N/A"),
          const SizedBox(height: 6),
          buildDetailRow(Icons.timer, "Best Lap", session.bestLapTime ?? "N/A"),
          const SizedBox(height: 6),
          buildDetailRow(Icons.speed, "Top Speed", session.topSpeed ?? "N/A"),
        ],
      ),
    );
  } else if (category == "BUSINESS_POST" && post.businessPostDetails != null) {
    final biz = post.businessPostDetails!;
    final hasTitle = biz.listingTitle != null && biz.listingTitle!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasTitle) ...[
          Text(
            biz.listingTitle!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xff2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDetailRow(
                Icons.category,
                "Category",
                biz.listingCategory ?? "N/A",
              ),
              const SizedBox(height: 6),
              buildDetailRow(Icons.attach_money, "Price", biz.price ?? "N/A"),
            ],
          ),
        ),
      ],
    );
  } else if ((category == "TRACK_UPDATE_POST" || category == "TRACK_UPDATE") &&
      post.trackUpdateDetails != null) {
    final track = post.trackUpdateDetails!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDetailRow(Icons.map, "Circuit", track.circuit ?? "N/A"),
          const SizedBox(height: 6),
          buildDetailRow(
            Icons.traffic,
            "Condition",
            track.surfaceCondition ?? "N/A",
          ),
          if (track.hazards != null && track.hazards!.isNotEmpty) ...[
            const SizedBox(height: 6),
            buildDetailRow(Icons.warning, "Hazards", track.hazards!.join(", ")),
          ],
        ],
      ),
    );
  } else if (category == "CLUB_POST" && post.clubPostDetails != null) {
    final club = post.clubPostDetails!;
    final hasTitle = club.title != null && club.title!.isNotEmpty;
    if (!hasTitle) return null;

    return Text(
      club.title!,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  return null;
}

Widget buildDetailRow(IconData icon, String label, String value) {
  return Row(
    children: [
      Icon(icon, size: 14, color: Colors.yellow),
      const SizedBox(width: 8),
      Text(
        "$label: ",
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      Expanded(
        child: Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final HomeController controller;
  final Widget Function(String, bool, VoidCallback) tabBuilder;

  _TabBarDelegate(this.controller, this.tabBuilder);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.black, // Background color when pinned
      padding: const EdgeInsets.only(top: 10, bottom: 15),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              tabBuilder(
                "POST",
                controller.rxActiveTab.value == 0,
                () => controller.changeTab(0),
              ),
              const SizedBox(width: 10),
              tabBuilder(
                "EVENTS",
                controller.rxActiveTab.value == 1,
                () => controller.changeTab(1),
              ),
              const SizedBox(width: 10),
              tabBuilder(
                "CLUBS",
                controller.rxActiveTab.value == 2,
                () => controller.changeTab(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

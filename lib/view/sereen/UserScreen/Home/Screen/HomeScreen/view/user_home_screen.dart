import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../../../../core/app_routes/app_routes.dart';
import '../../../../../../components/custom_appbar_user/custom_appbar_user.dart';
import '../controller/home_controller.dart';
import '../model/post_model.dart';
import 'comment_screen.dart' show showCommentSheet;
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
        body: Column(
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
                        hintText: "Search posts...",
                        hintStyle: const TextStyle(color: Colors.white30),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white70,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white54),
                          onPressed: () {
                            controller.getPost(searchTerm: "");
                            controller.showSearchBar.value = false;
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                      onChanged: (val) {
                        controller.searchPost(val);
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
                    child: CircularProgressIndicator(color: AppColors.yellow),
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

            /// ── TABS ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _tab(
                      "POST",
                      controller.rxActiveTab.value == 0,
                      () => controller.changeTab(0),
                    ),
                    const SizedBox(width: 10),
                    _tab(
                      "EVENTS",
                      controller.rxActiveTab.value == 1,
                      () => controller.changeTab(1),
                    ),
                    const SizedBox(width: 10),
                    _tab(
                      "CLUBS",
                      controller.rxActiveTab.value == 2,
                      () => controller.changeTab(2),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ── FEED AREA ────────────────────────────────────────────────
            Expanded(
              child: Obx(
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
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: controller.postsList.length + 2,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Column(
                                  children: [
                                    AddPostButton(
                                      label: "ADD POST",
                                      onTap: () => Get.toNamed(
                                        AppRoutes.createPostScreen,
                                      ),
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
                              final userName = categoryLabel.isNotEmpty
                                  ? "${post.user?.name ?? post.user?.userName ?? 'User'} • $categoryLabel"
                                  : (post.user?.name ??
                                        post.user?.userName ??
                                        'User');
                              final profileImage = post.user?.profileImage;
                              final location =
                                  post.spotDetails?.region ??
                                  post.trackUpdateDetails?.circuit ??
                                  post.sessionDetails?.trackName ??
                                  (post.category != null
                                      ? post.category!
                                            .replaceAll('_', ' ')
                                            .toUpperCase()
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
                                  post.user!.id ==
                                      controller.currentUserId.value;

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
                                    detailsWidget: _buildPostDetails(post),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const PostDetailScreen(),
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
                                              backgroundColor: const Color(
                                                0xff1C1C1C,
                                              ),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            20,
                                                          ),
                                                        ),
                                                  ),
                                              builder: (context) {
                                                return SafeArea(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
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
                                                          Navigator.pop(
                                                            context,
                                                          );
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

                    /// Tab 1:
                    ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _EventCard(
                          imageUrl:
                              "https://picsum.photos/seed/silverstone_event/600/300",
                          organizer: "ANDRUIA RACING",
                          title: "SILVERSTONE PERFORMANCE PADDOCK",
                          date: "OCT 24",
                          type: "TRACK DAY",
                          location: "SILVERSTONE",
                          slots: "47/50",
                          likes: "2.4k",
                          comments: "128",
                          status: "JOIN",
                        ),
                        _EventCard(
                          imageUrl:
                              "https://picsum.photos/seed/nurburg_event/600/300",
                          organizer: "SPEEDRING ELITE",
                          title: "NÜRBURGRING ENDURANCE SERIES",
                          date: "NOV 11",
                          type: "ENDURANCE",
                          location: "NÜRBURG",
                          slots: "FULL",
                          likes: "1.9M",
                          comments: "64",
                          status: "WAITLIST",
                        ),
                        _EventCard(
                          imageUrl:
                              "https://picsum.photos/seed/yas_event/600/300",
                          organizer: "SPEEDRING ELITE",
                          title: "YAS MARINA NIGHT SESSIONS",
                          date: "DEC 05",
                          type: "EXPERIENCE",
                          location: "YAS MARINA",
                          slots: "12/25",
                          likes: "5.5k",
                          comments: "225",
                          status: "JOIN",
                        ),
                        const SizedBox(height: 30),
                      ],
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCircularClubItem(
                                name: "GT3 COLL.",
                                imageUrl:
                                    "https://picsum.photos/seed/gt3coll/100/100",
                                onTap: () => Get.toNamed(
                                  AppRoutes.clubDetailsScreen,
                                  arguments: {
                                    "name": "Porsche GT3 Collective",
                                    "members": "1,248",
                                    "isMember": true,
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              _buildCircularClubItem(
                                name: "NUR ENDO",
                                imageUrl:
                                    "https://picsum.photos/seed/nurendo/100/100",
                                onTap: () => Get.toNamed(
                                  AppRoutes.clubDetailsScreen,
                                  arguments: {
                                    "name": "Nürburgring Endurance Group",
                                    "members": "856",
                                    "isMember": true,
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              _buildCircularClubItem(
                                name: "APEX PREP",
                                imageUrl:
                                    "https://picsum.photos/seed/apexprep/100/100",
                                onTap: () => Get.toNamed(
                                  AppRoutes.clubDetailsScreen,
                                  arguments: {
                                    "name": "Apex Strategy Masters",
                                    "members": "412",
                                    "isMember": true,
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),

                              /// Add New Club Button
                              GestureDetector(
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
                            ],
                          ),
                        ),
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
                        _buildBrowseClubCard(
                          name: "Porsche GT3 Collective",
                          members: "1,240",
                          imageUrl:
                              "https://picsum.photos/seed/gt3coll/100/100",
                          onTap: () => Get.toNamed(
                            AppRoutes.clubDetailsScreen,
                            arguments: {
                              "name": "Porsche GT3 Collective",
                              "members": "1,240",
                              "isMember": false,
                            },
                          ),
                        ),
                        _buildBrowseClubCard(
                          name: "Nürburgring Endurance Group",
                          members: "856",
                          imageUrl:
                              "https://picsum.photos/seed/nurendo/100/100",
                          onTap: () => Get.toNamed(
                            AppRoutes.clubDetailsScreen,
                            arguments: {
                              "name": "Nürburgring Endurance Group",
                              "members": "856",
                              "isMember": false,
                            },
                          ),
                        ),
                        _buildBrowseClubCard(
                          name: "Apex Strategy Masters",
                          members: "412",
                          imageUrl:
                              "https://picsum.photos/seed/apexprep/100/100",
                          onTap: () => Get.toNamed(
                            AppRoutes.clubDetailsScreen,
                            arguments: {
                              "name": "Apex Strategy Masters",
                              "members": "412",
                              "isMember": false,
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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
  final String status; // JOIN or WAITLIST

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
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFull = slots.toUpperCase() == "FULL";
    final bool isJoin = status.toUpperCase() == "JOIN";

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.eventDetailScreen,
          arguments: {
            'imageUrl': imageUrl,
            'title': title,
            'organizer': organizer,
            'date': date,
            'location': location,
            'likes': likes,
            'comments': comments,
            'timeWindow': '09:00 GMT',
            'capacity': isFull ? '100% FULL' : '84% FULL',
            'capacityProgress': isFull ? 1.0 : 0.84,
          },
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
                      const CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.person,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        organizer,
                        style: const TextStyle(
                          color: AppColors.yellow,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified,
                        color: AppColors.yellow,
                        size: 10,
                      ),
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
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        color: Colors.white38,
                        size: 16,
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
                      const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white38,
                        size: 16,
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
                      const Icon(
                        Icons.share_outlined,
                        color: Colors.white38,
                        size: 16,
                      ),
                      const Spacer(),

                      /// Action Button
                      Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: isJoin
                              ? AppColors.yellow
                              : const Color(0xff222222),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            status,
                            style: TextStyle(
                              color: isJoin ? Colors.black : Colors.white60,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
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

  Widget _metaRow(IconData icon, String label, {Color color = Colors.white60}) {
    return Row(
      children: [
        Icon(icon, color: Colors.white24, size: 12),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

Widget? _buildPostDetails(PostModel post) {
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
          _buildDetailRow(
            Icons.credit_card,
            "License Plate",
            spot.licensePlate ?? "N/A",
          ),
          const SizedBox(height: 6),
          _buildDetailRow(Icons.public, "Region", spot.region ?? "N/A"),
          const SizedBox(height: 6),
          _buildDetailRow(Icons.settings, "Engine", spot.engine ?? "N/A"),
          const SizedBox(height: 6),
          _buildDetailRow(
            Icons.flash_on,
            "Power",
            "${spot.powerHp ?? 'N/A'} HP",
          ),
          const SizedBox(height: 6),
          _buildDetailRow(
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
          _buildDetailRow(
            Icons.sports_motorsports,
            "Vehicle",
            session.vehicle ?? "N/A",
          ),
          const SizedBox(height: 6),
          _buildDetailRow(Icons.map, "Circuit", session.circuit ?? "N/A"),
          const SizedBox(height: 6),
          _buildDetailRow(Icons.flag, "Track", session.trackName ?? "N/A"),
          const SizedBox(height: 6),
          _buildDetailRow(
            Icons.timer,
            "Best Lap",
            session.bestLapTime ?? "N/A",
          ),
          const SizedBox(height: 6),
          _buildDetailRow(Icons.speed, "Top Speed", session.topSpeed ?? "N/A"),
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
              _buildDetailRow(
                Icons.category,
                "Category",
                biz.listingCategory ?? "N/A",
              ),
              const SizedBox(height: 6),
              _buildDetailRow(Icons.attach_money, "Price", biz.price ?? "N/A"),
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
          _buildDetailRow(Icons.map, "Circuit", track.circuit ?? "N/A"),
          const SizedBox(height: 6),
          _buildDetailRow(
            Icons.traffic,
            "Condition",
            track.surfaceCondition ?? "N/A",
          ),
          if (track.hazards != null && track.hazards!.isNotEmpty) ...[
            const SizedBox(height: 6),
            _buildDetailRow(
              Icons.warning,
              "Hazards",
              track.hazards!.join(", "),
            ),
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

Widget _buildDetailRow(IconData icon, String label, String value) {
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

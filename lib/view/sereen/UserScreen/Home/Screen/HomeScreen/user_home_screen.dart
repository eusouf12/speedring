import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../../../core/app_routes/app_routes.dart';
import '../../../../../../utils/app_images/app_images.dart';
import '../../../../../components/custom_appbar_user/custom_appbar_user.dart';
import 'comment_screen.dart' show showCommentSheet;
import 'story_view_screen.dart';
import 'create_story_screen.dart';
import 'post_detail_screen.dart';
import 'create_post_screen.dart';
import '../../widget/story_item.dart';
import '../../widget/add_post_button.dart';
import '../../widget/post_card.dart';
import '../../../../../components/custom_nav_bar/navbar.dart';
import '../../../../../../utils/app_colors/app_colors.dart';

class HomeController extends GetxController {
  final rxActiveTab = 0.obs; // 0: ALL, 1: EVENTS, 2: CLUBS
  void changeTab(int index) => rxActiveTab.value = index;
}

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final String userDisplayName = "CREATE";

    final List<Map<String, dynamic>> stories = [
      {'isMe': true, 'name': userDisplayName, 'image': null, 'icon': Icons.add},
      {
        'isMe': false,
        'name': 'MY DRIVE',
        'image': AppImages.helmet,
        'icon': null,
      },
      {
        'isMe': false,
        'name': 'TELEMETRY',
        'image': null,
        'icon': Icons.speed_outlined,
      },
      {
        'isMe': false,
        'name': 'LAP 4',
        'image': AppImages.electricBg,
        'icon': null,
      },
      {
        'isMe': false,
        'name': 'NÜRBURG',
        'image': AppImages.oldtimerBg,
        'icon': null,
      },
    ];

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomAppBarUser(
          showSearchIcon: true,
          onNotificationTap: () {
            Get.toNamed(AppRoutes.notificationScreen);
          },
          onMailTap: () {
            Get.toNamed(AppRoutes.messageScreen);
          },
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),

            /// ── STORIES ──────────────────────────────────────────────────
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];
                  return GestureDetector(
                    onTap: () {
                      if (story['isMe'] == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateStoryScreen(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StoryViewScreen(
                              userName: story['name'],
                              timeAgo: '14M AGO',
                              storyImageUrl: 'https://picsum.photos/400/800',
                            ),
                          ),
                        );
                      }
                    },
                    child: StoryItem(
                      isMe: story['isMe'],
                      name: story['name'],
                      imageSrc: story['image'],
                      icon: story['icon'],
                    ),
                  );
                },
              ),
            ),

            const Divider(color: Colors.white24),

            /// ── TABS ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _tab("ALL", controller.rxActiveTab.value == 0, () => controller.changeTab(0)),
                  const SizedBox(width: 10),
                  _tab("EVENTS", controller.rxActiveTab.value == 1, () => controller.changeTab(1)),
                  const SizedBox(width: 10),
                  _tab("CLUBS", controller.rxActiveTab.value == 2, () => controller.changeTab(2)),
                ],
              )),
            ),

            const SizedBox(height: 20),

            /// ── FEED AREA ────────────────────────────────────────────────
            Expanded(
              child: Obx(() => IndexedStack(
                index: controller.rxActiveTab.value,
                children: [
                  /// Tab 0: ALL Feed
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      AddPostButton(
                        label: "ADD POST",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreatePostScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      PostCard(
                        userName: "RED_BULL_FAN",
                        location: "Nürburgring",
                        imageUrl: "https://picsum.photos/600/401",
                        caption: "Circuit life never gets old. #Nürburgring #Racing",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PostDetailScreen(),
                          ),
                        ),
                        onLike: () {},
                        onComment: () => showCommentSheet(context),
                        onShare: () {},
                        onMore: () {},
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),

                  /// Tab 1: EVENTS Feed (matching SS design)
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _EventCard(
                        imageUrl: "https://picsum.photos/seed/silverstone_event/600/300",
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
                        imageUrl: "https://picsum.photos/seed/nurburg_event/600/300",
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
                        imageUrl: "https://picsum.photos/seed/yas_event/600/300",
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
                              imageUrl: "https://picsum.photos/seed/gt3coll/100/100",
                              onTap: () => Get.toNamed(
                                AppRoutes.clubDetailsScreen,
                                arguments: {"name": "Porsche GT3 Collective", "members": "1,248", "isMember": true},
                              ),
                            ),
                            const SizedBox(width: 20),
                            _buildCircularClubItem(
                              name: "NUR ENDO",
                              imageUrl: "https://picsum.photos/seed/nurendo/100/100",
                              onTap: () => Get.toNamed(
                                AppRoutes.clubDetailsScreen,
                                arguments: {"name": "Nürburgring Endurance Group", "members": "856", "isMember": true},
                              ),
                            ),
                            const SizedBox(width: 20),
                            _buildCircularClubItem(
                              name: "APEX PREP",
                              imageUrl: "https://picsum.photos/seed/apexprep/100/100",
                              onTap: () => Get.toNamed(
                                AppRoutes.clubDetailsScreen,
                                arguments: {"name": "Apex Strategy Masters", "members": "412", "isMember": true},
                              ),
                            ),
                            const SizedBox(width: 20),

                            /// Add New Club Button
                            GestureDetector(
                              onTap: () => Get.toNamed(AppRoutes.createClubScreen),
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
                                      child: Icon(Icons.add, color: AppColors.yellow, size: 22),
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
                        imageUrl: "https://picsum.photos/seed/gt3coll/100/100",
                        onTap: () => Get.toNamed(
                          AppRoutes.clubDetailsScreen,
                          arguments: {"name": "Porsche GT3 Collective", "members": "1,240", "isMember": false},
                        ),
                      ),
                      _buildBrowseClubCard(
                        name: "Nürburgring Endurance Group",
                        members: "856",
                        imageUrl: "https://picsum.photos/seed/nurendo/100/100",
                        onTap: () => Get.toNamed(
                          AppRoutes.clubDetailsScreen,
                          arguments: {"name": "Nürburgring Endurance Group", "members": "856", "isMember": false},
                        ),
                      ),
                      _buildBrowseClubCard(
                        name: "Apex Strategy Masters",
                        members: "412",
                        imageUrl: "https://picsum.photos/seed/apexprep/100/100",
                        onTap: () => Get.toNamed(
                          AppRoutes.clubDetailsScreen,
                          arguments: {"name": "Apex Strategy Masters", "members": "412", "isMember": false},
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ],
              )),
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
              errorBuilder: (context, _, _) => Container(height: 160, color: const Color(0xff1A1A1A)),
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
                        child: Icon(Icons.person, size: 10, color: Colors.white),
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
                      const Icon(Icons.verified, color: AppColors.yellow, size: 10),
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
                                color: isFull ? Colors.redAccent : AppColors.yellow,
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
                      const Icon(Icons.favorite_border, color: Colors.white38, size: 16),
                      const SizedBox(width: 4),
                      Text(likes, style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 14),
                      const Icon(Icons.chat_bubble_outline, color: Colors.white38, size: 16),
                      const SizedBox(width: 4),
                      Text(comments, style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 14),
                      const Icon(Icons.share_outlined, color: Colors.white38, size: 16),
                      const Spacer(),

                      /// Action Button
                      Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: isJoin ? AppColors.yellow : const Color(0xff222222),
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


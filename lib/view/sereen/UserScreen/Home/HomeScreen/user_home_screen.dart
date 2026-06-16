import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../../core/app_routes/app_routes.dart';
import '../../../../../utils/app_images/app_images.dart';
import '../../../../components/custom_appbar_user/custom_appbar_user.dart';
import 'comment_screen.dart' show showCommentSheet;
import 'story_view_screen.dart';
import 'create_story_screen.dart';
import 'post_detail_screen.dart';
import 'create_post_screen.dart';
import '../widget/story_item.dart';
import '../widget/add_post_button.dart';
import '../widget/post_card.dart';

import '../../../../components/custom_nav_bar/navbar.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        // "CREATE" — my story → open CreateStoryScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreateStoryScreen(),
                          ),
                        );
                      } else {
                        // Other story → open StoryViewScreen
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _tab("ALL", true),
                  const SizedBox(width: 10),
                  _tab("EVENTS", false),
                  const SizedBox(width: 10),
                  _tab("CLUBS", false),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ── FEED ─────────────────────────────────────────────────────
            Expanded(
              child: ListView(
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
                    userName: "CHASE_PERFORMANCE",
                    location: "Silverstone Circuit",
                    imageUrl: "https://picsum.photos/600/400",
                    caption: "New personal best! #TrackLife #Ferrari #Speedring",
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
            ),
          ],
        ),
        bottomNavigationBar: const CustomNavBar(currentIndex: 0),
      ),
    );
  }

  static Widget _tab(String title, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.amber : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: selected ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

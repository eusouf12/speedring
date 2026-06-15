import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_appbar_user/custom_appbar_user.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../SetupProfile/setup_profile_controller.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SetupProfileController? profileController =
        Get.isRegistered<SetupProfileController>()
        ? Get.find<SetupProfileController>()
        : null;
    final String userDisplayName =
        (profileController != null &&
            profileController.displayNameCtrl.text.isNotEmpty)
        ? profileController.displayNameCtrl.text
        : "CREATE";

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
        appBar: const CustomAppBarUser(showSearchIcon: true),
        body: Column(
          children: [
            const SizedBox(height: 10),

            /// STORIES
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];
                  return StoryItem(
                    isMe: story['isMe'],
                    name: story['name'],
                    imageSrc: story['image'],
                    icon: story['icon'],
                  );
                },
              ),
            ),

            const Divider(color: Colors.white24),

            /// TABS
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

            /// FEED
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  AddPostButton(),

                  SizedBox(height: 20),

                  PostCard(),

                  SizedBox(height: 20),

                  PostCard(),

                  SizedBox(height: 20),

                  TrackModeCard(),

                  SizedBox(height: 20),

                  SponsoredCard(),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
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

/// ---------------- STORY ----------------

class StoryItem extends StatelessWidget {
  const StoryItem({
    super.key,
    required this.isMe,
    required this.name,
    this.imageSrc,
    this.icon,
  });

  final bool isMe;
  final String name;
  final String? imageSrc;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Column(
        children: [
          /// Story Circle
          if (isMe)
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.yellow,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.yellow.withValues(alpha: 0.35),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 26,
                  weight: 900,
                ),
              ),
            )
          else
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.yellow, width: 1.5),
              ),
              child: ClipOval(
                child: imageSrc != null
                    ? CustomImage(
                        imageSrc: imageSrc!,
                        imageType: ImageType.png,
                        fit: BoxFit.cover,
                        width: 66,
                        height: 66,
                      )
                    : Container(
                        color: const Color(0xff1C1C1C),
                        child: Center(
                          child: Icon(
                            icon ?? Icons.person,
                            color: AppColors.yellow,
                            size: 22,
                          ),
                        ),
                      ),
              ),
            ),

          const SizedBox(height: 8),

          /// Name Label
          CustomText(
            text: name.toUpperCase(),
            color: isMe ? AppColors.yellow : Colors.white70,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ],
      ),
    );
  }
}

/// ---------------- ADD POST ----------------

class AddPostButton extends StatelessWidget {
  const AddPostButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle_outline),
            SizedBox(width: 8),
            Text("ADD POST", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

/// ---------------- POST CARD ----------------

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff1C1C1C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          /// Header
          ListTile(
            leading: const CircleAvatar(),
            title: const Text(
              "CHASE_PERFORMANCE",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              "Silverstone Circuit",
              style: TextStyle(color: Colors.grey),
            ),
            trailing: const Icon(Icons.more_horiz, color: Colors.white),
          ),

          /// Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              "https://picsum.photos/600/400",
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 12),

          /// Actions
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.favorite_border, color: Colors.white),
                SizedBox(width: 16),
                Icon(Icons.chat_bubble_outline, color: Colors.white),
                SizedBox(width: 16),
                Icon(Icons.share, color: Colors.white),
              ],
            ),
          ),

          const SizedBox(height: 12),

          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "New personal best! #TrackLife #Ferrari #Speedring",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------- TRACK MODE ----------------

class TrackModeCard extends StatelessWidget {
  const TrackModeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff1C1C1C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "SPA-FRANCORCHAMPS",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.map, color: Colors.amber),
            ],
          ),

          const SizedBox(height: 20),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TrackInfo("42", "LIVE DRIVERS"),
              _TrackInfo("24°C", "TRACK TEMP"),
              _TrackInfo("02:18", "BEST TODAY"),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("ENTER TRACK MODE"),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackInfo extends StatelessWidget {
  final String value;
  final String label;

  const _TrackInfo(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}

/// ---------------- SPONSORED ----------------

class SponsoredCard extends StatelessWidget {
  const SponsoredCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        "https://picsum.photos/600/500",
        fit: BoxFit.cover,
        height: 300,
        width: double.infinity,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../controller/home_controller.dart';
import 'package:speedring/service/api_url.dart';

class ClubDetailsScreen extends StatefulWidget {
  const ClubDetailsScreen({super.key});

  @override
  State<ClubDetailsScreen> createState() => _ClubDetailsScreenState();
}

class _ClubDetailsScreenState extends State<ClubDetailsScreen> {
  final HomeController controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null && Get.arguments['id'] != null) {
        controller.getSingleClub(Get.arguments['id']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.yellow,
              size: 24,
            ),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "CLUB DETAILS",
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          actions: [
            Obx(() {
              final club = controller.currentClubDetail.value;
              if (club == null) return const SizedBox();

              bool isAdmin =
                  club.members?.any(
                    (m) =>
                        m.user?.id == controller.currentUserId.value &&
                        m.role == "ADMIN",
                  ) ??
                  false;

              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.yellow),
                color: const Color(0xff1B1B1B),
                onSelected: (value) {
                  if (value == 'edit') {
                    Get.toNamed(AppRoutes.editClubScreen);
                  } else if (value == 'delete') {
                    Get.dialog(
                      AlertDialog(
                        backgroundColor: const Color(0xff181818),
                        title: const Text(
                          "Delete Club?",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: const Text(
                          "Are you sure you want to delete this club? This action cannot be undone.",
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text(
                              "CANCEL",
                              style: TextStyle(color: Colors.white54),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                              if (club.id != null) {
                                controller.deleteClub(club.id!).then((success) {
                                  if (success) {
                                    Get.back(); // Go back to clubs list
                                  }
                                });
                              }
                            },
                            child: const Text(
                              "YES",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (value == 'leave') {
                    Get.dialog(
                      AlertDialog(
                        backgroundColor: const Color(0xff181818),
                        title: const Text(
                          "Leave Club?",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: const Text(
                          "Are you sure you want to leave this club?",
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text(
                              "CANCEL",
                              style: TextStyle(color: Colors.white54),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                              if (club.id != null) {
                                controller.leaveClub(club.id!);
                              }
                            },
                            child: const Text(
                              "YES",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (value == 'requests') {
                    if (club.id != null) {
                      Get.toNamed(AppRoutes.clubJoinRequestsScreen, arguments: {'id': club.id});
                    }
                  } else if (value == 'members') {
                    if (club.id != null) {
                      Get.toNamed(AppRoutes.clubMembersScreen, arguments: {'id': club.id});
                    }
                  }
                },
                itemBuilder: (context) {
                  if (isAdmin) {
                    return [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text(
                          'Edit Group',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete Group',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'requests',
                        child: Text(
                          'View Join Requests',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'members',
                        child: Text(
                          'View Members',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'leave',
                        child: Text(
                          'Leave Group',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ];
                  } else {
                    return [
                      const PopupMenuItem(
                        value: 'members',
                        child: Text(
                          'View Members',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'leave',
                        child: Text(
                          'Leave Group',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ];
                  }
                },
              );
            }),
          ],
        ),

        body: Obx(() {
          if (controller.isClubDetailsLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }
          final club = controller.currentClubDetail.value;
          if (club == null) {
            return const Center(
              child: Text(
                "Club not found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          final String clubName = club.clubName ?? "Unknown";
          final String membersCount =
              "${club.totalMembersCount ?? club.members?.length ?? 0}";

          final String logoUrl = club.logo != null && club.logo!.isNotEmpty
              ? (club.logo!.startsWith('http')
                    ? club.logo!
                    : "${ApiUrl.imageUrl}${club.logo}")
              : "";

          final String bannerUrl =
              club.banner != null && club.banner!.isNotEmpty
              ? (club.banner!.startsWith('http')
                    ? club.banner!
                    : "${ApiUrl.imageUrl}${club.banner}")
              : "";

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Hero Banner & Logo Stack (Unified layout)
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      /// Banner Image
                      Container(
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(bannerUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.8),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),

                      /// Logo Overlap
                      Positioned(
                        bottom: 0,
                        left: 20,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.yellow,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.6),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              logoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, _, _) => const Icon(
                                Icons.shield,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Club Title
                      Text(
                        clubName.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),

                      /// Verified Member Badge Row
                      Text(
                        "ACTIVE MEMBERS: $membersCount",
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// Command Center
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xff111111),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              children: [
                                /// Group Chat Button (solid yellow)
                                _buildCommandButton(
                                  label: "GROUP CHAT",
                                  icon: Icons.chat_bubble_outline,
                                  isYellow: true,
                                  onPressed: () {
                                    Get.snackbar(
                                      "Chat",
                                      "Opening Group Chat room...",
                                    );
                                  },
                                ),
                                const SizedBox(height: 12),

                                /// Create Post Button
                                _buildCommandButton(
                                  label: "CREATE POST",
                                  icon: Icons.edit_outlined,
                                  isYellow: false,
                                  onPressed: () {
                                    Get.toNamed(AppRoutes.createPostScreen);
                                  },
                                ),
                                const SizedBox(height: 12),

                                /// Share Media Button
                                _buildCommandButton(
                                  label: "SHARE MEDIA",
                                  icon: Icons.photo_library_outlined,
                                  isYellow: false,
                                  onPressed: () {
                                    Get.snackbar(
                                      "Media",
                                      "Select media to upload...",
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          /// Command Center Badge Tag
                          Positioned(
                            top: -10,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              color: Colors.black,
                              child: const Text(
                                "COMMAND CENTER",
                                style: TextStyle(
                                  color: AppColors.yellow,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      /// Collective Feed Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "COLLECTIVE FEED",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            "LIVE_STREAM_v2.0",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// Collective Feed List
                      _buildFeedItem(
                        author: "MAXIMILLIAN_R",
                        time: "84m AGO",
                        content:
                            "Shared a new MoTeC data log from Spa-Francorchamps. Optimization on Sector 2 seems solid.",
                        likes: 24,
                        comments: 8,
                        avatar: "https://picsum.photos/seed/driver1/100/100",
                      ),
                      _buildFeedItem(
                        author: "ELARA_GT3",
                        time: "12m AGO",
                        content:
                            "Uploaded onboard footage: Nordschleife Sunset Session. Bridge-to-Gantry: 7:02.",
                        likes: 42,
                        comments: 15,
                        avatar: "https://picsum.photos/seed/driver2/100/100",
                        mediaUrl:
                            "https://picsum.photos/seed/porsche_cockpit/600/300",
                      ),
                      _buildFeedItem(
                        author: "TECH_LEAD_SAM",
                        time: "1h AGO",
                        content:
                            "New guide posted: Dampening Adjustments for high-speed undulations at Portimão.",
                        likes: 18,
                        comments: 3,
                        avatar: "https://picsum.photos/seed/driver3/100/100",
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCommandButton({
    required String label,
    required IconData icon,
    required bool isYellow,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isYellow
              ? AppColors.yellow
              : const Color(0xff1d1d1d),
          foregroundColor: isYellow ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isYellow
                ? BorderSide.none
                : const BorderSide(color: Colors.white10),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              size: 16,
              color: isYellow ? Colors.black : Colors.white38,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedItem({
    required String author,
    required String time,
    required String content,
    required int likes,
    required int comments,
    required String avatar,
    String? mediaUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 16, backgroundImage: NetworkImage(avatar)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    author,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: const TextStyle(color: Colors.white38, fontSize: 9),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          if (mediaUrl != null) ...[
            const SizedBox(height: 12),
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(mediaUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.thumb_up_alt_outlined,
                color: Colors.white38,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                "$likes",
                style: const TextStyle(color: Colors.white38, fontSize: 10),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white38,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                "$comments",
                style: const TextStyle(color: Colors.white38, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';

class ClubDetailsScreen extends StatelessWidget {
  const ClubDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String clubName = Get.arguments?['name'] ?? 'PORSCHE GT3 COLLECTIVE';
    final String membersCount = Get.arguments?['members'] ?? '1,240';
    final bool isAlreadyMember = Get.arguments?['isMember'] ?? false;

    // RxBool to manage membership state dynamically in this screen session
    final RxBool rxIsMember = isAlreadyMember.obs;

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.yellow, size: 24),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "CLUB DETAILS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                Get.toNamed(AppRoutes.editClubScreen);
              },
            ),
          ],
        ),
        body: Obx(() {
          if (!rxIsMember.value) {
            /// ==================== 3rd Page: Guest / Join View ====================
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Hero Banner & Logo Stack
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
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("https://picsum.photos/seed/porschegt3/800/400"),
                              fit: BoxFit.cover,
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
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white24, width: 2),
                            ),
                            child: Center(
                              child: Image.network(
                                "https://api.qrserver.com/v1/create-qr-code/?size=100x100&data=porsche_shield",
                                width: 60,
                                height: 60,
                                errorBuilder: (context, _, _) => const Icon(Icons.directions_car, color: AppColors.yellow, size: 40),
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
                        const SizedBox(height: 20),
      
                        /// JOIN CLUB Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellow,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              rxIsMember.value = true;
                              Get.snackbar(
                                "Welcome!",
                                "You are now a member of $clubName",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: const Color(0xff181818),
                                colorText: Colors.white,
                                borderColor: AppColors.yellow,
                                borderWidth: 1,
                              );
                            },
                            child: const Text(
                              "JOIN CLUB",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
      
                        /// Info Card row (MEMBERS, GLOBAL RANK, ACCESS)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xff111111),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Row(
                            children: [
                              _buildInfoCol("MEMBERS", membersCount),
                              _buildVerticalDivider(),
                              _buildInfoCol("GLOBAL RANK", "#04"),
                              _buildVerticalDivider(),
                              _buildInfoCol("ACCESS", "PUBLIC"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
      
                        /// About card
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
                              decoration: BoxDecoration(
                                color: const Color(0xff181818),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: const Text(
                                "The Porsche GT3 Collective is an elite alliance dedicated to the pursuit of mechanical perfection. We focus exclusively on the 911 GT3 lineage, prioritizing technical telemetry, precision driving, and structural engineering insights. Our mission is to bridge the gap between amateur enthusiasm and professional endurance standards, providing a sanctuary for those who view driving as a data-driven discipline rather than a casual leisure activity.",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  height: 1.6,
                                ),
                              ),
                            ),
      
                            /// About Tag
                            Positioned(
                              top: -10,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                color: Colors.black,
                                child: const Text(
                                  "About",
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
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            /// ==================== 4th Page: Member / Command Center View ====================
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
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("https://picsum.photos/seed/porschegt3/800/400"),
                              fit: BoxFit.cover,
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
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white24, width: 2),
                            ),
                            child: Center(
                              child: Image.network(
                                "https://api.qrserver.com/v1/create-qr-code/?size=100x100&data=porsche_shield",
                                width: 60,
                                height: 60,
                                errorBuilder: (context, _, _) => const Icon(Icons.directions_car, color: AppColors.yellow, size: 40),
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
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.yellow.withValues(alpha:0.15),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.yellow, width: 1),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.verified, color: AppColors.yellow, size: 10),
                                  SizedBox(width: 4),
                                  Text(
                                    "VERIFIED MEMBER",
                                    style: TextStyle(
                                      color: AppColors.yellow,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "ACTIVE MEMBERS: $membersCount",
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
                                      Get.snackbar("Chat", "Opening Group Chat room...");
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
                                      Get.snackbar("Media", "Select media to upload...");
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
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                          content: "Shared a new MoTeC data log from Spa-Francorchamps. Optimization on Sector 2 seems solid.",
                          likes: 24,
                          comments: 8,
                          avatar: "https://picsum.photos/seed/driver1/100/100",
                        ),
                        _buildFeedItem(
                          author: "ELARA_GT3",
                          time: "12m AGO",
                          content: "Uploaded onboard footage: Nordschleife Sunset Session. Bridge-to-Gantry: 7:02.",
                          likes: 42,
                          comments: 15,
                          avatar: "https://picsum.photos/seed/driver2/100/100",
                          mediaUrl: "https://picsum.photos/seed/porsche_cockpit/600/300",
                        ),
                        _buildFeedItem(
                          author: "TECH_LEAD_SAM",
                          time: "1h AGO",
                          content: "New guide posted: Dampening Adjustments for high-speed undulations at Portimão.",
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
          }
        }),
      ),
    );
  }

  Widget _buildInfoCol(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white10,
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
          backgroundColor: isYellow ? AppColors.yellow : const Color(0xff1d1d1d),
          foregroundColor: isYellow ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isYellow ? BorderSide.none : const BorderSide(color: Colors.white10),
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
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(avatar),
              ),
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
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 9,
                    ),
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
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.thumb_up_alt_outlined, color: Colors.white38, size: 14),
              const SizedBox(width: 4),
              Text(
                "$likes",
                style: const TextStyle(color: Colors.white38, fontSize: 10),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.chat_bubble_outline, color: Colors.white38, size: 14),
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

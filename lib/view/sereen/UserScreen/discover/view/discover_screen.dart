import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/view/components/custom_appbar_user/custom_appbar_user.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_nav_bar/navbar.dart';
import 'package:speedring/view/sereen/UserScreen/discover/controller/discover_controller.dart';
import 'package:speedring/view/sereen/UserScreen/discover/model/discover_model.dart';

class DiscoverScreen extends StatelessWidget {
  DiscoverScreen({super.key});

  final DiscoverController controller = Get.find<DiscoverController>();

  final List<String> spottingTags = [
    "Trending",
    "GT3 Series",
    "Nürburgring",
    "Spa-Francorchamps",
  ];
  final List<String> videoTags = ["All", "Onboard", "Technical", "Vlogs"];

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomAppBarUser(
          showSearchIcon: true,
          onNotificationTap: () => Get.toNamed(AppRoutes.notificationScreen),
          onMailTap: () => Get.toNamed(AppRoutes.messageScreen),
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),

            /// 1. Tab Selector: Spotting, Videos, Network
            _buildTabBar(),
            const SizedBox(height: 16),

            /// 2. Active Tab View
            Expanded(child: Obx(() => _buildActiveTabView())),
          ],
        ),
        bottomNavigationBar: const CustomNavBar(currentIndex: 1),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12, width: 1)),
      ),
      child: Obx(
        () => Row(
          children: [
            _buildTabItem(0, "Spotting"),
            _buildTabItem(1, "Videos"),
            _buildTabItem(2, "Network"),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    final bool isSelected = controller.activeSubTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.activeSubTab.value = index;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.yellow : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white38,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabView() {
    switch (controller.activeSubTab.value) {
      case 0:
        return _buildSpottingTab();
      case 1:
        return _buildVideosTab();
      case 2:
        return _buildNetworkTab();
      default:
        return _buildSpottingTab();
    }
  }

  /// ==================== 1. SPOTTING TAB ====================
  Widget _buildSpottingTab() {
    return RefreshIndicator(
      color: AppColors.yellow,
      backgroundColor: Colors.black,
      onRefresh: () async {
        await controller.getAllDiscoverPosts(refresh: true);
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!controller.isDiscoverLoading.value &&
              !controller.isMoreLoading.value &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            controller.getAllDiscoverPosts();
            return true;
          }
          return false;
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            /// ADD NEW SPOT Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Get.toNamed(AppRoutes.addSpotScreen),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_circle_outline, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "ADD NEW SPOT",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// Dynamic Spots list
            Obx(() {
              if (controller.isDiscoverLoading.value &&
                  controller.discoverPosts.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.yellow),
                );
              }
              if (controller.discoverPosts.isEmpty) {
                return const Center(
                  child: Text(
                    "No posts found",
                    style: TextStyle(color: Colors.white54),
                  ),
                );
              }
              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.discoverPosts.length,
                    itemBuilder: (context, index) {
                      final post = controller.discoverPosts[index];
                      return Obx(() => _buildSpotCard(post));
                    },
                  ),
                  if (controller.isMoreLoading.value)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: CircularProgressIndicator(color: AppColors.yellow),
                    ),
                ],
              );
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSpotCard(DiscoverPost post) {
    String imageUrl = "https://picsum.photos/seed/blue992/600/350";
    if (post.media != null && post.media!.isNotEmpty) {
      imageUrl = post.media!.first.url ?? imageUrl;
    }

    debugPrint("=== checking isMine ===");
    debugPrint("post.user?.id: ${post.user?.id}");
    debugPrint("controller.currentUserId.value: ${controller.currentUserId.value}");
    final bool isMine = post.user?.id != null && 
        controller.currentUserId.value.isNotEmpty && 
        post.user?.id == controller.currentUserId.value;
    debugPrint("isMine evaluated to: $isMine");

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Car Image & Badge Stack
          Stack(
            children: [
              Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey.shade900,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.white54,
                  ),
                ),
              ),
              // Region badge (top-left)
              if (post.spotDetails?.region != null)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      post.spotDetails!.region!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              // 3-dot menu (top-right) — only shown for post owner
              if (isMine)
                Positioned(
                  top: 4,
                  right: 4,
                  child: PopupMenuButton<String>(
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.more_vert, color: Colors.white, size: 18),
                    ),
                    color: const Color(0xff1C1C1C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (value) {
                      if (value == 'edit') {
                        Get.toNamed(AppRoutes.editSpotScreen, arguments: post);
                      } else if (value == 'delete') {
                        _showDeleteConfirmDialog(post.id ?? "");
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, color: Colors.white70, size: 16),
                            SizedBox(width: 10),
                            Text('Edit', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.red, size: 16),
                            SizedBox(width: 10),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          /// Description Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.spotDetails?.makeAndModel ?? "Unknown Model",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                "Spotted by @${post.user?.userName ?? "Unknown"}",
                                style: const TextStyle(color: Colors.white38, fontSize: 11),
                              ),
                              if (post.spotDetails?.licensePlate != null &&
                                  post.spotDetails!.licensePlate!.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white24),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.tag, color: Colors.white54, size: 10),
                                      const SizedBox(width: 3),
                                      Text(
                                        post.spotDetails!.licensePlate!,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Share button
                    GestureDetector(
                      onTap: () {
                        final link = "https://speedring.com/discover/${post.id}";
                        SharePlus.instance.share(
                          ShareParams(
                            text: "Check out this car spot on Speedring:\n\n$link",
                            subject: "Speedring Car Spot",
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.share_outlined,
                          color: Colors.white70,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(height: 1, color: Colors.white10),
                const SizedBox(height: 12),

                /// Car Stats
                Row(
                  children: [
                    _buildStatCol("ENGINE", post.spotDetails?.engine ?? "-"),
                    _buildVerticalDivider(),
                    _buildStatCol("POWER", post.spotDetails?.powerHp ?? "-"),
                    _buildVerticalDivider(),
                    _buildStatCol(
                      "0-100",
                      post.spotDetails?.zeroToHundred ?? "-",
                      isYellowValue: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(String postId) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xff181818),
        title: const Text("Delete Post", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Are you sure you want to delete this spot?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("No", style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteDiscoverPost(postId);
            },
            child: const Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCol(
    String label,
    String value, {
    bool isYellowValue = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 8,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: isYellowValue ? AppColors.yellow : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(width: 1, height: 24, color: Colors.white10);
  }

  /// ==================== 2. VIDEOS TAB ====================
  Widget _buildVideosTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        /// Horizontal subtags list
        SizedBox(
          height: 36,
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: videoTags.length,
              itemBuilder: (context, idx) {
                final tag = videoTags[idx];
                final isSel = controller.activeVideoTag.value == tag;
                return GestureDetector(
                  onTap: () => controller.activeVideoTag.value = tag,
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.yellow : const Color(0xff181818),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: isSel ? Colors.black : Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),

        /// ADD NEW VIDEO Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.yellow,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () => Get.toNamed(AppRoutes.addVideoScreen),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add_circle_outline, size: 18),
                SizedBox(width: 8),
                Text(
                  "ADD NEW VIDEO",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        /// Title uploads header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "LATEST UPLOADS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              "VIEW ALL",
              style: TextStyle(
                color: AppColors.yellow,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        /// Video Feed List
        _buildVideoCard(
          thumbnailUrl: "https://picsum.photos/seed/steering/600/350",
          duration: "11:02",
          category: "TECHNICAL",
          title: "Aero Deep Dive: 992 GT3 RS Downforce",
          creator: "EngineeringExplained",
          views: "214K VIEWS",
          postedTime: "2 DAYS AGO",
        ),
        _buildVideoCard(
          thumbnailUrl: "https://picsum.photos/seed/nightrun/600/350",
          duration: "8:45",
          category: "ONBOARD",
          title: "Night Run: Porsche Carrera GT - V10 Screamer",
          creator: "AutoTopNL",
          views: "890K VIEWS",
          postedTime: "5 DAYS AGO",
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildVideoCard({
    required String thumbnailUrl,
    required String duration,
    required String category,
    required String title,
    required String creator,
    required String views,
    required String postedTime,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Thumbnail Stack
          Stack(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(thumbnailUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    duration,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// Video Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Creator Avatar (Placeholder)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white12,
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white54,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        color: AppColors.yellow,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$creator • $views • $postedTime",
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.white54, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  /// ==================== 3. NETWORK TAB ====================
  Widget _buildNetworkTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        /// Quick Action Row
        Row(
          children: [
            Expanded(
              child: _buildNetworkActionBtn(
                icon: Icons.person_add_outlined,
                label: "CONNECT",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNetworkActionBtn(
                icon: Icons.qr_code_scanner,
                label: "SCAN ID",
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        /// SUGGESTED CONNECTIONS Header
        const Text(
          "SUGGESTED CONNECTIONS",
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),

        /// Users list
        _buildUserTile(
          name: "Alex V.",
          username: "@alex_gt3",
          carInfo: "992 GT3 / RS6 Avant",
          avatarUrl: "https://i.pravatar.cc/150?img=11",
        ),
        _buildUserTile(
          name: "Sarah M.",
          username: "@speed_sarah",
          carInfo: "Huracan STO",
          avatarUrl: "https://i.pravatar.cc/150?img=9",
        ),
        _buildUserTile(
          name: "Mark T.",
          username: "@mark_turbo",
          carInfo: "911 Turbo S",
          avatarUrl: "https://i.pravatar.cc/150?img=15",
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildNetworkActionBtn({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.yellow, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
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

  Widget _buildUserTile({
    required String name,
    required String username,
    required String carInfo,
    required String avatarUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(avatarUrl),
            backgroundColor: Colors.white12,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  username,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
                const SizedBox(height: 4),
                Text(
                  carInfo,
                  style: const TextStyle(
                    color: AppColors.yellow,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "CONNECT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

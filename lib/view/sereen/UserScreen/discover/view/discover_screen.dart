import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/view/components/custom_appbar_user/custom_appbar_user.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_nav_bar/navbar.dart';
import 'package:speedring/utils/navigation_utils.dart';
import 'package:speedring/view/sereen/UserScreen/discover/controller/discover_controller.dart';
import 'package:speedring/view/sereen/UserScreen/discover/model/discover_model.dart';
import 'package:speedring/view/sereen/UserScreen/discover/model/network_user_model.dart';

import 'package:speedring/view/sereen/UserScreen/discover/view/video_player_item.dart';

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
          onSearchTap: () => controller.showSearchBar.toggle(),
          onNotificationTap: () => Get.toNamed(AppRoutes.notificationScreen),
          onMailTap: () => Get.toNamed(AppRoutes.messageScreen),
        ),
        body: Column(
          children: [
            // ── Search Bar ──
            Obx(() {
              if (!controller.showSearchBar.value) {
                return const SizedBox.shrink();
              }
              final isVideo = controller.activeSubTab.value == 1;
              final isNetwork = controller.activeSubTab.value == 2;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff1C1C1C),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: isVideo
                          ? 'searchVideosHint'.tr
                          : isNetwork
                              ? 'searchUsersHint'.tr
                              : 'searchSpotsHint'.tr,
                      hintStyle: const TextStyle(color: Colors.white30),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white70,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () {
                          if (isVideo) {
                            controller.searchVideoPosts("");
                          } else if (isNetwork) {
                            controller.searchNetworkUsers("");
                          } else {
                            controller.searchDiscoverPosts("");
                          }
                          controller.showSearchBar.value = false;
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (val) {
                      if (isVideo) {
                        controller.searchVideoPosts(val);
                      } else if (isNetwork) {
                        controller.searchNetworkUsers(val);
                      } else {
                        controller.searchDiscoverPosts(val);
                      }
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 10),
            _buildTabBar(),
            const SizedBox(height: 16),
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
            _buildTabItem(0, 'spottingTab'.tr),
            _buildTabItem(1, 'videosTab'.tr),
            _buildTabItem(2, 'networkTab'.tr),
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
          if (controller.activeSubTab.value == index) return;
          controller.activeSubTab.value = index;
          if (index == 0) {
            controller.getAllDiscoverPosts(refresh: true);
          } else if (index == 1) {
            controller.getAllVideoPosts(refresh: true);
          } else if (index == 2) {
            controller.getNetworkUsers(refresh: true);
          }
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
              scrollInfo.metrics.maxScrollExtent > 0 &&
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
                  children: [
                    Icon(Icons.add_circle_outline, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'addNewSpot'.tr,
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
                return Center(
                  child: Text(
                    'noPostsFound'.tr,
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
    String imageUrl = "";
    if (post.media != null && post.media!.isNotEmpty) {
      imageUrl = post.media!.first.url ?? imageUrl;
    }

    debugPrint("=== checking isMine ===");
    debugPrint("post.user?.id: ${post.user?.id}");
    debugPrint(
      "controller.currentUserId.value: ${controller.currentUserId.value}",
    );
    final bool isMine =
        post.user?.id != null &&
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    color: const Color(0xff1C1C1C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        Get.toNamed(AppRoutes.editSpotScreen, arguments: post);
                      } else if (value == 'delete') {
                        _showDeleteConfirmDialog(post.id ?? "");
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              color: Colors.white70,
                              size: 16,
                            ),
                            SizedBox(width: 10),
                            Text('edit'.tr, style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 16,
                            ),
                            SizedBox(width: 10),
                            Text('delete'.tr, style: TextStyle(color: Colors.red)),
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
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 11,
                                ),
                              ),
                              if (post.spotDetails?.licensePlate != null &&
                                  post
                                      .spotDetails!
                                      .licensePlate!
                                      .isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white24),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.tag,
                                        color: Colors.white54,
                                        size: 10,
                                      ),
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
                        final link =
                            "https://speedring.com/discover/${post.id}";
                        SharePlus.instance.share(
                          ShareParams(
                            text:
                                'checkOutSpot'.tr + link,
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
        title: Text('deletePost'.tr, style: TextStyle(color: Colors.white)),
        content: Text(
          'deleteSpotConfirm'.tr,
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('no'.tr, style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteDiscoverPost(postId);
            },
            child: Text('yes'.tr, style: TextStyle(color: Colors.red)),
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
    return RefreshIndicator(
      color: AppColors.yellow,
      backgroundColor: Colors.black,
      onRefresh: () async => controller.getAllVideoPosts(refresh: true),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!controller.isVideoLoading.value &&
              !controller.isMoreVideoLoading.value &&
              scrollInfo.metrics.maxScrollExtent > 0 &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            controller.getAllVideoPosts();
            return true;
          }
          return false;
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            /// Horizontal tag filter
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: videoTags.length,
                itemBuilder: (context, idx) {
                  final tag = videoTags[idx];
                  return Obx(() {
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
                          color: isSel
                              ? AppColors.yellow
                              : const Color(0xff181818),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: Text(
                            tag == 'All' ? 'all'.tr : tag == 'Onboard' ? 'onboard'.tr : tag == 'Technical' ? 'technical'.tr : tag == 'Vlogs' ? 'vlogs'.tr : tag.tr,
                            style: TextStyle(
                              color: isSel ? Colors.black : Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            /// ADD NEW VIDEO button
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
                  children: [
                    Icon(Icons.add_circle_outline, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'addNewVideo'.tr,
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'latestUploads'.tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Video List
            Obx(() {
              if (controller.isVideoLoading.value &&
                  controller.videoPosts.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.yellow),
                );
              }
              if (controller.videoPosts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      'noVideosFound'.tr,
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.videoPosts.length,
                    itemBuilder: (context, index) {
                      final video = controller.videoPosts[index];

                      final isMine =
                          video.user?.id != null &&
                          controller.currentUserId.value.isNotEmpty &&
                          video.user!.id == controller.currentUserId.value;

                      final createdAt = video.createdAt;
                      String postedTime = "";
                      if (createdAt != null) {
                        final diff = DateTime.now().difference(createdAt);
                        if (diff.inDays > 0) {
                          postedTime =
                              "${diff.inDays} ${diff.inDays == 1 ? 'DAY' : 'DAYS'} AGO";
                        } else if (diff.inHours > 0) {
                          postedTime = "${diff.inHours}H AGO";
                        } else {
                          postedTime = "JUST NOW";
                        }
                      }

                      return VideoPlayerItem(
                        video: video,
                        isMine: isMine,
                        postedTime: postedTime,
                      );
                    },
                  ),
                  if (controller.isMoreVideoLoading.value)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
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

  /// ==================== 3. NETWORK TAB ====================
  Widget _buildNetworkTab() {
    return RefreshIndicator(
      color: AppColors.yellow,
      backgroundColor: Colors.black,
      onRefresh: () async => controller.getNetworkUsers(refresh: true),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!controller.isNetworkLoading.value &&
              !controller.isMoreNetworkLoading.value &&
              scrollInfo.metrics.maxScrollExtent > 0 &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            controller.getNetworkUsers();
            return true;
          }
          return false;
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            Text(
              'suggestedConnections'.tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.isNetworkLoading.value &&
                  controller.networkUsers.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.yellow),
                );
              }
              if (controller.networkUsers.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      'noSuggestedConnections'.tr,
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.networkUsers.length,
                    itemBuilder: (context, index) {
                      final user = controller.networkUsers[index];
                      return _buildUserTile(user: user);
                    },
                  ),
                  if (controller.isMoreNetworkLoading.value)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
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

  Widget _buildUserTile({required NetworkUser user}) {
    String name = user.name ?? "Unknown";
    String username = user.userName != null ? "@${user.userName}" : "";
    String carInfo = user.role?.toUpperCase() ?? "USER";
    String avatarUrl = user.profileImage ?? "";
    bool isFollowing = user.isFollowing;

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
          GestureDetector(
            onTap: () {
              if (user.id != null) {
                NavigationUtils.navigateToUserProfile(user.id!);
              }
            },
            child: CircleAvatar(
              radius: 24,
              backgroundImage: avatarUrl.isNotEmpty
                  ? NetworkImage(avatarUrl)
                  : null,
              backgroundColor: Colors.white12,
              child: avatarUrl.isEmpty
                  ? const Icon(Icons.person, color: Colors.white54)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (user.id != null) {
                      NavigationUtils.navigateToUserProfile(user.id!);
                    }
                  },
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  username,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
          GestureDetector(
            onTap: () {
              if (user.id != null) {
                controller.toggleFollowUser(user.id!);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isFollowing ? AppColors.yellow : Colors.white12,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isFollowing ? 'followingUpper'.tr : 'follow'.tr,
                style: TextStyle(
                  color: isFollowing ? Colors.black : Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

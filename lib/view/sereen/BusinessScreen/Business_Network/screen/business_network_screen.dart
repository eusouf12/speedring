import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/sereen/BusinessScreen/BusinessHome/business_navbar.dart';
import 'package:speedring/view/sereen/UserScreen/discover/controller/discover_controller.dart';
import 'package:speedring/view/sereen/UserScreen/discover/model/network_user_model.dart';
import 'package:speedring/helper/guest_checker.dart';
import 'package:speedring/utils/navigation_utils.dart';

class BusinessNetworkScreen extends StatelessWidget {
  const BusinessNetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DiscoverController>();

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'businessNetworkTitle'.tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          centerTitle: true,
          actions: [
            Obx(() => IconButton(
                  icon: Icon(
                    controller.showSearchBar.value
                        ? Icons.search_off_rounded
                        : Icons.search_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () => controller.showSearchBar.toggle(),
                )),
          ],
        ),
        body: Column(
          children: [
            // ── Search Bar ──
            Obx(() {
              if (!controller.showSearchBar.value) {
                return const SizedBox.shrink();
              }
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
                      hintText: 'searchUsersHint'.tr,
                      hintStyle: const TextStyle(color: Colors.white30),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white70,
                      ),
                      suffixIcon: IconButton(
                        icon:
                            const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () {
                          controller.searchNetworkUsers("");
                          controller.showSearchBar.value = false;
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (val) {
                      controller.searchNetworkUsers(val);
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            // ── Network Users List ──
            Expanded(
              child: RefreshIndicator(
                color: AppColors.yellow,
                backgroundColor: Colors.black,
                onRefresh: () async =>
                    controller.getNetworkUsers(refresh: true),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (!controller.isNetworkLoading.value &&
                        !controller.isMoreNetworkLoading.value &&
                        scrollInfo.metrics.maxScrollExtent > 0 &&
                        scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
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
                        style: const TextStyle(
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
                            child: CircularProgressIndicator(
                                color: AppColors.yellow),
                          );
                        }
                        if (controller.networkUsers.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Text(
                                'noSuggestedConnections'.tr,
                                style: const TextStyle(
                                    color: Colors.white54),
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              itemCount:
                                  controller.networkUsers.length,
                              itemBuilder: (context, index) {
                                final user =
                                    controller.networkUsers[index];
                                return _buildUserTile(
                                    user: user,
                                    controller: controller);
                              },
                            ),
                            if (controller
                                .isMoreNetworkLoading.value)
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20),
                                child: CircularProgressIndicator(
                                    color: AppColors.yellow),
                              ),
                          ],
                        );
                      }),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CustomBusinessNavBar(currentIndex: -1),
      ),
    );
  }

  Widget _buildUserTile({
    required NetworkUser user,
    required DiscoverController controller,
  }) {
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
              backgroundImage:
                  avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
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
                  style:
                      const TextStyle(color: Colors.white54, fontSize: 11),
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
              if (GuestChecker.showLoginDialogIfGuest()) return;
              if (user.id != null) {
                controller.toggleFollowUser(user.id!);
              }
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_const/app_const.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../../utils/app_images/app_images.dart';
import '../../../../components/custom_button/custom_button.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../components/custom_nav_bar/navbar.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../core/app_routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/profile_controller.dart';
import '../widgets/garage_vehicle_card.dart';
import '../../Home/Screen/HomeScreen/controller/home_controller.dart';
import '../../Home/widget/story_item.dart';
import '../../Home/Screen/HomeScreen/view/story/create_story_screen.dart';
import '../../Home/Screen/HomeScreen/view/story/story_view_screen.dart';
import '../../Home/widget/post_card.dart';
import '../../Home/Screen/HomeScreen/view/post/post_detail_screen.dart';
import '../../Home/Screen/HomeScreen/view/post/comment_screen.dart'
    show showCommentSheet;
import '../../Home/Screen/HomeScreen/view/user_home_screen.dart'
    show buildPostDetails;
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileScreenController>();
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,

          title: Image.asset(
            AppImages.splashLogo,
            height: 150,
            width: 350,
            fit: BoxFit.contain,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: AppColors.yellow,
              ),
              onPressed: () => Get.toNamed(AppRoutes.notificationScreen),
            ),
            IconButton(
              icon: const Icon(
                Icons.settings_outlined,
                color: AppColors.yellow,
              ),
              onPressed: () => Get.toNamed(AppRoutes.userParametersScreen),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }
          final profile = controller.profileData.value;
          final driverInfo = profile?.driverInfo;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Banner & Avatar Stack
                SizedBox(
                  height: 220.h,
                  width: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      /// Banner Image
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 180.h,
                        child: Image.network(
                          profile?.profileBanner ?? "",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: const Color(0xff1C1C1C),
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.white24,
                                    size: 48,
                                  ),
                                ),
                              ),
                        ),
                      ),
                      Positioned(
                        top: 12.h,
                        right: 12.w,
                        child: GestureDetector(
                          onTap: () {
                            if (profile != null) {
                              controller.initEditProfile(profile);
                            }
                            Get.toNamed(
                              AppRoutes.editProfileScreen,
                              arguments: profile,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(color: Colors.white24),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.edit,
                                  color: Colors.white70,
                                  size: 12,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "edit".tr.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// Profile Avatar
                      Positioned(
                        bottom: 0,
                        left: 16.w,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  profile?.profileImage ??
                                      AppConstants.profileImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        color: const Color(0xff1C1C1C),
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.white24,
                                          size: 40,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Coins indicator
                      Positioned(
                        bottom: 4.h,
                        right: 16.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => Get.toNamed(AppRoutes.walletScreen),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xff161616),
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.05),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.wallet,
                                      color: AppColors.yellow,
                                      size: 14,
                                    ),
                                    SizedBox(width: 4.w),
                                    CustomText(
                                      text:
                                          "${profile?.coinBalance ?? 0} ${'coins'.tr}"
                                              .toUpperCase(),
                                      color: AppColors.yellow1,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),

                /// Profile Identity Details
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: profile?.name?.toUpperCase() ?? "",
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          const Icon(
                            Icons.flag,
                            color: Colors.blue,
                            size: 14,
                          ), // Dutch flag placeholder
                          SizedBox(width: 6.w),
                          CustomText(
                            text:
                                "@${profile?.userName?.replaceAll(' ', '_').toLowerCase() ?? 'unknown username'}",
                            color: AppColors.yellow,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      CustomText(
                        text:
                            driverInfo?.bio ??
                            "No biography provided. Pushing the limits of engineering and performance.",
                        color: Colors.white70,
                        fontSize: 11,
                        textAlign: TextAlign.start,
                        height: 1.4,
                      ),
                      SizedBox(height: 16.h),

                      /// Social Toggles and Support button
                      Row(
                        children: [
                          if (driverInfo?.socialLinks?.instagram?.isNotEmpty ??
                              false) ...[
                            _buildSocialIcon(
                              Icons.camera_alt_outlined,
                              driverInfo!.socialLinks!.instagram!,
                            ),
                            SizedBox(width: 10.w),
                          ],
                          if (driverInfo?.socialLinks?.tiktok?.isNotEmpty ??
                              false) ...[
                            _buildSocialIcon(
                              Icons.music_note_outlined,
                              driverInfo!.socialLinks!.tiktok!,
                            ),
                            SizedBox(width: 10.w),
                          ],
                          if (driverInfo?.socialLinks?.youtube?.isNotEmpty ??
                              false) ...[
                            _buildSocialIcon(
                              Icons.play_circle_outline,
                              driverInfo!.socialLinks!.youtube!,
                            ),
                            SizedBox(width: 10.w),
                          ],
                          if (driverInfo?.socialLinks?.facebook?.isNotEmpty ??
                              false) ...[
                            _buildSocialIcon(
                              Icons.facebook_outlined,
                              driverInfo!.socialLinks!.facebook!,
                            ),
                          ],
                          const Spacer(),
                          CustomButton(
                            height: 34.h,
                            width: 110.w,
                            title: "support".tr.toUpperCase(),
                            fontSize: 10,
                            borderRadius: 18.r,
                            icon: const Icon(
                              Icons.sell_outlined,
                              color: Colors.black,
                              size: 12,
                            ),
                            onTap: () {
                              Get.toNamed(AppRoutes.supportSentScreen);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                /// Stats section
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: const Color(0xff111111),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      _buildStatItem(
                        "posts".tr.toUpperCase(),
                        "${profile?.postCount ?? 0}",
                      ),
                      _buildStatDivider(),
                      _buildStatItem(
                        "followers".tr.toUpperCase(),
                        "${profile?.followerCount ?? 0}",
                      ),
                      _buildStatDivider(),
                      _buildStatItem(
                        "sessions".tr.toUpperCase(),
                        "${profile?.joinedSessionCount ?? 0}",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                /// Stories / Highlights
                SizedBox(
                  height: 110,
                  child: GetBuilder<HomeController>(
                    init: Get.isRegistered<HomeController>()
                        ? null
                        : HomeController(),
                    builder: (homeController) {
                      return Obx(() {
                        if (homeController.isStoriesLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.yellow,
                            ),
                          );
                        }

                        // Filter to show only the profile user's stories
                        final storiesList = homeController.allStories
                            .where((s) => s.user?.id == profile?.id)
                            .toList();

                        // Show create button only if it's my profile
                        final isMyProfile =
                            profile?.id == homeController.currentUserId.value;
                        final itemCount = isMyProfile
                            ? storiesList.length + 1
                            : storiesList.length;

                        if (itemCount == 0) return const SizedBox.shrink();

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: itemCount,
                          itemBuilder: (context, index) {
                            if (isMyProfile && index == 0) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CreateStoryScreen(),
                                    ),
                                  );
                                },
                                child: StoryItem(
                                  isMe: true,
                                  name: 'create'.tr.toUpperCase(),
                                  imageSrc: null,
                                  icon: Icons.add,
                                ),
                              );
                            }

                            final storyIndex = isMyProfile ? index - 1 : index;
                            final storyGroup = storiesList[storyIndex];

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
                              ),
                            );
                          },
                        );
                      });
                    },
                  ),
                ),

                /// Nested Tab Navigation
                _buildTabSelector(),

                _buildActiveTabBody(),
              ],
            ),
          );
        }),
        bottomNavigationBar: const CustomNavBar(currentIndex: 4),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(
          url.startsWith('http') ? url : 'https://$url',
        );
        try {
          bool launched = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          if (!launched) {
            await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
          }
        } catch (e) {
          debugPrint("Could not launch $url: $e");
        }
      },
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white70, size: 16),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          CustomText(
            text: label,
            color: Colors.white38,
            fontSize: 8,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: value,
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 24.h, color: Colors.white10);
  }

  Widget _buildTabSelector() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTabItem(0, "posts".tr.toUpperCase()),
          _buildTabItem(1, "garage".tr.toUpperCase()),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    final controller = Get.find<ProfileScreenController>();
    return Obx(() {
      final bool isSelected = controller.activeTab == index;
      return GestureDetector(
        onTap: () {
          controller.activeTab = index;
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.yellow : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: CustomText(
            text: label,
            color: isSelected ? Colors.white : Colors.white38,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      );
    });
  }

  Widget _buildActiveTabBody() {
    final controller = Get.find<ProfileScreenController>();
    return Obx(() {
      switch (controller.activeTab) {
        case 0:
          return _buildPostsTab();
        case 1:
          return _buildGarageTab();
        default:
          return _buildPostsTab();
      }
    });
  }

  /// ── Tab 01: Posts Tab ──────────────────────────────────────────────────
  Widget _buildPostsTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: GetBuilder<HomeController>(
        init: Get.isRegistered<HomeController>() ? null : HomeController(),
        builder: (homeController) {
          return Obx(() {
            if (homeController.isPostLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.yellow),
              );
            }

            final profileController = Get.find<ProfileScreenController>();
            final targetUserId = profileController.profileData.value?.id;

            final myPosts = homeController.postsList
                .where((p) => p.user?.id == targetUserId)
                .toList();

            return Column(
              children: [
                if (targetUserId == homeController.currentUserId.value)
                  CustomButton(
                    height: 44.h,
                    title: "addPost".tr.toUpperCase(),
                    fontSize: 12,
                    borderRadius: 8.r,
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.black,
                      size: 16,
                    ),
                    onTap: () => Get.toNamed(AppRoutes.createPostScreen),
                  ),
                if (targetUserId == homeController.currentUserId.value)
                  SizedBox(height: 20.h),

                if (myPosts.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: const Center(
                      child: Text(
                        "No posts found.",
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ),
                  ),

                ...myPosts.map((post) {
                  final categoryLabel = post.category != null
                      ? post.category!.replaceAll('_', ' ').toUpperCase()
                      : '';
                  final userName =
                      post.user?.name ?? post.user?.userName ?? 'User';
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

                  final imageUrl = post.media != null && post.media!.isNotEmpty
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
                      post.user!.id == homeController.currentUserId.value;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: PostCard(
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
                        Get.context!,
                        MaterialPageRoute(
                          builder: (_) => PostDetailScreen(postId: post.id!),
                        ),
                      ),
                      onLike: () => homeController.reactToPost(post.id!),
                      onComment: () => showCommentSheet(Get.context!, post),
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
                                context: Get.context!,
                                useRootNavigator: true,
                                isScrollControlled: true,
                                useSafeArea: true,
                                backgroundColor: const Color(0xff1C1C1C),
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
                                          title: Text(
                                            "deletePost".tr,
                                            style: const TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                backgroundColor: const Color(
                                                  0xff1C1C1C,
                                                ),
                                                title: Text(
                                                  "deletePost".tr,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                content: Text(
                                                  "deletePostConfirm".tr,
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text(
                                                      "cancel".tr,
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      homeController.deletePost(
                                                        post.id!,
                                                      );
                                                    },
                                                    child: Text(
                                                      "delete".tr,
                                                      style: const TextStyle(
                                                        color: Colors.red,
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
                  );
                }),
              ],
            );
          });
        },
      ),
    );
  }

  /// ── Tab 02: Garage Tab ─────────────────────────────────────────────────
  Widget _buildGarageTab() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          CustomButton(
            height: 44.h,
            title: "addVehicle".tr.toUpperCase(),
            fontSize: 12,
            borderRadius: 8.r,
            icon: const Icon(
              Icons.add_circle_outline,
              color: Colors.black,
              size: 16,
            ),
            onTap: () => Get.toNamed(AppRoutes.addVehicleScreen),
          ),

          SizedBox(height: 24.h),

          CustomText(
            text: "vehicleStable".tr.toUpperCase(),
            color: AppColors.yellow,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
          SizedBox(height: 16.h),

          Obx(() {
            final profileController = Get.find<ProfileScreenController>();
            final vehicles = profileController.vehicles;

            if (profileController.isVehicleLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.yellow),
              );
            }

            if (vehicles.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Center(
                  child: Text(
                    "noVehiclesAdded".tr,
                    style: const TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ),
              );
            }

            return Column(
              children: vehicles.map((v) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: GarageVehicleCard(vehicle: v),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}

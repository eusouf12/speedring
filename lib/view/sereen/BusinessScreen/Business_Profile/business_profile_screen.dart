import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_images/app_images.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/utils/app_const/app_const.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_text/custom_text.dart';
import '../BusinessHome/business_navbar.dart';
import '../../UserScreen/Profile/controller/profile_controller.dart';
import '../../UserScreen/Home/Screen/HomeScreen/controller/home_controller.dart';
import '../../UserScreen/Home/widget/post_card.dart';
import '../../UserScreen/Home/Screen/HomeScreen/view/post/post_detail_screen.dart';
import '../../UserScreen/Home/Screen/HomeScreen/view/post/comment_screen.dart'
    show showCommentSheet;
import '../../UserScreen/Home/Screen/HomeScreen/view/user_home_screen.dart'
    show buildPostDetails, EventCard;
import '../../UserScreen/Home/Screen/HomeScreen/view/event/event_comment_screen.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  late final ProfileScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ProfileScreenController>();
    final homeController = Get.find<HomeController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.getMyEvent();
      homeController.getMyClubs();
      controller.getMyProfile();
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
              onPressed: () =>
                  Get.toNamed(AppRoutes.businessAccountSettingsScreen),
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
          final businessInfo = profile?.businessInfo;

          final socialLinks =
              businessInfo?.socialLinks ?? driverInfo?.socialLinks;
          final bio = businessInfo?.engineeringPhilosophy ?? driverInfo?.bio;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Banner & Profile Info
                SizedBox(
                  height: 220.h,
                  width: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Banner Image
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
                      // Profile Avatar
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
                      // Coins indicator
                      Positioned(
                        bottom: 4.h,
                        right: 16.w,
                        child: GestureDetector(
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
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                // Profile Identity Details
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
                      CustomText(
                        text:
                            "@${profile?.userName?.replaceAll(' ', '_').toLowerCase() ?? 'unknown_business'}",
                        color: AppColors.yellow,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 10.h),
                      CustomText(
                        text:
                            bio ??
                            "No biography provided. Leading the industry with exceptional automotive services.",
                        color: Colors.white70,
                        fontSize: 11,
                        textAlign: TextAlign.start,
                        height: 1.4,
                      ),
                      SizedBox(height: 16.h),
                      // Social Toggles and Support button
                      Row(
                        children: [
                          if (socialLinks?.instagram?.isNotEmpty ?? false) ...[
                            _buildSocialIcon(
                              Icons.camera_alt_outlined,
                              businessInfo!.socialLinks!.instagram!,
                            ),
                            SizedBox(width: 10.w),
                          ],
                          if (businessInfo?.socialLinks?.tiktok?.isNotEmpty ??
                              false) ...[
                            _buildSocialIcon(
                              Icons.music_note,
                              businessInfo!.socialLinks!.tiktok!,
                            ),
                            SizedBox(width: 10.w),
                          ],
                          if (businessInfo?.socialLinks?.youtube?.isNotEmpty ??
                              false) ...[
                            _buildSocialIcon(
                              Icons.play_circle_outline,
                              socialLinks!.youtube!,
                            ),
                            SizedBox(width: 10.w),
                          ],
                          if (socialLinks?.facebook?.isNotEmpty ?? false) ...[
                            _buildSocialIcon(
                              Icons.facebook_outlined,
                              socialLinks!.facebook!,
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

                // Stats section
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
                      _buildStatItem("listings".tr.toUpperCase(), "0"),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // Navigation Tabs Header
                _buildProfileTabs(),

                // Active Tab Content
                _buildActiveTabBody(),

                SizedBox(height: 80.h),
              ],
            ),
          );
        }),
        bottomNavigationBar: const CustomBusinessNavBar(currentIndex: 3),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          CustomText(
            text: value,
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
          ),
          SizedBox(height: 2.h),
          CustomText(
            text: label,
            color: Colors.white38,
            fontSize: 9.sp,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(height: 30.h, width: 1, color: Colors.white10);
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        } else {
          Get.snackbar(
            'Error',
            'Could not launch $url',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: const Color(0xff161616),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Icon(icon, color: Colors.white70, size: 16),
      ),
    );
  }

  Widget _buildProfileTabs() {
    final tabs = ["POSTS", "INVENTORY", "EVENT", "CLUBS"];
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          tabs.length,
          (index) => _buildTabItem(index, tabs[index].tr),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
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
    return GetBuilder<HomeController>(
      init: Get.isRegistered<HomeController>() ? null : HomeController(),
      builder: (homeController) {
        return Obx(() {
          switch (controller.activeTab) {
            case 0:
              return _buildPostsTab(homeController);
            case 1:
              return _buildInventoryTab();
            case 2:
              return _buildEventsTab(homeController);
            case 3:
              return _buildClubsTab(homeController);
            default:
              return _buildPostsTab(homeController);
          }
        });
      },
    );
  }

  Widget _buildPostsTab(HomeController homeController) {
    if (controller.isPostLoading.value) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(color: AppColors.yellow),
        ),
      );
    }

    final targetUserId = controller.profileData.value?.id;
    final myPosts = controller.myPosts;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
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
              child: Center(
                child: Text(
                  "noPostsFound".tr,
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ),
            ),

          ...myPosts.map((post) {
            final categoryLabel = post.category != null
                ? post.category!.replaceAll('_', ' ').toUpperCase()
                : '';
            final userName = post.user?.name ?? post.user?.userName ?? 'User';
            final profileImage = post.user?.profileImage;

            final loc =
                post.spotDetails?.region ??
                post.trackUpdateDetails?.circuit ??
                post.sessionDetails?.trackName;

            final location = loc != null && loc.isNotEmpty
                ? (categoryLabel.isNotEmpty ? "$categoryLabel • $loc" : loc)
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
                userId: post.user?.id,
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
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostDetailScreen(postId: post.id!),
                  ),
                ),
                onLike: () => homeController.reactToPost(post.id!),
                onComment: () => showCommentSheet(context, post: post),
                onShare: () {
                  final postLink = "https://speedring.com/post/${post.id}";
                  SharePlus.instance.share(
                    ShareParams(
                      text: "Check out this post on Speedring:\n\n$postLink",
                      subject: "Speedring Post",
                    ),
                  );
                },
                onMore: isMyPost ? () {} : null,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInventoryTab() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Center(
        child: Text(
          "noListingsFound".tr,
          style: const TextStyle(color: Colors.white54, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildEventsTab(HomeController homeController) {
    if (homeController.isEventsLoading.value) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(color: AppColors.yellow),
        ),
      );
    }
    if (homeController.eventsList.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: Text(
            "noEventsFound".tr,
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: homeController.eventsList.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final event = homeController.eventsList[index];
        String bannerUrl = event.bannerImage ?? "";
        if (bannerUrl.isNotEmpty && !bannerUrl.startsWith("http")) {
          bannerUrl = "http://10.10.28.90:4050$bannerUrl";
        }

        return EventCard(
          imageUrl: bannerUrl.isNotEmpty
              ? bannerUrl
              : "https://picsum.photos/seed/event_${event.id}/600/300",
          organizer: event.user?.name ?? "ORGANIZER",
          organizerImage: event.user?.profileImage,
          title: event.eventName ?? "UNTITLED EVENT",
          date: event.deploymentDate != null
              ? event.deploymentDate!.split('T')[0]
              : "UNKNOWN",
          type: event.missionType ?? "EVENT",
          location: event.locationCircuit ?? "UNKNOWN",
          slots: "${event.joinCount ?? 0}/${event.maxCapacity ?? 0}",
          likes: "${event.reactCount ?? 0}",
          comments: "${event.commentCount ?? 0}",
          isJoined: event.isEventJoined ?? false,
          isReacted: event.isReacted ?? false,
          isMyEvent:
              event.user?.id != null &&
              event.user!.id == homeController.currentUserId.value,
          eventId: event.id ?? '',
          onJoin: () {},
          onLike: () => homeController.reactToEvent(eventId: event.id!),
          onComment: () => showEventCommentSheet(context, event),
          onShare: () => shareEventLink(event),
        );
      },
    );
  }

  Widget _buildClubsTab(HomeController homeController) {
    if (homeController.isClubsLoading.value) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(color: AppColors.yellow),
        ),
      );
    }
    if (homeController.myClubs.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: Text(
            "noClubsFound".tr,
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: homeController.myClubs.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final club = homeController.myClubs[index];
        return GestureDetector(
          onTap: () =>
              Get.toNamed(AppRoutes.businessClubDetailsScreen, arguments: club),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xff111111),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    image: DecorationImage(
                      image: NetworkImage(
                        club.logo ?? "https://picsum.photos/100",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: club.clubName ?? "Unknown Club",
                        color: Colors.white,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w900,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 2.h),
                      CustomText(
                        text: "${club.totalMembersCount ?? 0} MEMBERS",
                        color: Colors.white38,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

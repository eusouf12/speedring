import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import 'package:speedring/view/components/share/share_controller.dart';
import 'package:speedring/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:speedring/core/app_routes/app_routes.dart';

class FollowListScreen extends StatefulWidget {
  final String userId;
  final String listType; // "followers" or "following"

  const FollowListScreen({
    Key? key,
    required this.userId,
    required this.listType,
  }) : super(key: key);

  @override
  State<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen> {
  late ShareController controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = Get.find<ShareController>();
    controller.fetchFollowUsers(widget.userId, widget.listType);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        controller.loadMoreFollowUsers(widget.userId, widget.listType);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050505),
      appBar: CustomRoyelAppbar(
        titleName: widget.listType == 'followers'
            ? 'followers'.tr
            : 'following'.tr,
        leftIcon: true,
      ),
      body: Obx(() {
        if (controller.isFollowUsersLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.yellow),
          );
        }

        if (controller.followUsersList.isEmpty) {
          return Center(
            child: CustomText(
              text: widget.listType == 'followers'
                  ? 'noFollowersFound'.tr
                  : 'noFollowingFound'.tr,
              color: Colors.white54,
            ),
          );
        }

        return ListView.separated(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          itemCount:
              controller.followUsersList.length +
              (controller.hasMoreFollowUsers.value ? 1 : 0),
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            if (index == controller.followUsersList.length) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.yellow),
              );
            }

            final user = controller.followUsersList[index];

            return GestureDetector(
              onTap: () {
                if (user.role == "business") {
                  Get.toNamed(
                    AppRoutes.businessProfileScreen,
                    arguments: user.id,
                  );
                } else {
                  Get.toNamed(
                    AppRoutes.singleProfileScreen,
                    arguments: user.id,
                  );
                }
              },
              child: Row(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white10),
                    ),
                    child: ClipOval(
                      child: CustomNetworkImage(
                        imageUrl: user.profileImage,
                        height: 50.h,
                        width: 50.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: user.name,
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                        ),
                        if (user.userName.isNotEmpty)
                          CustomText(
                            text: "@${user.userName}",
                            color: Colors.white54,
                            fontSize: 13,
                            textAlign: TextAlign.start,
                          ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      bool isFollowing = user.isFollow;
                      String buttonText = '';

                      bool isUnfollowState = false;

                      if (widget.listType == 'following') {
                        buttonText = 'unfollow'.tr;
                        isUnfollowState = true;
                      } else {
                        buttonText = isFollowing
                            ? 'unfollow'.tr
                            : 'followBack'.tr;
                        isUnfollowState = isFollowing;
                      }

                      return GestureDetector(
                        onTap: () => controller.toggleFollowUser(
                          user.id,
                          listType: widget.listType,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: isUnfollowState
                                ? Colors.transparent
                                : AppColors.yellow,
                            border: isUnfollowState
                                ? Border.all(color: AppColors.yellow)
                                : null,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: CustomText(
                            text: buttonText,
                            color: isUnfollowState
                                ? AppColors.yellow
                                : Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}

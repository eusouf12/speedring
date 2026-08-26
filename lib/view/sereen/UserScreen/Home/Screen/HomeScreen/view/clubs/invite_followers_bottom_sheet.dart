import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/view/sereen/UserScreen/Home/Screen/HomeScreen/controller/home_controller.dart';
import '../../../../../../../components/custom_netwrok_image/custom_network_image.dart';

class InviteFollowersBottomSheet extends StatefulWidget {
  final String clubId;
  const InviteFollowersBottomSheet({super.key, required this.clubId});

  @override
  State<InviteFollowersBottomSheet> createState() =>
      _InviteFollowersBottomSheetState();
}

class _InviteFollowersBottomSheetState
    extends State<InviteFollowersBottomSheet> {
  final HomeController homeController = Get.find<HomeController>();
  final List<String> selectedUserIds = [];

  @override
  void initState() {
    super.initState();
    homeController.getMyFollowers();
  }

  void _toggleSelection(String userId) {
    setState(() {
      if (selectedUserIds.contains(userId)) {
        selectedUserIds.remove(userId);
      } else {
        selectedUserIds.add(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Invite Followers".tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              if (homeController.isFollowersLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.yellow),
                );
              }
              final followers = homeController.myFollowers;
              if (followers.isEmpty) {
                return Center(
                  child: Text(
                    "You don't have any followers to invite.".tr,
                    style: const TextStyle(color: Colors.white54),
                  ),
                );
              }
              return ListView.builder(
                itemCount: followers.length,
                itemBuilder: (context, index) {
                  final follower = followers[index];
                  final userObj =
                      follower['follower']; // Assuming the API returns a follower object populated with user details. Wait, if it's my followers, the user who is following me is the follower. Or just use `follower`.
                  // Need to check the actual response structure for followers. I will assume it has 'id', 'name', 'profileImage'. If it is `{ "_id": "...", "follower": { "_id": "...", "name": "..." } }`, we use userObj.
                  // Let's use generic access just in case.
                  final Map<String, dynamic> user = userObj ?? follower;
                  final String userId = user['_id'] ?? user['id'] ?? '';
                  final String name =
                      user['userName'] ??
                      user['name'] ??
                      user['fullName'] ??
                      'Unknown';
                  final String image =
                      user['profileImage'] ?? user['image'] ?? '';
                  final bool isSelected = selectedUserIds.contains(userId);

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CustomNetworkImage(
                      imageUrl: image,
                      height: 40,
                      width: 40,
                      boxShape: BoxShape.circle,
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        _toggleSelection(userId);
                      },
                      activeColor: AppColors.primary,
                      checkColor: Colors.black,
                    ),
                    onTap: () => _toggleSelection(userId),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 20),
          Obx(() {
            return CustomButton(
              onTap:
                  selectedUserIds.isEmpty ||
                      homeController.isInvitingUsers.value
                  ? () {}
                  : () async {
                      final success = await homeController.inviteUsersToClub(
                        widget.clubId,
                        selectedUserIds,
                      );
                      if (success) {
                        Get.back(); // Close bottom sheet
                      }
                    },
              title: homeController.isInvitingUsers.value
                  ? "Inviting...".tr
                  : "Invite Selected".tr,
              textColor: Colors.black,
              fillColor: selectedUserIds.isEmpty
                  ? Colors.grey
                  : AppColors.yellow,
            );
          }),
        ],
      ),
    );
  }
}

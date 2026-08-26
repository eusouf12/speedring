import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      height: screenHeight * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.yellow,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invite Followers'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Obx(() {
                      final total = homeController.myFollowers.length;
                      return Text(
                        total > 0 ? 'membersAvailable'.trParams({'total': '$total'}) : 'selectToInvite'.tr,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      );
                    }),
                  ],
                ),
                const Spacer(),
                if (selectedUserIds.isNotEmpty)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'selectedCount'.trParams({'count': '${selectedUserIds.length}'}),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Divider(color: Colors.white.withValues(alpha: 0.08), thickness: 1, height: 1),

          // List
          Expanded(
            child: Obx(() {
              if (homeController.isFollowersLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.yellow, strokeWidth: 2.5),
                );
              }
              final followers = homeController.myFollowers;
              if (followers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person_search_rounded,
                          size: 56,
                          color: Colors.white.withValues(alpha: 0.15)),
                      const SizedBox(height: 12),
                      Text(
                        'noFollowersToInvite'.tr,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.7)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'growNetworkInvite'.tr,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.4)),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: followers.length,
                separatorBuilder: (_, _) => Divider(
                    color: Colors.white.withValues(alpha: 0.06), height: 1),
                itemBuilder: (context, index) {
                  final follower = followers[index];
                  final userObj = follower['follower'];
                  final Map<String, dynamic> user = userObj ?? follower;
                  final String userId = user['_id'] ?? user['id'] ?? '';
                  final String name = user['userName'] ??
                      user['name'] ??
                      user['fullName'] ??
                      'Unknown';
                  final String image =
                      user['profileImage'] ?? user['image'] ?? '';
                  final bool isSelected = selectedUserIds.contains(userId);

                  return InkWell(
                    onTap: () => _toggleSelection(userId),
                    borderRadius: BorderRadius.circular(12),
                    splashColor: AppColors.yellow.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          // Avatar with yellow ring
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.all(isSelected ? 2.5 : 0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(
                                      color: AppColors.yellow, width: 2.5)
                                  : null,
                            ),
                            child: CustomNetworkImage(
                              imageUrl: image,
                              height: 46,
                              width: 46,
                              boxShape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'memberLabel'.tr,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.4)),
                                ),
                              ],
                            ),
                          ),
                          // Circular check
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? AppColors.yellow
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.yellow
                                    : Colors.white.withValues(alpha: 0.25),
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(Icons.check_rounded,
                                    size: 16, color: Colors.black)
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // Invite Button
          Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 20),
            child: Obx(() {
              final isLoading = homeController.isInvitingUsers.value;
              final isEmpty = selectedUserIds.isEmpty;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  color: isEmpty
                      ? Colors.white.withValues(alpha: 0.08)
                      : AppColors.yellow,
                  borderRadius: BorderRadius.circular(16),
                  border: isEmpty
                      ? Border.all(
                          color: Colors.white.withValues(alpha: 0.12), width: 1)
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: isEmpty || isLoading
                        ? null
                        : () async {
                            final success =
                                await homeController.inviteUsersToClub(
                              widget.clubId,
                              selectedUserIds,
                            );
                            if (success) Get.back();
                          },
                    child: Center(
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.black, strokeWidth: 2.5),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.send_rounded,
                                  size: 18,
                                  color: isEmpty
                                      ? Colors.white.withValues(alpha: 0.3)
                                      : Colors.black,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isEmpty
                                      ? 'selectMembersToInvite'.tr
                                      : 'inviteSelectedCount'.trParams({'count': '${selectedUserIds.length}'}),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isEmpty
                                        ? Colors.white.withValues(alpha: 0.3)
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}


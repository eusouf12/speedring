import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/utils/navigation_utils.dart';
import '../../controller/home_controller.dart';
import 'package:speedring/service/api_url.dart';

class ClubMembersScreen extends StatelessWidget {
  const ClubMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final String clubId = args['id'] ?? '';

    // Fetch members when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (clubId.isNotEmpty) {
        controller.getClubMembers(clubId);
      }
    });

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
            onPressed: () => Get.back(),
          ),
          title: CustomText(
            text: "clubMembers".tr.toUpperCase(),
            color: AppColors.yellow,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isClubMembersLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }

          final currentUserId = controller.currentUserId.value;
          final club = controller.currentClubDetail.value;
          
          bool isAdmin = false;
          if (club != null && currentUserId.isNotEmpty) {
             isAdmin = club.members?.any((m) => 
               m.user?.id == currentUserId && m.role == 'ADMIN'
             ) ?? false;
          }

          if (controller.clubMembersList.isEmpty) {
            return Center(
              child: CustomText(
                text: "noMembersFound".tr,
                color: Colors.white54,
                fontSize: 14,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: controller.clubMembersList.length,
            itemBuilder: (context, index) {
              final memberData = controller.clubMembersList[index];
              final user = memberData['user'] ?? {};
              final role = memberData['role'] ?? 'MEMBER';
              final memberId = user['_id'] ?? user['id'] ?? "";
              final isMe = memberId == currentUserId;

              final name = user['name'] ?? user['userName'] ?? "Unknown";
              final profileImage = user['profileImage'] ?? "";

              String imageUrl = "";
              if (profileImage.isNotEmpty) {
                imageUrl = profileImage.startsWith('http')
                    ? profileImage
                    : "${ApiUrl.imageUrl}$profileImage";
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (user['_id'] != null) {
                          NavigationUtils.navigateToUserProfile(user['_id']);
                        } else if (user['id'] != null) {
                          NavigationUtils.navigateToUserProfile(user['id']);
                        }
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white10,
                        backgroundImage: imageUrl.isNotEmpty
                            ? NetworkImage(imageUrl)
                            : null,
                        child: imageUrl.isEmpty
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
                              if (user['_id'] != null) {
                                NavigationUtils.navigateToUserProfile(user['_id']);
                              } else if (user['id'] != null) {
                                NavigationUtils.navigateToUserProfile(user['id']);
                              }
                            },
                            child: CustomText(
                              text: name,
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            text: role.toString().tr.toUpperCase(),
                            color: AppColors.yellow,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ],
                      ),
                    ),
                    if (isAdmin && !isMe)
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: AppColors.yellow),
                        color: const Color(0xff1B1B1B),
                        onSelected: (value) {
                          if (value == 'toggle_role') {
                            final newRole = role == 'ADMIN' ? 'MEMBER' : 'ADMIN';
                            Get.dialog(
                              AlertDialog(
                                backgroundColor: const Color(0xff181818),
                                title: Text(
                                  "changeRoleQuest".tr,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                  "changeRoleConfirm".trParams({'name': name, 'role': newRole.tr}),
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text("cancel".tr.toUpperCase(), style: const TextStyle(color: Colors.white54)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      controller.changeMemberRole(clubId: clubId, memberId: memberId, role: newRole);
                                    },
                                    child: Text("yes".tr.toUpperCase(), style: const TextStyle(color: AppColors.yellow)),
                                  ),
                                ],
                              ),
                            );
                          } else if (value == 'remove') {
                            Get.dialog(
                              AlertDialog(
                                backgroundColor: const Color(0xff181818),
                                title: Text(
                                  "removeMemberQuest".tr,
                                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                  "removeMemberConfirm".trParams({'name': name}),
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text("cancel".tr.toUpperCase(), style: const TextStyle(color: Colors.white54)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      controller.removeClubMember(clubId: clubId, memberId: memberId);
                                    },
                                    child: Text("yes".tr.toUpperCase(), style: const TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'toggle_role',
                            child: Text(
                              role == 'ADMIN' ? 'makeMember'.tr : 'makeAdmin'.tr,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'remove',
                            child: Text(
                              'removeUser'.tr,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

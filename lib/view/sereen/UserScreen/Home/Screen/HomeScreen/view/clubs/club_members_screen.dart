import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
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
          title: const CustomText(
            text: "CLUB MEMBERS",
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
            return const Center(
              child: CustomText(
                text: "No members found",
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
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white10,
                      backgroundImage: imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl)
                          : null,
                      child: imageUrl.isEmpty
                          ? const Icon(Icons.person, color: Colors.white54)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: name,
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            text: role,
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
                                title: const Text(
                                  "Change Role?",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                  "Are you sure you want to make $name a $newRole?",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text("CANCEL", style: TextStyle(color: Colors.white54)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      controller.changeMemberRole(clubId: clubId, memberId: memberId, role: newRole);
                                    },
                                    child: const Text("YES", style: TextStyle(color: AppColors.yellow)),
                                  ),
                                ],
                              ),
                            );
                          } else if (value == 'remove') {
                            Get.dialog(
                              AlertDialog(
                                backgroundColor: const Color(0xff181818),
                                title: const Text(
                                  "Remove Member?",
                                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                  "Are you sure you want to remove $name from this club?",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text("CANCEL", style: TextStyle(color: Colors.white54)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      controller.removeClubMember(clubId: clubId, memberId: memberId);
                                    },
                                    child: const Text("YES", style: TextStyle(color: Colors.red)),
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
                              role == 'ADMIN' ? 'Make Member' : 'Make Admin',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'remove',
                            child: Text(
                              'Remove User',
                              style: TextStyle(color: Colors.red),
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

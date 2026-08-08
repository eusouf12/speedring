import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../controller/home_controller.dart';

class ClubPostScreen extends StatefulWidget {
  const ClubPostScreen({super.key});

  @override
  State<ClubPostScreen> createState() => _ClubPostScreenState();
}

class _ClubPostScreenState extends State<ClubPostScreen> {
  late final HomeController homeCtrl;

  @override
  void initState() {
    super.initState();
    homeCtrl = Get.find<HomeController>();
    homeCtrl.getMyClubs();
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white, size: 22),
          ),
          title: Text(
            "clubPost".tr,
            style: const TextStyle(
              color: AppColors.yellow,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          centerTitle: false,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 16),

            /// ── CLUB SELECTOR (As TITLE) ──────────────────────────────────
            Obx(() {
              if (homeCtrl.clubIsLoadingClubs.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.yellow),
                );
              }
              if (homeCtrl.clubMyClubs.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "notJoinedInClub".tr,
                    style: TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                );
              }
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "selectClub".tr,
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonFormField<String>(
                        dropdownColor: Colors.black,
                        initialValue: homeCtrl.clubSelectedClubId.value,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        items: homeCtrl.clubMyClubs.map((club) {
                          return DropdownMenuItem<String>(
                            value: club['_id']?.toString(),
                            child: Text(
                              club['clubName']?.toString() ?? "unnamedClub".tr,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          homeCtrl.clubSelectedClubId.value = val;
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),

            /// ── ADD MEDIA Box ─────────────────────────────────────────────
            GestureDetector(
              onTap: () => homeCtrl.pickPostImage(homeCtrl.clubSelectedMedia),
              child: Obx(
                () => Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xff111111),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white12,
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                  ),
                  child: homeCtrl.clubSelectedMedia.value != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            homeCtrl.clubSelectedMedia.value!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.camera_alt_outlined,
                                color: AppColors.yellow,
                                size: 28,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "addMediaMax50MB".tr,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ── POST DETAILS ──────────────────────────────────────────────
            Text(
              "postDetails".tr,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      cursorColor: AppColors.yellow,
                      controller: homeCtrl.clubDetailsCtrl,
                      maxLines: 6,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.5,
                      ),
                      decoration: InputDecoration(
                        hintText: "briefClub".tr,
                        hintStyle: const TextStyle(
                          color: Colors.white24,
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// ── PINNED ANNOUNCEMENT Box ────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff1A1A1A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0x22FF5252),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.campaign_outlined,
                      color: Colors.redAccent,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "pinnedAnnouncement".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "prioritizeThisPost".tr,
                          style: TextStyle(color: Colors.white38, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: homeCtrl.clubIsPinned.value,
                        onChanged: (val) {
                          homeCtrl.clubIsPinned.value = val;
                        },
                        activeThumbColor: AppColors.yellow,
                        activeTrackColor: AppColors.yellow.withValues(
                          alpha: 0.5,
                        ),
                        inactiveThumbColor: Colors.white60,
                        inactiveTrackColor: Colors.white10,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// ── Publish button ───────────────────────────────────────────
            Obx(
              () => GestureDetector(
                onTap: homeCtrl.isPostCreating.value
                    ? null
                    : () async {
                        if (homeCtrl.clubSelectedClubId.value == null ||
                            homeCtrl.clubDetailsCtrl.text.isEmpty) {
                          showCustomSnackBar(
                            "Club Selection and Details are required",
                            isError: true,
                          );
                          return;
                        }

                        final selectedClub = homeCtrl.clubMyClubs.firstWhere(
                          (club) =>
                              club['_id'] == homeCtrl.clubSelectedClubId.value,
                          orElse: () => {"clubName": "Club Post"},
                        );

                        final success = await homeCtrl.createPost(
                          category: "CLUB_POST",
                          visibility: "Club Only",
                          clubId: homeCtrl.clubSelectedClubId.value,
                          mediaFile: homeCtrl.clubSelectedMedia.value,
                          clubPostDetails: {
                            "title": selectedClub['clubName'],
                            "details": homeCtrl.clubDetailsCtrl.text.trim(),
                            "isPinned": homeCtrl.clubIsPinned.value,
                          },
                        );
                        if (success) {
                          Get.back(); // close editor
                          Get.back(); // close CreatePostScreen
                        }
                      },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: homeCtrl.isPostCreating.value
                        ? const Color(0xff2A2A2A)
                        : AppColors.yellow,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.publish,
                        color: homeCtrl.isPostCreating.value
                            ? Colors.white24
                            : Colors.black,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        homeCtrl.isPostCreating.value
                            ? "publishing".tr
                            : "publishClubPost".tr,
                        style: TextStyle(
                          color: homeCtrl.isPostCreating.value
                              ? Colors.white24
                              : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

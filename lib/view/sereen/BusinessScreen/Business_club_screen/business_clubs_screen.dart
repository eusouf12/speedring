import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/view/sereen/UserScreen/Home/Screen/HomeScreen/controller/home_controller.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../BusinessHome/business_navbar.dart';

class BusinessClubsScreen extends StatefulWidget {
  const BusinessClubsScreen({super.key});

  @override
  State<BusinessClubsScreen> createState() => _BusinessClubsScreenState();
}

class _BusinessClubsScreenState extends State<BusinessClubsScreen> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(HomeController());
    controller.getAllClubs();
    controller.getMyClubs();
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: BackButton(color: AppColors.yellow),
          title: Image.asset(AppImages.logo, height: 26.h, fit: BoxFit.contain),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),

            // Search clubs text field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                height: 44.h,
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.white10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.white30, size: 18.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        onChanged: (val) {
                          if (val.isEmpty) {
                            controller.getAllClubs(searchTerm: "");
                          } else {
                            controller.searchClubs(val);
                          }
                        },
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "searchClubsHint".tr,
                          hintStyle: const TextStyle(
                            color: Colors.white30,
                            fontSize: 13,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // CLUBS Feed
            Expanded(
              child: RefreshIndicator(
                color: AppColors.yellow,
                backgroundColor: Colors.black,
                onRefresh: () async {
                  controller.getAllClubs();
                  controller.getMyClubs();
                },
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const SizedBox(height: 16),

                    /// YOUR CLUBS Header
                    Text(
                      "yourClubs".tr.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.yellow,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 14),

                    /// Your Clubs List (Horizontal scroll)
                    Obx(() {
                      if (controller.isMyClubsLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.yellow,
                          ),
                        );
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Add New Club Button
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: GestureDetector(
                                onTap: () => Get.toNamed(
                                  AppRoutes.businessCreateClubScreen,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.yellow,
                                          width: 1.5,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.add,
                                          color: AppColors.yellow,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "newClub".tr.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ...controller.myClubs.map((club) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: _buildCircularClubItem(
                                  name: club.clubName ?? "Unknown",
                                  imageUrl:
                                      club.logo != null && club.logo!.isNotEmpty
                                      ? (club.logo!.startsWith('http')
                                            ? club.logo!
                                            : "${ApiUrl.imageUrl}${club.logo}")
                                      : "", // Fallback
                                  onTap: () => Get.toNamed(
                                    AppRoutes.businessClubDetailsScreen,
                                    arguments: {"id": club.id},
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 28),

                    /// BROWSE ALL CLUBS Header
                    Text(
                      "browseAllClubs".tr.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.yellow,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 16),

                    /// Browse Clubs List
                    Obx(() {
                      if (controller.isClubsLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.yellow,
                          ),
                        );
                      }
                      if (controller.allClubs.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              "noClubsFound".tr,
                              style: const TextStyle(color: Colors.white54),
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: controller.allClubs.map((club) {
                          return _buildBrowseClubCard(
                            name: club.clubName ?? "Unknown",
                            members: "${club.members?.length ?? 0}",
                            imageUrl: club.logo != null && club.logo!.isNotEmpty
                                ? (club.logo!.startsWith('http')
                                      ? club.logo!
                                      : "${ApiUrl.imageUrl}${club.logo}")
                                : "", // Fallback
                            isJoined: club.isClubJoined ?? false,
                            isPending: club.isJoinRequestPending ?? false,
                            onJoinTap: () {
                              if (club.id != null) {
                                controller.joinClub(club.id!);
                              }
                            },
                            onTap: () => Get.toNamed(
                              (club.isClubJoined == true)
                                  ? AppRoutes.businessClubDetailsScreen
                                  : AppRoutes.clubDetaislScreenNonMy,
                              arguments: {"id": club.id},
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CustomBusinessNavBar(currentIndex: 4),
      ),
    );
  }

  Widget _buildCircularClubItem({
    required String name,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 1.5),
              image: imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl.isEmpty
                ? const Center(child: Icon(Icons.groups, color: Colors.white38))
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrowseClubCard({
    required String name,
    required String members,
    required String imageUrl,
    required VoidCallback onTap,
    bool isJoined = false,
    bool isPending = false,
    VoidCallback? onJoinTap,
  }) {
    String btnText = "joinClub".tr.toUpperCase();
    Color btnColor = AppColors.yellow;
    Color textColor = Colors.black;
    Border? btnBorder;

    if (isJoined == true && isPending == false) {
      btnText = "joined".tr.toUpperCase();
      btnColor = Colors.transparent;
      textColor = AppColors.yellow;
      btnBorder = Border.all(color: AppColors.yellow, width: 1);
    } else if (isJoined == false && isPending == true) {
      btnText = "pendingRequest".tr.toUpperCase();
      btnColor = Colors.white24;
      textColor = Colors.white54;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xff181818),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            /// Logo
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl.isEmpty
                  ? const Center(
                      child: Icon(Icons.groups, color: Colors.white38),
                    )
                  : null,
            ),
            const SizedBox(width: 14),

            /// Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        members,
                        style: const TextStyle(
                          color: AppColors.yellow,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "activeMembers".tr.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Join Button
            GestureDetector(
              onTap: (isJoined || isPending) ? null : onJoinTap,
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: btnColor,
                  border: btnBorder,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    btnText,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

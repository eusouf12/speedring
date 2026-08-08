import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/view/sereen/UserScreen/Home/Screen/HomeScreen/controller/home_controller.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';

class ClubDetaislScreenNonMy extends StatefulWidget {
  const ClubDetaislScreenNonMy({super.key});

  @override
  State<ClubDetaislScreenNonMy> createState() => _ClubDetaislScreenNonMyState();
}

class _ClubDetaislScreenNonMyState extends State<ClubDetaislScreenNonMy> {
  final HomeController controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    final clubId = Get.arguments?['id'];
    if (clubId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.getSingleClub(clubId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "clubDetails".tr,
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        leading: const BackButton(color: Colors.amber),
      ),
      body: Obx(() {
        if (controller.isClubDetailsLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.yellow),
          );
        }

        final club = controller.currentClubDetail.value;
        if (club == null) {
          return Center(
            child: Text(
              "clubDetailsNotFound".tr,
              style: const TextStyle(color: Colors.white54),
            ),
          );
        }

        String coverUrl = "";
        if (club.banner != null && club.banner!.isNotEmpty) {
          coverUrl = club.banner!.startsWith('http')
              ? club.banner!
              : "${ApiUrl.imageUrl}${club.banner}";
        }

        String logoUrl = "";
        if (club.logo != null && club.logo!.isNotEmpty) {
          logoUrl = club.logo!.startsWith('http')
              ? club.logo!
              : "${ApiUrl.imageUrl}${club.logo}";
        }

        bool? isJoined = club.isClubJoined;
        bool? isPending = club.isJoinRequestPending;

        return SafeArea(
          bottom: true,
          top: false,
          child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Cover
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(coverUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -35,
                    left: 20,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.yellow, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                        image: logoUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(logoUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: logoUrl.isEmpty
                          ? const Icon(
                              Icons.shield,
                              color: Colors.white,
                              size: 40,
                            )
                          : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  club.clubName?.toUpperCase() ?? "unknownClub".tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Builder(
                  builder: (context) {
                    bool joinStatus = (isJoined == true);
                    bool pendingStatus =
                        (isJoined == false && isPending == true);

                    if (joinStatus) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.yellow.withValues(alpha: 0.1),
                          border: Border.all(
                            color: AppColors.yellow.withValues(alpha: 0.5),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.yellow,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "joinedStatus".tr,
                              style: const TextStyle(
                                color: AppColors.yellow,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (pendingStatus) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.yellow.withValues(alpha: 0.1),
                          border: Border.all(
                            color: AppColors.yellow.withValues(alpha: 0.5),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.access_time_filled,
                              color: AppColors.yellow,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "pendingRequestStatus".tr,
                              style: const TextStyle(
                                color: AppColors.yellow,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: Obx(() => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.yellow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: controller.isJoinClubLoading.value ? null : () {
                            if (club.id != null) {
                              controller.joinClub(club.id!);
                            }
                          },
                          child: controller.isJoinClubLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "joinClub".tr,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                        )),
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 25),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                color: const Color(0xff1B1B1B),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "membersCountLabel".tr,
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "${club.members?.length ?? 0}",
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 80, color: Colors.white12),
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            "accessLabel".tr,
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            (club.accessType ?? "PUBLIC").toUpperCase(),
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                color: const Color(0xff1B1B1B),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "aboutLabel".tr,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      club.description ?? "noDescriptionAvailable".tr,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.6,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      );
      }),
    );
  }
}

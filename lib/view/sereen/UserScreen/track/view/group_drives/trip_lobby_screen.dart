import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/sereen/UserScreen/track/widgets/track_appbar.dart';
import 'package:speedring/view/sereen/UserScreen/track/controller/track_controller.dart';
import 'package:speedring/view/sereen/UserScreen/track/mode/expedition_model.dart';
import '../../../../../../utils/app_const/app_const.dart';
import 'package:speedring/service/api_url.dart';
import 'package:intl/intl.dart';

import '../../../Profile/controller/profile_controller.dart';

class TripLobbyScreen extends StatefulWidget {
  const TripLobbyScreen({super.key});

  @override
  State<TripLobbyScreen> createState() => _TripLobbyScreenState();
}

class _TripLobbyScreenState extends State<TripLobbyScreen> {
  final TrackController trackController = Get.find<TrackController>();
  final ProfileScreenController profileController =
      Get.find<ProfileScreenController>();
  Expedition? driveArg;

  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    driveArg = Get.arguments as Expedition?;
    if (driveArg != null && driveArg!.id != null) {
      trackController.fetchSingleExpedition(driveArg!.id!);
    }
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (trackController.currentLobbyExpedition.value?.deploymentDate !=
          null) {
        final deployDate = trackController
            .currentLobbyExpedition
            .value!
            .deploymentDate!
            .toLocal();
        final diff = deployDate.difference(DateTime.now());
        setState(() {
          if (diff.isNegative) {
            _timeLeft = Duration.zero;
          } else {
            _timeLeft = diff;
          }
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: TrackAppBar(
          profilePic:
              profileController.profileData.value?.profileImage ??
              AppConstants.profileImage2,
          title: "tripLobby".tr.toUpperCase(),
          leading: BackButton(color: AppColors.yellow),
        ),
        body: Obx(() {
          if (trackController.isLoadingLobby.value &&
              trackController.currentLobbyExpedition.value == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }

          final Expedition? drive =
              trackController.currentLobbyExpedition.value ?? driveArg;
          if (drive == null) {
            return Center(
              child: Text(
                "errorLoadingLobbyDetails".tr,
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final bool isHost =
              drive.host?.id == profileController.profileData.value?.id;
          final bool canStart = _timeLeft == Duration.zero;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Parallax Header Image with Countdown Timer
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        image:
                            (drive.coverImage != null &&
                                drive.coverImage!.isNotEmpty)
                            ? DecorationImage(
                                image: NetworkImage(
                                  drive.coverImage!.startsWith("http")
                                      ? drive.coverImage!
                                      : "${ApiUrl.imageUrl}/${drive.coverImage}",
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              Colors.transparent,
                              Colors.black87,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      child: Column(
                        children: [
                          Text(
                            canStart
                                ? "expeditionReady".tr.toUpperCase()
                                : "commencingIn".tr.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.yellow,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                canStart
                                    ? "00:00:00"
                                    : _formatDuration(_timeLeft),
                                style: const TextStyle(
                                  color: AppColors.yellow,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                  shadows: [
                                    Shadow(color: Colors.black, blurRadius: 10),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (!canStart)
                                const Text(
                                  "T-MINUS", // Will add to translations if needed or use "tMinus".tr
                                  style: TextStyle(
                                    color: AppColors.yellow,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      /// PHASE 01 // INTEL
                      _buildSectionHeader("phase01Intel".tr.toUpperCase()),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xff111111),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              drive.tripName?.toUpperCase() ??
                                  "untitledExpedition".tr.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: AppColors.yellow,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "host".tr.toUpperCase() + ": ",
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "@${drive.host?.userName?.toUpperCase() ?? "unknown".tr.toUpperCase()}",
                                  style: const TextStyle(
                                    color: AppColors.yellow,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            /// Stats Grid
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: 2.2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              children: [
                                _buildGridStat(
                                  "date".tr.toUpperCase(),
                                  drive.deploymentDate != null
                                      ? DateFormat("MMM dd")
                                            .format(drive.deploymentDate!)
                                            .toUpperCase()
                                      : "--",
                                ),
                                _buildGridStat(
                                  "startTime".tr.toUpperCase(),
                                  drive.deploymentDate != null
                                      ? DateFormat("hh:mm a").format(
                                          drive.deploymentDate!.toLocal(),
                                        )
                                      : "--",
                                ),
                                _buildGridStat(
                                  "vehicles".tr.toUpperCase(),
                                  drive.vehicleClass?.toUpperCase() ??
                                      "mixed".tr.toUpperCase(),
                                ),
                                _buildGridStat(
                                  "meetingPt".tr.toUpperCase(),
                                  drive.meetingPoint?.address?.toUpperCase() ??
                                      "tbd".tr.toUpperCase(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// PHASE 02 // CONVOY
                      _buildSectionHeader("phase02Convoy".tr.toUpperCase()),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xff111111),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "convoyStatus".tr.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "${drive.participants?.length ?? 0} / ${drive.maxParticipants ?? 0} ",
                                        style: const TextStyle(
                                          color: AppColors.yellow,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            " " +
                                            "driversJoined".tr.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white38,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 10.sp),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            /// Joined Drivers Avatars Stack
                            GestureDetector(
                              onTap: () {
                                if (drive.participants == null ||
                                    drive.participants!.isEmpty)
                                  return;
                                Get.bottomSheet(
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: const BoxDecoration(
                                      color: Color(0xff111111),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "convoyParticipants".tr.toUpperCase(),
                                          style: const TextStyle(
                                            color: AppColors.yellow,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Flexible(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                drive.participants!.length,
                                            itemBuilder: (context, index) {
                                              final participant =
                                                  drive.participants![index];
                                              final pImageUrl =
                                                  (participant.profileImage !=
                                                          null &&
                                                      participant
                                                          .profileImage!
                                                          .isNotEmpty)
                                                  ? (participant.profileImage!
                                                            .startsWith('http')
                                                        ? participant
                                                              .profileImage!
                                                        : "${ApiUrl.imageUrl}/${participant.profileImage}")
                                                  : "https://ui-avatars.com/api/?name=${participant.name ?? 'U'}&background=random";
                                              return ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                leading: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    pImageUrl,
                                                  ),
                                                  backgroundColor:
                                                      Colors.white24,
                                                ),
                                                title: Text(
                                                  participant.name ??
                                                      "unknown".tr,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  "@${participant.userName ?? 'unknown'.tr}",
                                                  style: const TextStyle(
                                                    color: Colors.white54,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  isScrollControlled: true,
                                );
                              },
                              child: SizedBox(
                                height: 36,
                                child: Stack(
                                  children: [
                                    for (
                                      int i = 0;
                                      i < (drive.participants?.length ?? 0) &&
                                          i < 3;
                                      i++
                                    )
                                      Positioned(
                                        left: i * 24.0, // overlap offset
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(0xff222222),
                                            border: Border.all(
                                              color: AppColors.yellow,
                                              width: 2,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              18,
                                            ),
                                            child: Image.network(
                                              (drive
                                                              .participants![i]
                                                              .profileImage !=
                                                          null &&
                                                      drive
                                                          .participants![i]
                                                          .profileImage!
                                                          .isNotEmpty)
                                                  ? (drive
                                                            .participants![i]
                                                            .profileImage!
                                                            .startsWith('http')
                                                        ? drive
                                                              .participants![i]
                                                              .profileImage!
                                                        : "${ApiUrl.imageUrl}/${drive.participants![i].profileImage}")
                                                  : "https://ui-avatars.com/api/?name=${drive.participants![i].name ?? 'U'}&background=random",
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
                                                    Icons.person,
                                                    color: Colors.white54,
                                                    size: 20,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if ((drive.participants?.length ?? 0) > 3)
                                      Positioned(
                                        left: 3 * 24.0,
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: const Color(0xff222222),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors.yellow,
                                              width: 2,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "+${drive.participants!.length - 3}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      /// COMMAND
                      if (isHost) ...[
                        _buildSectionHeader("command".tr.toUpperCase()),
                        if (drive.status == null ||
                            drive.status!.toLowerCase() == 'upcoming')
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: canStart
                                    ? AppColors.yellow
                                    : Colors.white24,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: canStart
                                  ? () => trackController.startExpeditionTrip(
                                      drive.id!,
                                    )
                                  : null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.play_arrow,
                                    size: 20,
                                    color: canStart
                                        ? Colors.black
                                        : Colors.white38,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "startTrip".tr.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                      color: canStart
                                          ? Colors.black
                                          : Colors.white38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (drive.status == null ||
                            drive.status!.toLowerCase() == 'upcoming')
                          const SizedBox(height: 12),
                        _buildCommandButton(
                          "editTripDetails".tr.toUpperCase(),
                          Icons.edit_outlined,
                          onTap: () {
                            trackController.populateConfiguratorData(drive);
                            Get.toNamed(
                              AppRoutes.tripConfiguratorScreen,
                              arguments: drive,
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildCommandButton(
                          "SHARE INVITE LINK",
                          Icons.share_outlined,
                          onTap: () {
                            String url = "${ApiUrl.baseUrl}/invite/${drive.id}";
                            Share.share(
                              "Join my trip '${drive.tripName}' on Speedring! Link: $url",
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Get.defaultDialog(
                                title: "cancelTrip".tr,
                                middleText: "cancelExpeditionDesc".tr,
                                textCancel: "no".tr,
                                textConfirm: "yesCancel".tr,
                                confirmTextColor: Colors.white,
                                buttonColor: const Color(0xffF0294A),
                                onConfirm: () {
                                  trackController.deleteExpedition(drive.id!);
                                  Get.back(); // close dialog
                                  Get.back(); // return to Group Drives Screen
                                },
                              );
                            },
                            child: const Text(
                              "CANCEL TRIP",
                              style: TextStyle(
                                color: Color(0xffF0294A),
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        _buildSectionHeader("actions".tr.toUpperCase()),
                        _buildCommandButton(
                          "shareInviteLink".tr.toUpperCase(),
                          Icons.share_outlined,
                          onTap: () {
                            String url = "${ApiUrl.baseUrl}/invite/${drive.id}";
                            Share.share(
                              "Join the trip '${drive.tripName}' on Speedring! Link: $url",
                            );
                          },
                        ),
                      ],

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.yellow,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildGridStat(String label, String val) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            val,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandButton(
    String label,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff1d1d1d),
          foregroundColor: Colors.white70,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

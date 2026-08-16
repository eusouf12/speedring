import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../../../service/api_url.dart';
import '../../../../../../utils/app_const/app_const.dart' show AppConstants;
import '../../widgets/track_appbar.dart';
import '../../controller/track_controller.dart';
import '../../../Profile/controller/profile_controller.dart';
import '../../mode/expedition_model.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class GroupDrivesScreen extends StatefulWidget {
  const GroupDrivesScreen({super.key});

  @override
  State<GroupDrivesScreen> createState() => _GroupDrivesScreenState();
}

class _GroupDrivesScreenState extends State<GroupDrivesScreen> {
  String selectedTab = "UPCOMING";
  final TrackController trackController = Get.find<TrackController>();
  final ProfileScreenController profileController =
      Get.find<ProfileScreenController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    String type = "upcoming";
    if (selectedTab == "MY DRIVES") {
      type = "my_drives";
    } else if (selectedTab == "HISTORY") {
      type = "history";
    }
    trackController.getAllExpeditions(refresh: true, type: type);
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: TrackAppBar(
          title: "groupDrives".tr,
          profilePic:
              profileController.profileData.value?.profileImage ??
              AppConstants.profileImage2,
          leading: BackButton(color: AppColors.yellow),
        ),
        body: Column(
          children: [
            /// 1. START NEW DRIVE button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () =>
                      Get.toNamed(AppRoutes.tripConfiguratorScreen),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_circle_outline, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "startNewDrive".tr.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// 2. Tabs Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildTabButton("UPCOMING"),
                  const SizedBox(width: 8),
                  _buildTabButton("MY DRIVES"),
                  const SizedBox(width: 8),
                  _buildTabButton("HISTORY"),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /// 3. Scrollable List of Group Drives
            Expanded(
              child: Obx(() {
                if (trackController.isLoadingExpeditions.value &&
                    trackController.expeditions.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.yellow),
                  );
                }
                if (trackController.expeditions.isEmpty) {
                  return Center(
                    child: Text(
                      "noDrivesFound".tr,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: trackController.expeditions.length,
                  itemBuilder: (context, index) {
                    final drive = trackController.expeditions[index];
                    return _buildDriveCard(drive);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label) {
    final bool isSelected = selectedTab == label;
    String translationKey = label.toLowerCase().replaceAll(" ", "");
    // Fallback if no translation found
    String translated = translationKey.tr != translationKey
        ? translationKey.tr
        : label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = label;
          });
          _fetchData();
        },
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xff222222)
                : const Color(0xff111111),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppColors.yellow.withValues(alpha: 0.3)
                  : Colors.white10,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            translated.toUpperCase(),
            style: TextStyle(
              color: isSelected ? AppColors.yellow : Colors.white60,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDriveCard(Expedition drive) {
    final bool isOpen = drive.status == "upcoming";
    final String currentUserId = profileController.profileData.value?.id ?? "";
    final bool isHost = drive.host?.id == currentUserId;
    final bool isJoined =
        drive.participants?.any((p) => p.id == currentUserId) ?? false;
    final bool isFull =
        (drive.participants?.length ?? 0) >= (drive.maxParticipants ?? 0);

    String formattedDate = "";
    if (drive.deploymentDate != null) {
      formattedDate = DateFormat(
        "dd.MMM // HH:mm",
      ).format(drive.deploymentDate!);
    } else {
      formattedDate = drive.startTime ?? "";
    }

    String phaseText = "ACTIVE";
    if (drive.status == "completed") phaseText = "COMPLETED";
    if (drive.status == "upcoming") phaseText = "UPCOMING";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Card Image Banner with badge overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: () {
                  String? coverUrl = drive.coverImage;
                  if (coverUrl == null || coverUrl.isEmpty) {
                    if (drive.routeTrack != null && drive.routeTrack is Map) {
                      coverUrl = drive.routeTrack['coverImage'];
                    }
                  }

                  if (coverUrl == null || coverUrl.isEmpty) {
                    return Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.white.withValues(alpha: 0.05),
                      child: const Icon(
                        Icons.directions_car,
                        color: Colors.white24,
                        size: 40,
                      ),
                    );
                  }

                  return Image.network(
                    coverUrl.startsWith("http")
                        ? coverUrl
                        : "${ApiUrl.imageUrl}/$coverUrl",
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, _) => Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.white.withValues(alpha: 0.05),
                      child: const Icon(
                        Icons.directions_car,
                        color: Colors.white24,
                        size: 40,
                      ),
                    ),
                  );
                }(),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  color: Colors.black54,
                  child: Text(
                    phaseText,
                    style: const TextStyle(
                      color: AppColors.yellow,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// Drive Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drive.tripName ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "dateAndTime".tr.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "members".tr.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${drive.participants?.length ?? 0}/${drive.maxParticipants ?? 0}",
                            style: const TextStyle(
                              color: AppColors.yellow,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (isJoined || isHost) ...[
                  Text(
                    "startingPoint".tr.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    drive.meetingPoint?.address ?? "",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                /// Button & Share section
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: _buildActionButton(
                          drive,
                          isOpen,
                          isHost,
                          isJoined,
                          isFull,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 44,
                      width: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.share_outlined,
                          color: Colors.white70,
                          size: 18,
                        ),
                        onPressed: () {
                          // ignore: deprecated_member_use
                          Share.share(
                            "Join my expedition '${drive.tripName}' on Speedring! Date: $formattedDate. Location: ${drive.meetingPoint?.address ?? ''}",
                            subject: "Join ${drive.tripName}",
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    Expedition drive,
    bool isOpen,
    bool isHost,
    bool isJoined,
    bool isFull,
  ) {
    if (isHost && isOpen) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellow,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          Get.toNamed(AppRoutes.tripLobbyScreen, arguments: drive);
        },
        child: Text(
          "myTrip".tr.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      );
    }

    if (isJoined) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff2a2a2a),
          foregroundColor: AppColors.yellow,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          Get.toNamed(AppRoutes.tripLobbyScreen, arguments: drive);
        },
        child: Text(
          "joined".tr.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      );
    }

    if (isOpen) {
      if (isFull) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff2a2a2a),
            foregroundColor: Colors.white30,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: null,
          child: Text(
            "lobbyFull".tr.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        );
      }

      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellow,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          trackController.joinExpedition(drive.id!);
        },
        child: Text(
          "joinDrive".tr.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

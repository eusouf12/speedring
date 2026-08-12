import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_nav_bar/navbar.dart';
import 'package:speedring/view/sereen/UserScreen/track/mode/track_model.dart';
import '../../../../utils/app_const/app_const.dart';
import '../Profile/controller/profile_controller.dart';
import '../Profile/model/profile_model.dart';
import 'controller/track_controller.dart' show TrackController;
import 'widgets/track_appbar.dart';

class PrepareSessionScreen extends StatelessWidget {
  PrepareSessionScreen({super.key});

  final TrackController trackController = Get.find<TrackController>();
  final ProfileScreenController profileController =
      Get.find<ProfileScreenController>();

  void _showTrackSelectionBottomSheet(BuildContext context) {
    if (trackController.tracks.isEmpty) {
      trackController.getAllTracks(refresh: true);
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "selectTrack".tr,
                style: const TextStyle(
                  color: AppColors.yellow,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (trackController.isLoading.value &&
                      trackController.tracks.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.yellow),
                    );
                  }
                  if (trackController.tracks.isEmpty) {
                    return Center(
                      child: Text(
                        "noTracksFound".tr,
                        style: const TextStyle(color: Colors.white54),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: trackController.tracks.length,
                    itemBuilder: (context, index) {
                      Track track = trackController.tracks[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(track.coverImage ?? ""),
                          backgroundColor: Colors.grey[900],
                        ),
                        title: Text(
                          track.name ?? "unknownTrack".tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          track.country ?? "unknown".tr,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          trackController.setTrack(track);
                          Get.back();
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showVehicleSelectionBottomSheet(BuildContext context) {
    if (profileController.vehicles.isEmpty) {
      profileController.getMyVehicles(isLoadMore: false);
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "selectYourCar".tr,
                style: const TextStyle(
                  color: AppColors.yellow,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (profileController.isVehicleLoading.value &&
                      profileController.vehicles.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.yellow),
                    );
                  }
                  if (profileController.vehicles.isEmpty) {
                    return Center(
                      child: Text(
                        "noVehiclesAdded".tr,
                        style: const TextStyle(color: Colors.white54),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: profileController.vehicles.length,
                    itemBuilder: (context, index) {
                      Vehicle vehicle = profileController.vehicles[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            vehicle.vehicleImage ?? "",
                          ),
                          backgroundColor: Colors.grey[900],
                        ),
                        title: Text(
                          vehicle.vehicleName ?? "unknownCar".tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "${vehicle.brand ?? ''} ${vehicle.model ?? ''}"
                              .trim(),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          trackController.setVehicle(vehicle);
                          Get.back();
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // If opened with arguments, set them in the controller. Otherwise, if the controller is null we show "SELECT TRACK".
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null && Get.arguments is Track) {
        trackController.setTrack(Get.arguments as Track);
      } else if (Get.previousRoute == AppRoutes.trackHubScreen) {
        trackController.resetPrepareSessionState();
      }
    });

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: TrackAppBar(
          profilePic:
              profileController.profileData.value?.profileImage ??
              AppConstants.profileImage,
          title: "",
          showLogo: true,
          leading: const BackButton(color: AppColors.yellow),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// Title Header: PREPARE
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "prepare".tr,
                    style: const TextStyle(
                      color: AppColors.yellow,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(width: 60, height: 3, color: AppColors.yellow),
                ],
              ),
              const SizedBox(height: 24),

              /// 1. YOUR CAR Card
              GestureDetector(
                onTap: () => _showVehicleSelectionBottomSheet(context),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xff111111),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Obx(() {
                    final selectedVehicle =
                        trackController.selectedVehicle.value;
                    return selectedVehicle == null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40.0),
                            child: Center(
                              child: Text(
                                "selectYourCar".tr,
                                style: const TextStyle(
                                  color: AppColors.yellow,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Car image stack with badge
                              Stack(
                                children: [
                                  Image.network(
                                    selectedVehicle.vehicleImage ??
                                        "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=600&auto=format&fit=crop",
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 12,
                                    left: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: AppColors.yellow.withValues(
                                            alpha: 0.3,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "yourCar".tr,
                                        style: const TextStyle(
                                          color: AppColors.yellow,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              /// Car Description
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          selectedVehicle.vehicleName ??
                                              (selectedVehicle.brand ??
                                                  "unknownCar".tr),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${selectedVehicle.year ?? ''} ${selectedVehicle.model ?? ''}"
                                              .trim(),
                                          style: const TextStyle(
                                            color: Colors.white38,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff222222),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.loop,
                                        color: Colors.white70,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              /// 2. THE TRACK Selector Card
              GestureDetector(
                onTap: () => _showTrackSelectionBottomSheet(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xff111111),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "theTrack".tr,
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Obx(() {
                              final selectedTrack =
                                  trackController.selectedTrack.value;
                              return Text(
                                selectedTrack?.name?.toUpperCase() ??
                                    "selectTrack".tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.map_outlined,
                        color: AppColors.yellow,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.white38,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// 3. Telemetry card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "telemetryUpper".tr,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "recordMyLaps".tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () => Switch(
                        value: trackController.recordLaps.value,
                        onChanged: trackController.toggleRecordLaps,
                        activeThumbColor: AppColors.yellow,
                        activeTrackColor: AppColors.yellow.withValues(
                          alpha: 0.3,
                        ),
                        inactiveThumbColor: Colors.white38,
                        inactiveTrackColor: Colors.white10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              /// 4. START SESSION button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (trackController.selectedTrack.value == null ||
                        trackController.selectedVehicle.value == null) {
                      Get.snackbar(
                        "error".tr,
                        "pleaseSelectTrackAndVehicle".tr,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    Get.toNamed(AppRoutes.liveSessionScreen, arguments: trackController.selectedTrack.value);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "startSession".tr,
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
              const SizedBox(height: 16),

              /// System Signal acquired text
              Center(
                child: Text(
                  "systemReadyGps".tr,
                  style: const TextStyle(
                    color: Colors.white24,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        bottomNavigationBar: const CustomNavBar(currentIndex: 2),
      ),
    );
  }
}

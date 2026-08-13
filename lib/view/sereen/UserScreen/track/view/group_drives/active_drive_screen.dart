import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/utils/app_const/app_const.dart' show AppConstants;
import 'package:speedring/view/sereen/UserScreen/track/controller/active_drive_controller.dart';
import 'package:speedring/view/sereen/UserScreen/track/widgets/track_appbar.dart';

class ActiveDriveScreen extends StatelessWidget {
  const ActiveDriveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ActiveDriveController controller = Get.put(ActiveDriveController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: TrackAppBar(
        profilePic: controller.profileController.profileData.value?.profileImage ??
            AppConstants.profileImage2,
        title: controller.drive?.tripName?.toUpperCase() ?? "UNTITLED EXPEDITION",
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
          onPressed: () => Get.back(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.yellow, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.yellow,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  "liveTelemetry".tr.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.yellow,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          /// 1. Real Google Map Background
          Obx(
            () => GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  controller.drive?.meetingPoint?.lat ?? 0.0,
                  controller.drive?.meetingPoint?.lng ?? 0.0,
                ),
                zoom: 15,
              ),
              onMapCreated: controller.onMapCreated,
              markers: controller.markers.toSet(),
              polylines: controller.polylines.toSet(),
              myLocationEnabled: controller.isHost,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
            ),
          ),

          /// 2. Top Metrics Grid
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Obx(
              () => Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      "currSpeed".tr.toUpperCase(),
                      controller.currentSpeedKmh.value.toStringAsFixed(0),
                      "KM/H",
                      isHighlighted: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricCard(
                      "distance".tr.toUpperCase(),
                      controller.totalDistanceKm.value.toStringAsFixed(1),
                      "KM",
                      isHighlighted: false,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 3. Map Control Floating Buttons (Chat, Mic, Target)
          Positioned(
            bottom: 100,
            right: 16,
            child: Column(
              children: [
                _buildMapFloatingButton(Icons.chat_bubble_outline),
                const SizedBox(height: 12),
                _buildMapFloatingButton(Icons.mic_none_outlined),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    if (controller.currentLocation.value != null && controller.mapController != null) {
                      controller.mapController!.animateCamera(
                        CameraUpdate.newLatLng(
                          LatLng(
                            controller.currentLocation.value!.latitude,
                            controller.currentLocation.value!.longitude,
                          ),
                        ),
                      );
                    } else if (controller.drive?.meetingPoint != null && controller.mapController != null) {
                      controller.mapController!.animateCamera(
                        CameraUpdate.newLatLng(
                          LatLng(
                            controller.drive!.meetingPoint!.lat ?? 0.0,
                            controller.drive!.meetingPoint!.lng ?? 0.0,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.yellow.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.black,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// 4. Bottom Actions Row
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: controller.isHost
                ? Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: Obx(
                            () => OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => controller.toggleTrackingPause(),
                              child: Text(
                                controller.isTrackingPaused.value
                                    ? "resumeTracking".tr.toUpperCase()
                                    : "pauseTracking".tr.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: AppColors.yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: AppColors.yellow,
                                  width: 1.5,
                                ),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => Get.toNamed(
                              AppRoutes.endExpeditionScreen,
                              arguments: controller.drive,
                            ),
                            child: Text(
                              "endTrip".tr.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: AppColors.yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: AppColors.yellow,
                                  width: 1.5,
                                ),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => Get.back(),
                            child: Text(
                              "leaveTrip".tr.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String label,
    String value,
    String unit, {
    required bool isHighlighted,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xff111111).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 8,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: isHighlighted ? AppColors.yellow : Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
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
    );
  }

  Widget _buildMapFloatingButton(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xff111111).withValues(alpha: 0.9),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white10),
      ),
      child: Icon(icon, color: Colors.white70, size: 20),
    );
  }
}

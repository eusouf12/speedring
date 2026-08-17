import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/utils/app_const/app_const.dart' show AppConstants;
import 'package:speedring/view/sereen/UserScreen/track/controller/active_drive_controller.dart';
import 'package:speedring/view/sereen/UserScreen/track/widgets/track_appbar.dart';
import 'package:speedring/view/sereen/UserScreen/Profile/controller/settings_controller.dart';

class ActiveDriveScreen extends StatelessWidget {
  const ActiveDriveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ActiveDriveController controller = Get.put(ActiveDriveController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: TrackAppBar(
        profilePic:
            controller.profileController.profileData.value?.profileImage ??
            AppConstants.profileImage2,
        title: controller.drive?.tripName?.toUpperCase() ?? "unknown".tr,
        leading: BackButton(color: AppColors.yellow),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: () {
              _showSettingsBottomSheet(context, controller.settings);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Get.offAllNamed(AppRoutes.profileScreen);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.yellow, width: 1.5),
                    image: DecorationImage(
                      image: NetworkImage(
                        controller
                                .profileController
                                .profileData
                                .value
                                ?.profileImage ??
                            AppConstants.profileImage2,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
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
              padding: const EdgeInsets.only(bottom: 250),
            ),
          ),

          /// 2. Top Metrics Grid
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Obx(
              () => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          "currSpeed".tr.toUpperCase(),
                          controller.settings
                              .getSpeed(controller.currentSpeedKmh.value)
                              .toStringAsFixed(0),
                          controller.settings.speedUnit,
                          isHighlighted: true,
                        ),
                      ),
                      if (controller.settings.showDistance.value) ...[
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMetricCard(
                            "distance".tr.toUpperCase(),
                            controller.settings
                                .getDistance(controller.totalDistanceKm.value)
                                .toStringAsFixed(1),
                            controller.settings.distanceUnit,
                            isHighlighted: false,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (controller.settings.showGForce.value ||
                      controller.currentTemperature.value != "--") ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (controller.settings.showGForce.value)
                          Expanded(
                            child: _buildMetricCard(
                              "PEAK G-FORCE",
                              controller.peakGForce.value.toStringAsFixed(2),
                              "g",
                              isHighlighted: false,
                            ),
                          ),
                        if (controller.settings.showGForce.value &&
                            controller.currentTemperature.value != "--")
                          const SizedBox(width: 16),
                        if (controller.currentTemperature.value != "--")
                          Expanded(
                            child: _buildMetricCard(
                              "TEMP",
                              controller.currentTemperature.value.replaceAll(
                                RegExp(r' °[CF]'),
                                '',
                              ),
                              controller.currentTemperature.value.contains('C')
                                  ? '°C'
                                  : '°F',
                              isHighlighted: false,
                            ),
                          ),
                      ],
                    ),
                  ],
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
                    if (controller.currentLocation.value != null &&
                        controller.mapController != null) {
                      controller.mapController!.animateCamera(
                        CameraUpdate.newLatLng(
                          LatLng(
                            controller.currentLocation.value!.latitude,
                            controller.currentLocation.value!.longitude,
                          ),
                        ),
                      );
                    } else if (controller.drive?.meetingPoint != null &&
                        controller.mapController != null) {
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
            bottom: MediaQuery.of(context).viewPadding.bottom + 16,
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
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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

  void _showSettingsBottomSheet(
    BuildContext context,
    SettingsController settings,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "DISPLAY SETTINGS",
                style: const TextStyle(
                  color: AppColors.yellow,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => SwitchListTile(
                  title: const Text(
                    "Use Metric (KM/H)",
                    style: TextStyle(color: Colors.white),
                  ),
                  value: settings.isMetric.value,
                  activeTrackColor: AppColors.yellow,
                  onChanged: (val) => settings.toggleUnitSystem(),
                ),
              ),
              Obx(
                () => SwitchListTile(
                  title: const Text(
                    "Show Top Speed",
                    style: TextStyle(color: Colors.white),
                  ),
                  value: settings.showTopSpeed.value,
                  activeTrackColor: AppColors.yellow,
                  onChanged: (val) => settings.toggleTopSpeed(),
                ),
              ),
              Obx(
                () => SwitchListTile(
                  title: const Text(
                    "Show Average Speed",
                    style: TextStyle(color: Colors.white),
                  ),
                  value: settings.showAvgSpeed.value,
                  activeTrackColor: AppColors.yellow,
                  onChanged: (val) => settings.toggleAvgSpeed(),
                ),
              ),
              Obx(
                () => SwitchListTile(
                  title: const Text(
                    "Show Distance",
                    style: TextStyle(color: Colors.white),
                  ),
                  value: settings.showDistance.value,
                  activeTrackColor: AppColors.yellow,
                  onChanged: (val) => settings.toggleDistance(),
                ),
              ),
              Obx(
                () => SwitchListTile(
                  title: const Text(
                    "Show Peak G-Force",
                    style: TextStyle(color: Colors.white),
                  ),
                  value: settings.showGForce.value,
                  activeTrackColor: AppColors.yellow,
                  onChanged: (val) => settings.toggleGForce(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

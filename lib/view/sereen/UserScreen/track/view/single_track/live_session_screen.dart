import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/sereen/UserScreen/track/mode/track_model.dart';
import 'package:speedring/view/sereen/UserScreen/track/controller/live_session_controller.dart';
import 'package:speedring/view/sereen/UserScreen/Profile/controller/settings_controller.dart';

class LiveSessionScreen extends StatelessWidget {
  const LiveSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Track? track = Get.arguments as Track?;
    final LiveSessionController controller = Get.put(
      LiveSessionController(track: track),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// 1. Google Map Background
          Obx(
            () => GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  track?.startCoordinates?.lat ?? 0.0,
                  track?.startCoordinates?.lng ?? 0.0,
                ),
                zoom: 15,
              ),
              onMapCreated: controller.onMapCreated,
              markers: controller.markers.toSet(),
              polylines: controller.polylines.toSet(),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              padding: const EdgeInsets.only(bottom: 350),
            ),
          ),

          /// 2. Overlay UI
          SafeArea(
            child: Column(
              children: [
                /// Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "liveSession".tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white70),
                        onPressed: () {
                          _showSettingsBottomSheet(
                            context,
                            controller.settings,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                /// Bottom Stats Panel
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xff111111).withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Timer
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              color: AppColors.yellow,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Obx(
                              () => Text(
                                controller.formattedTime,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),

                      /// Speed Display
                      Text(
                        "currentVelocity".tr,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Obx(
                            () => Text(
                              controller.settings
                                  .getSpeed(controller.currentSpeedKmh.value)
                                  .toStringAsFixed(0),
                              style: const TextStyle(
                                color: AppColors.yellow,
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Obx(
                            () => Text(
                              controller.settings.speedUnit,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// Grid Stats
                      Obx(
                        () => Row(
                          children: [
                            if (controller.settings.showAvgSpeed.value)
                              Expanded(
                                child: _buildStatItem(
                                  "avgSpeed".tr,
                                  controller.settings
                                      .getSpeed(
                                        controller.averageSpeedKmh.value,
                                      )
                                      .toStringAsFixed(1),
                                  controller.settings.speedUnit,
                                ),
                              ),
                            if (controller.settings.showAvgSpeed.value &&
                                controller.settings.showDistance.value)
                              const SizedBox(width: 12),
                            if (controller.settings.showDistance.value)
                              Expanded(
                                child: _buildStatItem(
                                  "distance".tr,
                                  controller.settings
                                      .getDistance(
                                        controller.totalDistanceKm.value,
                                      )
                                      .toStringAsFixed(1),
                                  controller.settings.distanceUnit,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Obx(() {
                        bool showGForce = controller.settings.showGForce.value;
                        bool hasTemp =
                            controller.currentTemperature.value != "--";

                        if (!showGForce && !hasTemp) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(
                            children: [
                              if (showGForce)
                                Expanded(
                                  child: _buildStatItem(
                                    "peakGForce".tr,
                                    controller.peakGForce.value.toStringAsFixed(
                                      2,
                                    ),
                                    "g",
                                  ),
                                ),
                              if (showGForce && hasTemp)
                                const SizedBox(width: 12),
                              if (hasTemp)
                                Expanded(
                                  child: _buildStatItem(
                                    "temp".tr,
                                    controller.currentTemperature.value
                                        .replaceAll(RegExp(r' °[CF]'), ''),
                                    controller.currentTemperature.value
                                            .contains('C')
                                        ? '°C'
                                        : '°F',
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 10),

                      /// Finish Button
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.yellow,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () => controller.finishSession(),
                          child: Text(
                            "finishSession".tr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
                "displaySettings".tr,
                style: const TextStyle(
                  color: AppColors.yellow,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => SwitchListTile(
                  title: Text(
                    "useMetric".tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                  value: settings.isMetric.value,
                  activeTrackColor: AppColors.yellow,
                  onChanged: (val) => settings.toggleUnitSystem(),
                ),
              ),
              Obx(
                () => SwitchListTile(
                  title: Text(
                    "showTopSpeed".tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                  value: settings.showTopSpeed.value,
                  activeTrackColor: AppColors.yellow,
                  onChanged: (val) => settings.toggleTopSpeed(),
                ),
              ),
              Obx(
                () => SwitchListTile(
                  title: Text(
                    "showAvgSpeed".tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                  value: settings.showAvgSpeed.value,
                  activeTrackColor: AppColors.yellow,
                  onChanged: (val) => settings.toggleAvgSpeed(),
                ),
              ),
              Obx(
                () => SwitchListTile(
                  title: Text(
                    "showDistance".tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                  value: settings.showDistance.value,
                  activeTrackColor: AppColors.yellow,
                  onChanged: (val) => settings.toggleDistance(),
                ),
              ),
              Obx(
                () => SwitchListTile(
                  title: Text(
                    "showPeakGForce".tr,
                    style: const TextStyle(color: Colors.white),
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

  Widget _buildStatItem(String label, String value, String unit) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black,
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
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

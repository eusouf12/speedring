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
    final Map<String, dynamic>? args = Get.arguments as Map<String, dynamic>?;
    final Track? track = args?['track'] as Track?;
    final LiveSessionController controller = Get.put(
      LiveSessionController(track: track, vehicle: args?['vehicle']),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// 1. Google Map Background with Live Vehicle & Route
          Obx(
            () => GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  track?.startCoordinates?.lat ?? 0.0,
                  track?.startCoordinates?.lng ?? 0.0,
                ),
                zoom: 17.0,
              ),
              onMapCreated: controller.onMapCreated,
              onCameraMoveStarted: () {
                controller.onMapPanned();
              },
              markers: controller.markers.toSet(),
              polylines: controller.polylines.toSet(),
              myLocationEnabled: false, // Using custom rotating vehicle marker
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              compassEnabled: true,
              rotateGesturesEnabled: true,
              tiltGesturesEnabled: true,
              mapType: controller.mapType.value,
              padding: const EdgeInsets.only(bottom: 320, top: 80),
            ),
          ),

          /// 2. Top Header & Destination Progress
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Live Recording Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff111111).withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.yellow.withValues(alpha: 0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 9,
                              height: 9,
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              track?.name != null
                                  ? "${track!.name!.toUpperCase()} • ${'liveSession'.tr}"
                                  : "liveSession".tr.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Settings Button
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff111111).withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.tune_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            _showSettingsBottomSheet(
                              context,
                              controller.settings,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                /// Destination Distance Indicator (if finish coordinate exists)
                if (track?.finishCoordinates != null)
                  Obx(() {
                    final dist = controller.remainingDistanceKm.value;
                    if (dist <= 0) return const SizedBox.shrink();
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.yellow.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.flag_rounded,
                            color: AppColors.yellow,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${dist.toStringAsFixed(2)} ${controller.settings.distanceUnit.toLowerCase()} ${'remaining'.tr.tr == 'remaining' ? 'remaining' : 'remaining'.tr}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),

          /// 3. Floating Map Controls (Right Side - Strava Experience)
          Positioned(
            right: 16,
            top: 120,
            child: Column(
              children: [
                /// Recenter / Lock Camera Button (Glows when user pans away)
                Obx(
                  () => GestureDetector(
                    onTap: () => controller.recenterCamera(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: controller.isFollowingUser.value
                            ? const Color(0xff1a1a1a).withValues(alpha: 0.9)
                            : AppColors.yellow,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: controller.isFollowingUser.value
                              ? Colors.white24
                              : AppColors.yellow,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: controller.isFollowingUser.value
                                ? Colors.transparent
                                : AppColors.yellow.withValues(alpha: 0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        controller.isFollowingUser.value
                            ? Icons.navigation_rounded
                            : Icons.my_location_rounded,
                        color: controller.isFollowingUser.value
                            ? AppColors.yellow
                            : Colors.black,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                /// 2D / 3D Navigation Perspective Mode Toggle
                Obx(
                  () => GestureDetector(
                    onTap: () => controller.toggle3dPerspective(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xff1a1a1a).withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: controller.is3dPerspective.value
                              ? AppColors.yellow
                              : Colors.white24,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          controller.is3dPerspective.value ? "3D" : "2D",
                          style: TextStyle(
                            color: controller.is3dPerspective.value
                                ? AppColors.yellow
                                : Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                /// Map Layer Switcher (Normal / Hybrid)
                GestureDetector(
                  onTap: () => controller.toggleMapType(),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xff1a1a1a).withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(
                      Icons.layers_outlined,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                /// Zoom In Button
                GestureDetector(
                  onTap: () => controller.zoomIn(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xff1a1a1a).withValues(alpha: 0.9),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ),
                ),

                /// Zoom Out Button
                GestureDetector(
                  onTap: () => controller.zoomOut(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xff1a1a1a).withValues(alpha: 0.9),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(8),
                      ),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// 4. Bottom Driving Stats HUD Panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff101010).withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.8),
                      blurRadius: 20,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Timer & Compass Heading Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Timer Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                color: AppColors.yellow,
                                size: 15,
                              ),
                              const SizedBox(width: 6),
                              Obx(
                                () => Text(
                                  controller.formattedTime,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    fontFeatures: [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Elevation / Altitude Badge
                        Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.terrain_rounded,
                                  color: Colors.white60,
                                  size: 14,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "${controller.currentAltitude.value.toStringAsFixed(0)} m",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    /// Speedometer Readout (Strava Hero Velocity)
                    Text(
                      "currentVelocity".tr.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
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
                              fontSize: 54,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Obx(
                          () => Text(
                            controller.settings.speedUnit,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    /// 2-Column Stats Grid (Avg Speed, Distance, Peak G, Temp)
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
                            const SizedBox(width: 10),
                          if (controller.settings.showDistance.value)
                            Expanded(
                              child: _buildStatItem(
                                "distance".tr,
                                controller.settings
                                    .getDistance(
                                      controller.totalDistanceKm.value,
                                    )
                                    .toStringAsFixed(2),
                                controller.settings.distanceUnit,
                              ),
                            ),
                        ],
                      ),
                    ),

                    Obx(() {
                      final bool showGForce =
                          controller.settings.showGForce.value;
                      final bool hasTemp =
                          controller.currentTemperature.value != "--";

                      if (!showGForce && !hasTemp) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
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
                              const SizedBox(width: 10),
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
                    const SizedBox(height: 14),

                    /// Finish Session Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellow,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => controller.finishSession(),
                        child: Text(
                          "finishSession".tr.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "displaySettings".tr,
                style: const TextStyle(
                  color: AppColors.yellow,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => SwitchListTile(
                  title: Text(
                    "useMetric".tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 3),
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
                  fontFeatures: [FontFeature.tabularFigures()],
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

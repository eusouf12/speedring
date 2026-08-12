import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import '../../../../../utils/app_images/app_images.dart';
import '../../../components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/sereen/UserScreen/track/controller/track_controller.dart';
import 'package:speedring/view/sereen/UserScreen/Home/Screen/HomeScreen/controller/home_controller.dart';

class DriveSummaryScreen extends StatelessWidget {
  const DriveSummaryScreen({super.key});

  String _formatTime(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;
    if (h > 0) {
      return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
    } else {
      return "00:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final TrackController trackController = Get.find<TrackController>();
    final HomeController homeController = Get.put(HomeController());

    final Map<String, dynamic> args = Get.arguments ?? {};
    final List<LatLng> routePoints = args['routePoints'] ?? [];
    final int elapsedSeconds = args['elapsedSeconds'] ?? 0;
    final double totalDistanceKm = args['totalDistanceKm'] ?? 0.0;
    final double averageSpeedKmh = args['averageSpeedKmh'] ?? 0.0;
    final double topSpeedKmh = args['topSpeedKmh'] ?? 0.0;
    final List<double> speedHistory = args['speedHistory'] ?? [];

    String formattedTime = _formatTime(elapsedSeconds);

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Image.asset(
            AppImages.splashLogo,
            height: 150,
            width: 350,
            fit: BoxFit.contain,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 24),
              onPressed: () => Get.offAllNamed(AppRoutes.userHomeScreen),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),

              /// 2. Grid stats
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      Icons.access_time_filled,
                      "time".tr,
                      formattedTime,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      Icons.social_distance,
                      "distance".tr,
                      "${totalDistanceKm.toStringAsFixed(1)} ${'km'.tr}",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      Icons.flash_on,
                      "topSpeed".tr,
                      "${topSpeedKmh.toStringAsFixed(0)} ${'kmh'.tr}",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      Icons.speed,
                      "avgSpeed".tr,
                      "${averageSpeedKmh.toStringAsFixed(0)} ${'kmh'.tr}",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// 3. SESSION TRACK CARD
              Container(
                width: double.infinity,
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
                      "sessionTrack".tr,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: routePoints.isNotEmpty
                                ? routePoints.first
                                : (trackController
                                              .selectedTrack
                                              .value
                                              ?.startCoordinates !=
                                          null
                                      ? LatLng(
                                          trackController
                                                  .selectedTrack
                                                  .value!
                                                  .startCoordinates!
                                                  .lat ??
                                              0.0,
                                          trackController
                                                  .selectedTrack
                                                  .value!
                                                  .startCoordinates!
                                                  .lng ??
                                              0.0,
                                        )
                                      : const LatLng(0, 0)),
                            zoom: 14,
                          ),
                          polylines: {
                            if (routePoints.isNotEmpty)
                              Polyline(
                                polylineId: const PolylineId('route'),
                                points: routePoints,
                                color: AppColors.yellow,
                                width: 4,
                                jointType: JointType.round,
                                startCap: Cap.roundCap,
                                endCap: Cap.roundCap,
                              ),
                          },
                          markers: {
                            if (routePoints.isNotEmpty)
                              Marker(
                                markerId: const MarkerId('start'),
                                position: routePoints.first,
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueGreen,
                                ),
                              ),
                            if (routePoints.isNotEmpty)
                              Marker(
                                markerId: const MarkerId('finish'),
                                position: routePoints.last,
                                icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueRed,
                                ),
                              ),
                          },
                          zoomControlsEnabled: false,
                          scrollGesturesEnabled: false,
                          myLocationButtonEnabled: false,
                          mapType: MapType.normal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.circle, color: Colors.green, size: 6),
                        const SizedBox(width: 4),
                        Text(
                          "startUpper".tr,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.circle, color: Colors.red, size: 6),
                        const SizedBox(width: 4),
                        Text(
                          "endUpper".tr,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// 4. SPEED OVER TIME CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "speedOverTime".tr,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          "${'peak'.tr} ${topSpeedKmh.toStringAsFixed(0)} ${'kmh'.tr}",
                          style: const TextStyle(
                            color: AppColors.yellow,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: SpeedGraphPainter(
                          speedHistory: speedHistory,
                          topSpeed: topSpeedKmh,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "0:00",
                          style: TextStyle(
                            color: Colors.white24,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatTime(elapsedSeconds ~/ 3),
                          style: const TextStyle(
                            color: Colors.white24,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatTime((elapsedSeconds ~/ 3) * 2),
                          style: const TextStyle(
                            color: Colors.white24,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formattedTime,
                          style: const TextStyle(
                            color: Colors.white24,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              /// 5. SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    Map<String, dynamic> sessionData = {
                      "driveScore": 94,
                      "time": formattedTime,
                      "distance": totalDistanceKm,
                      "topSpeed": topSpeedKmh.toStringAsFixed(0),
                      "avgSpeed": averageSpeedKmh.toStringAsFixed(0),
                      "speedOverTime": speedHistory
                          .asMap()
                          .entries
                          .map(
                            (e) => {
                              "time": _formatTime(e.key),
                              "speed": e.value,
                            },
                          )
                          .toList(),
                      "sessionTrack": routePoints
                          .map((e) => {"lat": e.latitude, "lng": e.longitude})
                          .toList(),
                    };

                    bool success = await trackController.createSession(
                      sessionData,
                    );
                    if (success) {
                      Get.offAllNamed(AppRoutes.userHomeScreen);
                    }
                  },
                  child: Obx(
                    () => trackController.isCreatingSession.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "save".tr,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 16),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// SHARE RESULTS LINK
              Center(
                child: Obx(
                  () => homeController.isPostCreating.value
                      ? const CircularProgressIndicator(color: AppColors.yellow)
                      : TextButton.icon(
                          onPressed: () {
                            Get.bottomSheet(
                              Material(
                                color: const Color(0xff181818),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(
                                          Icons.share,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          "shareToFriends".tr,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          Get.back();
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(
                                          Icons.post_add,
                                          color: AppColors.yellow,
                                        ),
                                        title: Text(
                                          "postToApp".tr,
                                          style: const TextStyle(
                                            color: AppColors.yellow,
                                          ),
                                        ),
                                        onTap: () async {
                                          Get.back();
                                          Map<String, dynamic>
                                          sessionDetails = {
                                            "vehicle":
                                                trackController
                                                    .selectedVehicle
                                                    .value
                                                    ?.vehicleName ??
                                                "N/A",
                                            "vehicleImage":
                                                trackController
                                                    .selectedVehicle
                                                    .value
                                                    ?.vehicleImage ??
                                                "",
                                            "circuit":
                                                trackController
                                                    .selectedTrack
                                                    .value
                                                    ?.city ??
                                                "N/A",
                                            "trackName":
                                                trackController
                                                    .selectedTrack
                                                    .value
                                                    ?.name ??
                                                "N/A",
                                            "bestLapTime": formattedTime,
                                            "topSpeed": topSpeedKmh
                                                .toStringAsFixed(0),
                                            "summary":
                                                "Completed a drive of ${totalDistanceKm.toStringAsFixed(1)} km in $formattedTime.",
                                          };

                                          bool success = await homeController
                                              .createPost(
                                                category: "SESSION_POST",
                                                visibility: "Public",
                                                sessionDetails: sessionDetails,
                                                mediaUrl: trackController
                                                    .selectedVehicle
                                                    .value
                                                    ?.vehicleImage,
                                              );
                                          if (success) {
                                            Get.offAllNamed(
                                              AppRoutes.userHomeScreen,
                                            );
                                            showCustomSnackBar(
                                              "Success, Post created successfully",
                                              isError: false,
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.share_outlined,
                            color: Colors.white38,
                            size: 14,
                          ),
                          label: Text(
                            "shareResults".tr,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value) {
    return Container(
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
            children: [
              Icon(icon, color: AppColors.yellow, size: 12),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter to render the speed over time graph
class SpeedGraphPainter extends CustomPainter {
  final List<double> speedHistory;
  final double topSpeed;

  SpeedGraphPainter({required this.speedHistory, required this.topSpeed});

  @override
  void paint(Canvas canvas, Size size) {
    final bgGridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = AppColors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Draw horizontal grid lines
    for (int i = 1; i <= 3; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), bgGridPaint);
    }

    final path = Path();

    if (speedHistory.isEmpty) {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      // Create points based on dynamic speed data
      // y = 0 is top of canvas, y = size.height is bottom.
      // So y = size.height - (speed / topSpeed) * size.height * 0.9 (keep a 10% margin at top)
      final double maxSpeed = topSpeed > 0
          ? topSpeed
          : 1.0; // prevent div by zero

      for (int i = 0; i < speedHistory.length; i++) {
        final double x = (i / (speedHistory.length - 1)) * size.width;
        final double normalizedSpeed = (speedHistory[i] / maxSpeed).clamp(
          0.0,
          1.0,
        );
        final double y = size.height - (normalizedSpeed * size.height * 0.9);

        if (i == 0) {
          path.moveTo(x.isNaN ? 0 : x, y);
        } else {
          path.lineTo(x.isNaN ? 0 : x, y);
        }
      }
    }

    // Draw graph gradient fill under path
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.yellow.withValues(alpha: 0.25), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

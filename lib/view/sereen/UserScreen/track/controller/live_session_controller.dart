import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speedring/view/sereen/UserScreen/track/mode/track_model.dart';
import 'package:speedring/view/sereen/UserScreen/track/controller/track_controller.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/view/sereen/UserScreen/Profile/controller/settings_controller.dart';
import 'package:speedring/service/socket_service.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:http/http.dart' as http;
import 'package:speedring/helper/map_snap_helper.dart';

class LiveSessionController extends GetxController {
  final Track? track;
  final SettingsController settings = Get.find<SettingsController>();

  LiveSessionController({this.track});

  // Map state
  GoogleMapController? mapController;
  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Polyline> polylines = <Polyline>{}.obs;
  List<LatLng> routePoints = [];
  List<Map<String, dynamic>> sessionTrackPoints = [];

  // Custom marker icons
  BitmapDescriptor? carMarkerIcon;
  BitmapDescriptor? startMarkerIcon;
  BitmapDescriptor? finishMarkerIcon;

  // Tracking state & camera modes
  StreamSubscription<Position>? positionStream;
  Rx<Position?> currentLocation = Rx<Position?>(null);
  RxBool isFollowingUser = true.obs;
  RxBool is3dPerspective = false.obs;
  Rx<MapType> mapType = MapType.normal.obs;

  // Stats
  RxInt elapsedSeconds = 0.obs;
  RxDouble currentSpeedKmh = 0.0.obs;
  RxDouble currentHeading = 0.0.obs;
  RxDouble currentAltitude = 0.0.obs;
  RxDouble topSpeedKmh = 0.0.obs;
  RxDouble totalDistanceKm = 0.0.obs;
  RxDouble averageSpeedKmh = 0.0.obs;
  RxDouble remainingDistanceKm = 0.0.obs;
  List<double> speedHistory = [];

  // Fallback speed & heading tracking
  Position? _previousPosition;
  DateTime? _previousPositionTime;

  // Acceleration 0-100
  bool isAccelerating0to100 = false;
  DateTime? accelerationStartTime;
  RxDouble best0to100Time = 0.0.obs;

  // Advanced Acceleration
  bool isAccelerating0to200 = false;
  DateTime? acceleration0to200StartTime;
  RxDouble best0to200Time = 0.0.obs;

  bool isAccelerating100to200 = false;
  DateTime? acceleration100to200StartTime;
  RxDouble best100to200Time = 0.0.obs;

  bool isAccelerating0to300 = false;
  DateTime? acceleration0to300StartTime;
  RxDouble best0to300Time = 0.0.obs;

  bool isAccelerating200to300 = false;
  DateTime? acceleration200to300StartTime;
  RxDouble best200to300Time = 0.0.obs;

  // Sensors & API
  StreamSubscription<UserAccelerometerEvent>? accelerometerStream;
  RxDouble peakGForce = 0.0.obs;
  RxString currentTemperature = "--".obs;

  Timer? timer;
  bool isSessionActive = false;
  bool hasReachedDestination = false;

  @override
  void onInit() {
    super.onInit();
    _loadCustomMarkerIcons();
    _requestLocationPermissionAndStart();
  }

  @override
  void onClose() {
    timer?.cancel();
    positionStream?.cancel();
    accelerometerStream?.cancel();
    mapController?.dispose();
    super.onClose();
  }

  Future<void> _loadCustomMarkerIcons() async {
    // Generate sleek custom directional arrow / car pointer for real-time tracking
    carMarkerIcon = await _createDirectionalArrowMarker(
      color: AppColors.yellow,
      size: 70,
    );

    final trackController = Get.isRegistered<TrackController>()
        ? Get.find<TrackController>()
        : null;

    if (trackController?.startMarkerIcon != null) {
      startMarkerIcon = trackController!.startMarkerIcon;
    } else {
      startMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueYellow,
      );
    }

    if (trackController?.finishMarkerIcon != null) {
      finishMarkerIcon = trackController!.finishMarkerIcon;
    } else {
      finishMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      );
    }

    _setupStaticMarkers();
  }

  /// Create a high-visibility, crisp directional navigation marker with glow
  Future<BitmapDescriptor> _createDirectionalArrowMarker({
    required Color color,
    required int size,
  }) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final double radius = size / 2.0;

    // 1. Outer subtle halo ring
    final Paint haloPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(radius, radius), radius, haloPaint);

    // 2. Dark circular background backing for contrast
    final Paint bgPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(radius, radius), radius * 0.78, bgPaint);

    // 3. Yellow border ring
    final Paint ringPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.04;
    canvas.drawCircle(Offset(radius, radius), radius * 0.78, ringPaint);

    // 4. Directional delta/arrow pointing UP (North / 0 deg)
    final Path arrowPath = Path();
    final double top = radius - (radius * 0.55);
    final double bottom = radius + (radius * 0.45);
    final double left = radius - (radius * 0.45);
    final double right = radius + (radius * 0.45);
    final double innerIndent = radius + (radius * 0.2);

    arrowPath.moveTo(radius, top); // Tip pointing forward
    arrowPath.lineTo(right, bottom); // Right wing
    arrowPath.lineTo(radius, innerIndent); // Center notch
    arrowPath.lineTo(left, bottom); // Left wing
    arrowPath.close();

    final Paint arrowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(arrowPath, arrowPaint);

    // 5. White highlight line on arrow tip
    final Paint highlightPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.03
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(arrowPath, highlightPaint);

    final ui.Picture picture = recorder.endRecording();
    final ui.Image image = await picture.toImage(size, size);
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    if (byteData != null) {
      return BitmapDescriptor.bytes(byteData.buffer.asUint8List());
    }
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _setMapStyle();
    _moveCameraToStartOrCurrent();
  }

  void _setMapStyle() {
    if (mapController == null) return;
    const String darkStyle = '''
    [
      {"elementType": "geometry", "stylers": [{"color": "#121212"}]},
      {"elementType": "labels.icon", "stylers": [{"visibility": "off"}]},
      {"elementType": "labels.text.fill", "stylers": [{"color": "#757575"}]},
      {"elementType": "labels.text.stroke", "stylers": [{"color": "#212121"}]},
      {"featureType": "administrative", "elementType": "geometry", "stylers": [{"color": "#757575"}]},
      {"featureType": "poi", "elementType": "labels.text.fill", "stylers": [{"color": "#757575"}]},
      {"featureType": "poi.park", "elementType": "geometry", "stylers": [{"color": "#181818"}]},
      {"featureType": "road", "elementType": "geometry.fill", "stylers": [{"color": "#282828"}]},
      {"featureType": "road", "elementType": "labels.text.fill", "stylers": [{"color": "#8a8a8a"}]},
      {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#383838"}]},
      {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#000000"}]}
    ]
    ''';
    // ignore: deprecated_member_use
    mapController!.setMapStyle(darkStyle);
  }

  void _setupStaticMarkers() {
    if (track?.startCoordinates != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: LatLng(
            track!.startCoordinates!.lat ?? 0,
            track!.startCoordinates!.lng ?? 0,
          ),
          infoWindow: InfoWindow(title: 'startLocation'.tr),
          icon: startMarkerIcon ??
              BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
          zIndexInt: 2,
        ),
      );
    }
    if (track?.finishCoordinates != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('finish'),
          position: LatLng(
            track!.finishCoordinates!.lat ?? 0,
            track!.finishCoordinates!.lng ?? 0,
          ),
          infoWindow: InfoWindow(title: 'finishLocation'.tr),
          icon: finishMarkerIcon ??
              BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
          zIndexInt: 2,
        ),
      );
    }
  }

  void _moveCameraToStartOrCurrent() {
    if (mapController == null) return;
    if (currentLocation.value != null) {
      _updateCamera(
        LatLng(
          currentLocation.value!.latitude,
          currentLocation.value!.longitude,
        ),
        currentHeading.value,
      );
    } else if (track?.startCoordinates != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              track!.startCoordinates!.lat ?? 0,
              track!.startCoordinates!.lng ?? 0,
            ),
            zoom: 16.5,
          ),
        ),
      );
    }
  }

  Future<void> _requestLocationPermissionAndStart() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('error'.tr, 'locationServicesDisabled'.tr);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('error'.tr, 'locationPermissionsDenied'.tr);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('error'.tr, 'locationPermissionsDeniedForever'.tr);
      return;
    }

    // Permissions granted, start tracking immediately
    _startSession();
  }

  void _startSession() {
    isSessionActive = true;

    // Start timer (1s interval)
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isSessionActive) return;
      elapsedSeconds.value++;
      if (elapsedSeconds.value > 0) {
        averageSpeedKmh.value =
            totalDistanceKm.value / (elapsedSeconds.value / 3600.0);
      }
      speedHistory.add(currentSpeedKmh.value);
    });

    _startGForceTracking();

    // High-frequency Real-Time GPS Tracking with Fused Location Engine
    late LocationSettings locationSettings;
    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0, // Continuous live stream
        intervalDuration: const Duration(milliseconds: 500), // 500ms updates
        forceLocationManager: false, // Use FusedLocationProvider for best speed and bearing
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "Speedring is tracking your session in real-time.",
          notificationTitle: "Live Tracking Active",
          enableWakeLock: true,
        ),
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        activityType: ActivityType.automotiveNavigation,
        distanceFilter: 0,
        pauseLocationUpdatesAutomatically: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
      );
    }

    positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position? position) {
      if (position != null && isSessionActive) {
        _updateTracking(position);
      }
    });
  }

  void _updateTracking(Position position) {
    final DateTime now = DateTime.now();
    final LatLng newPoint = LatLng(position.latitude, position.longitude);

    // 1. Dual-Source Speed Calculation (Instant GPS + Delta distance/time fallback)
    double rawSpeedKmh = 0.0;

    if (position.speed > 0) {
      rawSpeedKmh = position.speed * 3.6;
    } else if (_previousPosition != null && _previousPositionTime != null) {
      // Calculate delta distance & time
      final double deltaDistanceMeters = Geolocator.distanceBetween(
        _previousPosition!.latitude,
        _previousPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      final double deltaTimeSeconds =
          now.difference(_previousPositionTime!).inMilliseconds / 1000.0;

      if (deltaTimeSeconds > 0.1) {
        final double calculatedSpeedMps = deltaDistanceMeters / deltaTimeSeconds;
        rawSpeedKmh = calculatedSpeedMps * 3.6;
      }
    }

    if (rawSpeedKmh < 0.5) {
      rawSpeedKmh = 0.0;
    }

    // Apply smooth low-pass filter (prevents GPS jitter while maintaining snappy response)
    double filteredSpeed = (currentSpeedKmh.value * 0.25) + (rawSpeedKmh * 0.75);
    if (rawSpeedKmh == 0.0) {
      filteredSpeed = 0.0;
    }
    currentSpeedKmh.value = double.parse(filteredSpeed.toStringAsFixed(1));

    if (currentSpeedKmh.value > topSpeedKmh.value) {
      topSpeedKmh.value = currentSpeedKmh.value;
    }

    // 2. Heading / Bearing Calculation
    double targetHeading = currentHeading.value;
    if (position.heading >= 0 && position.heading <= 360 && position.headingAccuracy < 35) {
      targetHeading = position.heading;
    } else if (_previousPosition != null) {
      final double distanceDelta = Geolocator.distanceBetween(
        _previousPosition!.latitude,
        _previousPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      if (distanceDelta > 1.2) {
        // Calculate bearing between previous and current coordinate
        targetHeading = _calculateBearing(
          _previousPosition!.latitude,
          _previousPosition!.longitude,
          position.latitude,
          position.longitude,
        );
      }
    }
    currentHeading.value = targetHeading;
    currentAltitude.value = position.altitude;

    // 3. Distance Accumulation
    if (_previousPosition != null) {
      final double distanceInMeters = Geolocator.distanceBetween(
        _previousPosition!.latitude,
        _previousPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      // Filter out stationary drift (< 0.5m)
      if (distanceInMeters >= 0.5) {
        totalDistanceKm.value += (distanceInMeters / 1000.0);
      }
    }

    // 4. Remaining Distance to Finish
    if (track?.finishCoordinates != null) {
      final double distMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        track!.finishCoordinates!.lat ?? 0,
        track!.finishCoordinates!.lng ?? 0,
      );
      remainingDistanceKm.value = distMeters / 1000.0;
    }

    // 5. Acceleration Sprint Detection (0-100, 100-200, 0-200, 0-300, 200-300)
    _processAccelerationTelemetry(currentSpeedKmh.value);

    // 6. Weather temperature initial fetch
    if (routePoints.isEmpty) {
      _fetchTemperature(position.latitude, position.longitude);
    }

    // 7. Route and Session Track Point Registration
    currentLocation.value = position;
    _previousPosition = position;
    _previousPositionTime = now;
    routePoints.add(newPoint);

    sessionTrackPoints.add({
      'lat': position.latitude,
      'lng': position.longitude,
      'speed': currentSpeedKmh.value.round(),
      'heading': currentHeading.value.round(),
      'altitude': position.altitude.round(),
      'timestamp': now.toIso8601String(),
    });

    // 8. Update Polyline & Vehicle Marker
    _updatePolyline();
    _updateVehicleMarker(newPoint, currentHeading.value);

    // 9. Strava-like Live Camera Auto-Follow
    if (isFollowingUser.value) {
      _updateCamera(newPoint, currentHeading.value);
    }

    // 10. Emit Live Telemetry over Socket for Real-Time Sync
    SocketApi.emit('telemetry_update', {
      'expeditionId': null,
      'lat': position.latitude,
      'lng': position.longitude,
      'speed': currentSpeedKmh.value.round(),
      'heading': currentHeading.value.round(),
      'altitude': position.altitude.round(),
      'timestamp': now.toIso8601String(),
    });

    // 11. Check Destination
    _checkDestinationReached(position);
  }

  double _calculateBearing(double startLat, double startLng, double endLat, double endLng) {
    final double dLng = (endLng - startLng) * (pi / 180.0);
    final double lat1 = startLat * (pi / 180.0);
    final double lat2 = endLat * (pi / 180.0);

    final double y = sin(dLng) * cos(lat2);
    final double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);
    final double b = (atan2(y, x) * 180.0 / pi + 360.0) % 360.0;
    return b;
  }

  void _updateVehicleMarker(LatLng position, double heading) {
    markers.removeWhere((m) => m.markerId.value == 'current_vehicle');
    markers.add(
      Marker(
        markerId: const MarkerId('current_vehicle'),
        position: position,
        rotation: heading,
        anchor: const Offset(0.5, 0.5),
        flat: true, // Rotates smoothly flat with the map plane
        icon: carMarkerIcon ??
            BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueYellow,
            ),
        zIndexInt: 10, // Always stays above route polylines
      ),
    );
  }

  void _updateCamera(LatLng target, double heading) {
    if (mapController == null) return;

    if (is3dPerspective.value) {
      // 3D Perspective Mode: Camera tilts and rotates with the car
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: target,
            zoom: 17.5,
            bearing: heading,
            tilt: 45.0,
          ),
        ),
      );
    } else {
      // 2D Navigation Mode: Centered, locked on vehicle
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: target,
            zoom: 17.0,
            bearing: 0.0,
            tilt: 0.0,
          ),
        ),
      );
    }
  }

  void recenterCamera() {
    isFollowingUser.value = true;
    if (currentLocation.value != null) {
      final LatLng pos = LatLng(
        currentLocation.value!.latitude,
        currentLocation.value!.longitude,
      );
      _updateCamera(pos, currentHeading.value);
    }
  }

  void toggle3dPerspective() {
    is3dPerspective.value = !is3dPerspective.value;
    if (currentLocation.value != null) {
      final LatLng pos = LatLng(
        currentLocation.value!.latitude,
        currentLocation.value!.longitude,
      );
      _updateCamera(pos, currentHeading.value);
    }
  }

  void toggleMapType() {
    if (mapType.value == MapType.normal) {
      mapType.value = MapType.hybrid;
    } else {
      mapType.value = MapType.normal;
    }
  }

  void zoomIn() {
    mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void zoomOut() {
    mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  void onMapPanned() {
    isFollowingUser.value = false;
  }

  void _updatePolyline() {
    polylines.clear();
    polylines.add(
      Polyline(
        polylineId: const PolylineId('active_route'),
        points: List<LatLng>.from(routePoints),
        color: AppColors.yellow,
        width: 5,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    );
  }

  void _processAccelerationTelemetry(double speed) {
    // 0-100 Sprint
    if (speed < 5.0) {
      isAccelerating0to100 = true;
      accelerationStartTime = null;
      isAccelerating0to200 = true;
      acceleration0to200StartTime = null;
      isAccelerating0to300 = true;
      acceleration0to300StartTime = null;
    } else if (speed >= 5.0 && isAccelerating0to100) {
      if (accelerationStartTime == null) {
        accelerationStartTime = DateTime.now();
        acceleration0to200StartTime = DateTime.now();
        acceleration0to300StartTime = DateTime.now();
      } else if (speed >= 100.0) {
        final duration = DateTime.now().difference(accelerationStartTime!);
        final seconds = duration.inMilliseconds / 1000.0;
        if (best0to100Time.value == 0.0 || seconds < best0to100Time.value) {
          best0to100Time.value = seconds;
        }
        isAccelerating0to100 = false;

        // Start 100-200 tracker
        isAccelerating100to200 = true;
        acceleration100to200StartTime = DateTime.now();
      }
    }

    // 0-200 Tracker
    if (speed >= 200.0 && isAccelerating0to200 && acceleration0to200StartTime != null) {
      final duration = DateTime.now().difference(acceleration0to200StartTime!);
      final seconds = duration.inMilliseconds / 1000.0;
      if (best0to200Time.value == 0.0 || seconds < best0to200Time.value) {
        best0to200Time.value = seconds;
      }
      isAccelerating0to200 = false;
    }

    // 100-200 Tracker
    if (speed >= 200.0 && isAccelerating100to200 && acceleration100to200StartTime != null) {
      final duration = DateTime.now().difference(acceleration100to200StartTime!);
      final seconds = duration.inMilliseconds / 1000.0;
      if (best100to200Time.value == 0.0 || seconds < best100to200Time.value) {
        best100to200Time.value = seconds;
      }
      isAccelerating100to200 = false;

      // Start 200-300 tracker
      isAccelerating200to300 = true;
      acceleration200to300StartTime = DateTime.now();
    }

    // 0-300 Tracker
    if (speed >= 300.0 && isAccelerating0to300 && acceleration0to300StartTime != null) {
      final duration = DateTime.now().difference(acceleration0to300StartTime!);
      final seconds = duration.inMilliseconds / 1000.0;
      if (best0to300Time.value == 0.0 || seconds < best0to300Time.value) {
        best0to300Time.value = seconds;
      }
      isAccelerating0to300 = false;
    }

    // 200-300 Tracker
    if (speed >= 300.0 && isAccelerating200to300 && acceleration200to300StartTime != null) {
      final duration = DateTime.now().difference(acceleration200to300StartTime!);
      final seconds = duration.inMilliseconds / 1000.0;
      if (best200to300Time.value == 0.0 || seconds < best200to300Time.value) {
        best200to300Time.value = seconds;
      }
      isAccelerating200to300 = false;
    }
  }

  void _checkDestinationReached(Position position) {
    if (hasReachedDestination || track?.finishCoordinates == null) return;

    final double distanceToFinish = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      track!.finishCoordinates!.lat ?? 0,
      track!.finishCoordinates!.lng ?? 0,
    );

    if (distanceToFinish < 50) {
      hasReachedDestination = true;
      _showDestinationReachedModal();
    }
  }

  void _showDestinationReachedModal() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.white10),
        ),
        title: const Text(
          "Destination Reached",
          style: TextStyle(color: AppColors.yellow, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "You have arrived at your end location.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              finishSession();
            },
            child: Text(
              "finishSession".tr,
              style: const TextStyle(
                color: AppColors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  String get formattedTime {
    final int h = elapsedSeconds.value ~/ 3600;
    final int m = (elapsedSeconds.value % 3600) ~/ 60;
    final int s = elapsedSeconds.value % 60;

    if (h > 0) {
      return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
    } else {
      return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
    }
  }

  Future<void> finishSession() async {
    isSessionActive = false;
    timer?.cancel();
    positionStream?.cancel();

    Get.dialog(
      const Center(
        child: CircularProgressIndicator(color: AppColors.yellow),
      ),
      barrierDismissible: false,
    );

    List<LatLng> snappedPoints = routePoints;
    try {
      snappedPoints = await MapSnapHelper.snapToRoads(routePoints);
    } catch (e) {
      debugPrint("Road snap error: $e");
    }

    Get.back();

    Get.offNamed(
      AppRoutes.driveSummaryScreen,
      arguments: {
        'track': track,
        'routePoints': snappedPoints,
        'detailedSessionTrack': sessionTrackPoints,
        'elapsedSeconds': elapsedSeconds.value,
        'totalDistanceKm': totalDistanceKm.value,
        'averageSpeedKmh': averageSpeedKmh.value,
        'topSpeedKmh': topSpeedKmh.value,
        'speedHistory': speedHistory,
        'best0to100Time': best0to100Time.value,
        'best0to200Time': best0to200Time.value,
        'best100to200Time': best100to200Time.value,
        'best0to300Time': best0to300Time.value,
        'best200to300Time': best200to300Time.value,
        'peakGForce': peakGForce.value,
        'temperature': currentTemperature.value,
      },
    );
  }

  void _startGForceTracking() {
    accelerometerStream = userAccelerometerEventStream().listen((
      UserAccelerometerEvent event,
    ) {
      final double gForce =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z) / 9.8;
      if (gForce > peakGForce.value) {
        peakGForce.value = gForce;
      }
    });
  }

  Future<void> _fetchTemperature(double lat, double lng) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lng&current_weather=true',
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final double tempC = data['current_weather']['temperature'];
        if (settings.isMetric.value) {
          currentTemperature.value = "${tempC.toStringAsFixed(1)} °C";
        } else {
          final double tempF = (tempC * 9 / 5) + 32;
          currentTemperature.value = "${tempF.toStringAsFixed(1)} °F";
        }
      }
    } catch (e) {
      debugPrint("Temp error: $e");
    }
  }
}


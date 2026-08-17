import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speedring/view/sereen/UserScreen/track/mode/track_model.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/view/sereen/UserScreen/Profile/controller/settings_controller.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LiveSessionController extends GetxController {
  final Track? track;
  final SettingsController settings = Get.find<SettingsController>();

  LiveSessionController({this.track});

  // Map state
  GoogleMapController? mapController;
  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Polyline> polylines = <Polyline>{}.obs;
  List<LatLng> routePoints = [];

  // Tracking state
  StreamSubscription<Position>? positionStream;
  Rx<Position?> currentLocation = Rx<Position?>(null);

  // Stats
  RxInt elapsedSeconds = 0.obs;
  RxDouble currentSpeedKmh = 0.0.obs;
  RxDouble topSpeedKmh = 0.0.obs;
  RxDouble totalDistanceKm = 0.0.obs;
  RxDouble averageSpeedKmh = 0.0.obs;
  List<double> speedHistory = [];

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

  // Sensors & API
  StreamSubscription<UserAccelerometerEvent>? accelerometerStream;
  RxDouble peakGForce = 0.0.obs;
  RxString currentTemperature = "--".obs;

  Timer? timer;
  bool isSessionActive = false;

  @override
  void onInit() {
    super.onInit();
    _setupMarkers();
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

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _setMapStyle();
    _moveCameraToStart();
  }

  void _setMapStyle() {
    if (mapController == null) return;
    const String darkStyle = '''
    [
      {
        "elementType": "geometry",
        "stylers": [
          {"color": "#111111"}
        ]
      },
      {
        "elementType": "labels.icon",
        "stylers": [
          {"visibility": "off"}
        ]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [
          {"color": "#757575"}
        ]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [
          {"color": "#212121"}
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
          {"color": "#757575"}
        ]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [
          {"color": "#181818"}
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry.fill",
        "stylers": [
          {"color": "#2c2c2c"}
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [
          {"color": "#8a8a8a"}
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
          {"color": "#3c3c3c"}
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
          {"color": "#000000"}
        ]
      }
    ]
    ''';
    // ignore: deprecated_member_use
    mapController!.setMapStyle(darkStyle);
  }

  void _setupMarkers() {
    if (track?.startCoordinates != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: LatLng(
            track!.startCoordinates!.lat ?? 0,
            track!.startCoordinates!.lng ?? 0,
          ),
          infoWindow: InfoWindow(title: 'startLocation'.tr),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
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
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  void _moveCameraToStart() {
    if (track?.startCoordinates != null && mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              track!.startCoordinates!.lat ?? 0,
              track!.startCoordinates!.lng ?? 0,
            ),
            zoom: 15,
          ),
        ),
      );
    }
  }

  Future<void> _requestLocationPermissionAndStart() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('error'.tr, 'locationServicesDisabled'.tr);
      return;
    }

    permission = await Geolocator.checkPermission();
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

    // Permissions are granted, start tracking
    _startSession();
  }

  void _startSession() {
    isSessionActive = true;

    // Start timer
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedSeconds.value++;
      if (elapsedSeconds.value > 0) {
        averageSpeedKmh.value =
            totalDistanceKm.value / (elapsedSeconds.value / 3600.0);
      }
      speedHistory.add(currentSpeedKmh.value);
    });

    _startGForceTracking();

    // Start location tracking
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2, // meters
    );

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position? position) {
            if (position != null && isSessionActive) {
              _updateTracking(position);
            }
          },
        );
  }

  void _updateTracking(Position position) {
    // Speed is in m/s -> multiply by 3.6 to get km/h
    final speed = position.speed * 3.6;
    currentSpeedKmh.value = speed;

    if (speed > topSpeedKmh.value) {
      topSpeedKmh.value = speed;
    }

    // 0-100 Acceleration Logic
    if (speed < 5.0) {
      isAccelerating0to100 = true;
      accelerationStartTime = null;
      isAccelerating0to200 = true;
      acceleration0to200StartTime = null;
    } else if (speed >= 5.0 && isAccelerating0to100) {
      if (accelerationStartTime == null) {
        accelerationStartTime = DateTime.now();
        acceleration0to200StartTime = DateTime.now();
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
    }

    LatLng newPoint = LatLng(position.latitude, position.longitude);

    if (routePoints.isEmpty) {
      _fetchTemperature(position.latitude, position.longitude);
    }

    if (currentLocation.value != null) {
      // Calculate distance between last point and current point
      double distanceInMeters = Geolocator.distanceBetween(
        currentLocation.value!.latitude,
        currentLocation.value!.longitude,
        position.latitude,
        position.longitude,
      );
      totalDistanceKm.value += (distanceInMeters / 1000);
    }

    currentLocation.value = position;
    routePoints.add(newPoint);

    _updatePolyline();

    // Auto follow camera and fit polyline bounds
    if (routePoints.length > 1) {
      double minLat = routePoints.first.latitude;
      double maxLat = routePoints.first.latitude;
      double minLng = routePoints.first.longitude;
      double maxLng = routePoints.first.longitude;

      for (var point in routePoints) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLng) minLng = point.longitude;
        if (point.longitude > maxLng) maxLng = point.longitude;
      }

      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );
      mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60.0));
    } else {
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(newPoint, 16.0));
    }

    _checkDestinationReached(position);
  }

  bool hasReachedDestination = false;

  void _checkDestinationReached(Position position) {
    if (hasReachedDestination || track?.finishCoordinates == null) return;

    double distanceToFinish = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      track!.finishCoordinates!.lat ?? 0,
      track!.finishCoordinates!.lng ?? 0,
    );

    // Assuming 50 meters as the threshold for reaching destination
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
          style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "You have arrived at your end location.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              finishSession(); // Proceed to finish
            },
            child: Text(
              "finishSession".tr,
              style: const TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _updatePolyline() {
    polylines.clear();
    polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: routePoints,
        color: Colors.yellow, // Yellow as requested
        width: 5,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    );
  }

  String get formattedTime {
    int h = elapsedSeconds.value ~/ 3600;
    int m = (elapsedSeconds.value % 3600) ~/ 60;
    int s = elapsedSeconds.value % 60;

    if (h > 0) {
      return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
    } else {
      return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
    }
  }

  void finishSession() {
    isSessionActive = false;
    timer?.cancel();
    positionStream?.cancel();

    Get.offNamed(
      AppRoutes.driveSummaryScreen,
      arguments: {
        'track': track,
        'routePoints': routePoints,
        'elapsedSeconds': elapsedSeconds.value,
        'totalDistanceKm': totalDistanceKm.value,
        'averageSpeedKmh': averageSpeedKmh.value,
        'topSpeedKmh': topSpeedKmh.value,
        'speedHistory': speedHistory,
        'best0to100Time': best0to100Time.value,
        'best0to200Time': best0to200Time.value,
        'best100to200Time': best100to200Time.value,
        'peakGForce': peakGForce.value,
        'temperature': currentTemperature.value,
      },
    );
  }

  void _startGForceTracking() {
    accelerometerStream = userAccelerometerEventStream().listen((UserAccelerometerEvent event) {
      double gForce = sqrt(event.x * event.x + event.y * event.y + event.z * event.z) / 9.8;
      if (gForce > peakGForce.value) {
        peakGForce.value = gForce;
      }
    });
  }

  Future<void> _fetchTemperature(double lat, double lng) async {
    try {
      final response = await http.get(Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=\$lat&longitude=\$lng&current_weather=true'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        double tempC = data['current_weather']['temperature'];
        if (settings.isMetric.value) {
          currentTemperature.value = "${tempC.toStringAsFixed(1)} °C";
        } else {
          // Use tempF
          double tempF = (tempC * 9 / 5) + 32;
          currentTemperature.value = "${tempF.toStringAsFixed(1)} °F";
        }
      }
    } catch (e) {
      debugPrint("Temp error: \$e");
    }
  }
}

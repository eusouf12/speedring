import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speedring/view/sereen/UserScreen/track/mode/track_model.dart';
import 'package:speedring/core/app_routes/app_routes.dart';

class LiveSessionController extends GetxController {
  final Track? track;
  
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
      markers.add(Marker(
        markerId: const MarkerId('start'),
        position: LatLng(track!.startCoordinates!.lat ?? 0, track!.startCoordinates!.lng ?? 0),
        infoWindow: InfoWindow(title: 'startLocation'.tr),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));
    }
    if (track?.finishCoordinates != null) {
      markers.add(Marker(
        markerId: const MarkerId('finish'),
        position: LatLng(track!.finishCoordinates!.lat ?? 0, track!.finishCoordinates!.lng ?? 0),
        infoWindow: InfoWindow(title: 'finishLocation'.tr),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    }
  }

  void _moveCameraToStart() {
    if (track?.startCoordinates != null && mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(track!.startCoordinates!.lat ?? 0, track!.startCoordinates!.lng ?? 0),
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
        averageSpeedKmh.value = totalDistanceKm.value / (elapsedSeconds.value / 3600.0);
      }
      speedHistory.add(currentSpeedKmh.value);
    });

    // Start location tracking
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2, // meters
    );

    positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) {
        if (position != null && isSessionActive) {
          _updateTracking(position);
        }
      }
    );
  }

  void _updateTracking(Position position) {
    // Speed is in m/s -> multiply by 3.6 to get km/h
    currentSpeedKmh.value = position.speed * 3.6;
    
    if (currentSpeedKmh.value > topSpeedKmh.value) {
      topSpeedKmh.value = currentSpeedKmh.value;
    }

    LatLng newPoint = LatLng(position.latitude, position.longitude);
    
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
    
    // Auto follow camera
    mapController?.animateCamera(
      CameraUpdate.newLatLng(newPoint)
    );

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
              style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
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
      )
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
    
    Get.offNamed(AppRoutes.driveSummaryScreen, arguments: {
      'track': track,
      'routePoints': routePoints,
      'elapsedSeconds': elapsedSeconds.value,
      'totalDistanceKm': totalDistanceKm.value,
      'averageSpeedKmh': averageSpeedKmh.value,
      'topSpeedKmh': topSpeedKmh.value,
      'speedHistory': speedHistory,
    });
  }
}

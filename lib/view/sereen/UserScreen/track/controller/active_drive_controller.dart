import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speedring/view/sereen/UserScreen/track/mode/expedition_model.dart';
import 'package:speedring/service/socket_service.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/utils/app_const/app_const.dart';
import 'package:speedring/view/sereen/UserScreen/Profile/controller/profile_controller.dart';
import 'package:speedring/view/sereen/UserScreen/Profile/controller/settings_controller.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

import '../../../../../core/app_routes/app_routes.dart';
import '../../../../../helper/shared_prefe/shared_prefe.dart';

class ActiveDriveController extends GetxController {
  Expedition? drive;
  bool isHost = false;

  // Map state
  GoogleMapController? mapController;
  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Polyline> polylines = <Polyline>{}.obs;
  List<LatLng> routePoints = <LatLng>[];

  // Tracking state
  StreamSubscription<Position>? positionStream;
  Rx<Position?> currentLocation = Rx<Position?>(null);

  // Live stats
  RxDouble currentSpeedKmh = 0.0.obs;
  RxDouble totalDistanceKm = 0.0.obs;
  RxInt elapsedSeconds = 0.obs;
  Timer? statsTimer;
  RxBool isTrackingPaused = false.obs;

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

  RxDouble topSpeedKmh = 0.0.obs;

  final ProfileScreenController profileController =
      Get.find<ProfileScreenController>();
  final SettingsController settings = Get.find<SettingsController>();

  @override
  void onInit() {
    super.onInit();
    drive = Get.arguments as Expedition?;
    if (drive != null) {
      final currentUserId = profileController.profileData.value?.id;
      isHost = drive!.host?.id == currentUserId;

      // Initialize Socket connection
      _setupSocket();

      // Setup initial map markers
      _setupInitialMarkers();

      // Start tracking OR listening is no longer conditional - EVERYONE tracks and listens
      _requestPermissionAndStartTracking();
      _listenToLiveTelemetry();
      _startGForceTracking();

      // Start elapsed timer
      _startElapsedTimer();
    }
  }

  @override
  void onClose() {
    positionStream?.cancel();
    statsTimer?.cancel();
    accelerometerStream?.cancel();
    mapController?.dispose();
    SocketApi.off('live_telemetry_feed');
    SocketApi.off('expedition_ended');
    super.onClose();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _setMapStyle();
    if (drive?.meetingPoint != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              drive!.meetingPoint!.lat ?? 0.0,
              drive!.meetingPoint!.lng ?? 0.0,
            ),
            zoom: 15,
          ),
        ),
      );
    }
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

  Future<void> _setupSocket() async {
    final token = await SharePrefsHelper.getString(AppConstants.bearerToken);
    final currentUserId = profileController.profileData.value?.id ?? "unknown";
    SocketApi.init(ApiUrl.socketUrl, currentUserId, token: token);
    SocketApi.emit('join_expedition_room', drive!.id);

    SocketApi.on('expedition_ended', (data) {
      Get.snackbar(
        "tripEnded".tr.tr == "tripEnded" ? "Trip Ended" : "tripEnded".tr,
        "hostEndedTrip".tr.tr == "hostEndedTrip"
            ? "The host has ended this trip."
            : "hostEndedTrip".tr,
      );
      Get.delete<ActiveDriveController>();
      Get.offAllNamed(AppRoutes.userHomeScreen);
    });
  }

  void _setupInitialMarkers() {
    if (drive?.meetingPoint != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('meeting_point'),
          position: LatLng(
            drive!.meetingPoint!.lat ?? 0.0,
            drive!.meetingPoint!.lng ?? 0.0,
          ),
          infoWindow: InfoWindow(title: 'meetingPoint'.tr),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );
    }
  }

  Future<void> _requestPermissionAndStartTracking() async {
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

    // Start tracking location
    const LocationSettings settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2,
    );

    positionStream = Geolocator.getPositionStream(locationSettings: settings)
        .listen((Position position) {
          if (!isTrackingPaused.value) {
            _updateMyTelemetry(position);
          }
        });
  }

  void _updateMyTelemetry(Position position) {
    currentLocation.value = position;

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
    if (speed >= 200.0 &&
        isAccelerating0to200 &&
        acceleration0to200StartTime != null) {
      final duration = DateTime.now().difference(acceleration0to200StartTime!);
      final seconds = duration.inMilliseconds / 1000.0;
      if (best0to200Time.value == 0.0 || seconds < best0to200Time.value) {
        best0to200Time.value = seconds;
      }
      isAccelerating0to200 = false;
    }

    // 100-200 Tracker
    if (speed >= 200.0 &&
        isAccelerating100to200 &&
        acceleration100to200StartTime != null) {
      final duration = DateTime.now().difference(
        acceleration100to200StartTime!,
      );
      final seconds = duration.inMilliseconds / 1000.0;
      if (best100to200Time.value == 0.0 || seconds < best100to200Time.value) {
        best100to200Time.value = seconds;
      }
      isAccelerating100to200 = false;
    }

    final LatLng newPoint = LatLng(position.latitude, position.longitude);

    if (routePoints.isEmpty) {
      _fetchTemperature(position.latitude, position.longitude);
    }
    if (routePoints.isNotEmpty) {
      final double distance = Geolocator.distanceBetween(
        routePoints.last.latitude,
        routePoints.last.longitude,
        position.latitude,
        position.longitude,
      );
      totalDistanceKm.value += (distance / 1000);
    }

    routePoints.add(newPoint);
    _updatePolyline();

    // Update my driver marker position with my profile pic icon
    final currentUserId = profileController.profileData.value?.id ?? 'my_id';
    final currentUserName = profileController.profileData.value?.name ?? 'Me';
    final currentUserPic = profileController.profileData.value?.profileImage;
    _updateDriverMarker(
      newPoint,
      currentUserPic,
      currentUserId,
      currentUserName,
    );

    // Auto pan map and fit polyline bounds
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

    // Check if reached destination
    _checkDestinationReached(position);

    // Send telemetry to viewers via socket
    SocketApi.emit('telemetry_update', {
      'expeditionId': drive!.id,
      'lat': position.latitude,
      'lng': position.longitude,
      'speed': (position.speed * 3.6).toInt(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void _listenToLiveTelemetry() {
    SocketApi.on('live_telemetry_feed', (data) {
      if (data == null) return;
      final String senderId = data['senderId']?.toString() ?? '';

      // Ignore if it's my own echo
      final myId = profileController.profileData.value?.id;
      if (senderId == myId) return;

      final double lat = (data['lat'] as num).toDouble();
      final double lng = (data['lng'] as num).toDouble();
      final LatLng newPoint = LatLng(lat, lng);

      // Find the participant's profile info
      String? profilePicUrl;
      String title = 'Member';

      if (drive?.host?.id == senderId) {
        profilePicUrl = drive!.host!.profileImage;
        title = drive!.host!.name ?? 'Host';
      } else if (drive?.participants != null) {
        try {
          final participant = drive!.participants!.firstWhere(
            (p) => p.id == senderId,
          );
          profilePicUrl = participant.profileImage;
          title = participant.name ?? 'Member';
        } catch (e) {
          // not found
        }
      }

      // Update THEIR marker on the map
      _updateDriverMarker(newPoint, profilePicUrl, senderId, title);
    });
  }

  void _updatePolyline() {
    polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: routePoints,
        color: AppColors.yellow,
        width: 4,
      ),
    );
  }

  bool hasReachedDestination = false;

  void _checkDestinationReached(Position position) {
    if (hasReachedDestination || drive?.meetingPoint == null) return;

    double distanceToFinish = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      drive!.meetingPoint!.lat ?? 0,
      drive!.meetingPoint!.lng ?? 0,
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
          style: TextStyle(
            color: AppColors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "You have arrived at the meeting point.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              if (isHost) {
                Get.toNamed(AppRoutes.endExpeditionScreen, arguments: drive);
              }
            },
            child: Text(
              isHost ? "endTrip".tr : "okay".tr,
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

  Future<void> _updateDriverMarker(
    LatLng position,
    String? profilePicUrl,
    String markerId,
    String title,
  ) async {
    BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueYellow,
    );

    if (profilePicUrl != null && profilePicUrl.isNotEmpty) {
      String fullUrl = profilePicUrl;
      if (!fullUrl.startsWith("http")) {
        fullUrl = "${ApiUrl.imageUrl}/$fullUrl";
      }
      markerIcon = await _getCircularMarkerIcon(fullUrl, const Size(80, 80));
    }

    markers.removeWhere((m) => m.markerId.value == markerId);

    // Make my own marker appear on top of others
    final bool isMe = markerId == profileController.profileData.value?.id;

    markers.add(
      Marker(
        markerId: MarkerId(markerId),
        position: position,
        icon: markerIcon,
        infoWindow: InfoWindow(title: title),
        zIndexInt: isMe ? 10 : 1,
      ),
    );
  }

  Future<BitmapDescriptor> _getCircularMarkerIcon(String url, Size size) async {
    try {
      final http.Response response = await http.get(Uri.parse(url));
      final ui.Codec codec = await ui.instantiateImageCodec(
        response.bodyBytes,
        targetWidth: size.width.toInt(),
        targetHeight: size.height.toInt(),
      );
      final ui.FrameInfo fi = await codec.getNextFrame();
      final ui.Image image = fi.image;

      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      final double radius = size.width / 2;

      // Draw yellow border circle
      final Paint borderPaint = Paint()
        ..color = AppColors.yellow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0;
      canvas.drawCircle(Offset(radius, radius), radius - 2.0, borderPaint);

      // Clip path for circular avatar
      final Path clipPath = Path()
        ..addOval(
          Rect.fromCircle(center: Offset(radius, radius), radius: radius - 4.0),
        );
      canvas.clipPath(clipPath);

      // Draw the profile image
      canvas.drawImage(image, Offset.zero, Paint());

      final ui.Image markerImage = await pictureRecorder.endRecording().toImage(
        size.width.toInt(),
        size.height.toInt(),
      );
      final ByteData? byteData = await markerImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData != null) {
        return BitmapDescriptor.bytes(byteData.buffer.asUint8List());
      }
    } catch (e) {
      debugPrint("Error loading profile marker icon: $e");
    }
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
  }

  void _startElapsedTimer() {
    statsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isTrackingPaused.value) {
        elapsedSeconds.value++;
      }
    });
  }

  void toggleTrackingPause() {
    isTrackingPaused.value = !isTrackingPaused.value;
  }

  String getFormattedDuration() {
    final int sec = elapsedSeconds.value;
    final int hours = sec ~/ 3600;
    final int minutes = (sec % 3600) ~/ 60;
    final int seconds = sec % 60;

    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
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
      final response = await http.get(Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lng&current_weather=true'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        double tempC = data['current_weather']['temperature'];
        if (settings.isMetric.value) {
          currentTemperature.value = "${tempC.toStringAsFixed(1)} °C";
        } else {
          double tempF = (tempC * 9/5) + 32;
          currentTemperature.value = "${tempF.toStringAsFixed(1)} °F";
        }
      }
    } catch (e) {
      debugPrint("Temp error: $e");
    }
  }
}

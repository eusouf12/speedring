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
import 'package:speedring/helper/shared_prefe/shared_prefe.dart';
import 'package:speedring/view/sereen/UserScreen/Profile/controller/profile_controller.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

import '../../../../../core/app_routes/app_routes.dart';

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

  final ProfileScreenController profileController =
      Get.find<ProfileScreenController>();

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

      // Start tracking or listening
      if (isHost) {
        _requestPermissionAndStartTracking();
      } else {
        _listenToLiveTelemetry();
      }

      // Start elapsed timer
      _startElapsedTimer();
    }
  }

  @override
  void onClose() {
    positionStream?.cancel();
    statsTimer?.cancel();
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
            _updateHostTelemetry(position);
          }
        });
  }

  void _updateHostTelemetry(Position position) {
    currentLocation.value = position;
    currentSpeedKmh.value = position.speed * 3.6;

    final LatLng newPoint = LatLng(position.latitude, position.longitude);
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

    // Update driver/host marker position with custom profile pic icon
    _updateDriverMarker(newPoint, drive!.host?.profileImage);

    // Auto pan map
    mapController?.animateCamera(CameraUpdate.newLatLng(newPoint));

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
      final double lat = (data['lat'] as num).toDouble();
      final double lng = (data['lng'] as num).toDouble();
      final double speed = (data['speed'] as num).toDouble();

      currentSpeedKmh.value = speed;
      final LatLng newPoint = LatLng(lat, lng);

      if (routePoints.isNotEmpty) {
        final double distance = Geolocator.distanceBetween(
          routePoints.last.latitude,
          routePoints.last.longitude,
          lat,
          lng,
        );
        totalDistanceKm.value += (distance / 1000);
      }

      routePoints.add(newPoint);
      _updatePolyline();

      // Update marker
      _updateDriverMarker(newPoint, drive!.host?.profileImage);

      // Auto pan map
      mapController?.animateCamera(CameraUpdate.newLatLng(newPoint));
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

  Future<void> _updateDriverMarker(
    LatLng position,
    String? profilePicUrl,
  ) async {
    BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueYellow,
    );

    if (profilePicUrl != null && profilePicUrl.isNotEmpty) {
      String fullUrl = profilePicUrl;
      if (!fullUrl.startsWith("http")) {
        fullUrl = "${ApiUrl.imageUrl}/$fullUrl";
      }
      markerIcon = await _getCircularMarkerIcon(fullUrl, const Size(120, 120));
    }

    markers.removeWhere((m) => m.markerId.value == 'driver_node');
    markers.add(
      Marker(
        markerId: const MarkerId('driver_node'),
        position: position,
        icon: markerIcon,
        infoWindow: InfoWindow(title: drive!.host?.name ?? 'driver'.tr),
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
}

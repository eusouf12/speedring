import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng _currentLocation = const LatLng(23.8103, 90.4125); // Default to Dhaka
  bool _isLoading = true;
  String _currentAddress = "Loading address...";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _finishLoading();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _finishLoading();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _finishLoading();
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
      await _getAddressFromLatLng(_currentLocation);
      
      if (_mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newLatLng(_currentLocation));
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
    } finally {
      _finishLoading();
    }
  }

  void _finishLoading() {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
              "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}"
                  .replaceAll(RegExp(r'^,\s*|,\s*$'), '')
                  .replaceAll(RegExp(r',\s*,'), ',');
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = "Unknown location";
      });
      debugPrint("Error getting address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: CustomText(
          text: 'Select Location',
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            )
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation,
                    zoom: 15,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  onCameraMove: (position) {
                    _currentLocation = position.target;
                  },
                  onCameraIdle: () {
                    _getAddressFromLatLng(_currentLocation);
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40), // Adjust for pin bottom
                    child: Icon(
                      Icons.location_pin,
                      size: 40.r,
                      color: AppColors.yellow,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Selected Address:',
                          color: Colors.white54,
                          fontSize: 12.sp,
                        ),
                        SizedBox(height: 8.h),
                        CustomText(
                          text: _currentAddress,
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.start,
                          maxLines: 2,
                        ),
                        SizedBox(height: 20.h),
                        CustomButton(
                          width: double.infinity,
                          height: 46.h,
                          onTap: () {
                            Get.back(result: _currentAddress);
                          },
                          title: 'Confirm Location',
                          fontSize: 14.sp,
                          fillColor: AppColors.yellow,
                          textColor: Colors.black,
                          borderRadius: 24.r,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/service/api_url.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../mode/track_model.dart';
import '../../Profile/model/profile_model.dart';

class TrackController extends GetxController {
  RxList<Track> tracks = <Track>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;
  
  // Prepare Session State
  RxBool recordLaps = false.obs;
  Rxn<Track> selectedTrack = Rxn<Track>();
  Rxn<Vehicle> selectedVehicle = Rxn<Vehicle>();

  int page = 1;
  int limit = 10;
  bool hasNextPage = true;

  RxString selectedFilter = "ALL TRACKS".obs;
  RxString searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    getAllTracks(refresh: true);
  }

  Timer? _debounce;

  void changeFilter(String filter) {
    if (selectedFilter.value == filter) return;
    selectedFilter.value = filter;
    getAllTracks(refresh: true);
  }

  void searchTracks(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchQuery.value = query;
      getAllTracks(refresh: true);
    });
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Location services are disabled. Please enable them to find nearby tracks.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
        return null;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: 'Location permissions are permanently denied, we cannot request permissions.');
      return null;
    } 

    return await Geolocator.getCurrentPosition();
  }

  Future<void> getAllTracks({bool refresh = false}) async {
    if (refresh) {
      page = 1;
      hasNextPage = true;
      tracks.clear();
      isLoading.value = true;
    } else {
      if (!hasNextPage || isLoadMore.value) return;
      isLoadMore.value = true;
    }

    try {
      double? lat;
      double? lng;

      if (selectedFilter.value == "NEARBY") {
        Position? position = await _determinePosition();
        if (position != null) {
          lat = position.latitude;
          lng = position.longitude;
        } else {
          isLoading.value = false;
          isLoadMore.value = false;
          return;
        }
      }

      String url = ApiUrl.getAllTracks(
        page: page,
        limit: limit,
        searchTerm: searchQuery.value.isEmpty ? null : searchQuery.value,
        lat: lat,
        lng: lng,
      );

      var response = await ApiClient.getData(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        TracksResponse trackResponse = TracksResponse.fromJson(response.body);
        if (trackResponse.data != null) {
          if (refresh) {
            tracks.assignAll(trackResponse.data!);
          } else {
            tracks.addAll(trackResponse.data!);
          }
          if (trackResponse.meta != null) {
            hasNextPage = trackResponse.meta!.page! < trackResponse.meta!.totalPage!;
            if (hasNextPage) page++;
          } else {
            hasNextPage = false;
          }
        }
      } else {
        Fluttertoast.showToast(msg: response.statusText ?? "Failed to load tracks");
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
    }
  }

  void toggleRecordLaps(bool value) {
    recordLaps.value = value;
  }

  void setTrack(Track? track) {
    selectedTrack.value = track;
  }

  void setVehicle(Vehicle? vehicle) {
    selectedVehicle.value = vehicle;
  }

  void resetPrepareSessionState() {
    selectedTrack.value = null;
    selectedVehicle.value = null;
    recordLaps.value = false;
  }
}

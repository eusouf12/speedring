import 'dart:async';
import 'dart:convert';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../mode/track_model.dart';
import '../../Profile/model/profile_model.dart';
import '../mode/session-stats_model.dart';
import 'package:speedring/view/sereen/UserScreen/track/mode/expedition_model.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
    getMySessionStats();
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
      Fluttertoast.showToast(
        msg:
            'Location services are disabled. Please enable them to find nearby tracks.',
      );
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
      Fluttertoast.showToast(
        msg:
            'Location permissions are permanently denied, we cannot request permissions.',
      );
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
            hasNextPage =
                trackResponse.meta!.page! < trackResponse.meta!.totalPage!;
            if (hasNextPage) page++;
          } else {
            hasNextPage = false;
          }
        }
      } else {
        Fluttertoast.showToast(
          msg: response.statusText ?? "Failed to load tracks",
        );
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

  //======================= My Session======================================
  RxList<dynamic> mySessionsList = <dynamic>[].obs;
  RxBool isLoadingSessions = false.obs;
  RxBool isCreatingSession = false.obs;

  Future<bool> createSession(Map<String, dynamic> sessionData) async {
    isCreatingSession.value = true;
    try {
      var response = await ApiClient.postData(ApiUrl.createSession, jsonEncode(sessionData));
      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(msg: "sessionCreated".tr);
        return true;
      } else {
        Fluttertoast.showToast(msg: response.statusText ?? "error".tr);
        return false;
      }
    } catch (e) {
      debugPrint("Error creating session: $e");
      return false;
    } finally {
      isCreatingSession.value = false;
    }
  }

  Rxn<DriveSessionStatsData> sessionStats = Rxn<DriveSessionStatsData>();
  RxBool isLoadingStats = false.obs;

  Future<void> getMySessionStats() async {
    isLoadingStats.value = true;
    try {
      var response = await ApiClient.getData(ApiUrl.getMySessionStats);
      if (response.statusCode == 200 || response.statusCode == 201) {
        DriveSessionStatsResponse statsResponse = DriveSessionStatsResponse.fromJson(response.body);
        sessionStats.value = statsResponse.data;
      }
    } catch (e) {
      debugPrint("Error fetching session stats: $e");
    } finally {
      isLoadingStats.value = false;
    }
  }

  Future<void> getMySessions() async {
    isLoadingSessions.value = true;
    try {
      var response = await ApiClient.getData(ApiUrl.mySessions);
      if (response.statusCode == 200) {
        mySessionsList.value = response.body["data"] ?? [];
      }
    } catch (e) {
      debugPrint("Error fetching my sessions: $e");
    } finally {
      isLoadingSessions.value = false;
    }
  }

  Future<void> deleteSession(String id) async {
    try {
      var response = await ApiClient.deleteData(ApiUrl.deleteSession(id));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "sessionDeleted".tr);
        mySessionsList.removeWhere((session) => session["_id"] == id || session["id"] == id);
      } else {
        Fluttertoast.showToast(msg: response.statusText ?? "error".tr);
      }
    } catch (e) {
      debugPrint("Error deleting session: $e");
    }
  }

  //==================== Group Track (Expeditions)==========================
  RxList<Expedition> expeditions = <Expedition>[].obs;
  RxBool isLoadingExpeditions = false.obs;
  RxBool isCreatingExpedition = false.obs;
  
  int expeditionPage = 1;
  bool hasNextExpeditionPage = true;

  Future<void> getAllExpeditions({bool refresh = false, String type = "upcoming"}) async {
    if (refresh) {
      expeditionPage = 1;
      hasNextExpeditionPage = true;
      expeditions.clear();
      isLoadingExpeditions.value = true;
    } else {
      if (!hasNextExpeditionPage) return;
    }

    try {
      String url = ApiUrl.getAllExpeditions(page: expeditionPage, limit: 10, type: type);
      var response = await ApiClient.getData(url);
      
      if (response.statusCode == 200) {
        ExpeditionResponse expResponse = ExpeditionResponse.fromJson(response.body);
        if (expResponse.data != null) {
          if (refresh) {
            expeditions.assignAll(expResponse.data!);
          } else {
            expeditions.addAll(expResponse.data!);
          }
          if (expResponse.meta != null) {
            hasNextExpeditionPage = expResponse.meta!.page! < expResponse.meta!.totalPage!;
            if (hasNextExpeditionPage) expeditionPage++;
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching expeditions: $e");
    } finally {
      isLoadingExpeditions.value = false;
    }
  }

  Future<Expedition?> createExpedition(Map<String, dynamic> data, String? imagePath) async {
    isCreatingExpedition.value = true;
    try {
      var request = await ApiClient.postMultipartData(
        ApiUrl.createExpedition, 
        {"data": jsonEncode(data)}, 
        multipartBody: imagePath != null ? [MultipartBody("coverImage", File(imagePath))] : []
      );
      if (request.statusCode == 200 || request.statusCode == 201) {
        Expedition? createdExpedition;
        try {
          final resData = jsonDecode(request.body!);
          showCustomSnackBar(resData['message'] ?? "expeditionCreated".tr, isError: false);
          if (resData['data'] != null) {
            createdExpedition = Expedition.fromJson(resData['data']);
          }
        } catch (_) {
          showCustomSnackBar("expeditionCreated".tr, isError: false);
        }
        getAllExpeditions(refresh: true);
        return createdExpedition;
      } else {
        try {
          final resData = jsonDecode(request.body!);
          showCustomSnackBar(resData['message'] ?? "error".tr, isError: true);
        } catch (_) {
          showCustomSnackBar("error".tr, isError: true);
        }
        return null;
      }
    } catch (e) {
      debugPrint("Error creating expedition: $e");
      return null;
    } finally {
      isCreatingExpedition.value = false;
    }
  }

  Future<void> joinExpedition(String id) async {
    try {
      var response = await ApiClient.postData(ApiUrl.joinExpedition(id), "{}");
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "joinedSuccessfully".tr);
        // Refresh
        int index = expeditions.indexWhere((e) => e.id == id);
        if (index != -1) {
          getAllExpeditions(refresh: true);
        }
      } else {
        Fluttertoast.showToast(msg: response.body["message"] ?? "error".tr);
      }
    } catch (e) {
      debugPrint("Error joining expedition: $e");
    }
  }

  Future<void> startExpedition(String id) async {
    try {
      var response = await ApiClient.patchData(ApiUrl.startExpedition(id), "{}");
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "expeditionStarted".tr);
        getAllExpeditions(refresh: true);
      } else {
        Fluttertoast.showToast(msg: response.body["message"] ?? "error".tr);
      }
    } catch (e) {
      debugPrint("Error starting expedition: $e");
    }
  }

  Future<void> updateExpedition(String id, Map<String, dynamic> data, String? imagePath) async {
    isCreatingExpedition.value = true;
    try {
      var request = await ApiClient.patchMultipartData(
        ApiUrl.updateExpedition(id), 
        {"data": jsonEncode(data)}, 
        multipartBody: imagePath != null ? [MultipartBody("coverImage", File(imagePath))] : []
      );
      if (request.statusCode == 200) {
        try {
          final resData = jsonDecode(request.body!);
          showCustomSnackBar(resData['message'] ?? "expeditionUpdated".tr, isError: false);
        } catch (_) {
          showCustomSnackBar("expeditionUpdated".tr, isError: false);
        }
        getAllExpeditions(refresh: true);
        fetchSingleExpedition(id);
        Get.back();
      } else {
        try {
          final resData = jsonDecode(request.body!);
          showCustomSnackBar(resData['message'] ?? "error".tr, isError: true);
        } catch (_) {
          showCustomSnackBar("error".tr, isError: true);
        }
      }
    } catch (e) {
      debugPrint("Error updating expedition: $e");
    } finally {
      isCreatingExpedition.value = false;
    }
  }

  Future<void> deleteExpedition(String id) async {
    try {
      var response = await ApiClient.deleteData(ApiUrl.deleteExpedition(id));
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "expeditionDeleted".tr);
        getAllExpeditions(refresh: true);
      } else {
        Fluttertoast.showToast(msg: "error".tr);
      }
    } catch (e) {
      debugPrint("Error deleting expedition: $e");
    }
  }

  // ─── Google Maps Geocoding ───
  Future<void> fetchLatLngFromAddress(String address) async {
    try {
      final query = Uri.encodeComponent(address);
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?address=$query&key=${ApiUrl.mapKey}';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final location = data['results'][0]['geometry']['location'];
          meetingPointLat.value = location['lat']?.toDouble() ?? 0.0;
          meetingPointLng.value = location['lng']?.toDouble() ?? 0.0;
        }
      }
    } catch (e) {
      debugPrint("GEOCODING API ERROR: $e");
    }
  }

  Future<Iterable<String>> fetchPlaceSuggestions(String query) async {
    if (query.isEmpty) return const Iterable<String>.empty();
    try {
      final q = Uri.encodeComponent(query);
      final url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$q&key=${ApiUrl.mapKey}';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List;
          return predictions.map((p) => p['description'].toString()).toList();
        }
      }
    } catch (e) {
      debugPrint("PLACES API ERROR: $e");
    }
    return const Iterable<String>.empty();
  }

  // --- Lobby State ---
  Rx<Expedition?> currentLobbyExpedition = Rx<Expedition?>(null);
  RxBool isLoadingLobby = false.obs;
  RxList<Host> lobbyParticipants = <Host>[].obs;

  Future<void> fetchSingleExpedition(String id) async {
    isLoadingLobby.value = true;
    try {
      var response = await ApiClient.getData(ApiUrl.getSingleExpedition(id));
      if (response.statusCode == 200) {
        currentLobbyExpedition.value = Expedition.fromJson(response.body['data']);
        if (currentLobbyExpedition.value?.participants != null) {
          lobbyParticipants.assignAll(currentLobbyExpedition.value!.participants!);
        }
      }
    } catch (e) {
      debugPrint("Error fetching single expedition: $e");
    } finally {
      isLoadingLobby.value = false;
    }
  }

  Future<void> startExpeditionTrip(String id) async {
    try {
      var response = await ApiClient.patchData(ApiUrl.startExpedition(id), "{}");
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Expedition Started!");
        fetchSingleExpedition(id);
      } else {
        Fluttertoast.showToast(msg: response.body['message'] ?? "error".tr);
      }
    } catch (e) {
      debugPrint("Error starting expedition: $e");
    }
  }
  
  // Trip Configurator State
  final TextEditingController nameController = TextEditingController();
  final TextEditingController objectiveController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController meetingPointController = TextEditingController();
  RxDouble meetingPointLat = 0.0.obs;
  RxDouble meetingPointLng = 0.0.obs;

  RxDouble maxParticipants = 12.0.obs;
  RxString selectedVehicleClass = "Cars".obs;
  RxBool publicDeployment = true.obs;
  RxString coverImagePath = "".obs;

  Expedition? editingDrive;

  void populateConfiguratorData(Expedition? drive) {
    editingDrive = drive;
    if (editingDrive == null) {
      nameController.clear();
      objectiveController.clear();
      dateController.clear();
      timeController.clear();
      meetingPointController.clear();
      meetingPointLat.value = 0.0;
      meetingPointLng.value = 0.0;
      maxParticipants.value = 12.0;
      selectedVehicleClass.value = "Cars";
      publicDeployment.value = true;
      coverImagePath.value = "";
      selectedTrack.value = null;
      return;
    }
    
    nameController.text = editingDrive!.tripName ?? "";
    objectiveController.text = editingDrive!.objective ?? "";
    
    if (editingDrive!.deploymentDate != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(editingDrive!.deploymentDate!.toLocal());
    }
    timeController.text = editingDrive!.startTime ?? "";
    meetingPointController.text = editingDrive!.meetingPoint?.address ?? "";
    meetingPointLat.value = editingDrive!.meetingPoint?.lat ?? 0.0;
    meetingPointLng.value = editingDrive!.meetingPoint?.lng ?? 0.0;
    maxParticipants.value = (editingDrive!.maxParticipants ?? 12).toDouble();
    selectedVehicleClass.value = editingDrive!.vehicleClass ?? "Cars";
    publicDeployment.value = editingDrive!.privacy == "Public";

    if (editingDrive!.routeTrack != null) {
      if (editingDrive!.routeTrack is Map<String, dynamic>) {
        selectedTrack.value = Track.fromJson(editingDrive!.routeTrack as Map<String, dynamic>);
      } else if (editingDrive!.routeTrack is String) {
        Track? found;
        for (var t in tracks) {
          if (t.id == editingDrive!.routeTrack) {
            found = t;
            break;
          }
        }
        selectedTrack.value = found ?? Track(id: editingDrive!.routeTrack as String);
      }
    } else {
      selectedTrack.value = null;
    }
  }

  Future<void> pickConfiguratorImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      coverImagePath.value = image.path;
    }
  }

  Future<void> saveConfiguredTrip() async {
    String isoDeploymentDate = "";
    try {
      if (dateController.text.isNotEmpty && timeController.text.isNotEmpty) {
        DateTime localDateTime = DateFormat("yyyy-MM-dd hh:mm a")
            .parse("${dateController.text} ${timeController.text}");
        isoDeploymentDate = localDateTime.toUtc().toIso8601String();
      }
    } catch (e) {
      debugPrint("Error parsing date/time: $e");
      isoDeploymentDate = dateController.text;
    }

    Map<String, dynamic> data = {
      "tripName": nameController.text,
      "objective": objectiveController.text,
      "deploymentDate": isoDeploymentDate,
      "startTime": timeController.text,
      "meetingPoint": {
        "address": meetingPointController.text,
        "lat": meetingPointLat.value,
        "lng": meetingPointLng.value
      },
      "maxParticipants": maxParticipants.value.toInt(),
      "vehicleClass": selectedVehicleClass.value,
      "privacy": publicDeployment.value ? "Public" : "Private",
    };

    if (selectedTrack.value != null) {
      data["routeTrack"] = selectedTrack.value!.id;
    }

    if (editingDrive != null) {
      await updateExpedition(
        editingDrive!.id!, 
        data, 
        coverImagePath.value.isNotEmpty ? coverImagePath.value : null
      );
    } else {
      Expedition? newExp = await createExpedition(
        data, 
        coverImagePath.value.isNotEmpty ? coverImagePath.value : null
      );
      if (newExp != null) {
        Get.back();
        Get.toNamed(AppRoutes.tripLobbyScreen, arguments: newExp);
      }
    }
  }
}

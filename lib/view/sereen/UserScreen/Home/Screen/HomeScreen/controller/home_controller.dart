import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import 'package:speedring/utils/app_const/app_const.dart';
import '../../../../../../../helper/shared_prefe/shared_prefe.dart';
import '../model/story_model.dart';

class HomeController extends GetxController {
  final rxActiveTab = 0.obs; // 0: ALL, 1: EVENTS, 2: CLUBS
  void changeTab(int index) => rxActiveTab.value = index;

  // ---Create  Story Creation -------------------------------
  final Rxn<File> selectedFile = Rxn<File>();
  final RxBool isVideo = false.obs;
  final RxBool isStoryCreating = false.obs;
  final ImagePicker _picker = ImagePicker();

  bool _isPickingMedia = false;

  Future<void> pickMedia({required bool isVideoVal}) async {
    if (_isPickingMedia) return;
    _isPickingMedia = true;

    try {
      final XFile? picked = isVideoVal
          ? await _picker.pickVideo(source: ImageSource.gallery)
          : await _picker.pickImage(source: ImageSource.gallery);

      if (picked != null) {
        selectedFile.value = File(picked.path);
        isVideo.value = isVideoVal;
      }
    } catch (e) {
      debugPrint("Error picking media: $e");
    } finally {
      _isPickingMedia = false;
    }
  }

  void resetStory() {
    selectedFile.value = null;
    isVideo.value = false;
    selectedMusic.value = null;
    selectedLocation.value = null;
  }

  // --- Story Enhancements ---
  final RxnString selectedMusic = RxnString();
  final RxnString selectedLocation = RxnString();

  Future<void> createStory() async {
    if (selectedFile.value == null) return;
    isStoryCreating.value = true;

    try {
      Map<String, dynamic> dataMap = {};

      if (selectedLocation.value != null &&
          selectedLocation.value!.isNotEmpty) {
        dataMap["location"] = {"name": selectedLocation.value};
      }

      if (selectedMusic.value != null && selectedMusic.value!.isNotEmpty) {
        dataMap["music"] = {"name": selectedMusic.value};
      }

      Map<String, String> body = {};
      if (dataMap.isNotEmpty) {
        body['data'] = jsonEncode(dataMap);
      }

      final response = await ApiClient.postMultipartData(
        ApiUrl.createStory,
        body,
        multipartBody: [MultipartBody('media', selectedFile.value!)],
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Story created successfully!", isError: false);
        resetStory();
        getStories(); // refresh the story list automatically
        Get.back(); // close the create story screen
      } else {
        showCustomSnackBar("Failed to create story", isError: true);
      }
    } catch (e) {
      showCustomSnackBar("An error occurred: $e");
    } finally {
      isStoryCreating.value = false;
    }
  }

  // --- Search State & Methods ---
  final RxList<Map<String, String>> musicList = <Map<String, String>>[].obs;
  final RxBool isSearchingMusic = false.obs;

  final RxList<String> locationList = <String>[].obs;
  final RxBool isSearchingLocation = false.obs;

  Timer? _debounce;

  void searchMusic(String query) {
    if (query.isEmpty) {
      musicList.clear();
      return;
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      isSearchingMusic.value = true;
      try {
        final url = Uri.parse(
          'https://itunes.apple.com/search?term=$query&entity=song&limit=15',
        );
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List results = data['results'] ?? [];
          musicList.value = results.map((item) {
            return {
              "title": item['trackName']?.toString() ?? "Unknown Title",
              "artist": item['artistName']?.toString() ?? "Unknown Artist",
              "previewUrl": item['previewUrl']?.toString() ?? "",
            };
          }).toList();
        }
      } catch (e) {
        debugPrint("Error searching music: $e");
      } finally {
        isSearchingMusic.value = false;
      }
    });
  }

  void searchLocation(String query) {
    if (query.isEmpty) {
      locationList.clear();
      return;
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      isSearchingLocation.value = true;
      try {
        final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=${ApiUrl.mapKey}',
        );
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'OK') {
            final List predictions = data['predictions'] ?? [];
            locationList.value = predictions.map((item) {
              return item['description']?.toString() ?? "Unknown Location";
            }).toList();
          } else {
            locationList.clear();
          }
        }
      } catch (e) {
        debugPrint("Error searching location: $e");
      } finally {
        isSearchingLocation.value = false;
      }
    });
  }

  Future<void> getCurrentLocation() async {
    isSearchingLocation.value = true;
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showCustomSnackBar("Location permissions are denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showCustomSnackBar("Location permissions are permanently denied.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address =
            "${place.locality ?? place.subLocality ?? place.name}, ${place.country}";
        selectedLocation.value = address;
        Get.back(); // close the bottom sheet
      }
    } catch (e) {
      showCustomSnackBar("Failed to get current location: $e");
    } finally {
      isSearchingLocation.value = false;
    }
  }

  // --- Audio Player ---
  final AudioPlayer audioPlayer = AudioPlayer();
  final RxString currentlyPlayingUrl = "".obs;

  Future<void> togglePlay(String url) async {
    if (url.isEmpty) return;

    try {
      if (currentlyPlayingUrl.value == url) {
        if (audioPlayer.playing) {
          await audioPlayer.pause();
          currentlyPlayingUrl.value = "";
        } else {
          await audioPlayer.play();
        }
      } else {
        currentlyPlayingUrl.value = url;
        await audioPlayer.setUrl(url);
        await audioPlayer.play();
      }
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  void stopAudio() {
    audioPlayer.stop();
    currentlyPlayingUrl.value = "";
  }

  // ---------------- Get Story Screction ==========================
  final RxList<StoryUserGroup> allStories = <StoryUserGroup>[].obs;
  final RxBool isStoriesLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getStories();
  }

  Future<void> getStories() async {
    isStoriesLoading.value = true;
    try {
      var response = await ApiClient.getData(ApiUrl.getAllStory);
      if (response.statusCode == 200) {
        var storyResponse = StoryResponse.fromJson(
          response.body is String ? jsonDecode(response.body) : response.body,
        );

        if (storyResponse.data != null) {
          List<StoryUserGroup> stories = storyResponse.data!;

          String token = await SharePrefsHelper.getString(
            AppConstants.bearerToken,
          );
          String? myUserId = _getUserIdFromToken(token);

          if (myUserId != null && myUserId.isNotEmpty) {
            int myIndex = stories.indexWhere(
              (element) => element.user?.id == myUserId,
            );
            if (myIndex != -1) {
              var myStory = stories.removeAt(myIndex);
              stories.insert(0, myStory);
            }
          }

          allStories.value = stories;
        }
      } else {
        debugPrint("Failed to fetch stories: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching stories: $e");
    } finally {
      isStoriesLoading.value = false;
    }
  }

  String? _getUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = parts[1];
      var normalized = base64Url.normalize(payload);
      var resp = utf8.decode(base64Url.decode(normalized));
      final decoded = json.decode(resp);
      return decoded['userId'];
    } catch (e) {
      return null;
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}

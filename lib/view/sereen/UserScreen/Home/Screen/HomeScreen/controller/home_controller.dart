import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';

class HomeController extends GetxController {
  final rxActiveTab = 0.obs; // 0: ALL, 1: EVENTS, 2: CLUBS
  void changeTab(int index) => rxActiveTab.value = index;

  // --- Story Creation ---
  final Rxn<File> selectedFile = Rxn<File>();
  final RxBool isVideo = false.obs;
  final RxBool isStoryCreating = false.obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickMedia({required bool isVideoVal}) async {
    final XFile? picked = isVideoVal
        ? await _picker.pickVideo(source: ImageSource.gallery)
        : await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      selectedFile.value = File(picked.path);
      isVideo.value = isVideoVal;
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
      final response = await ApiClient.postMultipartData(
        ApiUrl.createStory,
        {},
        multipartBody: [MultipartBody('media', selectedFile.value!)],
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Story created successfully!");
        resetStory();
        Get.back(); // close the create story screen
      } else {
        showCustomSnackBar("Failed to create story");
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
        final url = Uri.parse('https://itunes.apple.com/search?term=$query&entity=song&limit=15');
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
        print("Error searching music: $e");
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
            'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=${ApiUrl.mapKey}');
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
        print("Error searching location: $e");
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

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = "${place.locality ?? place.subLocality ?? place.name}, ${place.country}";
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
      print("Error playing audio: $e");
    }
  }

  void stopAudio() {
    audioPlayer.stop();
    currentlyPlayingUrl.value = "";
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}

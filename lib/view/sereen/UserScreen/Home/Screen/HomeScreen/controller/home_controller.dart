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
import '../model/view_story_model.dart';
import '../model/post_model.dart';
import '../model/audio_model.dart';
import '../model/event_model.dart';
import '../model/club_model.dart';

class HomeController extends GetxController {
  final rxActiveTab = 0.obs; // 0: POST, 1: EVENTS, 2: CLUBS
  void changeTab(int index) {
    rxActiveTab.value = index;
    if (index == 1 && eventsList.isEmpty) {
      getEvents();
    } else if (index == 2 && allClubs.isEmpty) {
      getAllClubs();
      getMyClubs();
    }
  }

  // ========================================= POST SECTION ==============================================================================
  final RxList<PostModel> postsList = <PostModel>[].obs;
  final RxBool isPostLoading = false.obs;
  final RxBool isLoadMoreLoading = false.obs;
  int _postPage = 1;
  bool _hasMorePosts = true;
  bool get hasMorePosts => _hasMorePosts;
  final RxString postSearchTerm = "".obs;
  final RxString postCategory = "".obs;
  Timer? _searchDebounce;
  final RxBool showSearchBar = false.obs;

  Future<void> getPost({
    bool isLoadMore = false,
    String? searchTerm,
    String? category,
    String? clubId,
  }) async {
    if (isLoadMore) {
      if (!_hasMorePosts || isLoadMoreLoading.value) return;
      isLoadMoreLoading.value = true;
    } else {
      isPostLoading.value = true;
      _postPage = 1;
      _hasMorePosts = true;
    }

    if (currentUserId.value.isEmpty) {
      try {
        String token = await SharePrefsHelper.getString(
          AppConstants.bearerToken,
        );
        String? myUserId = _getUserIdFromToken(token);
        if (myUserId != null && myUserId.isNotEmpty) {
          currentUserId.value = myUserId;
        }
      } catch (e) {
        debugPrint("Error reading userId in getPost: $e");
      }
    }

    if (searchTerm != null) {
      postSearchTerm.value = searchTerm;
    }
    if (category != null) {
      postCategory.value = category;
    }

    try {
      String url = ApiUrl.getAllPosts(
        page: _postPage,
        limit: 10,
        searchTerm: postSearchTerm.value,
        category: postCategory.value,
        clubId: clubId,
      );
      debugPrint("--- getPost URL: $url");

      var response = await ApiClient.getData(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var postResponse = PostResponse.fromJson(
          response.body is String ? jsonDecode(response.body) : response.body,
        );
        final newPosts = postResponse.data ?? [];
        if (newPosts.length < 10) {
          _hasMorePosts = false;
        } else {
          _postPage++;
        }
        if (isLoadMore) {
          postsList.addAll(newPosts);
        } else {
          postsList.value = newPosts;
        }
      } else {
        showCustomSnackBar("Failed to load posts", isError: true);
      }
    } catch (e) {
      debugPrint("Error loading posts: $e");
    } finally {
      if (isLoadMore) {
        isLoadMoreLoading.value = false;
      } else {
        isPostLoading.value = false;
      }
    }
  }

  void searchPost(String query) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      getPost(searchTerm: query);
    });
  }

  void searchClubs(String query) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      getAllClubs(searchTerm: query);
    });
  }

  Future<void> deletePost(String postId) async {
    try {
      var response = await ApiClient.deleteData(
        ApiUrl.deletePost(postId: postId),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        postsList.removeWhere((post) => post.id == postId);
        clubPosts.removeWhere((post) => post.id == postId);
        showCustomSnackBar("Post deleted successfully", isError: false);
      } else {
        showCustomSnackBar("Failed to delete post", isError: true);
      }
    } catch (e) {
      debugPrint("Error deleting post: $e");
      showCustomSnackBar("Error deleting post", isError: true);
    }
  }

  // ================== Single Post Detail ===========================
  final Rx<PostModel?> currentPostDetail = Rx<PostModel?>(null);
  final RxBool isPostDetailLoading = false.obs;

  Future<void> getSinglePost(String postId) async {
    isPostDetailLoading.value = true;
    currentPostDetail.value = null; // Clear previous
    try {
      var response = await ApiClient.getData(
        ApiUrl.getSinglePost(postId: postId),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final raw = response.body['data'];
        if (raw != null) {
          currentPostDetail.value = PostModel.fromJson(raw);
        }
      } else {
        showCustomSnackBar("Failed to load post details", isError: true);
      }
    } catch (e) {
      debugPrint("Error loading single post: $e");
      showCustomSnackBar("Error loading post details", isError: true);
    } finally {
      isPostDetailLoading.value = false;
    }
  }

  final RxSet<String> reactingPostIds = <String>{}.obs;

  Future<void> reactToPost(String postId, {String reactType = "LOVE"}) async {
    if (reactingPostIds.contains(postId)) return;
    reactingPostIds.add(postId);

    final globalIndex = postsList.indexWhere((element) => element.id == postId);
    final clubIndex = clubPosts.indexWhere((element) => element.id == postId);

    if (globalIndex == -1 && clubIndex == -1) {
      reactingPostIds.remove(postId);
      return;
    }

    final originalPost = globalIndex != -1
        ? postsList[globalIndex]
        : clubPosts[clubIndex];
    final alreadyLiked = originalPost.isReacted ?? false;

    List<PostReact> updatedReacts = List.from(originalPost.reacts ?? []);
    int updatedReactCount = originalPost.reactCount ?? 0;

    if (alreadyLiked) {
      updatedReacts.removeWhere((r) => r.user?.id == currentUserId.value);
      updatedReactCount = (updatedReactCount > 0) ? (updatedReactCount - 1) : 0;
    } else {
      updatedReacts.add(
        PostReact(
          id: "temp",
          reactType: reactType,
          user: PostUser(id: currentUserId.value),
          reactedAt: DateTime.now(),
        ),
      );
      updatedReactCount = updatedReactCount + 1;
    }

    final updatedPostModel = PostModel(
      id: originalPost.id,
      category: originalPost.category,
      visibility: originalPost.visibility,
      club: originalPost.club,
      status: originalPost.status,
      user: originalPost.user,
      clubPostDetails: originalPost.clubPostDetails,
      businessPostDetails: originalPost.businessPostDetails,
      sessionDetails: originalPost.sessionDetails,
      spotDetails: originalPost.spotDetails,
      trackUpdateDetails: originalPost.trackUpdateDetails,
      media: originalPost.media,
      reacts: updatedReacts,
      commentCount: originalPost.commentCount,
      reactCount: updatedReactCount,
      isReacted: !alreadyLiked,
      myReactType: !alreadyLiked ? reactType : null,
      comments: originalPost.comments,
      createdAt: originalPost.createdAt,
      updatedAt: originalPost.updatedAt,
    );

    if (globalIndex != -1) postsList[globalIndex] = updatedPostModel;
    if (clubIndex != -1) clubPosts[clubIndex] = updatedPostModel;
    if (currentPostDetail.value?.id == postId) {
      currentPostDetail.value = updatedPostModel;
    }

    try {
      var response = await ApiClient.patchData(
        ApiUrl.reactPost(postId: postId),
        jsonEncode({"reactType": reactType}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseBody = response.body is String
            ? jsonDecode(response.body)
            : response.body;
        if (responseBody["data"] != null) {
          final data = responseBody["data"];
          final reactsJson = data["reacts"] ?? [];
          final backendReacts = List<PostReact>.from(
            reactsJson.map((x) => PostReact.fromJson(x)),
          );
          final backendReactCount = data["reactCount"] ?? backendReacts.length;

          final isReacted = currentUserId.value.isNotEmpty
              ? backendReacts.any((r) => r.user?.id == currentUserId.value)
              : !alreadyLiked;

          final backendUpdatedPostModel = PostModel(
            id: originalPost.id,
            category: originalPost.category,
            visibility: originalPost.visibility,
            club: originalPost.club,
            status: originalPost.status,
            user: originalPost.user,
            clubPostDetails: originalPost.clubPostDetails,
            businessPostDetails: originalPost.businessPostDetails,
            sessionDetails: originalPost.sessionDetails,
            spotDetails: originalPost.spotDetails,
            trackUpdateDetails: originalPost.trackUpdateDetails,
            media: originalPost.media,
            reacts: backendReacts,
            commentCount: originalPost.commentCount,
            reactCount: backendReactCount,
            isReacted: isReacted,
            myReactType: isReacted ? reactType : null,
            comments: originalPost.comments,
            createdAt: originalPost.createdAt,
            updatedAt: originalPost.updatedAt,
          );

          if (globalIndex != -1) {
            postsList[globalIndex] = backendUpdatedPostModel;
          }
          if (clubIndex != -1) {
            clubPosts[clubIndex] = backendUpdatedPostModel;
          }
          if (currentPostDetail.value?.id == postId) {
            currentPostDetail.value = backendUpdatedPostModel;
          }
        }
      } else {
        if (globalIndex != -1) postsList[globalIndex] = originalPost;
        if (clubIndex != -1) clubPosts[clubIndex] = originalPost;
        if (currentPostDetail.value?.id == postId) {
          currentPostDetail.value = originalPost;
        }
        showCustomSnackBar("Failed to update reaction", isError: true);
      }
    } catch (e) {
      debugPrint("Error reacting to post: $e");
      if (globalIndex != -1) postsList[globalIndex] = originalPost;
      if (clubIndex != -1) clubPosts[clubIndex] = originalPost;
      if (currentPostDetail.value?.id == postId) {
        currentPostDetail.value = originalPost;
      }
    } finally {
      reactingPostIds.remove(postId);
    }
  }

  Future<void> commentOnPost(String postId, String commentText) async {
    try {
      var response = await ApiClient.postData(
        ApiUrl.commentPost(postId: postId),
        jsonEncode({"comment": commentText}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        getPost();
        if (currentPostDetail.value?.id == postId) getSinglePost(postId);
        showCustomSnackBar("Comment added successfully", isError: false);
      } else {
        showCustomSnackBar("Failed to add comment", isError: true);
      }
    } catch (e) {
      debugPrint("Error commenting on post: $e");
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      var response = await ApiClient.deleteData(
        ApiUrl.deleteComment(postId: postId, commentId: commentId),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        getPost();
        if (currentPostDetail.value?.id == postId) getSinglePost(postId);
        showCustomSnackBar("Comment deleted successfully", isError: false);
      } else {
        showCustomSnackBar("Failed to delete comment", isError: true);
      }
    } catch (e) {
      debugPrint("Error deleting comment: $e");
    }
  }

  Future<void> replyToComment(
    String postId,
    String commentId,
    String replyText,
  ) async {
    try {
      var response = await ApiClient.postData(
        ApiUrl.commentPostReply(postId: postId, commentId: commentId),
        jsonEncode({"comment": replyText}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        getPost();
        if (currentPostDetail.value?.id == postId) getSinglePost(postId);
        showCustomSnackBar("Reply added successfully", isError: false);
      } else {
        showCustomSnackBar("Failed to add reply", isError: true);
      }
    } catch (e) {
      debugPrint("Error replying to comment: $e");
    }
  }

  // ========================================= STORY SECTION ==============================================================================
  // ---Create  Story Creation -------------------------------
  final Rxn<File> selectedFile = Rxn<File>();
  final RxBool isVideo = false.obs;
  final RxBool isStoryCreating = false.obs;
  final ImagePicker _picker = ImagePicker();

  bool _isPickingMedia = false;

  Future<void> pickMedia({
    required bool isVideoVal,
    bool fromCamera = false,
  }) async {
    if (_isPickingMedia) return;
    _isPickingMedia = true;

    try {
      final source = fromCamera ? ImageSource.camera : ImageSource.gallery;
      final XFile? picked = isVideoVal
          ? await _picker.pickVideo(source: source)
          : await _picker.pickImage(source: source);

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
    selectedMusicUrl.value = null;
    selectedLocation.value = null;
  }

  // --- Story Enhancements ---
  final RxnString selectedMusic = RxnString();
  final RxnString selectedMusicUrl = RxnString();
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
        dataMap["music"] = {
          "name": selectedMusic.value,
          "url": selectedMusicUrl.value,
        };
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

  final RxBool isPostCreating = false.obs;

  // === Session Post Fields ===
  final sessionSummaryCtrl = TextEditingController();
  final sessionVehicleCtrl = TextEditingController();
  final sessionCircuitCtrl = TextEditingController();
  final sessionTrackNameCtrl = TextEditingController();
  final sessionBestLapTimeCtrl = TextEditingController();
  final sessionTopSpeedCtrl = TextEditingController();
  final Rxn<File> sessionSelectedImage = Rxn<File>();

  // === Spot Post Fields ===
  final spotLicensePlateCtrl = TextEditingController();
  final spotRegionCtrl = TextEditingController();
  final spotMakeAndModelCtrl = TextEditingController();
  final spotEngineCtrl = TextEditingController();
  final spotPowerHpCtrl = TextEditingController();
  final Rxn<File> spotSelectedImage = Rxn<File>();

  // === Track Update Fields ===
  final trackCircuitCtrl = TextEditingController();
  final trackNotesCtrl = TextEditingController();
  final RxString trackSelectedCondition = "DRY".obs;
  final RxString trackSelectedVisibility = "Public".obs;
  final RxMap<String, bool> trackHazards = <String, bool>{
    "Yellow Flag": false,
    "Red Flag": false,
    "Oil on Track": false,
    "Debris": false,
  }.obs;
  final Rxn<File> trackSelectedImage = Rxn<File>();

  // === Club Post Fields ===
  final clubTitleCtrl = TextEditingController();
  final clubDetailsCtrl = TextEditingController();
  final RxBool clubIsPinned = false.obs;
  final Rxn<File> clubSelectedMedia = Rxn<File>();
  final RxList<dynamic> clubMyClubs = <dynamic>[].obs;
  final RxnString clubSelectedClubId = RxnString();
  final RxBool clubIsLoadingClubs = false.obs;

  // === Business Post Fields ===
  final businessTitleCtrl = TextEditingController();
  final businessDescCtrl = TextEditingController();
  final businessPriceCtrl = TextEditingController();
  final RxString businessSelectedCategory = "Services".obs;
  final RxnString businessSelectedAudioTrack = RxnString("AUTOBAHN");
  final RxString businessSearchQuery = "".obs;
  final Rxn<File> businessSelectedImage = Rxn<File>();

  final ImagePicker _postImagePicker = ImagePicker();

  Future<void> pickPostImage(Rxn<File> targetRx) async {
    try {
      final XFile? picked = await _postImagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (picked != null) {
        targetRx.value = File(picked.path);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void resetAllPostFields() {
    sessionSummaryCtrl.clear();
    sessionVehicleCtrl.clear();
    sessionCircuitCtrl.clear();
    sessionTrackNameCtrl.clear();
    sessionBestLapTimeCtrl.clear();
    sessionTopSpeedCtrl.clear();
    sessionSelectedImage.value = null;

    spotLicensePlateCtrl.clear();
    spotRegionCtrl.clear();
    spotMakeAndModelCtrl.clear();
    spotEngineCtrl.clear();
    spotPowerHpCtrl.clear();
    spotSelectedImage.value = null;

    trackCircuitCtrl.clear();
    trackNotesCtrl.clear();
    trackSelectedCondition.value = "DRY";
    trackSelectedVisibility.value = "Public";
    trackHazards.forEach((key, val) => trackHazards[key] = false);
    trackSelectedImage.value = null;

    clubTitleCtrl.clear();
    clubDetailsCtrl.clear();
    clubIsPinned.value = false;
    clubSelectedMedia.value = null;

    businessTitleCtrl.clear();
    businessDescCtrl.clear();
    businessPriceCtrl.clear();
    businessSelectedCategory.value = "Services";
    businessSelectedAudioTrack.value = null;
    businessSearchQuery.value = "";
    businessSelectedImage.value = null;
  }

  Future<bool> createPost({
    required String category,
    required String visibility,
    Map<String, dynamic>? sessionDetails,
    Map<String, dynamic>? spotDetails,
    Map<String, dynamic>? trackUpdateDetails,
    Map<String, dynamic>? clubPostDetails,
    Map<String, dynamic>? businessPostDetails,
    String? clubId,
    File? mediaFile,
    String? mediaUrl,
  }) async {
    isPostCreating.value = true;
    try {
      Map<String, dynamic> dataMap = {
        "category": category,
        "visibility": visibility,
      };

      if (sessionDetails != null) {
        dataMap["sessionDetails"] = sessionDetails;
      }
      if (spotDetails != null) {
        dataMap["spotDetails"] = spotDetails;
      }
      if (trackUpdateDetails != null) {
        dataMap["trackUpdateDetails"] = trackUpdateDetails;
      }
      if (clubPostDetails != null) {
        dataMap["clubPostDetails"] = clubPostDetails;
      }
      if (businessPostDetails != null) {
        dataMap["businessPostDetails"] = businessPostDetails;
      }
      if (clubId != null) {
        dataMap["club"] = clubId;
      }
      if (mediaUrl != null && mediaUrl.isNotEmpty) {
        dataMap["media"] = [
          {
            "url": mediaUrl,
            "type": "image"
          }
        ];
      }

      dynamic response;
      if (mediaFile != null) {
        response = await ApiClient.postMultipartData(
          ApiUrl.createPost,
          {"data": jsonEncode(dataMap)},
          multipartBody: [MultipartBody('media', mediaFile)],
        );
      } else {
        response = await ApiClient.postData(
          ApiUrl.createPost,
          jsonEncode(dataMap),
        );
      }

      Map<String, dynamic> jsonResponse = {};
      try {
        jsonResponse = response.body is String
            ? jsonDecode(response.body)
            : response.body as Map<String, dynamic>;
      } catch (e) {
        debugPrint("JSON Decode error in createPost: $e");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar(
          jsonResponse['message']?.toString() ?? "Post published successfully!",
          isError: false,
        );
        getPost();
        return true;
      } else {
        showCustomSnackBar(
          jsonResponse['message']?.toString() ?? "Failed to publish post",
          isError: true,
        );
        return false;
      }
    } catch (e) {
      showCustomSnackBar("An error occurred: $e", isError: true);
      return false;
    } finally {
      isPostCreating.value = false;
    }
  }

  // --- Club Group Post Specific ---
  final TextEditingController clubGroupPostTextCtrl = TextEditingController();
  final Rxn<File> clubGroupSelectedMedia = Rxn<File>();
  final RxList<PostModel> clubPosts = <PostModel>[].obs;
  final RxBool isClubPostsLoading = false.obs;

  Future<void> getClubPosts(String clubId) async {
    isClubPostsLoading.value = true;
    try {
      String url = ApiUrl.getAllPosts(
        page: 1,
        limit: 50, // Get a chunk of posts for the club
        clubId: clubId,
      );
      var response = await ApiClient.getData(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var postResponse = PostResponse.fromJson(
          response.body is String ? jsonDecode(response.body) : response.body,
        );
        clubPosts.value = postResponse.data ?? [];
      } else {
        showCustomSnackBar("Failed to load club posts", isError: true);
      }
    } catch (e) {
      debugPrint("Error loading club posts: $e");
    } finally {
      isClubPostsLoading.value = false;
    }
  }

  Future<void> pickClubGroupMedia(
    ImageSource source, {
    bool isVideo = false,
  }) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? pickedFile;
      if (isVideo) {
        pickedFile = await picker.pickVideo(source: source);
      } else {
        pickedFile = await picker.pickImage(source: source);
      }

      if (pickedFile != null) {
        clubGroupSelectedMedia.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Could not pick media: $e", colorText: Colors.red);
    }
  }

  Future<bool> createClubSpecificPost({
    required String clubId,
    required String details,
    File? mediaFile,
  }) async {
    final success = await createPost(
      category: "CLUB_POST",
      visibility: "Club Only",
      clubId: clubId,
      mediaFile: mediaFile,
      clubPostDetails: {
        "title": "Group Post",
        "details": details,
        "isPinned": false,
      },
    );
    if (success) {
      clubGroupPostTextCtrl.clear();
      clubGroupSelectedMedia.value = null;
      getClubPosts(clubId);
    }
    return success;
  }

  // --- Search State & Methods ---
  final RxList<Map<String, String>> musicList = <Map<String, String>>[].obs;
  final RxBool isSearchingMusic = false.obs;

  final RxList<String> locationList = <String>[].obs;
  final RxBool isSearchingLocation = false.obs;

  Timer? _debounce;

  void searchMusic(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      isSearchingMusic.value = true;
      try {
        String url = ApiUrl.getAllMusic;
        if (query.isNotEmpty) {
          url += "?searchTerm=${Uri.encodeComponent(query)}";
        }
        var response = await ApiClient.getData(url);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var musicResponse = MusicResponse.fromJson(
            response.body is String ? jsonDecode(response.body) : response.body,
          );
          final list = musicResponse.data ?? [];
          musicList.value = list.map((item) {
            String fullAudioUrl = item.audioUrl ?? "";
            if (fullAudioUrl.isNotEmpty && !fullAudioUrl.startsWith("http")) {
              fullAudioUrl = "${ApiUrl.imageUrl}$fullAudioUrl";
            }
            return {
              "title": item.title ?? "Unknown Title",
              "artist": item.artist ?? "Unknown Artist",
              "previewUrl": fullAudioUrl,
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

  final AudioPlayer audioPlayer = AudioPlayer();
  final RxString currentlyPlayingUrl = "".obs;
  final RxBool isPlayingRx = false.obs;

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
  final RxString currentUserId = "".obs;

  @override
  void onInit() {
    super.onInit();
    audioPlayer.playingStream.listen((playing) {
      isPlayingRx.value = playing;
    });
    getStories();
    getPost();
    getEvents();
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
            currentUserId.value = myUserId;
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

  // ---------------- Delete Story Screction ==========================
  final RxBool isStoryDeleting = false.obs;

  Future<bool> deleteStory(String storyId) async {
    isStoryDeleting.value = true;
    try {
      var response = await ApiClient.deleteData(
        ApiUrl.deleteStory(storyId: storyId),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Story deleted successfully!", isError: false);
        await getStories(); // refresh stories list
        return true;
      } else {
        showCustomSnackBar("Failed to delete story", isError: true);
        return false;
      }
    } catch (e) {
      showCustomSnackBar("An error occurred: $e", isError: true);
      return false;
    } finally {
      isStoryDeleting.value = false;
    }
  }

  // ---------------- Like Story ==========================
  final RxBool isStoryLiking = false.obs;

  Future<bool> likeStory(String storyId) async {
    isStoryLiking.value = true;
    try {
      var body = jsonEncode({"type": "like"});
      var response = await ApiClient.patchData(
        ApiUrl.likeStory(storyId: storyId),
        body,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        showCustomSnackBar("Failed to like story", isError: true);
        return false;
      }
    } catch (e) {
      showCustomSnackBar("An error occurred: $e", isError: true);
      return false;
    } finally {
      isStoryLiking.value = false;
    }
  }

  // ---------------- View Story (Mark viewed) ==========================
  Future<bool> postViewStory(String storyId) async {
    debugPrint("--- postViewStory called for storyId: $storyId");
    try {
      var response = await ApiClient.patchData(
        ApiUrl.postViewStory(storyId: storyId),
        jsonEncode({}),
      );
      debugPrint("--- postViewStory response status: ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("--- postViewStory success!");
        return true;
      }
      debugPrint(
        "--- postViewStory failed with status: ${response.statusCode}",
      );
      return false;
    } catch (e) {
      debugPrint("--- Error marking story as viewed: $e");
      return false;
    }
  }

  // ---------------- Get Story Viewers ==========================
  final RxBool isStoryViewersLoading = false.obs;

  Future<StoryViewersResponse?> getStoryViewers(String storyId) async {
    isStoryViewersLoading.value = true;
    try {
      var response = await ApiClient.getData(
        ApiUrl.viewStory(storyId: storyId),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null) {
          return StoryViewersResponse.fromJson(response.body);
        }
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching story viewers: $e");
      return null;
    } finally {
      isStoryViewersLoading.value = false;
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

  // ================== Event =======================================
  final RxList<EventModel> eventsList = <EventModel>[].obs;
  final RxBool isEventsLoading = false.obs;
  final RxBool isEventsLoadMoreLoading = false.obs;

  final Rx<EventModel?> currentEventDetail = Rx<EventModel?>(null);
  final RxBool isEventDetailLoading = false.obs;

  Future<void> getSingleEvent(String eventId) async {
    isEventDetailLoading.value = true;
    currentEventDetail.value = null; // Clear previous
    try {
      final response = await ApiClient.getData(
        ApiUrl.getSingleEvent(eventId: eventId),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final raw = response.body['data'];
        if (raw != null) {
          currentEventDetail.value = EventModel.fromJson(raw);
        }
      } else {
        showCustomSnackBar("Failed to load event details", isError: true);
      }
    } catch (e) {
      debugPrint("Error loading single event: $e");
      showCustomSnackBar("Error loading event details", isError: true);
    } finally {
      isEventDetailLoading.value = false;
    }
  }

  int _eventPage = 1;
  bool _hasMoreEvents = true;
  bool get hasMoreEvents => _hasMoreEvents;

  final RxString eventSearchTerm = "".obs;
  Timer? _eventSearchDebounce;

  void searchEvents(String query) {
    if (_eventSearchDebounce?.isActive ?? false) _eventSearchDebounce?.cancel();
    _eventSearchDebounce = Timer(const Duration(milliseconds: 350), () {
      getEvents(searchTerm: query);
    });
  }

  Future<void> getEvents({bool isLoadMore = false, String? searchTerm}) async {
    if (searchTerm != null) {
      eventSearchTerm.value = searchTerm;
    }
    if (isLoadMore) {
      if (!_hasMoreEvents || isEventsLoadMoreLoading.value) return;
      isEventsLoadMoreLoading.value = true;
    } else {
      isEventsLoading.value = true;
      _eventPage = 1;
      _hasMoreEvents = true;
    }

    try {
      final response = await ApiClient.getData(
        ApiUrl.getEvents(
          page: _eventPage,
          limit: 10,
          searchTerm: eventSearchTerm.value,
        ),
      );
      if (response.statusCode == 200) {
        final raw = response.body['data'];
        List<dynamic>? data;
        if (raw is List) {
          data = raw;
        } else if (raw is Map && raw['data'] is List) {
          data = raw['data'] as List;
        }
        final newEvents = (data ?? [])
            .map((e) => EventModel.fromJson(e))
            .toList();

        if (newEvents.length < 10) {
          _hasMoreEvents = false;
        } else {
          _eventPage++;
        }

        if (isLoadMore) {
          eventsList.addAll(newEvents);
        } else {
          eventsList.value = newEvents;
        }
      } else {
        showCustomSnackBar("Failed to load events", isError: true);
      }
    } catch (e) {
      debugPrint("Error fetching events: $e");
    } finally {
      if (isLoadMore) {
        isEventsLoadMoreLoading.value = false;
      } else {
        isEventsLoading.value = false;
      }
    }
  }

  Future<bool> createEvent({
    required File mediaFile,
    required Map<String, dynamic> eventData,
  }) async {
    try {
      final body = {'data': jsonEncode(eventData)};
      final response = await ApiClient.postMultipartData(
        ApiUrl.createEvent,
        body,
        multipartBody: [MultipartBody('bannerImage', mediaFile)],
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Event created successfully!", isError: false);
        getEvents();
        return true;
      } else {
        showCustomSnackBar("Failed to create event", isError: true);
        return false;
      }
    } catch (e) {
      showCustomSnackBar("Error creating event: $e", isError: true);
      return false;
    }
  }

  Future<void> getMyEvent() async {
    isEventsLoading.value = true;
    try {
      final response = await ApiClient.getData(ApiUrl.getMyEvent);
      if (response.statusCode == 200) {
        final data = response.body['data'] as List?;
        if (data != null) {
          eventsList.value = data.map((e) => EventModel.fromJson(e)).toList();
        }
      }
    } catch (e) {
      debugPrint("Error fetching my events: $e");
    } finally {
      isEventsLoading.value = false;
    }
  }

  Future<bool> joinEvent({required String eventId}) async {
    // Optimistic update
    final index = eventsList.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      final original = eventsList[index];
      final alreadyJoined = original.isEventJoined ?? false;
      eventsList[index] = EventModel(
        id: original.id,
        eventName: original.eventName,
        missionType: original.missionType,
        deploymentDate: original.deploymentDate,
        locationCircuit: original.locationCircuit,
        maxCapacity: original.maxCapacity,
        accessType: original.accessType,
        briefing: original.briefing,
        bannerImage: original.bannerImage,
        shareCount: original.shareCount,
        status: original.status,
        joinCount: alreadyJoined
            ? ((original.joinCount ?? 1) - 1)
            : ((original.joinCount ?? 0) + 1),
        reactCount: original.reactCount,
        commentCount: original.commentCount,
        isReacted: original.isReacted,
        isEventJoined: !alreadyJoined,
        myReactType: original.myReactType,
        timeWindow: original.timeWindow,
        user: original.user,
        comments: original.comments,
      );
      try {
        final response = await ApiClient.postData(
          ApiUrl.joinEvent(eventId: eventId),
          jsonEncode({}),
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          return true;
        } else {
          // rollback
          eventsList[index] = original;
          showCustomSnackBar("Failed to join event", isError: true);
          return false;
        }
      } catch (e) {
        eventsList[index] = original;
        debugPrint("Error joining event: $e");
        return false;
      }
    }
    return false;
  }

  final RxSet<String> reactingEventIds = <String>{}.obs;

  Future<bool> reactToEvent({
    required String eventId,
    String reactType = "LOVE",
  }) async {
    if (reactingEventIds.contains(eventId)) return false;
    reactingEventIds.add(eventId);

    final index = eventsList.indexWhere((e) => e.id == eventId);
    if (index == -1) {
      reactingEventIds.remove(eventId);
      return false;
    }

    final original = eventsList[index];
    final alreadyLiked = original.isReacted ?? false;
    final updatedCount = alreadyLiked
        ? ((original.reactCount ?? 1) > 0 ? (original.reactCount! - 1) : 0)
        : (original.reactCount ?? 0) + 1;

    // Optimistic update
    eventsList[index] = EventModel(
      id: original.id,
      eventName: original.eventName,
      missionType: original.missionType,
      deploymentDate: original.deploymentDate,
      locationCircuit: original.locationCircuit,
      maxCapacity: original.maxCapacity,
      accessType: original.accessType,
      briefing: original.briefing,
      bannerImage: original.bannerImage,
      shareCount: original.shareCount,
      status: original.status,
      joinCount: original.joinCount,
      reactCount: updatedCount,
      commentCount: original.commentCount,
      isReacted: !alreadyLiked,
      myReactType: !alreadyLiked ? reactType : null,
      isEventJoined: original.isEventJoined,
      timeWindow: original.timeWindow,
      user: original.user,
      comments: original.comments,
    );
    if (currentEventDetail.value?.id == eventId) {
      currentEventDetail.value = eventsList[index];
    }

    try {
      final response = await ApiClient.patchData(
        ApiUrl.reactEvent(eventId: eventId),
        jsonEncode({"reactType": reactType}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = (response.body is String
            ? jsonDecode(response.body)
            : response.body)['data'];
        if (data != null) {
          final backendReactCount = data['reactCount'] ?? updatedCount;
          final backendIsReacted = data['isReacted'] ?? !alreadyLiked;
          eventsList[index] = EventModel(
            id: original.id,
            eventName: original.eventName,
            missionType: original.missionType,
            deploymentDate: original.deploymentDate,
            locationCircuit: original.locationCircuit,
            maxCapacity: original.maxCapacity,
            accessType: original.accessType,
            briefing: original.briefing,
            bannerImage: original.bannerImage,
            shareCount: original.shareCount,
            status: original.status,
            joinCount: original.joinCount,
            reactCount: backendReactCount,
            commentCount: original.commentCount,
            isReacted: backendIsReacted,
            myReactType: backendIsReacted ? reactType : null,
            isEventJoined: original.isEventJoined,
            timeWindow: original.timeWindow,
            user: original.user,
            comments: original.comments,
          );
          if (currentEventDetail.value?.id == eventId) {
            currentEventDetail.value = eventsList[index];
          }
        }
        return true;
      } else {
        // rollback
        eventsList[index] = original;
        if (currentEventDetail.value?.id == eventId) {
          currentEventDetail.value = original;
        }
        return false;
      }
    } catch (e) {
      eventsList[index] = original;
      debugPrint("Error reacting to event: $e");
      return false;
    } finally {
      reactingEventIds.remove(eventId);
    }
  }

  Future<bool> commentOnEvent({
    required String eventId,
    required String comment,
  }) async {
    try {
      final response = await ApiClient.postData(
        ApiUrl.commentEvent(eventId: eventId),
        jsonEncode({"comment": comment}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final index = eventsList.indexWhere((e) => e.id == eventId);
        if (index != -1) {
          final original = eventsList[index];
          final body = response.body is String
              ? jsonDecode(response.body)
              : response.body;
          final data = body['data'];

          // Use backend comments if available, else add temp comment
          List<EventComment> updatedComments;
          if (data != null && data['comments'] is List) {
            updatedComments = (data['comments'] as List)
                .map((c) => EventComment.fromJson(c))
                .toList();
          } else {
            updatedComments = [
              ...(original.comments ?? []),
              EventComment(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                comment: comment,
                user: EventUser(id: currentUserId.value, name: 'You'),
              ),
            ];
          }

          eventsList[index] = EventModel(
            id: original.id,
            eventName: original.eventName,
            missionType: original.missionType,
            deploymentDate: original.deploymentDate,
            locationCircuit: original.locationCircuit,
            maxCapacity: original.maxCapacity,
            accessType: original.accessType,
            briefing: original.briefing,
            bannerImage: original.bannerImage,
            shareCount: original.shareCount,
            status: original.status,
            joinCount: original.joinCount,
            reactCount: original.reactCount,
            commentCount:
                data?['commentCount'] ?? (original.commentCount ?? 0) + 1,
            isReacted: original.isReacted,
            myReactType: original.myReactType,
            isEventJoined: original.isEventJoined,
            timeWindow: original.timeWindow,
            user: original.user,
            comments: updatedComments,
          );
          if (currentEventDetail.value?.id == eventId) {
            currentEventDetail.value = eventsList[index];
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error commenting on event: $e");
      return false;
    }
  }

  Future<bool> shareEvent({required String eventId}) async {
    try {
      final response = await ApiClient.postData(
        ApiUrl.shareEvent(eventId: eventId),
        jsonEncode({}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error sharing event: $e");
      return false;
    }
  }

  Future<dynamic> getEventInteractions({required String eventId}) async {
    try {
      final response = await ApiClient.getData(
        ApiUrl.getEventInteractions(eventId: eventId),
      );
      if (response.statusCode == 200) {
        return response.body['data'];
      }
      return null;
    } catch (e) {
      debugPrint("Error getting event interactions: $e");
      return null;
    }
  }

  Future<bool> deleteEvent({required String eventId}) async {
    try {
      final response = await ApiClient.deleteData(
        ApiUrl.deleteEvent(eventId: eventId),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Event deleted", isError: false);
        eventsList.removeWhere((e) => e.id == eventId);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error deleting event: $e");
      return false;
    }
  }

  Future<bool> deleteEventComment({
    required String eventId,
    required String commentId,
  }) async {
    try {
      final response = await ApiClient.deleteData(
        ApiUrl.deleteEventComment(eventId: eventId, commentId: commentId),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final index = eventsList.indexWhere((e) => e.id == eventId);
        if (index != -1) {
          final original = eventsList[index];
          final updatedComments = List<EventComment>.from(
            original.comments ?? [],
          );
          updatedComments.removeWhere((c) => c.id == commentId);

          eventsList[index] = EventModel(
            id: original.id,
            eventName: original.eventName,
            missionType: original.missionType,
            deploymentDate: original.deploymentDate,
            locationCircuit: original.locationCircuit,
            maxCapacity: original.maxCapacity,
            accessType: original.accessType,
            briefing: original.briefing,
            bannerImage: original.bannerImage,
            shareCount: original.shareCount,
            status: original.status,
            joinCount: original.joinCount,
            reactCount: original.reactCount,
            commentCount: (original.commentCount ?? 1) > 0
                ? original.commentCount! - 1
                : 0,
            isReacted: original.isReacted,
            myReactType: original.myReactType,
            isEventJoined: original.isEventJoined,
            timeWindow: original.timeWindow,
            user: original.user,
            comments: updatedComments,
          );
          if (currentEventDetail.value?.id == eventId) {
            currentEventDetail.value = eventsList[index];
          }
        }
        showCustomSnackBar("Comment deleted", isError: false);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error deleting event comment: $e");
      return false;
    }
  }

  Future<bool> reactToEventComment({
    required String eventId,
    required String commentId,
    String reactType = "LOVE",
  }) async {
    try {
      final response = await ApiClient.patchData(
        ApiUrl.reactEventComment(eventId: eventId, commentId: commentId),
        jsonEncode({"reactType": reactType}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error reacting to event comment: $e");
      return false;
    }
  }

  Future<bool> replyToEventComment({
    required String eventId,
    required String commentId,
    required String replyText,
  }) async {
    try {
      final response = await ApiClient.postData(
        ApiUrl.replyEventComment(eventId: eventId, commentId: commentId),
        jsonEncode({"comment": replyText}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final index = eventsList.indexWhere((e) => e.id == eventId);
        if (index != -1) {
          final original = eventsList[index];
          final body = response.body is String
              ? jsonDecode(response.body)
              : response.body;
          final data = body['data'];

          List<EventComment> updatedComments = List<EventComment>.from(
            original.comments ?? [],
          );
          final cIndex = updatedComments.indexWhere((c) => c.id == commentId);
          if (cIndex != -1) {
            final oldComment = updatedComments[cIndex];
            List<EventCommentReply> newReplies;

            if (data != null && data['replies'] is List) {
              newReplies = (data['replies'] as List)
                  .map((r) => EventCommentReply.fromJson(r))
                  .toList();
            } else {
              newReplies = [
                ...(oldComment.replies ?? []),
                EventCommentReply(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  comment: replyText,
                  user: EventUser(id: currentUserId.value, name: 'You'),
                ),
              ];
            }

            updatedComments[cIndex] = EventComment(
              id: oldComment.id,
              comment: oldComment.comment,
              commentedAt: oldComment.commentedAt,
              user: oldComment.user,
              reacts: oldComment.reacts,
              replies: newReplies,
              isReacted: oldComment.isReacted,
              myReactType: oldComment.myReactType,
            );
          }

          eventsList[index] = EventModel(
            id: original.id,
            eventName: original.eventName,
            missionType: original.missionType,
            deploymentDate: original.deploymentDate,
            locationCircuit: original.locationCircuit,
            maxCapacity: original.maxCapacity,
            accessType: original.accessType,
            briefing: original.briefing,
            bannerImage: original.bannerImage,
            shareCount: original.shareCount,
            status: original.status,
            joinCount: original.joinCount,
            reactCount: original.reactCount,
            commentCount: original.commentCount,
            isReacted: original.isReacted,
            myReactType: original.myReactType,
            isEventJoined: original.isEventJoined,
            timeWindow: original.timeWindow,
            user: original.user,
            comments: updatedComments,
          );
          if (currentEventDetail.value?.id == eventId) {
            currentEventDetail.value = eventsList[index];
          }
        }
        showCustomSnackBar("Reply added", isError: false);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error replying to event comment: $e");
      return false;
    }
  }

  // ========================================= CLUBS SECTION ==============================================================================
  final RxList<ClubModel> allClubs = <ClubModel>[].obs;
  final RxList<ClubModel> myClubs = <ClubModel>[].obs;
  final Rx<ClubModel?> currentClubDetail = Rx<ClubModel?>(null);

  final RxBool isClubsLoading = false.obs;
  final RxBool isMyClubsLoading = false.obs;
  final RxBool isClubDetailsLoading = false.obs;
  final RxBool isCreateClubLoading = false.obs;

  Future<void> getAllClubs({String? searchTerm}) async {
    isClubsLoading.value = true;
    try {
      final response = await ApiClient.getData(
        ApiUrl.getAllClubs(searchTerm: searchTerm),
      );
      if (response.statusCode == 200) {
        var bodyData = response.body['data'];
        List dataList = [];
        if (bodyData is List) {
          dataList = bodyData;
        } else if (bodyData is Map && bodyData['data'] is List) {
          dataList = bodyData['data'];
        }
        allClubs.value = dataList
            .map((json) => ClubModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint("Error fetching all clubs: $e");
    } finally {
      isClubsLoading.value = false;
    }
  }

  Future<void> getMyClubs() async {
    isMyClubsLoading.value = true;
    try {
      final response = await ApiClient.getData(ApiUrl.getMyClubs);
      if (response.statusCode == 200) {
        var bodyData = response.body['data'];
        List dataList = [];
        if (bodyData is List) {
          dataList = bodyData;
        } else if (bodyData is Map && bodyData['data'] is List) {
          dataList = bodyData['data'];
        }
        myClubs.value = dataList
            .map((json) => ClubModel.fromJson(json))
            .toList();
      } else {
        debugPrint(response.body['message']);
      }
    } catch (e) {
      debugPrint("Error fetching my clubs: $e");
    } finally {
      isMyClubsLoading.value = false;
    }
  }

  Future<void> getSingleClub(String clubId) async {
    isClubDetailsLoading.value = true;
    try {
      final response = await ApiClient.getData(
        ApiUrl.getSingleClub(clubId: clubId),
      );
      if (response.statusCode == 200) {
        final data = response.body['data'];
        if (data != null) {
          currentClubDetail.value = ClubModel.fromJson(data);
        }
      }
    } catch (e) {
      debugPrint("Error fetching club details: $e");
    } finally {
      isClubDetailsLoading.value = false;
    }
  }

  Future<bool> createClub({
    required String clubName,
    required String description,
    List<String>? categories,
    required String accessType,
    required bool telemetryVerification,
    File? logo,
    File? banner,
  }) async {
    isCreateClubLoading.value = true;
    try {
      Map<String, dynamic> body = {
        'clubName': clubName,
        'description': description,
        if (categories != []) 'categories': categories,
        'accessType': accessType,
        'telemetryVerification': telemetryVerification,
      };

      List<MultipartBody> multipartBodyList = [];

      if (logo != null) {
        multipartBodyList.add(MultipartBody('logo', logo));
      }
      if (banner != null) {
        multipartBodyList.add(MultipartBody('banner', banner));
      }

      final response = await ApiClient.postMultipartData(ApiUrl.createClub, {
        "data": jsonEncode(body),
      }, multipartBody: multipartBodyList);

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Club created successfully!", isError: false);
        getAllClubs();
        getMyClubs();
        return true;
      } else {
        showCustomSnackBar(response.body['message'] ?? 'Failed to create club');
        return false;
      }
    } catch (e) {
      debugPrint("Error creating club: $e");
      return false;
    } finally {
      isCreateClubLoading.value = false;
    }
  }

  final RxList<dynamic> clubMembersList = <dynamic>[].obs;
  final RxBool isClubMembersLoading = false.obs;

  Future<void> getClubMembers(String clubId) async {
    isClubMembersLoading.value = true;
    try {
      final response = await ApiClient.getData(
        ApiUrl.getClubMembers(clubId: clubId),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body['data'];
        if (data is List) {
          clubMembersList.value = data;
        } else if (data != null && data['data'] is List) {
          clubMembersList.value = data['data'];
        } else {
          clubMembersList.clear();
        }
      }
    } catch (e) {
      debugPrint("Error fetching club members: $e");
    } finally {
      isClubMembersLoading.value = false;
    }
  }

  final RxList<dynamic> clubJoinRequestsList = <dynamic>[].obs;
  final RxBool isClubJoinRequestsLoading = false.obs;

  Future<void> getClubJoinRequests(String clubId) async {
    isClubJoinRequestsLoading.value = true;
    try {
      final response = await ApiClient.getData(
        ApiUrl.getJoinRequests(clubId: clubId),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body['data'];
        if (data is List) {
          clubJoinRequestsList.value = data;
        } else if (data != null && data['data'] is List) {
          clubJoinRequestsList.value = data['data'];
        } else {
          clubJoinRequestsList.clear();
        }
      }
    } catch (e) {
      debugPrint("Error fetching club join requests: $e");
    } finally {
      isClubJoinRequestsLoading.value = false;
    }
  }

  Future<void> handleJoinRequest({
    required String clubId,
    required String memberId,
    required String action, // "approve" or "reject"
  }) async {
    try {
      final response = await ApiClient.patchData(
        ApiUrl.handleRequest(clubId: clubId),
        jsonEncode({"memberId": memberId, "action": action}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Request ${action}d successfully", isError: false);
        // Remove from list
        clubJoinRequestsList.removeWhere((req) {
          final id = req['_id'] ?? req['id'];
          return id == memberId;
        });
        clubJoinRequestsList.refresh();
      } else {
        showCustomSnackBar(
          response.body['message'] ?? "Failed to handle request",
        );
      }
    } catch (e) {
      debugPrint("Error handling join request: $e");
    }
  }

  Future<void> changeMemberRole({
    required String clubId,
    required String memberId,
    required String role, // "ADMIN" or "MEMBER"
  }) async {
    try {
      final response = await ApiClient.patchData(
        ApiUrl.changeRole(clubId: clubId),
        jsonEncode({"memberId": memberId, "role": role}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Role updated successfully", isError: false);
        getClubMembers(clubId);
        getSingleClub(clubId);
      } else {
        showCustomSnackBar(response.body['message'] ?? "Failed to update role");
      }
    } catch (e) {
      debugPrint("Error changing role: $e");
    }
  }

  Future<void> removeClubMember({
    required String clubId,
    required String memberId,
  }) async {
    try {
      final response = await ApiClient.deleteData(
        ApiUrl.removeMember(clubId: clubId, memberId: memberId),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Member removed successfully", isError: false);
        getClubMembers(clubId);
        getSingleClub(clubId);
      } else {
        showCustomSnackBar(
          response.body['message'] ?? "Failed to remove member",
        );
      }
    } catch (e) {
      debugPrint("Error removing member: $e");
    }
  }

  Future<bool> updateClub({
    required String clubId,
    required String clubName,
    required String description,
    List<String>? categories,
    required String accessType,
    File? logo,
    File? banner,
  }) async {
    isCreateClubLoading.value = true;
    try {
      Map<String, dynamic> body = {
        'clubName': clubName,
        'description': description,
        if (categories != null && categories.isNotEmpty)
          'categories': categories,
        'accessType': accessType,
      };

      List<MultipartBody> multipartBodyList = [];

      if (logo != null) {
        multipartBodyList.add(MultipartBody('logo', logo));
      }
      if (banner != null) {
        multipartBodyList.add(MultipartBody('banner', banner));
      }

      final response = await ApiClient.patchMultipartData(
        ApiUrl.updateClub(clubId: clubId),
        {"data": jsonEncode(body)},
        multipartBody: multipartBodyList,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Club updated successfully!", isError: false);
        getSingleClub(clubId);
        getAllClubs();
        getMyClubs();
        return true;
      } else {
        showCustomSnackBar(response.body['message'] ?? 'Failed to update club');
        return false;
      }
    } catch (e) {
      debugPrint("Error updating club: $e");
      showCustomSnackBar('An error occurred');
      return false;
    } finally {
      isCreateClubLoading.value = false;
    }
  }

  Future<bool> deleteClub(String clubId) async {
    isCreateClubLoading.value = true;
    try {
      final response = await ApiClient.deleteData(
        ApiUrl.deleteClub(clubId: clubId),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Club deleted successfully!", isError: false);
        getAllClubs();
        getMyClubs();
        return true;
      } else {
        showCustomSnackBar(response.body['message'] ?? 'Failed to delete club');
        return false;
      }
    } catch (e) {
      debugPrint("Error deleting club: $e");
      showCustomSnackBar('An error occurred');
      return false;
    } finally {
      isCreateClubLoading.value = false;
    }
  }

  // Loading state for joining a club
  final RxBool isJoinClubLoading = false.obs;

  Future<void> joinClub(String clubId) async {
    if (isJoinClubLoading.value) return; // prevent duplicate calls
    isJoinClubLoading.value = true;
    try {
      final response = await ApiClient.postData(
        ApiUrl.joinClub(clubId: clubId),
        jsonEncode({}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("join club successful", isError: false);

        // Optimistic UI Update for single club
        if (currentClubDetail.value?.id == clubId) {
          String access = (currentClubDetail.value?.accessType ?? "PUBLIC")
              .toUpperCase();
          if (access == "PUBLIC") {
            currentClubDetail.value?.isClubJoined = true;
            currentClubDetail.value?.isJoinRequestPending = false;
          } else {
            currentClubDetail.value?.isClubJoined = false;
            currentClubDetail.value?.isJoinRequestPending = true;
          }
          currentClubDetail.refresh();
        }

        // Optimistic UI Update for all clubs list
        int index = allClubs.indexWhere((c) => c.id == clubId);
        if (index != -1) {
          String access = (allClubs[index].accessType ?? "PUBLIC")
              .toUpperCase();
          if (access == "PUBLIC") {
            allClubs[index].isClubJoined = true;
            allClubs[index].isJoinRequestPending = false;
          } else {
            allClubs[index].isClubJoined = false;
            allClubs[index].isJoinRequestPending = true;
          }
          allClubs.refresh();
        }

        getSingleClub(clubId); // Refresh details
        getMyClubs(); // Refresh my clubs
      } else {
        showCustomSnackBar(response.body['message'] ?? 'Failed to join club');
      }
    } catch (e) {
      debugPrint("Error joining club: $e");
      showCustomSnackBar('An error occurred');
    }
  }

  Future<void> leaveClub(String clubId) async {
    try {
      final response = await ApiClient.postData(
        ApiUrl.leaveClub(clubId: clubId),
        jsonEncode({}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("Left club successfully", isError: false);

        // Optimistic UI Update for single club
        if (currentClubDetail.value?.id == clubId) {
          currentClubDetail.value?.isClubJoined = false;
          currentClubDetail.refresh();
        }

        // Optimistic UI Update for all clubs list
        int index = allClubs.indexWhere((c) => c.id == clubId);
        if (index != -1) {
          allClubs[index].isClubJoined = false;
          allClubs.refresh();
        }

        getSingleClub(clubId); // Refresh details
        getMyClubs(); // Refresh my clubs
      } else {
        showCustomSnackBar(response.body['message'] ?? 'Failed to leave club');
      }
    } catch (e) {
      debugPrint("Error leaving club: $e");
      showCustomSnackBar('An error occurred');
    }
  }

  @override
  void onClose() {
    sessionSummaryCtrl.dispose();
    sessionVehicleCtrl.dispose();
    sessionCircuitCtrl.dispose();
    sessionTrackNameCtrl.dispose();
    sessionBestLapTimeCtrl.dispose();
    sessionTopSpeedCtrl.dispose();
    spotLicensePlateCtrl.dispose();
    spotRegionCtrl.dispose();
    spotMakeAndModelCtrl.dispose();
    spotEngineCtrl.dispose();
    spotPowerHpCtrl.dispose();
    trackCircuitCtrl.dispose();
    trackNotesCtrl.dispose();
    clubTitleCtrl.dispose();
    clubDetailsCtrl.dispose();
    businessTitleCtrl.dispose();
    businessDescCtrl.dispose();
    businessPriceCtrl.dispose();
    audioPlayer.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}

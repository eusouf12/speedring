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

class HomeController extends GetxController {
  final rxActiveTab = 0.obs; // 0: POST, 1: EVENTS, 2: CLUBS
  void changeTab(int index) => rxActiveTab.value = index;
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
        String token = await SharePrefsHelper.getString(AppConstants.bearerToken);
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

  Future<void> deletePost(String postId) async {
    try {
      var response = await ApiClient.deleteData(ApiUrl.deletePost(postId: postId));
      if (response.statusCode == 200 || response.statusCode == 201) {
        postsList.removeWhere((post) => post.id == postId);
        showCustomSnackBar("Post deleted successfully", isError: false);
      } else {
        showCustomSnackBar("Failed to delete post", isError: true);
      }
    } catch (e) {
      debugPrint("Error deleting post: $e");
      showCustomSnackBar("Error deleting post", isError: true);
    }
  }

  final RxSet<String> reactingPostIds = <String>{}.obs;

  Future<void> reactToPost(String postId, {String reactType = "LOVE"}) async {
    if (reactingPostIds.contains(postId)) return;
    reactingPostIds.add(postId);

    final index = postsList.indexWhere((element) => element.id == postId);
    if (index == -1) {
      reactingPostIds.remove(postId);
      return;
    }

    final originalPost = postsList[index];
    final alreadyLiked = originalPost.isReacted ?? false;

    List<PostReact> updatedReacts = List.from(originalPost.reacts ?? []);
    int updatedReactCount = originalPost.reactCount ?? 0;

    if (alreadyLiked) {
      updatedReacts.removeWhere((r) => r.user?.id == currentUserId.value);
      updatedReactCount = (updatedReactCount > 0) ? (updatedReactCount - 1) : 0;
    } else {
      updatedReacts.add(PostReact(
        id: "temp",
        reactType: reactType,
        user: PostUser(id: currentUserId.value),
        reactedAt: DateTime.now(),
      ));
      updatedReactCount = updatedReactCount + 1;
    }

    postsList[index] = PostModel(
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

    try {
      var response = await ApiClient.patchData(
        ApiUrl.reactPost(postId: postId),
        jsonEncode({"reactType": reactType}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseBody = response.body is String ? jsonDecode(response.body) : response.body;
        if (responseBody["data"] != null) {
          final data = responseBody["data"];
          final reactsJson = data["reacts"] ?? [];
          final backendReacts = List<PostReact>.from(reactsJson.map((x) => PostReact.fromJson(x)));
          final backendReactCount = data["reactCount"] ?? backendReacts.length;
          
          final isReacted = currentUserId.value.isNotEmpty
              ? backendReacts.any((r) => r.user?.id == currentUserId.value)
              : !alreadyLiked;

          postsList[index] = PostModel(
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
        }
      } else {
        postsList[index] = originalPost;
        showCustomSnackBar("Failed to update reaction", isError: true);
      }
    } catch (e) {
      debugPrint("Error reacting to post: $e");
      postsList[index] = originalPost;
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
        showCustomSnackBar("Comment deleted successfully", isError: false);
      } else {
        showCustomSnackBar("Failed to delete comment", isError: true);
      }
    } catch (e) {
      debugPrint("Error deleting comment: $e");
    }
  }

  Future<void> replyToComment(String postId, String commentId, String replyText) async {
    try {
      var response = await ApiClient.postData(
        ApiUrl.commentPostReply(postId: postId, commentId: commentId),
        jsonEncode({"comment": replyText}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        getPost();
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
  final RxString currentUserId = "".obs;

  @override
  void onInit() {
    super.onInit();
    getStories();
    getPost();
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

  @override
  void onClose() {
    audioPlayer.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}

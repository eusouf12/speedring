class ApiUrl {
  // static const String baseUrl =
  //     "https://comparable-leasing-overcome-prix.trycloudflare.com/api/v1";
  // static const String imageUrl =
  //     "https://comparable-leasing-overcome-prix.trycloudflare.com";

  //=============== wINDOWS ======================
  static const String baseUrl = "http://10.10.28.90:4050/api/v1";
  static const String imageUrl = "http://10.10.28.90:4050";

  //========================= Mac ========================
  // static const String baseUrl = "http://10.0.2.2:4050/api/v1";
  // static const String imageUrl = "http://10.0.2.2:4050";
  static String socketUrl = imageUrl;
  static String mapKey = "AIzaSyCHBKvR2Wgc4eF53nYTlGYxULSQuVpb9t4";

  ///========================= Authentication =========================
  static const String signUp = "/auth/register";
  static const String signIn = "/auth/login";
  static const String verificationOtp = "/auth/verify-otp";
  static const String forgotPassword = "/auth/forgot-password";
  static const String verificationOtpForgetPass =
      "/auth/verify-forgot-password-otp";
  static const String resendOtp = "/auth/resend-otp";
  static const String registerBusiness = "/auth/register-business";
  static const String setupUserProfile = "/users/driver/setup-profile";

  static const String newPassword = "/auth/reset-password";

  // =================== my profile =====================================
  static const String myProfile = "/users/my-profile";
  static const String updateProfile = "/users/update-profile";
  static const String addVehicle = "/users/add-vehicle";
  static String updateVehicle(String id) => "/users/update-vehicle/$id";
  static String deleteVehicle(String id) => "/users/delete-vehicle/$id";
  static String myVehicles({required int page}) =>
      "/users/my-vehicles?page=$page&limit=10";
  static const String allPlans = "/plans/all-plans";
  static String buyPlan({required String planId}) =>
      "/payments/create-checkout-session/$planId";

  static const String getActiveCoinPackages =
      "/coin-packages/get-active-packages";
  static String buyCoinPackage(String packageId) =>
      "/payments/create-coin-checkout-session/$packageId";
  static const String getMyWallet = "/wallets/my-wallet";
  static const String getMyTransactions = "/payments/my-transactions";
  static const String supportDriver = "/wallets/support-driver";
  static const String getMyFollowing = "/users/my-following";

  static const String privacyPolicy = "/legal-docs/privacy-policy";
  static const String termsCondition = "/legal-docs/terms-conditions";
  static const String aboutUs = "/legal-docs/about-us";
  static const String contactUs = "/contact";
  static const String changePassword = "/auth/change-password";

  ///========================= User =========================
  static const String createStory = "/stories/create-story";
  static const String getAllStory = "/stories/get-all-user-stories";
  static const String getAllMusic = "/music/get-all-audio";
  static String deleteStory({required String storyId}) =>
      "/stories/delete-story/$storyId";
  static String likeStory({required String storyId}) =>
      "/stories/react-story/$storyId";
  static String viewStory({required String storyId}) =>
      "/stories/get-story-viewers/$storyId";
  static String postViewStory({required String storyId}) =>
      "/stories/view-story/$storyId";
  // =======post===============
  static String getAllPosts({
    required int page,
    required int limit,
    String? searchTerm,
    String? category,
    String? clubId,
  }) {
    String url = "/posts/get-all-posts?page=$page&limit=$limit";
    if (searchTerm != null && searchTerm.isNotEmpty) {
      url += "&searchTerm=${Uri.encodeComponent(searchTerm)}";
    }
    if (category != null && category.isNotEmpty) {
      url += "&category=${Uri.encodeComponent(category)}";
    }
    if (clubId != null && clubId.isNotEmpty) {
      url += "&clubId=${Uri.encodeComponent(clubId)}";
    }
    return url;
  }

  static String deletePost({required String postId}) =>
      "/posts/delete-post/$postId";
  static String getSinglePost({required String postId}) =>
      "/posts/view-post/$postId";
  static String reactPost({required String postId}) =>
      "/posts/react-post/$postId";
  static String commentPost({required String postId}) =>
      "/posts/comment-post/$postId";
  static String commentPostReply({
    required String postId,
    required String commentId,
  }) => "/posts/$postId/comment/$commentId/reply";

  static String toggleSavePost({required String postId}) =>
      "/posts/toggle-save/$postId";
  static String getSavedPosts({required int page, required int limit}) =>
      "/posts/saved-posts?page=$page&limit=$limit";
  static String deleteComment({
    required String postId,
    required String commentId,
  }) => "/posts/$postId/comment/$commentId";
  static String getPostInteractions({required String postId}) =>
      "/posts/get-post-interactions/$postId";
  static const String createPost = "/posts/create-post";
  static String getUserPosts({required String userId, int page = 1, int limit = 10}) =>
      "/posts/user-posts/$userId?page=$page&limit=$limit";
  static String getUserVehicles({required String userId, int page = 1}) =>
      "/users/user-vehicles/$userId?page=$page";
  static const String getMyClubs = "/clubs/get-my-clubs";
  static String getEvents({int page = 1, int limit = 10, String? searchTerm}) {
    String url = "/events/get-all-events?page=$page&limit=$limit";
    if (searchTerm != null && searchTerm.isNotEmpty) {
      url += "&searchTerm=${Uri.encodeComponent(searchTerm)}";
    }
    return url;
  }

  static String getAllTracks({
    int page = 1,
    int limit = 10,
    String? searchTerm,
    double? lat,
    double? lng,
  }) {
    String url = "/tracks/get-all-tracks?page=$page&limit=$limit";
    if (searchTerm != null && searchTerm.isNotEmpty) {
      url += "&searchTerm=${Uri.encodeComponent(searchTerm)}";
    }
    if (lat != null && lng != null) {
      url += "&lat=$lat&lng=$lng";
    }
    return url;
  }

  // ============ Events =========
  static const String createEvent = "/events/create-event";
  static const String getMyEvent = "/events/get-my-event";
  static String getSingleEvent({required String eventId}) =>
      "/events/view-event/$eventId";
  static String joinEvent({required String eventId}) =>
      "/events/join-event/$eventId";
  static String reactEvent({required String eventId}) =>
      "/events/react-event/$eventId";
  static String commentEvent({required String eventId}) =>
      "/events/add-comment/$eventId";
  static String shareEvent({required String eventId}) =>
      "/events/share-event/$eventId";
  static String getEventInteractions({required String eventId}) =>
      "/events/get-event-interactions/$eventId";
  static String deleteEvent({required String eventId}) =>
      "/events/delete-event/$eventId";
  static String deleteEventComment({
    required String eventId,
    required String commentId,
  }) => "/events/$eventId/comment/$commentId";
  static String reactEventComment({
    required String eventId,
    required String commentId,
  }) => "/events/$eventId/comment/$commentId/react";
  static String replyEventComment({
    required String eventId,
    required String commentId,
  }) => "/events/$eventId/comment/$commentId/reply";
  // ============ Clubs =========
  static const String createClub = "/clubs/create-club";
  static String getAllClubs({String? searchTerm}) {
    String url = "/clubs/get-all-clubs";
    if (searchTerm != null && searchTerm.isNotEmpty) {
      url += "?searchTerm=${Uri.encodeComponent(searchTerm)}";
    }
    return url;
  }

  static String updateClub({required String clubId}) =>
      "/clubs/update-club/$clubId";
  static String deleteClub({required String clubId}) =>
      "/clubs/delete-club/$clubId";
  static String joinClub({required String clubId}) => "/clubs/$clubId/join";
  static String leaveClub({required String clubId}) => "/clubs/$clubId/leave";
  static String getSingleClub({required String clubId}) =>
      "/clubs/view-club/$clubId";
  static String changeRole({required String clubId}) =>
      "/clubs/$clubId/change-role";
  static String removeMember({
    required String clubId,
    required String memberId,
  }) => "/clubs/$clubId/remove-member/$memberId";
  static String handleRequest({required String clubId}) =>
      "/clubs/$clubId/handle-request";
  static String shareClub({required String clubId}) => "/clubs/$clubId/share";
  static String createClubPost({required String clubId}) =>
      "/clubs/$clubId/create-post";
  static String getClubMembers({required String clubId}) =>
      "/clubs/$clubId/members";
  static String getJoinRequests({required String clubId}) =>
      "/clubs/$clubId/join-requests";

  // static String getRecommendedCountries ({required String page}) => "/recommendations/history?page=$page&limit=10";

  // ============ Discover =========
  static const String createDiscoverPost = "/discovers/create-discover-post";
  static String getAllDiscoverPosts({
    int page = 1,
    int limit = 10,
    String searchTerm = '',
  }) {
    final q = searchTerm.isNotEmpty
        ? '&searchTerm=${Uri.encodeComponent(searchTerm)}'
        : '';
    return "/discovers/get-all-discover-posts?page=$page&limit=$limit$q";
  }

  static String editDiscoverPost({required String postId}) =>
      "/discovers/edit-discover-post/$postId";
  static String deleteDiscoverPost({required String postId}) =>
      "/discovers/delete-my-post/$postId";
  static String toggleFollow({required String userId}) =>
      "/users/$userId/toggle-follow";
  static String getDiscoverNetworkUsers({
    int page = 1,
    String searchTerm = '',
  }) {
    final q = searchTerm.isNotEmpty
        ? '&searchTerm=${Uri.encodeComponent(searchTerm)}'
        : '';
    return "/users/discover?page=$page&limit=20$q";
  }

  // ============ Videos =========
  static const String createVideoPost = "/videos/create-video-post";
  static String getAllVideos({
    int page = 1,
    int limit = 10,
    String classification = '',
    String searchTerm = '',
  }) {
    var q = "page=$page&limit=$limit";
    if (classification.isNotEmpty && classification != 'All') {
      q += '&classification=${Uri.encodeComponent(classification)}';
    }
    if (searchTerm.isNotEmpty) {
      q += '&searchTerm=${Uri.encodeComponent(searchTerm)}';
    }
    return "/videos/get-all-videos?$q";
  }

  static String deleteVideo({required String videoId}) =>
      "/videos/delete-video/$videoId";
  static String editVideo({required String videoId}) =>
      "/videos/edit-video/$videoId";
  static String shareVideo({required String videoId}) =>
      "/videos/share-video/$videoId";
  static String incrementVideoViews({required String videoId}) =>
      "/videos/increment-views/$videoId";

  // ============ Marketplace =========
  static String getAllMarketplaceListings({
    int page = 1,
    int limit = 10,
    String? category,
    String? searchTerm,
  }) {
    String url = "/marketplaces/get-all-listings?page=$page&limit=$limit";
    if (category != null && category.isNotEmpty) {
      url += "&category=${Uri.encodeComponent(category)}";
    }
    if (searchTerm != null && searchTerm.isNotEmpty) {
      url += "&searchTerm=${Uri.encodeComponent(searchTerm)}";
    }
    return url;
  }

  static String get createMarketplaceListing => "/marketplaces/create-listing";
  static String getMyListings({int page = 1, String? category}) {
    String url = "/marketplaces/get-my-listings?page=$page&limit=10";
    if (category != null && category.isNotEmpty && category != "ALL") {
      url += "&category=${Uri.encodeComponent(category)}";
    }
    return url;
  }

  static String viewListing(String id) => "/marketplaces/view-listing/$id";
  static String editListing(String id) => "/marketplaces/edit-listing/$id";
  static String deleteListing(String id) => "/marketplaces/delete-listing/$id";

  // =================== Drive Sessions =====================================
  static const String createSession = "/drive-sessions/create-session";
  static const String mySessions = "/drive-sessions/my-sessions";
  static const String getMySessionStats =
      "/drive-sessions/get-my-session-stats";
  static String deleteSession(String id) =>
      "/drive-sessions/delete-session/$id";

  // =================== Expeditions (Group Drives) =====================================
  static const String createExpedition = "/expeditions/create-expedition";

  static String getAllExpeditions({
    int page = 1,
    int limit = 10,
    String? type,
  }) {
    String url = "/expeditions/get-all-expeditions?page=$page&limit=$limit";
    if (type != null && type.isNotEmpty) {
      url += "&type=${Uri.encodeComponent(type)}";
    }
    return url;
  }

  static String getSingleExpedition(String id) =>
      "/expeditions/single-expedition/$id";
  static String joinExpedition(String id) => "/expeditions/join-expedition/$id";
  static String getExpeditionParticipants(String id) =>
      "/expeditions/get-expedition-participants/$id";
  static String startExpedition(String id) =>
      "/expeditions/start-expedition/$id";
  static String endExpedition(String id) => "/expeditions/end-expedition/$id";
  static String updateExpedition(String id) =>
      "/expeditions/update-expedition/$id";
  static String deleteExpedition(String id) =>
      "/expeditions/delete-expedition/$id";

  // =================== Videos / Reels =====================================
  // static const String createVideoPost = "/videos/create-video-post";
  // static const String getAllVideos = "/videos/get-all-videos";
  // static const String getMyVideos = "/videos/get-my-videos";
  // static String deleteVideo(String id) => "/videos/delete-video/$id";
  static String getSingleVideo(String id) => "/videos/get-single-video/$id";
}

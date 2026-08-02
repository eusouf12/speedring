class ApiUrl {
  static const String baseUrl = "http://10.10.28.90:4050/api/v1";
  static const String imageUrl = "http://10.10.28.90:4050";
  static String socketUrl = baseUrl;
  static String mapKey = "AIzaSyCHBKvR2Wgc4eF53nYTlGYxULSQuVpb9t4";

  ///========================= Authentication =========================
  static const String signUp = "/auth/register";
  static const String signIn = "/auth/login";
  static const String verificationOtp = "/auth/verify-otp";
  static const String forgotPassword = "/auth/forgot-password";
  static const String verificationOtpForgetPass =
      "/auth/verify-forgot-password-otp";
  static const String resendOtp = "/auth/resend-otp";
  static const String setupUserProfile = "/users/driver/setup-profile";

  static const String newPassword = "/auth/reset-password";

  // =================== my profile =====================================
  static const String myProfile = "/users/my-profile";
  static const String updateProfile = "/users/update-profile";
  static const String allPlans = "/plans/all-plans";
  static String buyPlan({required String planId}) =>
      "/payments/create-checkout-session/$planId";

  static const String privacyPolicy = "/legal-docs/privacy-policy";
  static const String termsCondition = "/legal-docs/terms-conditions";
  static const String aboutUs = "/legal-docs/about-us";
  static const String contactUs = "/contact";
  static const String changePassword = "/auth/change-password";

  ///========================= User =========================
  static const String createStory = "/stories/create-story";
  static const String getAllStory = "/stories/get-all-user-stories";
  static String deleteStory({required String storyId}) =>
      "/stories/delete-story/$storyId";
  static String likeStory({required String storyId}) =>
      "/stories/react-story/$storyId";
  static String viewStory({required String storyId}) =>
      "/stories/get-story-viewers/$storyId";
  static String postViewStory({required String storyId}) =>
      "/stories/view-story/$storyId";
  static String getAllPosts({
    required int page,
    required int limit,
    String? searchTerm,
    String? category,
  }) {
    String url = "/posts/get-all-posts?page=$page&limit=$limit";
    if (searchTerm != null && searchTerm.isNotEmpty) {
      url += "&searchTerm=${Uri.encodeComponent(searchTerm)}";
    }
    if (category != null && category.isNotEmpty) {
      url += "&category=${Uri.encodeComponent(category)}";
    }
    return url;
  }

  static String deletePost({required String postId}) =>
      "/posts/delete-post/$postId";
  static String reactPost({required String postId}) =>
      "/posts/react-post/$postId";
  static String commentPost({required String postId}) =>
      "/posts/comment-post/$postId";
  static String commentPostReply({
    required String postId,
    required String commentId,
  }) =>
      "/posts/$postId/comment/$commentId/reply";
  static String deleteComment({
    required String postId,
    required String commentId,
  }) =>
      "/posts/$postId/comment/$commentId";
  // static String getRecommendedCountries ({required String page}) => "/recommendations/history?page=$page&limit=10";
}

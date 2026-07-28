class ApiUrl {
  static const String baseUrl = "http://10.10.28.90:4050/api/v1";
  static const String imageUrl = "http://10.10.28.90:4050";
  static String socketUrl = baseUrl;

  ///========================= Authentication =========================
  static const String signUp = "/auth/signup";
  static const String signIn = "/auth/login";
  static const String verificationOtp = "/auth/verify-signup-otp";
  static const String forgotPassword = "/auth/forgot-password";
  static const String verificationOtpForgetPass = "/auth/verify-reset-otp";
  static const String newPassword = "/auth/reset-password";
  static const String setupUserProfile = "/users/driver/setup-profile";

  // =================== my profile =====================================
  static const String privacyPolicy = "/legal-docs/privacy-policy";
  static const String termsCondition = "/legal-docs/terms-conditions";
  static const String aboutUs = "/legal-docs/about-us";
  static const String contactUs = "/contact";
  static const String changePassword = "/auth/change-password";
  static const String myProfile = "/auth/me";
  static const String updateProfile = "/users/update-user";

  ///========================= User =========================
  // static String getRecommendedCountries ({required String page}) => "/recommendations/history?page=$page&limit=10";
}

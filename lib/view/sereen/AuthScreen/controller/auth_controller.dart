import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/helper/shared_prefe/shared_prefe.dart';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import 'package:speedring/utils/app_const/app_const.dart';

class AuthController extends GetxController {
  // ──----------------- Login ───────────────────────────────
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // final emailController = TextEditingController(
  //   text: "ahteshamulhasan18@gmail.com",
  // );
  final emailController = TextEditingController(text: "riyaj@gmail.com");
  // final passwordController = TextEditingController(text: "SecurePassword123");
  final passwordController = TextEditingController(text: "12345Eu@");

  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> loginValidator() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;

    Map<String, String> body = {
      'email': emailController.text.trim(),
      'password': passwordController.text,
    };

    try {
      var response = await ApiClient.postData(ApiUrl.signIn, jsonEncode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonResponse = _parseResponseBody(response.body);
        showCustomSnackBar(
          jsonResponse['message'] ?? "Login successful",
          isError: false,
        );

        var dataMap = jsonResponse['data'] as Map<String, dynamic>? ?? {};
        String accessToken =
            dataMap['token']?.toString() ??
            dataMap['accessToken']?.toString() ??
            "";

        var userMap = dataMap['user'] as Map<String, dynamic>? ?? {};
        String role = userMap['role']?.toString() ?? "";
        bool isProfileSetup = userMap['isProfileSetup'] == true;

        var subscriptionPlan =
            userMap['subscriptionPlan'] as Map<String, dynamic>? ?? {};
        String planName = subscriptionPlan['name']?.toString() ?? "";

        await SharePrefsHelper.setString(AppConstants.bearerToken, accessToken);

        if (role.isNotEmpty) {
          await SharePrefsHelper.setString(AppConstants.role, role);
        }

        if (planName.isNotEmpty) {
          await SharePrefsHelper.setString(
            AppConstants.subscriptionPlanName,
            planName,
          );
        }

        if (role == 'driver') {
          if (isProfileSetup) {
            Get.offAllNamed(AppRoutes.userHomeScreen);
          } else {
            Get.toNamed(AppRoutes.setupProfileScreen1);
          }
        } else {
          Get.offAllNamed(AppRoutes.businessHomeScreen);
        }
      } else {
        Map<String, dynamic> errorResponse = _parseResponseBody(response.body);
        showCustomSnackBar(
          errorResponse['message'] ?? 'Login failed. Please try again.',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint("Login error: $e");
      showCustomSnackBar("Something went wrong", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // ── Signup ───────────────────────────────────────────────────────────────
  final signupFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final signupRole = 'driver'.obs;

  final RxBool isSignupPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool isSignupLoading = false.obs;
  final RxBool isTermsAgreed = false.obs;
  final RxBool isAgeConfirmed = false.obs; // Used as a fallback

  final RxBool isAgeVerifiedFromPreviousScreen = false.obs;
  final RxString selectedAgeGroup = '18+'.obs; // Dropdown value

  void toggleSignupPasswordVisibility() {
    isSignupPasswordVisible.value = !isSignupPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> signupValidator() async {
    if (!signupFormKey.currentState!.validate()) return;
    if (!isTermsAgreed.value) {
      showCustomSnackBar(
        "You must agree to the Terms of Service",
        isError: true,
      );
      return;
    }

    isSignupLoading.value = true;

    Map<String, dynamic> body = {
      'name': nameController.text.trim(),
      'userName': usernameController.text.trim(),
      'email': signupEmailController.text.trim(),
      'password': signupPasswordController.text,
      'confirmPassword': confirmPasswordController.text,
      'ageGroup': isAgeVerifiedFromPreviousScreen.value
          ? (isAgeConfirmed.value ? '18+' : '16+')
          : selectedAgeGroup.value,
      'agreedToTerms': isTermsAgreed.value,
      'role': signupRole.value,
    };

    try {
      var response = await ApiClient.postData(ApiUrl.signUp, jsonEncode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonResponse = _parseResponseBody(response.body);
        showCustomSnackBar(
          jsonResponse['message'] ?? "Signup successful",
          isError: false,
        );

        Get.toNamed(
          AppRoutes.verifyOtpScreen,
          arguments: {
            'email': signupEmailController.text.trim(),
            'isSignup': true,
          },
        );
      } else {
        Map<String, dynamic> errorResponse = _parseResponseBody(response.body);
        showCustomSnackBar(
          errorResponse['message'] ?? 'Signup failed',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint("Signup error: $e");
      showCustomSnackBar("Something went wrong", isError: true);
    } finally {
      isSignupLoading.value = false;
    }
  }

  // ── Forgot Password ──────────────────────────────────────────────────────
  final forgotFormKey = GlobalKey<FormState>();
  final forgotEmailController = TextEditingController();
  final RxBool isForgotLoading = false.obs;

  Future<void> sendOtp() async {
    if (!forgotFormKey.currentState!.validate()) return;
    isForgotLoading.value = true;

    Map<String, String> body = {'email': forgotEmailController.text.trim()};

    try {
      var response = await ApiClient.postData(
        ApiUrl.forgotPassword,
        jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonResponse = _parseResponseBody(response.body);
        showCustomSnackBar(
          jsonResponse['message'] ?? "OTP sent to your email",
          isError: false,
        );

        _startResendCountdown();
        Get.toNamed(
          AppRoutes.verifyOtpScreen,
          arguments: {
            'email': forgotEmailController.text.trim(),
            'isSignup': false,
          },
        );
      } else {
        Map<String, dynamic> errorResponse = _parseResponseBody(response.body);
        showCustomSnackBar(
          errorResponse['message'] ?? 'Request failed',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint("Forgot password error: $e");
      showCustomSnackBar("Something went wrong", isError: true);
    } finally {
      isForgotLoading.value = false;
    }
  }

  // ── Verify OTP ───────────────────────────────────────────────────────────
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

  final RxBool isOtpLoading = false.obs;
  final RxInt resendCountdown = 0.obs;
  Timer? _resendTimer;

  // Track reset token from forgot password OTP
  String _resetToken = '';

  void _startResendCountdown({int seconds = 60}) {
    resendCountdown.value = seconds;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (resendCountdown.value <= 0) {
        t.cancel();
      } else {
        resendCountdown.value--;
      }
    });
  }

  // ── Resend otp ───────────────────────────────────────────────────
  Future<void> resendOtp() async {
    String email = Get.arguments?['email'] ?? forgotEmailController.text.trim();
    if (email.isEmpty) {
      email = signupEmailController.text.trim();
    }

    if (email.isEmpty) {
      showCustomSnackBar("Email is missing", isError: true);
      return;
    }

    isForgotLoading.value = true;
    Map<String, String> body = {'email': email};

    try {
      var response = await ApiClient.postData(
        ApiUrl.resendOtp,
        jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showCustomSnackBar("OTP resent successfully", isError: false);
        _startResendCountdown();
      } else {
        Map<String, dynamic> errorResponse = _parseResponseBody(response.body);
        showCustomSnackBar(
          errorResponse['message'] ?? 'Failed to resend OTP',
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar("Something went wrong", isError: true);
    } finally {
      isForgotLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    final otp = otpControllers.map((c) => c.text).join();
    if (otp.length < 4) {
      showCustomSnackBar("Please enter a valid OTP", isError: true);
      return;
    }

    isOtpLoading.value = true;

    bool isSignup = Get.arguments?['isSignup'] ?? false;
    String email = Get.arguments?['email'] ?? '';

    Map<String, dynamic> body = {'email': email, 'otp': otp};

    try {
      String url = isSignup
          ? ApiUrl.verificationOtp
          : ApiUrl.verificationOtpForgetPass;
      var response = await ApiClient.postData(url, jsonEncode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonResponse = _parseResponseBody(response.body);
        showCustomSnackBar(
          jsonResponse['message'] ?? "Account verified successfully!",
          isError: false,
        );

        if (!isSignup) {
          // For forgot password, we get a reset token
          if (jsonResponse['data'] != null) {
            if (jsonResponse['data'] is Map) {
              _resetToken =
                  jsonResponse['data']['resetToken']?.toString() ?? '';
            } else {
              _resetToken = jsonResponse['data'].toString();
            }
          }
          Get.toNamed(AppRoutes.resetPasswordScreen);
        } else {
          formKey = GlobalKey<FormState>();
          Get.offAllNamed(AppRoutes.loginScreen);
        }
      } else {
        Map<String, dynamic> errorResponse = _parseResponseBody(response.body);
        showCustomSnackBar(
          errorResponse['message'] ?? 'Verification failed',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint("Verify OTP error: $e");
      showCustomSnackBar("Something went wrong", isError: true);
    } finally {
      isOtpLoading.value = false;
    }
  }

  // ── Reset Password ────────────────────────────────────────────────────
  final resetFormKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  final RxString resetPasswordStrength = ''.obs;
  final RxBool isResetLoading = false.obs;

  Future<void> resetPassword() async {
    if (!resetFormKey.currentState!.validate()) return;
    isResetLoading.value = true;

    Map<String, dynamic> body = {
      'newPassword': newPasswordController.text,
      'confirmPassword': confirmNewPasswordController.text,
    };

    try {
      // Temporarily set bearer token to reset token to pass auth if needed
      await SharePrefsHelper.setString(AppConstants.bearerToken, _resetToken);

      var response = await ApiClient.postData(
        ApiUrl.newPassword,
        jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonResponse = _parseResponseBody(response.body);
        showCustomSnackBar(
          jsonResponse['message'] ?? "Password reset successfully.",
          isError: false,
        );

        // Remove reset token after success
        await SharePrefsHelper.remove(AppConstants.bearerToken);

        formKey = GlobalKey<FormState>();
        Get.offAllNamed(AppRoutes.loginScreen);
      } else {
        Map<String, dynamic> errorResponse = _parseResponseBody(response.body);
        showCustomSnackBar(
          errorResponse['message'] ?? 'Password reset failed',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint("Reset password error: $e");
      showCustomSnackBar("Something went wrong", isError: true);
    } finally {
      isResetLoading.value = false;
    }
  }

  Map<String, dynamic> _parseResponseBody(dynamic body) {
    if (body == null) return {};
    if (body is Map) return Map<String, dynamic>.from(body);
    if (body is String && body.isNotEmpty) {
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }
    return {};
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    usernameController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    confirmPasswordController.dispose();
    forgotEmailController.dispose();
    for (final c in otpControllers) {
      c.dispose();
    }
    for (final f in otpFocusNodes) {
      f.dispose();
    }
    _resendTimer?.cancel();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.onClose();
  }
}

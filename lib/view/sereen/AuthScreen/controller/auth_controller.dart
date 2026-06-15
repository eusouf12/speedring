import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/core/app_routes/app_routes.dart';

class AuthController extends GetxController {
  // ── Login ────────────────────────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> loginValidator() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    Get.toNamed(AppRoutes.setupProfileScreen1);
  }

  // ── Signup ───────────────────────────────────────────────────────────────
  final signupFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isSignupPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool isSignupLoading = false.obs;
  final RxBool isTermsAgreed = false.obs;
  final RxBool isAgeConfirmed = false.obs;

  void toggleSignupPasswordVisibility() {
    isSignupPasswordVisible.value = !isSignupPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> signupValidator() async {
    if (!signupFormKey.currentState!.validate()) return;
    isSignupLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isSignupLoading.value = false;
    // TODO: wire up real signup
  }

  // ── Forgot Password ──────────────────────────────────────────────────────
  final forgotFormKey = GlobalKey<FormState>();
  final forgotEmailController = TextEditingController();
  final RxBool isForgotLoading = false.obs;

  Future<void> sendOtp() async {
    if (!forgotFormKey.currentState!.validate()) return;
    isForgotLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isForgotLoading.value = false;
    _startResendCountdown();
    Get.toNamed(AppRoutes.verifyOtpScreen);
    // TODO: call API to send OTP
  }

  // ── Verify OTP ───────────────────────────────────────────────────────────
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes =
      List.generate(6, (_) => FocusNode());

  final RxBool isOtpLoading = false.obs;
  final RxInt resendCountdown = 0.obs;
  Timer? _resendTimer;

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

  Future<void> resendOtp() async {
    isForgotLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isForgotLoading.value = false;
    _startResendCountdown();
    // TODO: call API to resend OTP
  }

  Future<void> verifyOtp() async {
    final otp = otpControllers.map((c) => c.text).join();
    if (otp.length < 6) return;
    isOtpLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isOtpLoading.value = false;
    Get.toNamed(AppRoutes.resetPasswordScreen);
    // TODO: verify OTP with API
  }

  // ── Reset Password ───────────────────────────────────────────────────────
  final resetFormKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();
  final RxString resetPasswordStrength = ''.obs;
  final RxBool isResetLoading = false.obs;

  Future<void> resetPassword() async {
    if (!resetFormKey.currentState!.validate()) return;
    isResetLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isResetLoading.value = false;
    // TODO: call API to reset password
    Get.offAllNamed(AppRoutes.loginScreen);
  }

  @override
  void onClose() {
    // Login
    emailController.dispose();
    passwordController.dispose();
    // Signup
    nameController.dispose();
    usernameController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    confirmPasswordController.dispose();
    // Forgot
    forgotEmailController.dispose();
    // OTP
    for (final c in otpControllers) {
      c.dispose();
    }
    for (final f in otpFocusNodes) {
      f.dispose();
    }
    _resendTimer?.cancel();
    // Reset
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.onClose();
  }
}

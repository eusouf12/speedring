import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    // TODO: wire up real auth
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

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    usernameController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

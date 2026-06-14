import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_images/app_images.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_image/custom_image.dart';
import 'package:speedring/view/components/custom_loader/custom_loader.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import 'package:speedring/view/components/custom_text_field/custom_text_field.dart';
import 'package:speedring/view/sereen/AuthScreen/controller/auth_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: controller.resetFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Logo ──────────────────────────────────────────────────
                CustomImage(
                  imageSrc: AppImages.splashLogo,
                  imageType: ImageType.png,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),

                // ── Back arrow ────────────────────────────────────────────
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Heading ───────────────────────────────────────────────
                CustomText(
                  text: 'Your new password\nmust be secure.',
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  maxLines: 2,
                ),

                const SizedBox(height: 32),

                // ── New Password ──────────────────────────────────────────
                CustomText(
                  text: 'NEW PASSWORD',
                  color: Colors.white60,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  textEditingController: controller.newPasswordController,
                  hintText: '•••••••',
                  isPassword: true,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter new password';
                    if (v.length < 8) return 'Minimum 8 characters';
                    if (!v.contains(RegExp(r'[A-Z]'))) {
                      return 'Must have an uppercase letter';
                    }
                    if (!v.contains(RegExp(r'[0-9]'))) {
                      return 'Must contain a number';
                    }
                    if (!v.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
                      return 'Must contain a special character';
                    }
                    return null;
                  },
                  onChanged: (v) {
                    controller.resetPasswordStrength.value = v;
                  },
                ),

                const SizedBox(height: 20),

                // ── Confirm New Password ──────────────────────────────────
                CustomText(
                  text: 'CONFIRM PASSWORD',
                  color: Colors.white60,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  textEditingController: controller.confirmNewPasswordController,
                  hintText: '•••••••',
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Icon(
                      Icons.shield_outlined,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Confirm your password';
                    if (v != controller.newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 28),

                // ── Password strength hints ───────────────────────────────
                Obx(() {
                  final pwd = controller.resetPasswordStrength.value;
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Column(
                      children: [
                        _strengthRow(
                          'Minimum 8 characters',
                          pwd.length >= 8,
                        ),
                        const SizedBox(height: 10),
                        _strengthRow(
                          'Uppercase letter',
                          pwd.contains(RegExp(r'[A-Z]')),
                        ),
                        const SizedBox(height: 10),
                        _strengthRow(
                          'Number',
                          pwd.contains(RegExp(r'[0-9]')),
                        ),
                        const SizedBox(height: 10),
                        _strengthRow(
                          'Special character',
                          pwd.contains(
                              RegExp(r'[!@#\$%^&*(),.?":{}|<>]')),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 32),

                // ── UPDATE PASSWORD button ────────────────────────────────
                Obx(() {
                  return controller.isResetLoading.value
                      ? const CustomLoader()
                      : CustomButton(
                          onTap: () => controller.resetPassword(),
                          title: 'UPDATE PASSWORD  ⚡',
                          fillColor: const Color(0xffF5C400),
                          textColor: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          borderRadius: 16,
                        );
                }),

                const SizedBox(height: 32),

                // ── Footer ───────────────────────────────────────────────
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline,
                          color: Colors.white24, size: 12),
                      const SizedBox(width: 6),
                      CustomText(
                        text: 'END-TO-END ENCRYPTED SYSTEM UPDATE',
                        color: Colors.white24,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Strength indicator row ────────────────────────────────────────────────
  Widget _strengthRow(String label, bool met) {
    return Row(
      children: [
        Icon(
          met
              ? Icons.check_circle_outline_rounded
              : Icons.radio_button_unchecked_rounded,
          color: met ? const Color(0xffF5C400) : Colors.white24,
          size: 18,
        ),
        const SizedBox(width: 10),
        CustomText(
          text: label,
          color: met ? Colors.white70 : Colors.white30,
          fontSize: 13,
          fontWeight: met ? FontWeight.w500 : FontWeight.w400,
        ),
      ],
    );
  }
}

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

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: controller.signupFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Logo ──────────────────────────────────────────────────
                CustomImage(
                  imageSrc: AppImages.splashLogo,
                  imageType: ImageType.png,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),

                // ── Heading ───────────────────────────────────────────────
                Center(
                  child: CustomText(
                    text: 'Create Your Account',
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: CustomText(
                    text:
                        'Access elite racing metrics and\nperformance telemetry.',
                    color: Colors.white54,
                    fontSize: 15,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    fontFamily: 'Barlow',
                  ),
                ),

                const SizedBox(height: 28),

                // ── Full Name ─────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'Full Name',
                      color: Colors.white60,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffF5C400).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xffF5C400).withOpacity(0.3),
                        ),
                      ),
                      child: const CustomText(
                        text: 'IDENTITY_V1',
                        color: Color(0xffF5C400),
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  textEditingController: controller.nameController,
                  hintText: 'Driver Name',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Enter your name';
                    if (v.trim().length < 2) return 'Name too short';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ── Username ──────────────────────────────────────────────
                CustomText(
                  text: 'Username',
                  color: Colors.white60,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  textEditingController: controller.usernameController,
                  hintText: 'handle',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Icon(
                      Icons.alternate_email_rounded,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Enter a username';
                    }
                    if (v.trim().length < 3) return 'Minimum 3 characters';
                    if (v.contains(' ')) return 'No spaces allowed';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ── Email ─────────────────────────────────────────────────
                CustomText(
                  text: 'Email',
                  color: Colors.white60,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  textEditingController: controller.signupEmailController,
                  hintText: 'driver@speedring.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Icon(
                      Icons.mail_outline_rounded,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your email';
                    if (!GetUtils.isEmail(v)) return 'Enter a valid email';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ── Password ──────────────────────────────────────────────
                CustomText(
                  text: 'Password',
                  color: Colors.white60,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  textEditingController: controller.signupPasswordController,
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
                    if (v == null || v.isEmpty) return 'Enter a password';
                    if (v.length < 6) return 'Minimum 6 characters';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ── Confirm Password ──────────────────────────────────────
                CustomText(
                  text: 'Confirm',
                  color: Colors.white60,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  textEditingController: controller.confirmPasswordController,
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
                    if (v != controller.signupPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ── Checkboxes ────────────────────────────────────────────
                Obx(
                  () => _checkboxRow(
                    value: controller.isTermsAgreed.value,
                    onChanged: (v) =>
                        controller.isTermsAgreed.value = v ?? false,
                    richText: _termsRichText(),
                  ),
                ),

                const SizedBox(height: 10),

                Obx(
                  () => _checkboxRow(
                    value: controller.isAgeConfirmed.value,
                    onChanged: (v) =>
                        controller.isAgeConfirmed.value = v ?? false,
                    richText: const TextSpan(
                      text: 'I confirm that I am at least 16 years of age.',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ── CREATE ACCOUNT button ─────────────────────────────────
                Obx(() {
                  return controller.isSignupLoading.value
                      ? const CustomLoader()
                      : CustomButton(
                          onTap: () {
                            controller.signupValidator();
                          },
                          title: 'CREATE ACCOUNT',
                          fillColor: const Color(0xffF5C400),
                          textColor: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          borderRadius: 16,
                        );
                }),

                const SizedBox(height: 12),

                // ── CREATE BUSINESS ACCOUNT button ────────────────────────
                CustomButton(
                  onTap: () {
                    // TODO: business account flow
                  },
                  title: 'CREATE BUSINESS ACCOUNT',
                  fillColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  borderRadius: 16,
                  isBorder: true,
                  borderWidth: 1,
                  borderColor: Colors.white,
                ),

                const SizedBox(height: 32),

                // ── Already have account ───────────────────────────────────
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: 'Already have account? ',
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: CustomText(
                          text: 'Login',
                          color: const Color(0xffF5C400),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
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

  // ── Checkbox row helper ───────────────────────────────────────────────────
  Widget _checkboxRow({
    required bool value,
    required void Function(bool?) onChanged,
    required InlineSpan richText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xffF5C400),
            checkColor: Colors.black,
            side: const BorderSide(color: Colors.white38, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: RichText(text: richText)),
      ],
    );
  }

  // ── Terms & Privacy rich text ─────────────────────────────────────────────
  InlineSpan _termsRichText() {
    return TextSpan(
      style: const TextStyle(color: Colors.white60, fontSize: 13, height: 1.4),
      children: [
        const TextSpan(text: 'I agree to the '),
        WidgetSpan(
          child: GestureDetector(
            onTap: () {
              /* TODO: terms */
            },
            child: const Text(
              'Terms of Service',
              style: TextStyle(
                color: Color(0xffF5C400),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ),
        const TextSpan(text: ' and '),
        WidgetSpan(
          child: GestureDetector(
            onTap: () {
              /* TODO: privacy */
            },
            child: const Text(
              'Privacy Policy',
              style: TextStyle(
                color: Color(0xffF5C400),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

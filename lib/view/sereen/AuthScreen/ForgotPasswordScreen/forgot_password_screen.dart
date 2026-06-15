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

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: controller.forgotFormKey,
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

                const SizedBox(height: 40),

                // ── Heading ───────────────────────────────────────────────
                Center(
                  child: CustomText(
                    text: 'Forgot Password?',
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: CustomText(
                    text:
                        'Enter your registered email and we\'ll send\nyou a reset code.',
                    color: Colors.white54,
                    fontSize: 14,
                    maxLines: 2,
                    fontFamily: 'Barlow',
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 36),

                // ── Email label ───────────────────────────────────────────
                CustomText(
                  text: 'EMAIL',
                  color: Colors.white60,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  textEditingController: controller.forgotEmailController,
                  hintText: 'driver@speedring.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
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

                const SizedBox(height: 36),

                // ── Send OTP button ───────────────────────────────────────
                Obx(() {
                  return controller.isForgotLoading.value
                      ? const CustomLoader()
                      : CustomButton(
                          onTap: () => controller.sendOtp(),
                          title: 'SEND RESET CODE',
                          fillColor: const Color(0xffF5C400),
                          textColor: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          borderRadius: 16,
                        );
                }),

                // ── Spacer to push login link to bottom ───────────────────
                SizedBox(height: screenHeight * 0.2 - bottomPadding),

                // ── Remember password ─────────────────────────────────────
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: 'Remember your password? ',
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

                SizedBox(height: 24 + bottomPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_images/app_images.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_image/custom_image.dart';
import 'package:speedring/view/components/custom_loader/custom_loader.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import 'package:speedring/view/sereen/AuthScreen/controller/auth_controller.dart';

class VerifyOtpScreen extends StatelessWidget {
  VerifyOtpScreen({super.key});

  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Logo ────────────────────────────────────────────────────
              CustomImage(
                imageSrc: AppImages.splashLogo,
                imageType: ImageType.png,
                height: 160,
                width: double.infinity,
                fit: BoxFit.contain,
              ),

          
              const SizedBox(height: 24),

              // ── Heading ──────────────────────────────────────────────────
              Center(
                child: CustomText(
                  text: 'Verify Your Email',
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      height: 1.5,
                      fontFamily: 'Barlow',
                    ),
                    children: [
                      const TextSpan(text: 'We sent a 6-digit code to\n'),
                      TextSpan(
                        text: controller.forgotEmailController.text.isEmpty
                            ? 'your email'
                            : controller.forgotEmailController.text,
                        style: const TextStyle(
                          color: Color(0xffF5C400),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ── OTP boxes ────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  return _OtpBox(
                    controller: controller.otpControllers[i],
                    focusNode: controller.otpFocusNodes[i],
                    nextFocus: i < 5 ? controller.otpFocusNodes[i + 1] : null,
                    prevFocus: i > 0 ? controller.otpFocusNodes[i - 1] : null,
                  );
                }),
              ),

              const SizedBox(height: 36),

              // ── Verify button ─────────────────────────────────────────────
              Obx(() {
                return controller.isOtpLoading.value
                    ? const CustomLoader()
                    : CustomButton(
                        onTap: () => controller.verifyOtp(),
                        title: 'VERIFY CODE',
                        fillColor: const Color(0xffF5C400),
                        textColor: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        borderRadius: 16,
                      );
              }),

              const SizedBox(height: 28),

              // ── Resend ────────────────────────────────────────────────────
              Obx(() {
                final seconds = controller.resendCountdown.value;
                return Center(
                  child: seconds > 0
                      ? RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 14),
                            children: [
                              const TextSpan(text: 'Resend code in '),
                              TextSpan(
                                text: '${seconds}s',
                                style: const TextStyle(
                                  color: Color(0xffF5C400),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () => controller.resendOtp(),
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                  color: Colors.white54, fontSize: 14),
                              children: [
                                TextSpan(text: "Didn't receive a code? "),
                                TextSpan(
                                  text: 'Resend',
                                  style: TextStyle(
                                    color: Color(0xffF5C400),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                );
              }),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Single OTP input box ──────────────────────────────────────────────────────
class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    this.nextFocus,
    this.prevFocus,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final FocusNode? prevFocus;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 56,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: const Color(0xFF181818),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xffF5C400), width: 1.5),
          ),
        ),
        onChanged: (v) {
          if (v.isNotEmpty && nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          } else if (v.isEmpty && prevFocus != null) {
            FocusScope.of(context).requestFocus(prevFocus);
          }
        },
      ),
    );
  }
}

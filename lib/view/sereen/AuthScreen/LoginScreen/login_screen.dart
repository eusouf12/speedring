import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/utils/app_images/app_images.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_image/custom_image.dart';
import 'package:speedring/view/components/custom_loader/custom_loader.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import 'package:speedring/view/components/custom_text_field/custom_text_field.dart';
import 'package:speedring/view/sereen/AuthScreen/controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.find<AuthController>();



  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Logo ────────────────────────────────────────────────
                CustomImage(
                  imageSrc: AppImages.splashLogo,
                  imageType: ImageType.png,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),

                // ── Welcome back ────────────────────────────────────────
                Center(
                  child: CustomText(
                    text: 'Welcome Back',
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: CustomText(
                    text: 'Log in to continue your motorsport \njourney.',
                    color: Colors.white54,
                    fontSize: 15,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    fontFamily: "Barlow",
                  ),
                ),

                const SizedBox(height: 36),

                // ── Email label ──────────────────────────────────────────
                CustomText(
                  text: 'EMAIL OR USERNAME',
                  color: Colors.white60,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  textEditingController: controller.emailController,
                  hintText: 'driver@speedring.com',
                  keyboardType: TextInputType.emailAddress,
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

                const SizedBox(height: 20),

                // ── Password label + forgot ──────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: 'PASSWORD',
                      color: Colors.white60,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.4,
                      textAlign: TextAlign.left,
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: navigate to forgot password
                      },
                      child: CustomText(
                        text: 'Forgot?',
                        color: const Color(0xffF5C400),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  textEditingController: controller.passwordController,
                  hintText: '••••••••',
                  isPassword: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your password';
                    if (v.length < 6) return 'Minimum 6 characters';
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // ── LOGIN button ─────────────────────────────────────────
                Obx(() {
                  return controller.isLoading.value
                      ? const CustomLoader()
                      : CustomButton(
                          onTap: () {
                            controller.loginValidator();
                          },
                          title: 'LOGIN',
                          fillColor: const Color(0xffF5C400),
                          textColor: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          borderRadius: 16,
                        );
                }),
                const SizedBox(height: 28),

                // ── OR divider ───────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.white12, thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: CustomText(
                        text: 'OR',
                        color: Colors.white38,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.white12, thickness: 1),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Continue with Google ─────────────────────────────────
                CustomButton(
                  onTap: () {},
                  title: "CONTINUE WITH GOOGLE",
                  fillColor: Color(0xFF1A1A1A),
                  textColor: Colors.white,
                  fontSize: 14,
                  borderRadius: 16,
                  isBorder: true,
                  borderColor: Colors.white10,
                  icon: _googleIcon(),
                ),

                const SizedBox(height: 12),

                // ── Continue with Apple ──────────────────────────────────
                CustomButton(
                  onTap: () {},
                  title: "CONTINUE WITH APPLE",
                  fillColor: Color(0xFF1A1A1A),
                  textColor: Colors.white,
                  fontSize: 14,
                  borderRadius: 16,
                  isBorder: true,
                  borderColor: Colors.white10,
                  icon: Icon(Icons.apple, color: Colors.white, size: 22),
                ),

                const SizedBox(height: 40),

                // ── Sign up prompt ───────────────────────────────────────
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Don't have an account? ",
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.signupScreen);
                        },
                        child: CustomText(
                          text: 'Sign Up',
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

  // ─── Proper Google G SVG icon ────────────────────────────────────────────────
  Widget _googleIcon() {
    const svgString = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">
  <path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/>
  <path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"/>
  <path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"/>
  <path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/>
  <path fill="none" d="M0 0h48v48H0z"/>
</svg>''';
    return SvgPicture.string(svgString, width: 22, height: 22);
  }
}

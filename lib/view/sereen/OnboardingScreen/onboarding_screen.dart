import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import '../../../core/app_routes/app_routes.dart';
import 'widget/custom_onboarding_card.dart';
import 'widget/on_bording_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    return Scaffold(
      body: Stack(
        children: [
          /// Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboding_img.png',
              fit: BoxFit.cover,
            ),
          ),

          /// Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: .15),
                    Colors.black.withValues(alpha: .45),
                    Colors.black.withValues(alpha: .95),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          text: "welcomeTo".tr,
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomText(
                          text: " ${"speedring".tr}",
                          color: const Color(0xffF5C400),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  CustomText(
                    text: "onboardingSubtitle".tr,
                    color: Colors.white,
                    fontSize: 18,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 25),

                  CustomText(
                    text: "onboardingDesc".tr,
                    color: Colors.white.withValues(alpha: .75),
                    fontSize: 14,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),

                  const Spacer(),

                  /// PAGEVIEW
                  SizedBox(
                    height: 200,
                    child: PageView(
                      controller: controller.pageController,
                      onPageChanged: controller.onPageChanged,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: CustomOnboardingCard(
                            icon: Icons.speed,
                            label: "trackMode".tr,
                            title: "telemetry".tr,
                            description: "trackModeDesc".tr,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: CustomOnboardingCard(
                            icon: Icons.directions_car,
                            label: "garage".tr,
                            title: "vehicles".tr,
                            description: "garageDesc".tr,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: CustomOnboardingCard(
                            icon: Icons.location_on,
                            label: "spotting".tr,
                            title: "worldWide".tr,
                            description: "spottingDesc".tr,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// DOTS
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: controller.currentIndex.value == index
                              ? 10
                              : 8,
                          height: controller.currentIndex.value == index
                              ? 10
                              : 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.currentIndex.value == index
                                ? const Color(0xffF5C400)
                                : Colors.white24,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),
                  //btn
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffF5C400),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed(AppRoutes.ageVerifyScreen);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "getStarted".tr,
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.loginScreen);
                    },
                    child: CustomText(
                      text: "alreadyHaveAccount".tr,
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

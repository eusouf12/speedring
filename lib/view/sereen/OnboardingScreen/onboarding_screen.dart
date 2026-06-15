import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import '../../../core/app_routes/app_routes.dart';
import 'widget/customonboardingCard.dart';
import 'widget/on_bording_controller.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final controller = Get.find<OnboardingController>();

  @override
  Widget build(BuildContext context) {
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
                    Colors.black.withOpacity(.15),
                    Colors.black.withOpacity(.45),
                    Colors.black.withOpacity(.95),
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
                      children: const [
                        CustomText(
                          text: "WELCOME TO",
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomText(
                          text: " SPEEDRING",
                          color: Color(0xffF5C400),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const CustomText(
                    text: "The social network for motorsport\nenthusiasts.",
                    color: Colors.white,
                    fontSize: 18,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 25),

                  CustomText(
                    text:
                        "Track sessions. Share experiences. Discover cars, riders, clubs and motorsport events.",
                    color: Colors.white.withOpacity(.75),
                    fontSize: 14,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),

                  Spacer(),

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
                            label: "Track Mode",
                            title: "Telemetry",
                            description:
                                "Real-time lap timing and precise performance data tracking.",
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: CustomOnboardingCard(
                            icon: Icons.directions_car,
                            label: "GARAGE",
                            title: "Vehicles",
                            description:
                                "Manage your collection and service history in one digital vault",
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: CustomOnboardingCard(
                            icon: Icons.location_on,
                            label: "SPOTTING",
                            title: "World Wide",
                            description:
                                "Discover and share exotic car sightings fromacross the globe",
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

                  Spacer(),
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
                        Get.toNamed(AppRoutes.codeRequest);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "GET STARTED",
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.loginScreen);
                    },
                    child: const CustomText(
                      text: "I ALREADY HAVE AN ACCOUNT",
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_image/custom_image.dart';
import '../../../utils/app_images/app_images.dart';
import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        return CustomGradient(
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                // Logo exactly in the center
                Center(
                  child: FadeTransition(
                    opacity: controller.logoFadeAnimation,
                    child: ScaleTransition(
                      scale: controller.logoScaleAnimation,
                      child: CustomImage(
                        imageSrc: AppImages.splashLogo,
                        width: double.infinity,
                        height: 300,
                      ),
                    ),
                  ),
                ),
                // Telemetry Progress UI at the bottom
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Obx(() {
                      final progressPercent = (controller.progress.value * 100).toInt();
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.statusMessages[controller.statusIndex.value],
                                style: const TextStyle(
                                  color: Color(0xFFFFC107), // Amber/Yellow
                                  fontFamily: 'Courier',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                '$progressPercent%',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Courier',
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Progress Bar
                          LinearProgressIndicator(
                            value: controller.progress.value,
                            backgroundColor: Colors.grey[900],
                            color: const Color(0xFFFFC107),
                            minHeight: 2,
                          ),
                          const SizedBox(height: 20),
                          // Three dots pulsing
                          FadeTransition(
                            opacity: controller.dotsController,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                3,
                                (index) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Container(
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFFC107),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

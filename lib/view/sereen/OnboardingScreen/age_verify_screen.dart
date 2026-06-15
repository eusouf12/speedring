import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_images/app_images.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../components/custom_appbar_speedring/custom_appbar_speedring.dart';
import '../../components/custom_button/custom_button.dart';
import '../../components/custom_gradient/custom_gradient.dart';
import '../../components/custom_image/custom_image.dart';
import '../../components/custom_text/custom_text.dart';

// ─── Controller ────────────────────────────────────────────────
class AgeVerifyController extends GetxController {
  final RxInt selectedAge = 1.obs; // 0=16+, 1=18+, 2=Under16
  final RxBool confirmed = false.obs;
}

// ─── Screen ────────────────────────────────────────────────────
class AgeVerifyScreen extends StatelessWidget {
  const AgeVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AgeVerifyController());

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: const CustomAppBarSpeedring(),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    /// ── Helmet Image ──────────────────────────────
                    CustomImage(
                      imageSrc: AppImages.helmet,
                      imageType: ImageType.png,
                      height: 190,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 20),

                    /// ── Title ─────────────────────────────────────
                    const CustomText(
                      text: 'AGE VERIFICATION',
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      textAlign: TextAlign.center,
                      letterSpacing: 1,
                    ),

                    const SizedBox(height: 10),

                    /// ── Subtitle ──────────────────────────────────
                    const CustomText(
                      text:
                          'Speedring follows DACH youth\nprotection and GDPR standards.',
                      color: Colors.white54,
                      fontSize: 13,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),

                    const SizedBox(height: 28),

                    /// ── Age Options ───────────────────────────────
                    Obx(
                      () => Column(
                        children: [
                          _AgeOption(
                            isSelected: controller.selectedAge.value == 0,
                            onTap: () => controller.selectedAge.value = 0,
                            label: '16+ Community Access',
                            sublabel: 'SOCIAL FEED AND BASIC TRACKING.',
                          ),
                          const SizedBox(height: 10),
                          _AgeOption(
                            isSelected: controller.selectedAge.value == 1,
                            onTap: () => controller.selectedAge.value = 1,
                            label: '18+ Full Access',
                            sublabel: 'MARKETPLACE, PRO, BUSINESS FEATURES.',
                            highlighted: true,
                          ),
                          const SizedBox(height: 10),
                          _AgeOption(
                            isSelected: controller.selectedAge.value == 2,
                            onTap: () => controller.selectedAge.value = 2,
                            label: 'Under 16',
                            sublabel: 'PARENTAL CONSENT REQUIRED.',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// ── Confirm Checkbox ──────────────────────────
                    Obx(
                      () => GestureDetector(
                        onTap: () => controller.confirmed.value =
                            !controller.confirmed.value,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: controller.confirmed.value
                                    ? AppColors.yellow
                                    : Colors.transparent,
                                border: Border.all(
                                  color: controller.confirmed.value
                                      ? AppColors.yellow
                                      : Colors.white38,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: controller.confirmed.value
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.black,
                                      size: 14,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: CustomText(
                                text:
                                    'I confirm that the information provided is accurate.',
                                color: Colors.white70,
                                fontSize: 12,
                                textAlign: TextAlign.left,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// ── Continue Button ───────────────────────────
                    Obx(
                      () => CustomButton(
                        title: 'CONTINUE  ›',
                        height: 56,
                        borderRadius: 30,
                        fillColor: controller.confirmed.value
                            ? AppColors.yellow
                            : Colors.white12,
                        textColor: controller.confirmed.value
                            ? Colors.black
                            : Colors.white38,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        onTap: controller.confirmed.value
                            ? () => Get.toNamed(AppRoutes.signupScreen)
                            : null,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// ── Learn More link ───────────────────────────
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: const CustomText(
                    //     text: 'LEARN MORE',
                    //     color: Colors.white38,
                    //     fontSize: 11,
                    //     fontWeight: FontWeight.w600,
                    //     letterSpacing: 1.5,
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Single age option radio card
// ─────────────────────────────────────────────
class _AgeOption extends StatelessWidget {
  const _AgeOption({
    required this.isSelected,
    required this.onTap,
    required this.label,
    required this.sublabel,
    this.highlighted = false,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final String label;
  final String sublabel;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.yellow.withValues(alpha: 0.08)
              : const Color(0xff1C1C1C),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.yellow : Colors.white12,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            /// Radio circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.yellow : Colors.white38,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.yellow,
                        ),
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 14),

            /// Labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: label,
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 2),
                  CustomText(
                    text: sublabel,
                    color: Colors.white38,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../components/custom_appbar_stepped/custom_appbar_stepped.dart';
import '../../components/custom_button/custom_button.dart';
import '../../components/custom_image/custom_image.dart';
import '../../../utils/app_images/app_images.dart';
import '../../components/custom_gradient/custom_gradient.dart'
    show CustomGradient;
import 'setup_profile_controller.dart';

class SetupProfileScreen2 extends StatelessWidget {
  const SetupProfileScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SetupProfileController>();

    final List<Map<String, dynamic>> categories = [
      {
        'id': 'combustion',
        'titleKey': 'combustion',
        'subtitleKey': 'iceTelemetry',
        'icon': Icons.toys_outlined,
        'bgImage': AppImages.combustionBg,
      },
      {
        'id': 'electric',
        'titleKey': 'electric',
        'subtitleKey': 'voltTelemetry',
        'icon': Icons.bolt,
        'bgImage': AppImages.electricBg,
      },
      {
        'id': 'motorcycle',
        'titleKey': 'motorcycle',
        'subtitleKey': 'twoWheel',
        'icon': Icons.two_wheeler,
        'bgImage': AppImages.motorcycleBg,
      },
      {
        'id': 'karting',
        'titleKey': 'karting',
        'subtitleKey': 'chassisAgility',
        'icon': Icons.flag_outlined,
        'bgImage': AppImages.kartingBg,
      },
      {
        'id': 'oldtimer',
        'titleKey': 'oldtimer',
        'subtitleKey': 'legacyEngines',
        'icon': Icons.directions_car_filled_outlined,
        'bgImage': AppImages.oldtimerBg,
      },
      {
        'id': 'spotters',
        'titleKey': 'spotters',
        'subtitleKey': 'spottersInsights',
        'icon': Icons.camera_alt,
        'bgImage': AppImages.spotters,
      },
      {
        'id': 'others',
        'titleKey': 'others',
        'subtitleKey': 'customTelemetry',
        'icon': Icons.stars,
        'bgImage': AppImages.others,
      },
    ];

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomAppBarStepped(
          showBackButton: true,
          currentStep: 2,
          totalSteps: 4,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ── Top Subtitle text ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Text(
                'chooseInterests'.tr,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            /// ── Motorsport Interests Cards ────────────────────────
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final item = categories[index];

                  return Obx(() {
                    // Multi-selection er jonno dynamic check
                    final isSelected = controller.selectedInterests.contains(
                      item['id'],
                    );

                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          controller.selectedInterests.remove(item['id']);
                        } else {
                          controller.selectedInterests.add(item['id']);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        height: 180,
                        decoration: BoxDecoration(
                          color: const Color(0xff1C1C1C),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.yellow
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Stack(
                          children: [
                            /// Background Vehicle Silhouette Image
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Opacity(
                                  opacity: isSelected ? 0.25 : 0.15,
                                  child: CustomImage(
                                    imageSrc: item['bgImage'],
                                    imageType: ImageType.png,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            /// Content Structure
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  /// Top Row: Yellow Icon
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.4,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      item['icon'],
                                      color: AppColors.yellow,
                                      size: 20,
                                    ),
                                  ),

                                  /// Bottom Content: Titles
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (item['subtitleKey'] as String).tr,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        (item['titleKey'] as String).tr,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),

            /// ── Bottom Continue Button Fixed ──────────────────────
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                title: 'continueBtn'.tr,
                height: 54,
                borderRadius: 30,
                fillColor: AppColors.yellow,
                textColor: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 15,
                onTap: () {
                  // Step 3 layout link kore diben ekhane
                  Get.toNamed(AppRoutes.setupProfileScreen3);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

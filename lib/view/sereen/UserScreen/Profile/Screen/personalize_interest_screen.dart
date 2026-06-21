import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/view/components/custom_image/custom_image.dart';
import 'package:speedring/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/utils/app_images/app_images.dart';
import 'package:speedring/view/sereen/SetupProfile/setup_profile_controller.dart';

class PersonalizeInterestScreen extends StatelessWidget {
  const PersonalizeInterestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // If controller is not registered (which happens if onboarding has finished and controller was disposed),
    // we put it here so the state remains valid.
    final SetupProfileController controller =
        Get.isRegistered<SetupProfileController>()
        ? Get.find<SetupProfileController>()
        : Get.put(SetupProfileController());

    final List<Map<String, dynamic>> categories = [
      {
        'id': 'combustion',
        'title': 'Combustion',
        'subtitle': 'ICE PERFORMANCE',
        'icon': Icons.toys_outlined,
        'bgImage': AppImages.combustionBg,
      },
      {
        'id': 'electric',
        'title': 'Electric',
        'subtitle': 'VOLT TELEMETRY',
        'icon': Icons.bolt,
        'bgImage': AppImages.electricBg,
      },
      {
        'id': 'motorcycle',
        'title': 'Motorcycle',
        'subtitle': 'TWO-WHEEL DYNAMICS',
        'icon': Icons.two_wheeler,
        'bgImage': AppImages.motorcycleBg,
      },
      {
        'id': 'karting',
        'title': 'Karting',
        'subtitle': 'CHASSIS AGILITY',
        'icon': Icons.flag_outlined,
        'bgImage': AppImages.kartingBg,
      },
      {
        'id': 'oldtimer',
        'title': 'Oldtimer',
        'subtitle': 'LEGACY ENGINES',
        'icon': Icons.directions_car_filled_outlined,
        'bgImage': AppImages.oldtimerBg,
      },
    ];

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomRoyelAppbar(
          titleName: "PERSONALIZE INTERESTS",
          leftIcon: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ── Top Subtitle text ──────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Text(
                'Choose your motorsport interests to personalize your technical telemetry feed.',
                style: TextStyle(
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
                                        item['subtitle'],
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item['title'],
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

            /// ── Bottom Save Changes Button Fixed ──────────────────────
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                title: 'SAVE CHANGES',
                height: 54,
                borderRadius: 30,
                fillColor: AppColors.yellow,
                textColor: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 15,
                onTap: () {
                  Get.back();
                  Get.snackbar(
                    "Preferences Saved",
                    "Motorsport interests updated successfully.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xff181818),
                    colorText: Colors.white,
                    borderColor: AppColors.yellow,
                    borderWidth: 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

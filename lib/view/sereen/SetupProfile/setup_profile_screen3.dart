import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../components/custom_appbar_stepped/custom_appbar_stepped.dart';
import '../../components/custom_button/custom_button.dart';
import '../../components/custom_gradient/custom_gradient.dart';
import '../../components/custom_image/custom_image.dart';
import '../../components/custom_text/custom_text.dart';
import '../../components/custom_text_field/custom_text_field.dart';
import 'setup_profile_controller.dart';

class SetupProfileScreen3 extends StatelessWidget {
  const SetupProfileScreen3({super.key});

  static const Color _cardBg = Color(0xff1C1C1C);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SetupProfileController>();

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomAppBarStepped(
          showBackButton: true,
          currentStep: 3,
          totalSteps: 4,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ── Title Section ─────────────────────────────────────
              const CustomText(
                text: 'ADD YOUR FIRST VEHICLE',
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
              const SizedBox(height: 4),
              const CustomText(
                text: 'BUILD YOUR SPEEDRING GARAGE.',
                color: Colors.grey,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
                fontFamily: "Barlow",
              ),

              const SizedBox(height: 24),

              /// ── Vehicle Preview Card ──────────────────────────────
              _buildVehiclePreview(controller),

              const SizedBox(height: 28),

              /// ── Form Fields ───────────────────────────────────────
              _SectionLabel(label: 'VEHICLE NAME'),
              const SizedBox(height: 6),
              CustomTextField(
                textEditingController: controller.vehicleNameCtrl,
                hintText: 'e.g. Daily Driver',
                fillColor: _cardBg,
              ),

              const SizedBox(height: 16),

              /// Brand & Model Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel(label: 'BRAND'),
                        const SizedBox(height: 6),
                        CustomTextField(
                          textEditingController: controller.brandCtrl,
                          hintText: 'Porsche',
                          fillColor: _cardBg,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel(label: 'MODEL'),
                        const SizedBox(height: 6),
                        CustomTextField(
                          textEditingController: controller.modelCtrl,
                          hintText: '911 GT3 RS',
                          fillColor: _cardBg,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Year & HP Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel(label: 'YEAR'),
                        const SizedBox(height: 6),
                        CustomTextField(
                          textEditingController: controller.yearCtrl,
                          hintText: '2023',
                          fillColor: _cardBg,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel(label: 'HP'),
                        const SizedBox(height: 6),
                        CustomTextField(
                          textEditingController: controller.hpCtrl,
                          hintText: '528',
                          fillColor: _cardBg,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// ── Engine Type Selection ─────────────────────────────
              _SectionLabel(label: 'ENGINE TYPE'),
              const SizedBox(height: 12),
              Obx(
                () => Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _EngineChip(
                      label: 'COMBUSTION',
                      isSelected: controller.engineType.value == 'combustion',
                      onTap: () => controller.engineType.value = 'combustion',
                    ),
                    _EngineChip(
                      label: 'ELECTRIC',
                      isSelected: controller.engineType.value == 'electric',
                      onTap: () => controller.engineType.value = 'electric',
                    ),
                    _EngineChip(
                      label: 'MOTORCYCLE',
                      isSelected: controller.engineType.value == 'motorcycle',
                      onTap: () => controller.engineType.value = 'motorcycle',
                    ),
                    _EngineChip(
                      label: 'KARTING',
                      isSelected: controller.engineType.value == 'karting',
                      onTap: () => controller.engineType.value = 'karting',
                    ),
                    _EngineChip(
                      label: 'OLDTIMER',
                      isSelected: controller.engineType.value == 'oldtimer',
                      onTap: () => controller.engineType.value = 'oldtimer',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// ── Vehicle Image Upload ──────────────────────────────
              _SectionLabel(label: 'VEHICLE IMAGE'),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  // Add Image Picker Logic
                },
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10, width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        color: AppColors.yellow,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      const CustomText(
                        text: 'UPLOAD VEHICLE PHOTO',
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                      const CustomText(
                        text: 'High resolution PNG, JPG, or JPEG',
                        color: Colors.white24,
                        fontSize: 9,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// ── Action Buttons ────────────────────────────────────
              CustomButton(
                title: 'ADD VEHICLE',
                height: 56,
                borderRadius: 30,
                fillColor: AppColors.yellow,
                textColor: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 15,
                onTap: () => Get.toNamed(AppRoutes.setupProfileScreen4),
              ),

              const SizedBox(height: 12),

              Center(
                child: TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.setupProfileScreen4),
                  child: const CustomText(
                    text: 'SKIP FOR NOW',
                    color: Colors.white54,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Vehicle Preview Card UI Component
  Widget _buildVehiclePreview(SetupProfileController controller) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Background Auto-swapping Images
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Obx(() {
                final imageSrc = controller.previewImages[controller.currentPreviewIndex.value];
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: SizedBox(
                    key: ValueKey<String>(imageSrc),
                    width: double.infinity,
                    height: double.infinity,
                    child: Opacity(
                      opacity: 0.5,
                      child: CustomImage(
                        imageSrc: imageSrc,
                        imageType: ImageType.png,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Gradient Overlay to enhance text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.black.withValues(alpha: 0.2),
                  ],
                ),
              ),
            ),
          ),

          // Text Details
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'PORSCHE PLATINUM',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'PORSCHE 911 GT3 RS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          // HP Badge
          Positioned(
            top: 20,
            right: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: const [
                Text(
                  '528',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  'HP',
                  style: TextStyle(
                    color: AppColors.yellow,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          // Dot Indicators for Swap
          Positioned(
            bottom: 16,
            right: 20,
            child: Obx(() {
              return Row(
                children: List.generate(
                  controller.previewImages.length,
                  (index) {
                    final isCurrent = controller.currentPreviewIndex.value == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(left: 6),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCurrent ? AppColors.yellow : Colors.white38,
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// Section Label Component
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: label,
      color: Colors.white38,
      fontSize: 10,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.0,
    );
  }
}

/// Engine Selection Chip Component
class _EngineChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _EngineChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.yellow : const Color(0xff1C1C1C),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.yellow : Colors.white10,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

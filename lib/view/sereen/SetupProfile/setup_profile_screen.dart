import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_images/app_images.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../components/custom_appbar_stepped/custom_appbar_stepped.dart';
import '../../components/custom_button/custom_button.dart';
import '../../components/custom_image/custom_image.dart';
import '../../components/custom_text/custom_text.dart';
import '../../components/custom_text_field/custom_text_field.dart';
import 'setup_profile_controller.dart';

// ─── Screen ────────────────────────────────────────────────────
class SetupProfileScreen1 extends StatelessWidget {
  const SetupProfileScreen1({super.key});

  static const Color _cardBg = Color(0xff1C1C1C);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SetupProfileController());

    return CustomGradient(
      child: Scaffold(
        appBar: CustomAppBarStepped(
          showBackButton: false,
          currentStep: 1,
          totalSteps: 4,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ── Title ─────────────────────────────────────────────
              const Center(
                child: CustomText(
                  text: 'SET UP YOUR PROFILE',
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 28),

              /// ── Profile Picture ───────────────────────────────────
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                        border: Border.all(
                          color: AppColors.yellow.withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: CustomImage(
                          imageSrc: AppImages.helmet,
                          imageType: ImageType.png,
                          fit: BoxFit.cover,
                          height: 110,
                          width: 110,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.yellow,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              /// ── Display Name ──────────────────────────────────────
              // _SectionLabel(label: 'Display Name'),
              // const SizedBox(height: 6),
              // CustomTextField(
              //   textEditingController: controller.displayNameCtrl,
              //   hintText: 'e.g., Sebastian V.',
              //   fillColor: _cardBg,
              // ),
              const SizedBox(height: 16),

              /// ── Bio / Driver Stats ────────────────────────────────
              _SectionLabel(label: 'Bio / Driver Stats'),
              const SizedBox(height: 6),
              CustomTextField(
                textEditingController: controller.bioCtrl,
                hintText: 'Tell the paddock about your journey...',
                fillColor: _cardBg,
                maxLines: 4,
                textAlignVertical: TextAlignVertical.top,
                contentPadding: const EdgeInsets.all(16),
              ),

              const SizedBox(height: 16),

              /// ── User Role / Identity ──────────────────────────────
              _SectionLabel(label: 'User Role / Identity'),
              const SizedBox(height: 6),
              CustomTextField(
                textEditingController: controller.roleCtrl,
                hintText: 'e.g., Spotter, Racer, Journalist...',
                fillColor: _cardBg,
              ),

              const SizedBox(height: 12),

              /// ── Display Role Publicly toggle ──────────────────────
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const CustomText(
                        text: 'DISPLAY ROLE PUBLICLY',
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        textAlign: TextAlign.left,
                      ),
                      const Spacer(),
                      Switch(
                        value: controller.displayRolePublicly.value,
                        onChanged: (v) =>
                            controller.displayRolePublicly.value = v,
                        activeThumbColor: Colors.white,
                        activeTrackColor: AppColors.yellow,
                        inactiveTrackColor: Colors.white24,
                        inactiveThumbColor: Colors.white54,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// ── Nationality / Origin ──────────────────────────────
              _SectionLabel(label: 'Nationality / Origin'),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CustomTextField(hintText: 'Germany', fillColor: _cardBg),
              ),

              const SizedBox(height: 20),

              /// ── Social Telemetry ──────────────────────────────────
              const CustomText(
                text: 'Social Telemetry',
                color: AppColors.yellow1,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8),

              _SocialField(
                controller: controller.instagramCtrl,
                icon: Icons.camera_alt_outlined,
                hint: 'Instagram',
              ),
              const SizedBox(height: 8),
              _SocialField(
                controller: controller.tiktokCtrl,
                icon: Icons.music_note_outlined,
                hint: 'TikTok',
              ),
              const SizedBox(height: 8),
              _SocialField(
                controller: controller.youtubeCtrl,
                icon: Icons.play_circle_outline,
                hint: 'YouTube',
              ),
              const SizedBox(height: 8),
              _SocialField(
                controller: controller.facebookCtrl,
                icon: Icons.facebook_outlined,
                hint: 'Facebook',
              ),

              const SizedBox(height: 20),

              /// ── Primary Category ──────────────────────────────────
              // const CustomText(
              //   text: 'Primary Category',
              //   color: Colors.black,
              //   fontSize: 13,
              //   fontWeight: FontWeight.w600,
              //   textAlign: TextAlign.left,
              // ),
              // const SizedBox(height: 10),

              // Obx(
              //   () => GridView.count(
              //     crossAxisCount: 2,
              //     crossAxisSpacing: 10,
              //     mainAxisSpacing: 10,
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     childAspectRatio: 2.4,
              //     children: [
              //       _CategoryTile(
              //         icon: Icons.settings,
              //         label: 'Combustion',
              //         isSelected: controller.selectedCategory.value == 0,
              //         onTap: () => controller.selectedCategory.value = 0,
              //       ),
              //       _CategoryTile(
              //         icon: Icons.bolt,
              //         label: 'Electric',
              //         isSelected: controller.selectedCategory.value == 1,
              //         onTap: () => controller.selectedCategory.value = 1,
              //       ),
              //       _CategoryTile(
              //         icon: Icons.two_wheeler,
              //         label: 'Motorcycle',
              //         isSelected: controller.selectedCategory.value == 2,
              //         onTap: () => controller.selectedCategory.value = 2,
              //       ),
              //       _CategoryTile(
              //         icon: Icons.sports_motorsports,
              //         label: 'Karting',
              //         isSelected: controller.selectedCategory.value == 3,
              //         onTap: () => controller.selectedCategory.value = 3,
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 10),
              // Obx(
              //   () => _CategoryTile(
              //     icon: Icons.history,
              //     label: 'Old Timer',
              //     isSelected: controller.selectedCategory.value == 4,
              //     onTap: () => controller.selectedCategory.value = 4,
              //     fullWidth: true,
              //   ),
              // ),
              const SizedBox(height: 32),

              /// ── Continue Button ───────────────────────────────────
              CustomButton(
                title: 'CONTINUE',
                height: 56,
                borderRadius: 30,
                fillColor: AppColors.yellow,
                textColor: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 15,
                onTap: () => Get.toNamed(AppRoutes.setupProfileScreen2),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Section label
// ─────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: label,
      color: AppColors.yellow1,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      textAlign: TextAlign.left,
    );
  }
}

// ─────────────────────────────────────────────
//  Social media row field
// ─────────────────────────────────────────────
class _SocialField extends StatelessWidget {
  const _SocialField({
    required this.controller,
    required this.icon,
    required this.hint,
  });

  final TextEditingController controller;
  final IconData icon;
  final String hint;

  static const Color _cardBg = Color(0xff1C1C1C);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      textEditingController: controller,
      hintText: hint,
      fillColor: _cardBg,
      prefixIcon: Icon(icon, color: Colors.white54, size: 20),
    );
  }
}

// class _CategoryTile extends StatelessWidget {
//   const _CategoryTile({
//     required this.icon,
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//     this.fullWidth = false,
//   });

//   final IconData icon;
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;
//   final bool fullWidth;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         width: fullWidth ? double.infinity : null,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.yellow : const Color(0xff1C1C1C),
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? Colors.black : Colors.white70,
//               size: 20,
//             ),
//             const SizedBox(width: 8),
//             CustomText(
//               text: label,
//               color: isSelected ? Colors.black : Colors.white70,
//               fontSize: 13,
//               fontWeight: FontWeight.w700,
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

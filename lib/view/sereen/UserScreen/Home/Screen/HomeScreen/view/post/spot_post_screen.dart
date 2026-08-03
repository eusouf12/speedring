import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../controller/home_controller.dart';

class SpotPostScreen extends StatelessWidget {
  const SpotPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
          title: const Text(
            "CREATE SPOT",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          centerTitle: true,
          actions: [
            Obx(() => TextButton(
              onPressed: homeCtrl.isPostCreating.value
                  ? null
                  : () async {
                      if (homeCtrl.spotMakeAndModelCtrl.text.isEmpty) {
                        showCustomSnackBar("Make and Model is required", isError: true);
                        return;
                      }
                      final success = await homeCtrl.createPost(
                        category: "SPOT_POST",
                        visibility: "Public",
                        mediaFile: homeCtrl.spotSelectedImage.value,
                        spotDetails: {
                          "licensePlate": homeCtrl.spotLicensePlateCtrl.text.trim(),
                          "region": homeCtrl.spotRegionCtrl.text.trim(),
                          "makeAndModel": homeCtrl.spotMakeAndModelCtrl.text.trim(),
                          "engine": homeCtrl.spotEngineCtrl.text.trim(),
                          "powerHp": homeCtrl.spotPowerHpCtrl.text.trim(),
                        },
                      );
                      if (success) {
                        Get.back(); // close editor
                        Get.back(); // close CreatePostScreen
                      }
                    },
              child: Text(
                homeCtrl.isPostCreating.value ? "PUBLISHING" : "PUBLISH",
                style: const TextStyle(
                  color: AppColors.yellow,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            )),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            /// ── Hero image / Upload Photo ────────────────────────────────
            GestureDetector(
              onTap: () => homeCtrl.pickPostImage(homeCtrl.spotSelectedImage),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Obx(() => Container(
                  height: 180,
                  width: double.infinity,
                  color: const Color(0xff1A1A1A),
                  child: homeCtrl.spotSelectedImage.value != null
                      ? Image.file(
                          homeCtrl.spotSelectedImage.value!,
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                color: AppColors.yellow,
                                size: 32,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "ADD SPOT PHOTO",
                                style: TextStyle(
                                  color: AppColors.yellow,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                )),
              ),
            ),

            /// ── SECTION 1: VEHICLE IDENTIFICATION ──────────────────────────
            const _SectionHeader("VEHICLE IDENTIFICATION"),

            const _FieldLabel("LICENSE PLATE"),
            const SizedBox(height: 6),
            _CustomInputRow(
              controller: homeCtrl.spotLicensePlateCtrl,
              icon: const Text(
                "#",
                style: TextStyle(
                  color: AppColors.yellow,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              hint: "ENTER PLATE ID",
            ),

            const SizedBox(height: 14),

            const _FieldLabel("REGION / COUNTRY"),
            const SizedBox(height: 6),
            _CustomInputRow(
              controller: homeCtrl.spotRegionCtrl,
              icon: const Icon(Icons.public, color: AppColors.yellow, size: 20),
              hint: "SELECT REGION",
            ),

            const SizedBox(height: 14),

            const _FieldLabel("MAKE & MODEL"),
            const SizedBox(height: 6),
            _CustomInputRow(
              controller: homeCtrl.spotMakeAndModelCtrl,
              icon: const Icon(
                Icons.directions_car_filled,
                color: AppColors.yellow,
                size: 20,
              ),
              hint: "E.G. PORSCHE 911 GT3 RS",
            ),

            /// ── SECTION 2: SPECIFICATION OVERRIDE ──────────────────────────
            const _SectionHeader("SPECIFICATION OVERRIDE"),

            _SpecBox(
              label: "ENGINE",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    cursorColor: AppColors.yellow,
                    controller: homeCtrl.spotEngineCtrl,
                    style: const TextStyle(
                      color: AppColors.yellow,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                    decoration: const InputDecoration(
                      hintText: "ENGINE",
                      hintStyle: TextStyle(
                        color: AppColors.yellow,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),

            _SpecBox(
              label: "POWER (HP)",
              child: Row(
                children: [
                  const Icon(Icons.flash_on, color: AppColors.yellow, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      cursorColor: AppColors.yellow,
                      controller: homeCtrl.spotPowerHpCtrl,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        hintText: "E.G. 525",
                        hintStyle: TextStyle(
                          color: Colors.white38,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// ── Publish button ───────────────────────────────────────────
            Obx(() => GestureDetector(
              onTap: homeCtrl.isPostCreating.value
                  ? null
                  : () async {
                      if (homeCtrl.spotMakeAndModelCtrl.text.isEmpty) {
                        showCustomSnackBar("Make and Model is required", isError: true);
                        return;
                      }
                      final success = await homeCtrl.createPost(
                        category: "SPOT_POST",
                        visibility: "Public",
                        mediaFile: homeCtrl.spotSelectedImage.value,
                        spotDetails: {
                          "licensePlate": homeCtrl.spotLicensePlateCtrl.text.trim(),
                          "region": homeCtrl.spotRegionCtrl.text.trim(),
                          "makeAndModel": homeCtrl.spotMakeAndModelCtrl.text.trim(),
                          "engine": homeCtrl.spotEngineCtrl.text.trim(),
                          "powerHp": homeCtrl.spotPowerHpCtrl.text.trim(),
                        },
                      );
                      if (success) {
                        Navigator.pop(context);
                      }
                    },
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: homeCtrl.isPostCreating.value ? const Color(0xff2A2A2A) : AppColors.yellow,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    homeCtrl.isPostCreating.value ? "PUBLISHING..." : "PUBLISH SPOT",
                    style: TextStyle(
                      color: homeCtrl.isPostCreating.value ? Colors.white24 : Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            )),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Row(
        children: [
          Container(
            color: Colors.black,
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.yellow,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: Colors.white38,
      fontSize: 9,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
    ),
  );
}

class _CustomInputRow extends StatelessWidget {
  final Widget icon;
  final String hint;
  final TextEditingController controller;

  const _CustomInputRow({required this.icon, required this.hint, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 14),
          Expanded(
            child: TextFormField(
              cursorColor: AppColors.yellow,
              controller: controller,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Colors.white38,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecBox extends StatelessWidget {
  final String label;
  final Widget child;

  const _SpecBox({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

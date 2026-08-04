import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../controller/home_controller.dart';

class SessionPostScreen extends StatelessWidget {
  const SessionPostScreen({super.key});

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
            "CREATE SESSION",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            /// ── Hero image ──────────────────────────────────────────────
            GestureDetector(
              onTap: () =>
                  homeCtrl.pickPostImage(homeCtrl.sessionSelectedImage),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Obx(
                  () => Container(
                    height: 180,
                    width: double.infinity,
                    color: const Color(0xff1A1A1A),
                    child: homeCtrl.sessionSelectedImage.value != null
                        ? Image.file(
                            homeCtrl.sessionSelectedImage.value!,
                            fit: BoxFit.cover,
                          )
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  color: AppColors.yellow,
                                  size: 32,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "ADD PHOTO",
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
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ── Vehicle ─────────────────────────────────────────────────
            const _FieldLabel("VEHICLE"),
            const SizedBox(height: 6),
            _InputField(
              hint: "Ferrari SF90 Stradale",
              controller: homeCtrl.sessionVehicleCtrl,
            ),

            const SizedBox(height: 14),

            /// ── Circuit ─────────────────────────────────────────────────
            const _FieldLabel("CIRCUIT"),
            const SizedBox(height: 6),
            _InputField(
              hint: "Silverstone Circuit",
              controller: homeCtrl.sessionCircuitCtrl,
            ),

            const SizedBox(height: 14),

            /// ── Track Name ──────────────────────────────────────────────
            const _FieldLabel("TRACK NAME"),
            const SizedBox(height: 6),
            _InputField(
              hint: "Grand Prix Loop",
              controller: homeCtrl.sessionTrackNameCtrl,
            ),

            const SizedBox(height: 20),

            /// ── Best Lap Time ────────────────────────────────────────────
            const _FieldLabel("BEST LAP TIME"),
            const SizedBox(height: 8),
            _InputField(
              hint: "01:28.442",
              controller: homeCtrl.sessionBestLapTimeCtrl,
            ),

            const SizedBox(height: 20),

            /// ── Top Speed ────────────────────────────────────────────────
            const _FieldLabel("TOP SPEED ACHIEVED"),
            const SizedBox(height: 8),
            _InputField(
              hint: "342 KM/H",
              controller: homeCtrl.sessionTopSpeedCtrl,
            ),

            const SizedBox(height: 20),

            /// ── Driver Session Summary ───────────────────────────────────
            const _FieldLabel("DRIVER SESSION SUMMARY"),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xff1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                cursorColor: AppColors.yellow,
                controller: homeCtrl.sessionSummaryCtrl,
                maxLines: 4,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.6,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// ── Publish button ───────────────────────────────────────────
            Obx(
              () => _PublishButton(
                label: homeCtrl.isPostCreating.value
                    ? "PUBLISHING..."
                    : "PUBLISH SESSION",
                onTap: homeCtrl.isPostCreating.value
                    ? null
                    : () async {
                        if (homeCtrl.sessionVehicleCtrl.text.isEmpty ||
                            homeCtrl.sessionCircuitCtrl.text.isEmpty) {
                          showCustomSnackBar(
                            "Vehicle and Circuit are required",
                            isError: true,
                          );
                          return;
                        }
                        final success = await homeCtrl.createPost(
                          category: "SESSION_POST",
                          visibility: "Public",
                          mediaFile: homeCtrl.sessionSelectedImage.value,
                          sessionDetails: {
                            "vehicle": homeCtrl.sessionVehicleCtrl.text.trim(),
                            "circuit": homeCtrl.sessionCircuitCtrl.text.trim(),
                            "trackName": homeCtrl.sessionTrackNameCtrl.text
                                .trim(),
                            "bestLapTime": homeCtrl.sessionBestLapTimeCtrl.text
                                .trim(),
                            "topSpeed": homeCtrl.sessionTopSpeedCtrl.text
                                .trim(),
                            "summary": homeCtrl.sessionSummaryCtrl.text.trim(),
                          },
                        );
                        if (success) {
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      },
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

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

class _InputField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  const _InputField({required this.hint, required this.controller});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xff1A1A1A),
      borderRadius: BorderRadius.circular(12),
    ),
    child: TextFormField(
      cursorColor: AppColors.yellow,
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        border: InputBorder.none,
        isDense: true,
      ),
    ),
  );
}

class _PublishButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _PublishButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 56,
      decoration: BoxDecoration(
        color: onTap != null ? AppColors.yellow : const Color(0xff2A2A2A),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: onTap != null ? Colors.black : Colors.white24,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),
    ),
  );
}

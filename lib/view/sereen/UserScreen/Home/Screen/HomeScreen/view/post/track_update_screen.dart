import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../controller/home_controller.dart';

class TrackUpdateScreen extends StatelessWidget {
  const TrackUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();
    const List<String> conditions = ["DRY", "DAMP", "WET", "FLOODED"];

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
            "CREATE TRACK UPDATE",
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
            /// ── Circuit Selector ───────────────────────────────────────────
            const _FieldLabel("SELECT CIRCUIT"),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xff1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                cursorColor: AppColors.yellow,
                controller: homeCtrl.trackCircuitCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: "Enter Circuit Name",
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// ── Surface Conditions ─────────────────────────────────────────
            const _FieldLabel("SURFACE CONDITION"),
            const SizedBox(height: 8),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: conditions.map((condition) {
                  final isSelected =
                      homeCtrl.trackSelectedCondition.value == condition;
                  Color getConditionColor() {
                    switch (condition) {
                      case "DRY":
                        return Colors.green;
                      case "DAMP":
                        return Colors.orange;
                      case "WET":
                        return Colors.blue;
                      case "FLOODED":
                        return Colors.red;
                      default:
                        return AppColors.yellow;
                    }
                  }

                  return Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          homeCtrl.trackSelectedCondition.value = condition,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? getConditionColor().withValues(alpha: 0.2)
                              : const Color(0xff1A1A1A),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? getConditionColor()
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            condition,
                            style: TextStyle(
                              color: isSelected
                                  ? getConditionColor()
                                  : Colors.white60,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            /// ── Active Flags & Hazards ────────────────────────────────────
            const _FieldLabel("ACTIVE FLAGS & HAZARDS"),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xff1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(
                () => Column(
                  children: homeCtrl.trackHazards.keys.map((hazard) {
                    final isChecked = homeCtrl.trackHazards[hazard] ?? false;
                    return Material(
                      color: Colors.transparent,
                      child: CheckboxListTile(
                        title: Text(
                          hazard,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        value: isChecked,
                        activeColor: AppColors.yellow,
                        checkColor: Colors.black,
                        dense: true,
                        onChanged: (val) {
                          if (val != null) {
                            homeCtrl.trackHazards[hazard] = val;
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ── Live Media Attachment ────────────────────────────────────
            const _FieldLabel("LIVE PHOTO / VIDEO (OPTIONAL)"),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => homeCtrl.pickPostImage(homeCtrl.trackSelectedImage),
              child: Obx(
                () => Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xff1A1A1A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white10,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: homeCtrl.trackSelectedImage.value != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            homeCtrl.trackSelectedImage.value!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Colors.white38,
                                size: 32,
                              ),
                              SizedBox(height: 6),
                              Text(
                                "ATTACH CURRENT TRACK IMAGE",
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ── Details/Notes ─────────────────────────────────────────────
            const _FieldLabel("DETAILS / NOTES"),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xff1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                cursorColor: AppColors.yellow,
                controller: homeCtrl.trackNotesCtrl,
                maxLines: 3,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.5,
                ),
                decoration: const InputDecoration(
                  hintText:
                      "Add specific location, advice, or flag information...",
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ── Visibility ───────────────────────────────────────────────
            const _FieldLabel("UPDATE VISIBILITY"),
            const SizedBox(height: 8),
            Obx(
              () => Row(
                children: ["Public", "Followers", "Club Only"].map((opt) {
                  final isSel = homeCtrl.trackSelectedVisibility.value == opt;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => homeCtrl.trackSelectedVisibility.value = opt,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSel
                              ? AppColors.yellow
                              : const Color(0xff1A1A1A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            opt,
                            style: TextStyle(
                              color: isSel ? Colors.black : Colors.white60,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 32),

            /// ── Publish button ───────────────────────────────────────────
            Obx(
              () => GestureDetector(
                onTap: homeCtrl.isPostCreating.value
                    ? null
                    : () async {
                        if (homeCtrl.trackCircuitCtrl.text.isEmpty) {
                          showCustomSnackBar(
                            "Circuit is required",
                            isError: true,
                          );
                          return;
                        }

                        List<String> activeHazards = [];
                        homeCtrl.trackHazards.forEach((key, val) {
                          if (val) activeHazards.add(key);
                        });

                        final success = await homeCtrl.createPost(
                          category: "TRACK_UPDATE",
                          visibility: homeCtrl.trackSelectedVisibility.value,
                          mediaFile: homeCtrl.trackSelectedImage.value,
                          trackUpdateDetails: {
                            "circuit": homeCtrl.trackCircuitCtrl.text.trim(),
                            "surfaceCondition":
                                homeCtrl.trackSelectedCondition.value,
                            "hazards": activeHazards,
                            "notes": homeCtrl.trackNotesCtrl.text.trim(),
                          },
                        );
                        if (success) {
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        }
                      },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: homeCtrl.isPostCreating.value
                        ? const Color(0xff2A2A2A)
                        : AppColors.yellow,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      homeCtrl.isPostCreating.value
                          ? "PUBLISHING..."
                          : "PUBLISH UPDATE",
                      style: TextStyle(
                        color: homeCtrl.isPostCreating.value
                            ? Colors.white24
                            : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
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

import 'package:flutter/material.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';

class TrackUpdateScreen extends StatelessWidget {
  const TrackUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String selectedCircuit = "Silverstone Circuit, Northamptonshire, UK";
    const String selectedCondition = "DRY";
    const List<String> conditions = ["DRY", "DAMP", "WET", "FLOODED"];

    final Map<String, bool> hazards = {
      "Yellow Flag": false,
      "Red Flag": false,
      "Oil on Track": false,
      "Debris": false,
    };

    final notesCtrl = TextEditingController(
      text: "Light rain starting to fall around Copse. Kerbs are getting very slippery. Recommend caution on Turn 9 exit.",
    );

    const String visibility = "Public";

    return Scaffold(
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "PUBLISH",
              style: TextStyle(
                color: AppColors.yellow,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          /// ── Circuit Selector ───────────────────────────────────────────
          const _FieldLabel("SELECT CIRCUIT"),
          const SizedBox(height: 6),
          const _SelectorRow(value: selectedCircuit),

          const SizedBox(height: 16),

          /// ── Surface Conditions ─────────────────────────────────────────
          const _FieldLabel("SURFACE CONDITION"),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: conditions.map((condition) {
              final isSelected = selectedCondition == condition;
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
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? getConditionColor().withOpacity(0.2)
                        : const Color(0xff1A1A1A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? getConditionColor() : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      condition,
                      style: TextStyle(
                        color: isSelected ? getConditionColor() : Colors.white60,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
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
            child: Column(
              children: hazards.keys.map((hazard) {
                final isChecked = hazards[hazard] ?? false;
                return CheckboxListTile(
                  title: Text(
                    hazard,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  value: isChecked,
                  activeColor: AppColors.yellow,
                  checkColor: Colors.black,
                  dense: true,
                  onChanged: (val) {},
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          /// ── Live Media Attachment ────────────────────────────────────
          const _FieldLabel("LIVE PHOTO / VIDEO (OPTIONAL)"),
          const SizedBox(height: 8),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xff1A1A1A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10, style: BorderStyle.solid),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, color: Colors.white38, size: 32),
                  SizedBox(height: 6),
                  Text(
                    "ATTACH CURRENT TRACK IMAGE",
                    style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ],
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
              controller: notesCtrl,
              maxLines: 3,
              style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
              decoration: const InputDecoration(
                hintText: "Add specific location, advice, or flag information...",
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
          Row(
            children: ["Public", "Followers", "Club Only"].map((opt) {
              final isSel = visibility == opt;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.yellow : const Color(0xff1A1A1A),
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
              );
            }).toList(),
          ),

          const SizedBox(height: 32),

          /// ── Publish button ───────────────────────────────────────────
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  "PUBLISH UPDATE",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
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

class _SelectorRow extends StatelessWidget {
  final String value;
  const _SelectorRow({required this.value});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xff1A1A1A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white38, size: 18),
          ],
        ),
      );
}

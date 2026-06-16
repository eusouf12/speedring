import 'package:flutter/material.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';

class BusinessPostScreen extends StatefulWidget {
  const BusinessPostScreen({super.key});

  @override
  State<BusinessPostScreen> createState() => _BusinessPostScreenState();
}

class _BusinessPostScreenState extends State<BusinessPostScreen> {
  final _titleCtrl = TextEditingController(text: "Precision Suspension Tuning Service");
  final _descCtrl = TextEditingController(
    text: "Professional corner weighting, dampening setup, and alignment optimized for your specific track and driving style.",
  );
  final _priceCtrl = TextEditingController(text: "\$350.00");
  String _selectedCategory = "Services"; // Services, Vehicles, Parts, Event Hosting
  String? _selectedAudioTrack = "AUTOBAHN";

  final List<String> _categories = ["Services", "Vehicles", "Parts", "Events"];

  final List<Map<String, String>> _audioTracks = [
    {"title": "THUNDERSTRUCK", "duration": "03:42", "genre": "Rock / High-Energy"},
    {"title": "AUTOBAHN", "duration": "04:15", "genre": "Synthwave / Speed"},
    {"title": "FIREST", "duration": "02:58", "genre": "Cyberpunk / Industrial"},
    {"title": "REDLINE", "duration": "03:10", "genre": "Electronic / Techno"},
  ];

  String _searchQuery = "";

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTracks = _audioTracks.where((track) {
      return track["title"]!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

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
          "CREATE BUSINESS POST",
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
          /// ── Business Basic details ────────────────────────────────────
          _FieldLabel("LISTING TITLE"),
          const SizedBox(height: 6),
          _InputField(hint: "e.g. Carbon Fiber Hood", controller: _titleCtrl),

          const SizedBox(height: 14),

          _FieldLabel("LISTING CATEGORY"),
          const SizedBox(height: 8),
          Row(
            children: _categories.map((cat) {
              final isSel = _selectedCategory == cat;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.yellow : const Color(0xff1A1A1A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        cat,
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

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel("PRICE"),
                    const SizedBox(height: 6),
                    _InputField(hint: "\$0.00", controller: _priceCtrl),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel("CONTACT / CALL TO ACTION"),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xff1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Send Message",
                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down, color: Colors.white38, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _FieldLabel("DESCRIPTION"),
          const SizedBox(height: 6),
          _InputField(hint: "Write details about your offering...", controller: _descCtrl, maxLines: 3),

          const SizedBox(height: 24),

          /// ── Telemetry Audio section ────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.music_note_outlined, color: AppColors.yellow, size: 16),
              const SizedBox(width: 6),
              _FieldLabel("ATTACH TELEMETRY AUDIO"),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xff1A1A1A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.yellow.withOpacity(0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Audio search bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.white38, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: const InputDecoration(
                            hintText: "Search telemetry tracks...",
                            hintStyle: TextStyle(color: Colors.white24),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "RACE-READY TRACKS",
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredTracks.length,
                  separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1),
                  itemBuilder: (context, index) {
                    final track = filteredTracks[index];
                    final isSelected = _selectedAudioTrack == track["title"];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        track["title"]!,
                        style: TextStyle(
                          color: isSelected ? AppColors.yellow : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "${track["genre"]} • ${track["duration"]}",
                        style: const TextStyle(color: Colors.white38, fontSize: 10),
                      ),
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.yellow.withOpacity(0.1) : Colors.black26,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          isSelected ? Icons.pause : Icons.play_arrow,
                          color: isSelected ? AppColors.yellow : Colors.white60,
                          size: 18,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isSelected ? Icons.check_circle : Icons.radio_button_off,
                          color: isSelected ? AppColors.yellow : Colors.white24,
                          size: 18,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedAudioTrack = track["title"];
                          });
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
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
                  "↑  PUBLISH BUSINESS POST",
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

class _InputField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  const _InputField({required this.hint, required this.controller, this.maxLines = 1});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xff1A1A1A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,
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

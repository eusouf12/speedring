import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import '../widgets/track_appbar.dart';

class ShareExpeditionScreen extends StatefulWidget {
  const ShareExpeditionScreen({super.key});

  @override
  State<ShareExpeditionScreen> createState() => _ShareExpeditionScreenState();
}

class _ShareExpeditionScreenState extends State<ShareExpeditionScreen> {
  final TextEditingController narrativeController = TextEditingController();
  String selectedVisibility = "PUBLIC";

  @override
  void dispose() {
    narrativeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: TrackAppBar(
        title: "SHARE EXPEDITION",
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.yellow),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// POST PREVIEW
            _buildSectionHeader("POST PREVIEW"),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Driver profile & drive title
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.yellow, width: 1.5),
                            image: const DecorationImage(
                              image: NetworkImage("https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=100&fit=crop"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "@COMMANDER_ALPHA",
                                style: TextStyle(color: AppColors.yellow, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "MIDNIGHT COAST RUN",
                                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert, color: Colors.white60),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  /// Map Graphic
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage("https://images.unsplash.com/photo-1524661135-423995f22d0b?w=600&fit=crop"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  /// Overlay Metrics Panel
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: const Color(0xff0d0d0d),
                    child: Row(
                      children: [
                        Expanded(child: _buildPreviewMetric("DISTANCE", "142.8", "KM")),
                        Expanded(child: _buildPreviewMetric("TIME", "03:12:45", "")),
                        Expanded(child: _buildPreviewMetric("AVG VELOCITY", "107", "KM/H")),
                      ],
                    ),
                  ),

                  /// Card Footer (Avatars + Likes/Comments/Share)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _buildMiniAvatar("https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&fit=crop"),
                            const SizedBox(width: 4),
                            _buildMiniAvatar("https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=100&fit=crop"),
                            const SizedBox(width: 4),
                            _buildMiniAvatar("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&fit=crop"),
                            const SizedBox(width: 4),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Color(0xff222222),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "+8",
                                style: TextStyle(color: Colors.white60, fontSize: 7, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(Icons.favorite_border, color: Colors.white70, size: 20),
                              onPressed: () {},
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(Icons.chat_bubble_outline, color: Colors.white70, size: 20),
                              onPressed: () {},
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(Icons.share_outlined, color: Colors.white70, size: 20),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// MISSION NARRATIVE
            _buildSectionHeader("MISSION NARRATIVE"),
            TextField(
              controller: narrativeController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xff111111),
                hintText: "Detail your mission objectives...",
                hintStyle: const TextStyle(color: Colors.white24),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.yellow, width: 1),
                ),
              ),
            ),
            const SizedBox(height: 24),

            /// TACTICAL TAGGING
            _buildSectionHeader("TACTICAL TAGGING"),
            Row(
              children: [
                Expanded(child: _buildTaggingButton("TAG PILOTS", Icons.person_add_alt_1_outlined)),
                const SizedBox(width: 12),
                Expanded(child: _buildTaggingButton("TAG VEHICLES", Icons.directions_car_outlined)),
              ],
            ),
            const SizedBox(height: 24),

            /// VISIBILITY PROTOCOL
            _buildSectionHeader("VISIBILITY PROTOCOL"),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  _buildVisibilityChip("PUBLIC", Icons.public),
                  const SizedBox(width: 6),
                  _buildVisibilityChip("FOLLOWERS", Icons.people_outline),
                  const SizedBox(width: 6),
                  _buildVisibilityChip("PRIVATE", Icons.lock_outline),
                ],
              ),
            ),
            const SizedBox(height: 32),

            /// POST TO FEED BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Get.offAllNamed(AppRoutes.userHomeScreen);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.send, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "POST TO FEED",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.yellow,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildPreviewMetric(String label, String val, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 7, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              val,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900),
            ),
            if (unit.isNotEmpty) ...[
              const SizedBox(width: 2),
              Text(
                unit,
                style: const TextStyle(color: Colors.white38, fontSize: 7, fontWeight: FontWeight.bold),
              ),
            ]
          ],
        ),
      ],
    );
  }

  Widget _buildMiniAvatar(String url) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.yellow, width: 0.7),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildTaggingButton(String label, IconData icon) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.yellow, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: Colors.white38, size: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildVisibilityChip(String label, IconData icon) {
    final bool isSelected = selectedVisibility == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedVisibility = label;
          });
        },
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xff222222) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.yellow.withValues(alpha:0.3) : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? AppColors.yellow : Colors.white38, size: 14),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.yellow : Colors.white38,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

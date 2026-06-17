import 'package:flutter/material.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';

class ClubPostScreen extends StatelessWidget {
  const ClubPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: const SizedBox.shrink(),
          title: const Text(
            "CREATE CLUB POST",
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white, size: 22),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 16),
      
            /// ── TITLE Container ───────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "TITLE",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      initialValue: "Grand Prix Loop",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      
            const SizedBox(height: 16),
      
            /// ── ADD MEDIA Box ─────────────────────────────────────────────
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white12,
                  style: BorderStyle.solid,
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.yellow,
                      size: 28,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Add Media (Max 50MB)",
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      
            const SizedBox(height: 20),
      
            /// ── POST DETAILS ──────────────────────────────────────────────
            const Text(
              "POST DETAILS",
              style: TextStyle(
                color: Colors.white38,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  /// Toolbar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white10)),
                    ),
                    child: Row(
                      children: [
                        const Text("B", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(width: 18),
                        const Text("I", style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(width: 18),
                        const Text("#", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(width: 18),
                        const Icon(Icons.link, color: Colors.white70, size: 16),
                        const SizedBox(width: 14),
                        Container(width: 1, height: 16, color: Colors.white24),
                        const SizedBox(width: 14),
                        const Icon(Icons.format_list_bulleted, color: Colors.white70, size: 16),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                      maxLines: 6,
                      style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
                      decoration: const InputDecoration(
                        hintText: "Brief the club on the next stage...",
                        hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      
            const SizedBox(height: 16),
      
            /// ── PINNED ANNOUNCEMENT Box ────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff1A1A1A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0x22FF5252),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.campaign_outlined,
                      color: Colors.redAccent,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PINNED ANNOUNCEMENT",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Prioritize this post for all club members",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: false,
                      onChanged: (val) {},
                      activeThumbColor: AppColors.yellow,
                      activeTrackColor: AppColors.yellow.withValues(alpha:0.5),
                      inactiveThumbColor: Colors.white60,
                      inactiveTrackColor: Colors.white10,
                    ),
                  ),
                ],
              ),
            ),
      
            const SizedBox(height: 40),
      
            /// ── Publish button ───────────────────────────────────────────
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.publish,
                      color: Colors.black,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "PUBLISH SESSION",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
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

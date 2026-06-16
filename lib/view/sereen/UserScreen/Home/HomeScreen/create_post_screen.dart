import 'package:flutter/material.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'session_post_screen.dart';
import 'spot_post_screen.dart';
import 'track_update_screen.dart';
import 'club_post_screen.dart';
import 'business_post_screen.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  int? _selectedIndex;

  static const List<_PostType> _postTypes = [
    _PostType(
      icon: Icons.speed_outlined,
      title: "SESSION POST",
      description: "Share your latest lap times and telemetry data.",
    ),
    _PostType(
      icon: Icons.remove_red_eye_outlined,
      title: "SPOT POST",
      description: "Captured a rare machine? Share your latest find.",
    ),
    _PostType(
      icon: Icons.location_on_outlined,
      title: "TRACK UPDATE",
      description: "Live reports on track conditions and traffic.",
    ),
    _PostType(
      icon: Icons.groups_outlined,
      title: "CLUB POST",
      description: "Connect with your crew and organize private events.",
    ),
    _PostType(
      icon: Icons.work_outline,
      title: "BUSINESS POST",
      description: "List vehicles, services, or professional insights.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      /// ── AppBar ─────────────────────────────────────────────────────────
      appBar: CustomRoyelAppbar(titleName: "Create Post", leftIcon: true),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  /// ── Post type cards ────────────────────────────────────
                  ...List.generate(_postTypes.length, (i) {
                    final type = _postTypes[i];
                    final isSelected = _selectedIndex == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIndex = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff1A1A1A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.yellow
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            /// Icon box
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                type.icon,
                                color: isSelected
                                    ? AppColors.yellow
                                    : Colors.white54,
                                size: 22,
                              ),
                            ),

                            const SizedBox(width: 14),

                            /// Text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    type.title,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.yellow
                                          : Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    type.description,
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 11,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            Icon(
                              Icons.chevron_right,
                              color: isSelected
                                  ? AppColors.yellow
                                  : Colors.white24,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          /// ── Bottom section ─────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              MediaQuery.of(context).padding.bottom + 16,
            ),
            child: Column(
              children: [
                /// CONTINUE button
                GestureDetector(
                  onTap: _selectedIndex != null ? () {
                    Widget target;
                    switch (_selectedIndex) {
                      case 0:
                        target = const SessionPostScreen();
                        break;
                      case 1:
                        target = const SpotPostScreen();
                        break;
                      case 2:
                        target = const TrackUpdateScreen();
                        break;
                      case 3:
                        target = const ClubPostScreen();
                        break;
                      case 4:
                        target = const BusinessPostScreen();
                        break;
                      default:
                        return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => target),
                    );
                  } : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 56,
                    decoration: BoxDecoration(
                      color: _selectedIndex != null
                          ? AppColors.yellow
                          : const Color(0xff2A2A2A),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "CONTINUE  →",
                        style: TextStyle(
                          color: _selectedIndex != null
                              ? Colors.black
                              : Colors.white24,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  "SELECT A CATEGORY TO PROCEED TO THE EDITOR",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white24,
                    fontSize: 9,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostType {
  final IconData icon;
  final String title;
  final String description;

  const _PostType({
    required this.icon,
    required this.title,
    required this.description,
  });
}

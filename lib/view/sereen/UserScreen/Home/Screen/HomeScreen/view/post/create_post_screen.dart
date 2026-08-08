import 'package:flutter/material.dart';
import 'package:speedring/helper/shared_prefe/shared_prefe.dart';
import 'package:speedring/utils/app_const/app_const.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'session_post_screen.dart';
import 'spot_post_screen.dart';
import 'track_update_screen.dart';
import 'package:get/get.dart';
import '../../controller/home_controller.dart';
import 'club_post_screen.dart';
import 'business_post_screen.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  int? _selectedIndex;
  String _userRole = '';

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    Get.find<HomeController>().resetAllPostFields();
  }

  Future<void> _loadUserRole() async {
    final role = await SharePrefsHelper.getString(AppConstants.role);
    if (mounted) {
      setState(() {
        _userRole = role;
      });
    }
  }

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
    final filteredTypes = _postTypes.where((type) {
      if (_userRole == 'driver' && type.title == 'BUSINESS POST') {
        return false;
      }
      return true;
    }).toList();

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,

        /// ── AppBar ─────────────────────────────────────────────────────────
        appBar: CustomRoyelAppbar(titleName: "createPost".tr, leftIcon: true),

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
                    ...List.generate(filteredTypes.length, (i) {
                      final type = filteredTypes[i];
                      final isSelected = _selectedIndex == i;
                      final String translatedTitle = type.title == 'SESSION POST' ? 'sessionPost'.tr.toUpperCase()
                          : type.title == 'SPOT POST' ? 'spotPost'.tr.toUpperCase()
                          : type.title == 'TRACK UPDATE' ? 'trackUpdate'.tr.toUpperCase()
                          : type.title == 'CLUB POST' ? 'clubPost'.tr.toUpperCase()
                          : 'businessPost'.tr.toUpperCase();
                      final String translatedDesc = type.title == 'SESSION POST' ? 'sessionPostDesc'.tr
                          : type.title == 'SPOT POST' ? 'spotPostDesc'.tr
                          : type.title == 'TRACK UPDATE' ? 'trackUpdateDesc'.tr
                          : type.title == 'CLUB POST' ? 'clubPostDesc'.tr
                          : 'businessPostDesc'.tr;
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
                                      translatedTitle,
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
                                      translatedDesc,
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
                    onTap: _selectedIndex != null
                        ? () {
                            final selectedType = filteredTypes[_selectedIndex!];
                            Widget target;
                            switch (selectedType.title) {
                              case "SESSION POST":
                                target = const SessionPostScreen();
                                break;
                              case "SPOT POST":
                                target = const SpotPostScreen();
                                break;
                              case "TRACK UPDATE":
                                target = const TrackUpdateScreen();
                                break;
                              case "CLUB POST":
                                target = const ClubPostScreen();
                                break;
                              case "BUSINESS POST":
                                target = const BusinessPostScreen();
                                break;
                              default:
                                return;
                            }
                            Get.to(() => target);
                          }
                        : null,
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
                          "${'continueBtn'.tr}  →",
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

                  Text(
                    "selectCategoryToProceed".tr.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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

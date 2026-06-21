import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_appbar_stepped/custom_appbar_stepped.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../components/custom_button/custom_button.dart';
import '../../components/custom_gradient/custom_gradient.dart' show CustomGradient;
import '../../components/custom_image/custom_image.dart';
import '../../../utils/app_images/app_images.dart';
import 'setup_profile_controller.dart';

class SetupProfileScreen4 extends StatelessWidget {
  const SetupProfileScreen4({super.key});

  static const Color _tileBg = Color(0xff141414); // Dark premium card background

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SetupProfileController>();

    final List<Map<String, dynamic>> items = [
      {
        'id': 'track_alerts',
        'icon': Icons.flag_rounded,
        'category': 'LIVE TELEMETRY',
        'title': 'Track Open Alerts',
        'trailingBadge': 'REAL-TIME',
      },
      {
        'id': 'new_followers',
        'icon': Icons.people_alt_rounded,
        'category': 'SOCIAL',
        'title': 'New Followers',
      },
      {
        'id': 'live_sessions',
        'icon': Icons.location_on_rounded,
        'category': 'LOCATION BASED',
        'title': 'Live Sessions Nearby',
      },
      {
        'id': 'marketplace',
        'icon': Icons.shopping_cart_rounded,
        'category': 'MARKETPLACE',
        'title': 'Marketplace Messages',
      },
      {
        'id': 'event_updates',
        'icon': Icons.emoji_events_rounded,
        'category': 'PRO TOUR',
        'title': 'Event Updates',
      },
    ];

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomAppBarStepped(
          showBackButton: true,
          currentStep: 4,
          totalSteps: 4,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),

                      /// ── Premium Helmet & Alert Emblem Artwork ─────────
                      Center(
                        child: SizedBox(
                          height: 240,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomImage(
                                imageSrc: AppImages.helmed2, 
                                imageType: ImageType.png,
                                height: 220,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// ── Title Header (STAY IN THE FAST LANE) ──────────
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            fontFamily: 'Changa', // Apnar custom impact font handle korbe
                          ),
                          children: [
                            TextSpan(text: 'STAY IN THE ', style: TextStyle(color: Colors.white)),
                            TextSpan(text: 'FAST LANE', style: TextStyle(color: AppColors.yellow)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// ── Subtitle Description ──────────────────────────
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Get notified about sessions, followers, events and marketplace activity. Never miss a green flag.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// ── Notification Features List ────────────────────
                      Obx(
                        () => Column(
                          children: items.map((item) {
                            final isSelected = controller.selectedNotifications.contains(item['id']);
                            return _buildNotificationTile(
                              icon: item['icon'] as IconData,
                              category: item['category'] as String,
                              title: item['title'] as String,
                              trailingBadge: item['trailingBadge'] as String?,
                              isSelected: isSelected,
                              onTap: () {
                                if (isSelected) {
                                  controller.selectedNotifications.remove(item['id']);
                                } else {
                                  controller.selectedNotifications.add(item['id']);
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              /// ── Bottom Actions (Fixed at baseline) ────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: Column(
                  children: [
                    CustomButton(
                      title: 'ENABLE NOTIFICATIONS',
                      height: 54,
                      borderRadius: 30,
                      fillColor: AppColors.yellow,
                      textColor: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      onTap: () {
                        // Request notification permissions code here
                        _navigateToDashboard();
                      },
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _navigateToDashboard(),
                      child: const Text(
                        'MAYBE LATER',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable Component for Notification Feed Feature Cards
  Widget _buildNotificationTile({
    required IconData icon,
    required String category,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    String? trailingBadge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _tileBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.yellow : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            /// Leading Icon Container Box
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.yellow.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.yellow : Colors.white38,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),

            /// Title Context Meta fields
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? AppColors.yellow.withValues(alpha: 0.7) : Colors.white38,
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            /// Trailing Highlight Badge (e.g., REAL-TIME)
            if (trailingBadge != null)
              Text(
                trailingBadge,
                style: TextStyle(
                  color: isSelected ? AppColors.yellow : Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToDashboard() {
    // Finish onboarding flow and replace routes structure
    Get.offAllNamed(AppRoutes.preview);
  }
}
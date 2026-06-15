import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_routes/app_routes.dart' show AppRoutes;
import '../../../utils/app_colors/app_colors.dart';
import '../../components/custom_gradient/custom_gradient.dart';
import '../../../utils/app_images/app_images.dart';
import '../../components/custom_image/custom_image.dart';

class GaragePreparationScreen extends StatefulWidget {
  const GaragePreparationScreen({super.key});

  @override
  State<GaragePreparationScreen> createState() => _GaragePreparationScreenState();
}

class _GaragePreparationScreenState extends State<GaragePreparationScreen> {
  static const Color _cardBg = Color(0xff141414);

  @override
  void initState() {
    super.initState();
    // 3 second por layout automate vabe next onboarding layer (Step 4) e redirect hobe
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.setupProfileScreen4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),

              /// ── Top Center Logo ───────────────────────────────────
              Center(
                child: CustomImage(
                  imageSrc: AppImages.logo,
                  imageType: ImageType.png,
                  height: 48,
                  width: 140,
                  fit: BoxFit.contain,
                ),
              ),

              const Spacer(flex: 2),

              /// ── Main Dynamic Header Title ─────────────────────────
              const Text(
                'PREPARING YOUR\nGARAGE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 20),

              /// ── Precise Gold Line Progress Bar ──────────────────
              Center(
                child: SizedBox(
                  width: 180,
                  child: Stack(
                    children: [
                      Container(
                        height: 3,
                        width: double.infinity,
                        color: Colors.white12,
                      ),
                      Container(
                        height: 3,
                        width: 70, // Simulated line progression from SS
                        color: AppColors.yellow,
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),

              /// ── Status Logs Wrapper Block ──────────────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Checklist items
                    _buildChecklistRow('Profile configured'),
                    const SizedBox(height: 14),
                    _buildChecklistRow('Vehicle interests synced'),
                    const SizedBox(height: 14),
                    _buildChecklistRow('Feed personalized'),

                    const SizedBox(height: 20),
                    const Divider(color: Colors.white10, height: 1),
                    const SizedBox(height: 20),

                    /// Live Status Meta Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'LIVE STATUS',
                          style: TextStyle(
                            color: AppColors.yellow,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          'EST. 2.4s',
                          style: TextStyle(
                            color: Colors.white24,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    /// Dynamic Processing updates
                    const Text(
                      'Finding motorsport enthusiasts\nnear you ...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper Checklist Component
  Widget _buildChecklistRow(String label) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xff2A2306), // Subtle golden dark background ring
          ),
          child: const Icon(
            Icons.check_circle,
            color: AppColors.yellow,
            size: 18,
          ),
        ),
        const SizedBox(width: 14),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../components/custom_appbar_speedring/custom_appbar_speedring.dart';

// ─── Controller ────────────────────────────────────────────────
class ChoosePlanController extends GetxController {
  final RxInt selectedPlan = 1.obs; // 0=Private, 1=Pro, 2=Business
}

class ChoosePlanScreen extends StatelessWidget {
  const ChoosePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChoosePlanController());

    return CustomGradient(
      child: Scaffold(
        backgroundColor:AppColors.black,
        appBar: const CustomAppBarSpeedring(),
        body: Column(
          children: [
            /// ── Plan Cards ───────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(
                  () => Column(
                    children: [
                      const CustomText(
                        text: 'Choose Your Plan',
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const CustomText(
                        text: 'Start your motorsport journey.',
                        color: Colors.white54,
                        fontSize: 13,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      /// PRIVATE
                      _PlanCard(
                        isSelected: controller.selectedPlan.value == 0,
                        onTap: () => controller.selectedPlan.value = 0,
                        tier: 'ENTRY LEVEL',
                        name: 'PRIVATE',
                        price: 'Free Forever',
                        features: const [
                          'Community feed',
                          'Stories',
                          'Basic track mode',
                          'Marketplace browsing',
                          'Garage',
                          'Events',
                          'Free reactions 👍❤️',
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// PRIVATE PRO
                      _PlanCard(
                        isSelected: controller.selectedPlan.value == 1,
                        onTap: () => controller.selectedPlan.value = 1,
                        tier: 'PROFESSIONAL',
                        name: 'PRIVATE PRO',
                        price: '€4.99/month',
                        badge: 'MOST POPULAR',
                        promoTag: 'FIRST 3 MONTHS FREE!',
                        proBadge: true,
                        highlighted: true,
                        features: const [
                          'Advanced telemetry',
                          'Unlimited tracks',
                          'Offline track mode',
                          'AI track analysis',
                          'Data export',
                          'Hobby Support Reactions 🏆🥇🏁',
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// BUSINESS
                      _PlanCard(
                        isSelected: controller.selectedPlan.value == 2,
                        onTap: () => controller.selectedPlan.value = 2,
                        tier: 'CORPORATE',
                        name: 'BUSINESS',
                        price: 'Start For Free',
                        features: const [
                          'Business profile',
                          'Marketplace listings',
                          'Ads promotion',
                          'Event management',
                          'Analytics dashboard',
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            /// ── Continue Button ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomButton(
                title: 'Continue',
                height: 56,
                borderRadius: 30,
                fillColor: AppColors.yellow,
                textColor: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17,
                onTap: () => Get.toNamed(AppRoutes.loginScreen),
              ),
            ),

            const SizedBox(height: 10),

            const CustomText(
              text: 'CHANGE ANYTIME IN SETTINGS',
              color: Colors.white38,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}


//  _PlanCard  –  StatelessWidget

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.isSelected,
    required this.onTap,
    required this.tier,
    required this.name,
    required this.price,
    required this.features,
    this.badge,
    this.promoTag,
    this.proBadge = false,
    this.highlighted = false,
  });

  final bool isSelected;
  final VoidCallback onTap;
  final String tier;
  final String name;
  final String price;
  final List<String> features;
  final String? badge;
  final String? promoTag;
  final bool proBadge;
  final bool highlighted;

 
  static const Color _cardBg = Color(0xff1C1C1C);

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isSelected ? AppColors.yellow : Colors.white12;
    final double borderWidth = isSelected ? 1.5 : 1.0;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// Card body
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Promo tag
                if (promoTag != null) ...[
                  _PromoTag(label: promoTag!),
                  const SizedBox(height: 10),
                ],

                /// Tier + price row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: tier,
                            color: highlighted ? AppColors.yellow: Colors.white54,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 2),
                          CustomText(
                            text: name,
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    CustomText(
                      text: price,
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),

                /// PRO badge row
                if (proBadge) ...[const SizedBox(height: 8), _ProBadgeRow()],

                const SizedBox(height: 12),
                const Divider(color: Colors.white10, height: 1),
                const SizedBox(height: 12),

                /// Feature list
                ...features.map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check,
                          color: highlighted ? AppColors.yellow : Colors.white60,
                          size: 14,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomText(
                            text: f,
                            color: Colors.white70,
                            fontSize: 13,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// MOST POPULAR badge
          if (badge != null)
            Positioned(
              top: -1,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: CustomText(
                  text: badge!,
                  color: Colors.black,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Small helper widgets  (StatelessWidget)
// ─────────────────────────────────────────────
class _PromoTag extends StatelessWidget {
  const _PromoTag({required this.label});
  final String label;

 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.yellow, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: CustomText(
        text: label,
        color: AppColors.yellow,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _ProBadgeRow extends StatelessWidget {
  const _ProBadgeRow();

 

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.verified, color: AppColors.yellow, size: 16),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.yellow.withValues(alpha: 0.15),
            border: Border.all(color: AppColors.yellow, width: 0.8),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const CustomText(
            text: 'PRO BADGE',
            color: AppColors.yellow,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

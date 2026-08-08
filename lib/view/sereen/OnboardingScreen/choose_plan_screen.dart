import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'checkout_webview.dart';
import '../UserScreen/Profile/Screen/user_parameters_screen.dart';
import '../../../core/app_routes/app_routes.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import '../../components/custom_appbar_speedring/custom_appbar_speedring.dart';
import '../SetupProfile/setup_profile_controller.dart';

import 'package:speedring/helper/shared_prefe/shared_prefe.dart';
import 'package:speedring/utils/app_const/app_const.dart';

// ─── Controller ────────────────────────────────────────────────
class ChoosePlanController extends GetxController {
  final RxInt selectedPlan = 1.obs; // 0=Private, 1=Pro, 2=Business
  final RxString currentPlanName = ''.obs;
  bool _hasAutoSelected = false;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentPlan();

    // Listen to changes in both current plan and the plans list to handle all race conditions
    ever(currentPlanName, (_) => _tryAutoSelect());
    final setupCtrl = Get.put(SetupProfileController());
    ever(setupCtrl.plansList, (_) => _tryAutoSelect());
  }

  Future<void> _loadCurrentPlan() async {
    currentPlanName.value = await SharePrefsHelper.getString(
      AppConstants.subscriptionPlanName,
    );
    debugPrint(
      "========> Current Plan from Storage: '${currentPlanName.value}'",
    );
    _tryAutoSelect();
  }

  void _tryAutoSelect() {
    if (_hasAutoSelected) return;

    String current = currentPlanName.value.trim();
    if (current.isEmpty) return;

    try {
      final setupController = Get.find<SetupProfileController>();
      final plansList = setupController.plansList;
      if (plansList.isEmpty) return;

      for (int i = 0; i < plansList.length; i++) {
        if (plansList[i].rawName.trim() == current) {
          selectedPlan.value = i;
          _hasAutoSelected = true;
          break;
        }
      }
    } catch (e) {
      // Ignore if not initialized
    }
  }
}

class ChoosePlanScreen extends StatelessWidget {
  final bool isModal;
  const ChoosePlanScreen({super.key, this.isModal = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChoosePlanController());
    final setupController = Get.put(SetupProfileController());

    Widget content = Column(
      children: [
        /// ── Plan Cards ───────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() {
              if (setupController.isPlansLoading.value) {
                return const Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.yellow),
                  ),
                );
              }

              return Column(
                children: [
                  CustomText(
                    text: 'choosePlan'.tr,
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    text: 'startJourney'.tr,
                    color: Colors.white54,
                    fontSize: 13,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  if (setupController.plansList.isEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: CustomText(
                        text: 'noPlans'.tr,
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ] else ...[
                    ...List.generate(setupController.plansList.length, (index) {
                      final plan = setupController.plansList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _PlanCard(
                          isSelected: controller.selectedPlan.value == index,
                          onTap: () => controller.selectedPlan.value = index,
                          tier: plan.tier,
                          name: plan.name,
                          price: plan.price,
                          features: plan.features,
                          badge: plan.badge,
                          promoTag: plan.promoTag,
                          proBadge: plan.isProBadge,
                          highlighted: plan.isHighlighted,
                        ),
                      );
                    }),
                  ],

                  const SizedBox(height: 20),
                ],
              );
            }),
          ),
        ),

        /// ── Continue Button ──────────────────────────────
        Obx(() {
          bool isDisabled = false;
          String selectedRawName = '';
          if (setupController.plansList.isNotEmpty &&
              controller.selectedPlan.value >= 0 &&
              controller.selectedPlan.value <
                  setupController.plansList.length) {
            selectedRawName = setupController
                .plansList[controller.selectedPlan.value]
                .rawName;
            if (selectedRawName == 'PRIVATE' || selectedRawName == 'FREE') {
              isDisabled = true;
            }
            if (controller.currentPlanName.value.isNotEmpty &&
                selectedRawName == controller.currentPlanName.value) {
              isDisabled = true;
            }
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomButton(
              title: 'continue'.tr,
              height: 56,
              borderRadius: 30,
              isLoading: setupController.isBuyPlanLoading.value,
              fillColor: isDisabled ? Colors.white24 : AppColors.yellow,
              textColor: isDisabled ? Colors.white54 : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
              onTap: isDisabled
                  ? () {}
                  : () async {
                      final selectedPlanId = setupController
                          .plansList[controller.selectedPlan.value]
                          .id;

                      // Call the API and get the checkout URL
                      String? checkoutUrl = await setupController.buyPlan(
                        selectedPlanId,
                      );

                      if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
                        try {
                          // Push to the CheckoutWebView
                          await Get.to(
                            () => CheckoutWebView(url: checkoutUrl),
                          );

                          // Set ProfileScreen as the root, then push UserParametersScreen on top.
                          // This ensures the back button correctly drops you back to ProfileScreen.
                          Get.offAllNamed(AppRoutes.profileScreen);
                          Get.to(() => const UserParametersScreen());
                        } catch (e) {
                          debugPrint("Error opening CheckoutWebView: $e");
                        }
                      }
                    },
            ),
          );
        }),

        const SizedBox(height: 10),

        CustomText(
          text: 'changeAnytime'.tr,
          color: Colors.white38,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 14),
      ],
    );

    if (isModal) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12, width: 1),
          ),
          padding: const EdgeInsets.only(top: 20),
          child: content,
        ),
      );
    }

    return CustomGradient(
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: const CustomAppBarSpeedring(),
        body: content,
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
                            color: highlighted
                                ? AppColors.yellow
                                : Colors.white54,
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
                          color: highlighted
                              ? AppColors.yellow
                              : Colors.white60,
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
          child: CustomText(
            text: 'proBadge'.tr,
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

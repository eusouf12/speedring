import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../components/custom_gradient/custom_gradient.dart';

class BusinessCreatePromotionScreen extends StatelessWidget {
  const BusinessCreatePromotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Local reactive states
    final RxString selectedGoal = "Views".obs; // Views, Interactions, Leads
    final RxString selectedAudience = "Racing Fans".obs; // Racing Fans, Drivers Near Me, Everyone
    final RxInt selectedBudget = 25.obs; // 10, 25, 50, 0 (0 means Custom)
    final RxInt customBudget = 15.obs;
    final RxInt durationDays = 7.obs;

    // Helper calculations
    int getDailyBudget() => selectedBudget.value == 0 ? customBudget.value : selectedBudget.value;
    int getTotalSpend() => getDailyBudget() * durationDays.value;
    int getEstimatedReach() => getDailyBudget() * 116.8.toInt() * durationDays.value;

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "CREATE PROMOTION",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: EdgeInsets.only(right: 16.w),
              alignment: Alignment.center,
              child: Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.yellow, width: 1),
                  image: const DecorationImage(
                    image: NetworkImage("https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=100&fit=crop"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selection section header
              CustomText(
                text: "SELECT YOUR POST/EVENT TO PROMOTE",
                color: AppColors.yellow,
                fontSize: 9.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
              SizedBox(height: 10.h),

              // Preview Card with Gold Border
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.yellow, width: 1.5),
                ),
                padding: EdgeInsets.all(12.w),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6.r),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=200&fit=crop",
                        width: 60.r,
                        height: 60.r,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60.r,
                          height: 60.r,
                          color: Colors.white10,
                          child: const Icon(Icons.broken_image, color: Colors.white24),
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "911 GT3 RS SHOWCASE",
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w900,
                          ),
                          SizedBox(height: 4.h),
                          CustomText(
                            text: "Completed the track telemetry calibration on our primary 911 GT3 RS. Aerodynamic efficiency was measured...",
                            color: Colors.white54,
                            fontSize: 8.5.sp,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Icon(Icons.favorite_border, color: AppColors.yellow, size: 12.sp),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: "1.8K Likes",
                                color: Colors.white38,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(width: 12.w),
                              Icon(Icons.chat_bubble_outline, color: Colors.white38, size: 11.sp),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: "242 Comments",
                                color: Colors.white38,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // SECTION 1: GOAL
              CustomText(
                text: "SELECT YOUR GOAL",
                color: Colors.white38,
                fontSize: 9.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
              SizedBox(height: 10.h),
              Obx(() => Column(
                children: [
                  _buildGoalCard(
                    goalId: "Views",
                    title: "MORE VIEWS",
                    description: "Increase video and post reach to build brand authority.",
                    icon: Icons.play_circle_outline,
                    isSelected: selectedGoal.value == "Views",
                    onTap: () => selectedGoal.value = "Views",
                  ),
                  SizedBox(height: 10.h),
                  _buildGoalCard(
                    goalId: "Interactions",
                    title: "MORE INTERACTIONS",
                    description: "Get more messages, post likes, shares, or club joins.",
                    icon: Icons.chat_bubble_outline,
                    isSelected: selectedGoal.value == "Interactions",
                    onTap: () => selectedGoal.value = "Interactions",
                  ),
                  SizedBox(height: 10.h),
                  _buildGoalCard(
                    goalId: "Leads",
                    title: "MORE LEADS",
                    description: "Gather customer contact info and direct sales inquiries.",
                    icon: Icons.contact_mail_outlined,
                    isSelected: selectedGoal.value == "Leads",
                    onTap: () => selectedGoal.value = "Leads",
                  ),
                ],
              )),
              SizedBox(height: 24.h),

              // SECTION 2: AUDIENCE
              CustomText(
                text: "TARGET AUDIENCE",
                color: Colors.white38,
                fontSize: 9.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
              SizedBox(height: 10.h),
              Obx(() => Row(
                children: [
                  _buildAudienceChip("Racing Fans", selectedAudience.value == "Racing Fans", () => selectedAudience.value = "Racing Fans"),
                  SizedBox(width: 10.w),
                  _buildAudienceChip("Drivers Near Me", selectedAudience.value == "Drivers Near Me", () => selectedAudience.value = "Drivers Near Me"),
                  SizedBox(width: 10.w),
                  _buildAudienceChip("Everyone", selectedAudience.value == "Everyone", () => selectedAudience.value = "Everyone"),
                ],
              )),
              SizedBox(height: 24.h),

              // SECTION 3: DAILY BUDGET
              CustomText(
                text: "DAILY BUDGET",
                color: Colors.white38,
                fontSize: 9.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
              SizedBox(height: 10.h),
              Obx(() => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBudgetButton(10, selectedBudget.value == 10, () => selectedBudget.value = 10),
                      _buildBudgetButton(25, selectedBudget.value == 25, () => selectedBudget.value = 25),
                      _buildBudgetButton(50, selectedBudget.value == 50, () => selectedBudget.value = 50),
                      _buildBudgetButton(0, selectedBudget.value == 0, () => selectedBudget.value = 0), // Custom
                    ],
                  ),
                  if (selectedBudget.value == 0) ...[
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        CustomText(
                          text: "CUSTOM BUDGET (\$/DAY):",
                          color: Colors.white70,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppColors.yellow,
                              inactiveTrackColor: Colors.white12,
                              thumbColor: AppColors.yellow,
                              overlayColor: AppColors.yellow.withValues(alpha: 0.2),
                              valueIndicatorColor: AppColors.yellow,
                              valueIndicatorTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            child: Slider(
                              value: customBudget.value.toDouble(),
                              min: 5,
                              max: 200,
                              divisions: 39,
                              label: "\$${customBudget.value}",
                              onChanged: (val) => customBudget.value = val.round(),
                            ),
                          ),
                        ),
                        CustomText(
                          text: "\$${customBudget.value}",
                          color: AppColors.yellow,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ],
                    ),
                  ],
                ],
              )),
              SizedBox(height: 20.h),

              // DURATION SLIDER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "DURATION",
                    color: Colors.white38,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                  Obx(() => CustomText(
                    text: "${durationDays.value} DAYS",
                    color: AppColors.yellow,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                  )),
                ],
              ),
              SizedBox(height: 6.h),
              Obx(() => SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.yellow,
                  inactiveTrackColor: Colors.white12,
                  thumbColor: AppColors.yellow,
                  overlayColor: AppColors.yellow.withValues(alpha: 0.2),
                ),
                child: Slider(
                  value: durationDays.value.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  onChanged: (val) => durationDays.value = val.round(),
                ),
              )),
              SizedBox(height: 24.h),

              // SECTION 4: Reach Estimation Box
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => CustomText(
                              text: "${getEstimatedReach().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} Fans",
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                            )),
                            SizedBox(height: 4.h),
                            CustomText(
                              text: "ESTIMATED CAMPAIGN REACH",
                              color: Colors.white38,
                              fontSize: 7.5.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Obx(() => CustomText(
                              text: "${durationDays.value} Days",
                              color: AppColors.yellow,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                            )),
                            SizedBox(height: 4.h),
                            CustomText(
                              text: "CAMPAIGN DURATION",
                              color: Colors.white38,
                              fontSize: 7.5.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white10, height: 24),
                    Obx(() => CustomText(
                      text: "Total marketing investment for this campaign: \$${getTotalSpend()}.00 USD.",
                      color: Colors.white54,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                    )),
                  ],
                ),
              ),
              SizedBox(height: 28.h),

              // START PROMOTION Button
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.snackbar(
                    "PROMOTION INITIATED",
                    "Your outreach campaign has been registered and is queueing for verification.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xff111111),
                    colorText: Colors.white,
                    borderColor: AppColors.yellow,
                    borderWidth: 1,
                  );
                },
                child: Container(
                  height: 48.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: CustomText(
                      text: "START PROMOTION",
                      color: Colors.black,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard({
    required String goalId,
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff111111),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.yellow : Colors.white10,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        padding: EdgeInsets.all(14.w),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.yellow : Colors.white54,
              size: 22.sp,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    color: isSelected ? AppColors.yellow : Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: description,
                    color: Colors.white38,
                    fontSize: 8.5.sp,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.radio_button_checked, color: AppColors.yellow, size: 18.sp)
            else
              Icon(Icons.radio_button_off, color: Colors.white24, size: 18.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildAudienceChip(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 34.h,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.yellow : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected ? AppColors.yellow : Colors.white10,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: CustomText(
            text: label.toUpperCase(),
            color: isSelected ? Colors.black : Colors.white54,
            fontSize: 8.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetButton(int value, bool isSelected, VoidCallback onTap) {
    final text = value == 0 ? "CUSTOM" : "\$$value";
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72.w,
        height: 38.h,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.yellow : const Color(0xff111111),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.yellow : Colors.white10,
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: CustomText(
          text: text,
          color: isSelected ? Colors.black : Colors.white70,
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

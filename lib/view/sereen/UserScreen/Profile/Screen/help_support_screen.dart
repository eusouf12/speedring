import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_button/custom_button.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';

class HelpSupportController extends GetxController {
  final ticketSubjectController = TextEditingController();
  final ticketMessageController = TextEditingController();

  final expandedFaqIndex = (-1).obs;

  @override
  void onClose() {
    ticketSubjectController.dispose();
    ticketMessageController.dispose();
    super.onClose();
  }

  void toggleFaq(int index) {
    if (expandedFaqIndex.value == index) {
      expandedFaqIndex.value = -1;
    } else {
      expandedFaqIndex.value = index;
    }
  }

  void submitTicket() {
    if (ticketSubjectController.text.isEmpty || ticketMessageController.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Subject and description are required to submit a ticket.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff181818),
        colorText: Colors.redAccent,
        borderColor: Colors.redAccent.withValues(alpha: 0.5),
        borderWidth: 1,
      );
      return;
    }

    ticketSubjectController.clear();
    ticketMessageController.clear();

    Get.snackbar(
      "Ticket Submitted",
      "Support has received your ticket and will respond via notification shortly.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff181818),
      colorText: Colors.white,
      borderColor: AppColors.yellow,
      borderWidth: 1,
    );
  }
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HelpSupportController());
    final List<Map<String, String>> faqs = [
      {
        "q": "HOW DOES TELEMETRY LOGGING WORK?",
        "a": "Speedring connects to your device's internal GPS sensor and maps coordinates, speed, and elevation in real time during a session. Ensure location services are set to 'Always Allow' for the best tracking performance."
      },
      {
        "q": "HOW DO I UPGRADE TO PRO CERTIFIED STATUS?",
        "a": "Pro status is granted when a driver completes a verification checklist including verified track session completions, slot occupancy, and positive driver rating metrics."
      },
      {
        "q": "CAN I EXPORT MY SESSION METRICS?",
        "a": "Yes! Advanced analytics are exportable as CSV or JSON dossiers for integration with professional telemetry tools. This feature requires an active premium subscription."
      },
    ];

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
            onPressed: () => Get.back(),
          ),
          titleSpacing: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: "SYSTEM SUPPORT",
                color: AppColors.yellow,
                fontSize: 8.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
              CustomText(
                text: "HELP & SUPPORT",
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// FAQ header
              _buildSectionHeader("FREQUENTLY ASKED QUESTIONS"),
              SizedBox(height: 12.h),

              /// FAQ Items
              ...List.generate(faqs.length, (idx) {
                final faq = faqs[idx];
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff111111),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () => controller.toggleFaq(idx),
                          title: CustomText(
                            text: faq["q"]!,
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.start,
                          ),
                          trailing: Obx(() => Icon(
                                controller.expandedFaqIndex.value == idx
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.white60,
                              )),
                        ),
                        Obx(() => controller.expandedFaqIndex.value == idx
                            ? Padding(
                                padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
                                child: CustomText(
                                  text: faq["a"]!,
                                  color: Colors.white54,
                                  fontSize: 11,
                                  textAlign: TextAlign.start,
                                  height: 1.5,
                                ),
                              )
                            : const SizedBox.shrink()),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: 24.h),

              /// Contact Support section
              _buildSectionHeader("SUBMIT A SUPPORT TICKET"),
              SizedBox(height: 12.h),

              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel("SUBJECT"),
                    _buildTextField(
                      controller: controller.ticketSubjectController,
                      hint: "Enter ticket topic...",
                    ),
                    SizedBox(height: 16.h),
                    _buildFieldLabel("DESCRIPTION / DETAILS"),
                    _buildTextField(
                      controller: controller.ticketMessageController,
                      hint: "Explain your issue or question in detail...",
                      maxLines: 4,
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                      height: 44.h,
                      title: "SUBMIT TICKET",
                      fontSize: 12,
                      borderRadius: 8.r,
                      onTap: controller.submitTicket,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return CustomText(
      text: title,
      color: AppColors.yellow,
      fontSize: 9.sp,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.0,
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: label,
        color: Colors.white38,
        fontSize: 8.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: maxLines > 1 ? 8.h : 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
          isDense: true,
        ),
      ),
    );
  }
}

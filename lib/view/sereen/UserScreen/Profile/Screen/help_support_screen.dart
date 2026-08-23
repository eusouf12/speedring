import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/ToastMsg/toast_message.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_loader/custom_loader.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/app_const/app_const.dart';
import 'package:speedring/helper/shared_prefe/shared_prefe.dart';
import 'dart:convert';
import '../controller/manage_web_controller.dart';

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

  final RxBool isLoading = false.obs;

  void submitTicket() async {
    if (ticketSubjectController.text.isEmpty ||
        ticketMessageController.text.isEmpty) {
      Get.snackbar(
        "validationError".tr,
        "subjectDescRequired".tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff181818),
        colorText: Colors.redAccent,
        borderColor: Colors.redAccent.withValues(alpha: 0.5),
        borderWidth: 1,
      );
      return;
    }

    isLoading.value = true;
    try {
      String name = await SharePrefsHelper.getString(
        AppConstants.name,
        defaultValue: "User",
      );
      String email = await SharePrefsHelper.getString(
        AppConstants.email,
        defaultValue: "user@example.com",
      );

      Map<String, dynamic> body = {
        "name": name,
        "email": email,
        "subject": ticketSubjectController.text,
        "desc": ticketMessageController.text,
      };

      var response = await ApiClient.postData(
        ApiUrl.createContact,
        jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ticketSubjectController.clear();
        ticketMessageController.clear();
        showCustomSnackBar("ticketSubmitted".tr, isError: false);
      } else {
        showCustomSnackBar("failedSubmitTicket".tr);
      }
    } catch (e) {
      showCustomSnackBar("errorOccurred".tr);
    } finally {
      isLoading.value = false;
    }
  }
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HelpSupportController>();
    final manageWebController = Get.find<ManageWebController>()..fetchFaq();

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
          title: CustomText(
            text: "helpSupport".tr.toUpperCase(),
            color: AppColors.yellow,
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// FAQ header
              _buildSectionHeader("FREQUENTLY ASKED QUESTIONS".tr),
              SizedBox(height: 12.h),

              /// FAQ Items
              Obx(() {
                if (manageWebController.isLoadingFaq.value) {
                  return const Center(child: CustomLoader());
                }

                final faqs = manageWebController.faqList;
                if (faqs.isEmpty) {
                  return Center(
                    child: CustomText(
                      text: "No FAQs available".tr,
                      color: Colors.white54,
                    ),
                  );
                }

                return Column(
                  children: List.generate(faqs.length, (idx) {
                    final faq = faqs[idx];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff111111),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Column(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: ListTile(
                                onTap: () => controller.toggleFaq(idx),
                                title: CustomText(
                                  text: faq["question"] ?? '',
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.start,
                                ),
                                trailing: Obx(
                                  () => Icon(
                                    controller.expandedFaqIndex.value == idx
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: Colors.white60,
                                  ),
                                ),
                              ),
                            ),
                            Obx(
                              () => controller.expandedFaqIndex.value == idx
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                        left: 16.w,
                                        right: 16.w,
                                        bottom: 16.h,
                                      ),
                                      child: Html(
                                        data: faq["answer"] ?? '',
                                        style: {
                                          "body": Style(
                                            color: Colors.white54,
                                            fontSize: FontSize(11.0),
                                            margin: Margins.zero,
                                            padding: HtmlPaddings.zero,
                                          ),
                                        },
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              }),
              SizedBox(height: 24.h),

              /// Contact Support section
              _buildSectionHeader("submitSupportTicket".tr),
              SizedBox(height: 12.h),

              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel("subject".tr),
                    _buildTextField(
                      controller: controller.ticketSubjectController,
                      hint: "enterTicketTopic".tr,
                    ),
                    SizedBox(height: 16.h),
                    _buildFieldLabel("descriptionDetails".tr),
                    _buildTextField(
                      controller: controller.ticketMessageController,
                      hint: "explainIssueDetail".tr,
                      maxLines: 4,
                    ),
                    SizedBox(height: 20.h),
                    Obx(
                      () => CustomButton(
                        height: 44.h,
                        title: "SUBMIT TICKET".tr,
                        fontSize: 12,
                        borderRadius: 8.r,
                        isLoading: controller.isLoading.value,
                        fillColor: AppColors.yellow,
                        textColor: Colors.black,
                        onTap: controller.submitTicket,
                      ),
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
      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: maxLines > 1 ? 8.h : 4.h,
      ),
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

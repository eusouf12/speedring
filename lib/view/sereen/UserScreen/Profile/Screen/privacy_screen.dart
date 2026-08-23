import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../controller/manage_web_controller.dart';
import 'package:speedring/view/components/custom_loader/custom_loader.dart';
import 'package:flutter_html/flutter_html.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ManageWebController>()..fetchPrivacyPolicy();

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
            text: "privacyPolicy".tr.toUpperCase(),
            color: AppColors.yellow,
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        body: Obx(() {
          if (controller.isLoadingPrivacy.value) {
            return const Center(child: CustomLoader());
          }
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: _buildContentCard(
              child: Html(
                data: controller.privacyContent.value,
                style: {
                  "body": Style(
                    color: const Color(0xffB0B0B0),
                    fontSize: FontSize(12.0),
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                  ),
                },
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContentCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: child,
    );
  }
}

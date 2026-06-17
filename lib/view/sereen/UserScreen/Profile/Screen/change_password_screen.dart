import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_button/custom_button.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';

class ChangePasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final obscureCurrent = true.obs;
  final obscureNew = true.obs;
  final obscureConfirm = true.obs;

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void updatePassword() {
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "All password fields are required.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff181818),
        colorText: Colors.redAccent,
        borderColor: Colors.redAccent.withValues(alpha: 0.5),
        borderWidth: 1,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        "Error",
        "New password and confirm password do not match.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff181818),
        colorText: Colors.redAccent,
        borderColor: Colors.redAccent.withValues(alpha: 0.5),
        borderWidth: 1,
      );
      return;
    }

    Get.back();
    Get.snackbar(
      "Security Updated",
      "Your password has been successfully updated.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff181818),
      colorText: Colors.white,
      borderColor: AppColors.yellow,
      borderWidth: 1,
    );
  }
}

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());
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
                text: "SYSTEM SECURITY",
                color: AppColors.yellow,
                fontSize: 8.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
              CustomText(
                text: "CHANGE PASSWORD",
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    _buildFieldLabel("CURRENT PASSWORD"),
                    Obx(() => _buildTextField(
                          controller: controller.currentPasswordController,
                          obscureText: controller.obscureCurrent.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscureCurrent.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.white38,
                              size: 18,
                            ),
                            onPressed: () => controller.obscureCurrent.toggle(),
                          ),
                        )),
                    SizedBox(height: 16.h),
                    _buildFieldLabel("NEW PASSWORD"),
                    Obx(() => _buildTextField(
                          controller: controller.newPasswordController,
                          obscureText: controller.obscureNew.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscureNew.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.white38,
                              size: 18,
                            ),
                            onPressed: () => controller.obscureNew.toggle(),
                          ),
                        )),
                    SizedBox(height: 16.h),
                    _buildFieldLabel("CONFIRM PASSWORD"),
                    Obx(() => _buildTextField(
                          controller: controller.confirmPasswordController,
                          obscureText: controller.obscureConfirm.value,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscureConfirm.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.white38,
                              size: 18,
                            ),
                            onPressed: () => controller.obscureConfirm.toggle(),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              CustomButton(
                height: 50.h,
                title: "UPDATE PASSWORD",
                fontSize: 13,
                borderRadius: 8.r,
                onTap: controller.updatePassword,
              ),
            ],
          ),
        ),
      ),
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
    required bool obscureText,
    Widget? suffixIcon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          ?suffixIcon,
        ],
      ),
    );
  }
}

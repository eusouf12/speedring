import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../core/app_routes/app_routes.dart';

class UserParametersScreen extends StatefulWidget {
  const UserParametersScreen({super.key});

  @override
  State<UserParametersScreen> createState() => _UserParametersScreenState();
}

class _UserParametersScreenState extends State<UserParametersScreen> {
  bool isAccountExpanded = true;
  final TextEditingController _displayNameController = TextEditingController(text: "DOMINIC_TORETTO_99");
  final TextEditingController _emailController = TextEditingController(text: "******@speedring.pro");
  
  final TextEditingController _currPassController = TextEditingController(text: "•••••••••");
  final TextEditingController _newPassController = TextEditingController(text: "•••••••••");
  final TextEditingController _confirmPassController = TextEditingController(text: "•••••••••");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: "SYSTEM CONFIGURATION",
              color: AppColors.yellow,
              fontSize: 8.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
            const Text(
              "USER PARAMETERS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Driver status banner
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.yellow,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified, color: Colors.black, size: 20),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "DRIVER PROFILE",
                        color: Colors.white38,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      SizedBox(height: 2.h),
                      const CustomText(
                        text: "PRO CERTIFIED",
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            /// Account accordion
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      setState(() {
                        isAccountExpanded = !isAccountExpanded;
                      });
                    },
                    leading: const Icon(Icons.person_outline, color: Colors.white70),
                    title: const CustomText(
                      text: "ACCOUNT",
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    trailing: Icon(
                      isAccountExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.white70,
                    ),
                  ),
                  if (isAccountExpanded) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("DISPLAY NAME"),
                          _buildTextField(controller: _displayNameController),
                          SizedBox(height: 12.h),
                          _buildFieldLabel("EMAIL ENCRYPTION"),
                          _buildTextField(controller: _emailController),
                          SizedBox(height: 16.h),
                          CustomButton(
                            height: 40.h,
                            title: "UPDATE CREDENTIALS",
                            fontSize: 11,
                            borderRadius: 6.r,
                            onTap: () {},
                          ),
                          SizedBox(height: 20.h),
                          _buildSectionHeader("SECURITY PARAMETERS"),
                          SizedBox(height: 8.h),
                          _buildFieldLabel("CURRENT PASSWORD"),
                          _buildTextField(controller: _currPassController, obscureText: true),
                          SizedBox(height: 12.h),
                          _buildFieldLabel("NEW PASSWORD"),
                          _buildTextField(controller: _newPassController, obscureText: true),
                          SizedBox(height: 12.h),
                          _buildFieldLabel("CONFIRM PASSWORD"),
                          _buildTextField(controller: _confirmPassController, obscureText: true),
                          SizedBox(height: 16.h),
                          CustomButton(
                            height: 40.h,
                            title: "RESET SECURITY ACCESS",
                            fontSize: 11,
                            borderRadius: 6.r,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 16.h),

            /// Settings menu list
            _buildSettingsTile(
              icon: Icons.notifications_none,
              title: "NOTIFICATIONS",
              onTap: () => Get.toNamed(AppRoutes.notificationScreen),
            ),
            SizedBox(height: 12.h),
            _buildSettingsTile(
              icon: Icons.workspace_premium_outlined,
              title: "SUBSCRIPTION",
              onTap: () {},
            ),
            SizedBox(height: 12.h),
            _buildSettingsTile(
              icon: Icons.gavel_outlined,
              title: "TERMS & CONDITIONS",
              onTap: () {},
            ),
            SizedBox(height: 12.h),
            _buildSettingsTile(
              icon: Icons.security_outlined,
              title: "PRIVACY POLICY",
              onTap: () {},
            ),
            SizedBox(height: 12.h),
            _buildSettingsTile(
              icon: Icons.help_outline,
              title: "HELP & SUPPORT",
              onTap: () {},
            ),
            SizedBox(height: 12.h),
            _buildSettingsTile(
              icon: Icons.info_outline,
              title: "ABOUT",
              onTap: () {},
            ),
            SizedBox(height: 24.h),

            /// Terminate session button
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: const Color(0xff181111),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              child: InkWell(
                onTap: () {
                  Get.offAllNamed(AppRoutes.loginScreen);
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: Colors.redAccent, size: 18),
                    SizedBox(width: 8.w),
                    const CustomText(
                      text: "TERMINATE SESSION",
                      color: Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            /// Build version info
            Center(
              child: CustomText(
                text: "SPEEDRING SYSTEM V4.2.0 | BUILD 88A92X",
                color: Colors.white24,
                fontSize: 8.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return CustomText(
      text: title,
      color: AppColors.yellow,
      fontSize: 8.sp,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.0,
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: CustomText(
        text: label,
        color: Colors.white38,
        fontSize: 8.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, bool obscureText = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withOpacity(0.03)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.white70, size: 20),
        title: CustomText(
          text: title,
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white38),
      ),
    );
  }
}

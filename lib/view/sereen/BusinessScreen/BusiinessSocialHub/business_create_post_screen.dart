import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_image/custom_image.dart';
import '../../../components/custom_text/custom_text.dart';

class BusinessCreatePostScreen extends StatefulWidget {
  const BusinessCreatePostScreen({super.key});

  @override
  State<BusinessCreatePostScreen> createState() => _BusinessCreatePostScreenState();
}

class _BusinessCreatePostScreenState extends State<BusinessCreatePostScreen> {
  int? _selectedIndex;

  final List<Map<String, dynamic>> _postTypes = [
    {
      'icon': Icons.speed_outlined,
      'title': "SESSION POST",
      'description': "Share your latest lap times and telemetry data.",
    },
    {
      'icon': Icons.remove_red_eye_outlined,
      'title': "SPOT POST",
      'description': "Captured a rare machine? Share your latest find.",
    },
    {
      'icon': Icons.add_location_alt_outlined,
      'title': "TRACK UPDATE",
      'description': "Live reports on track conditions and traffic.",
    },
    {
      'icon': Icons.groups_outlined,
      'title': "CLUB POST",
      'description': "Connect with your crew and organize private events.",
    },
    {
      'icon': Icons.work_outline,
      'title': "BUSINESS POST",
      'description': "List vehicles, services, or professional insights.",
    },
  ];

  @override
  Widget build(BuildContext context) {
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
          title: CustomImage(
            imageSrc: AppImages.logo,
            imageType: ImageType.png,
            height: 30.h,
            fit: BoxFit.contain,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(height: 24.h),
            CustomText(
              text: "CREATE YOUR POST",
              color: AppColors.yellow,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
            SizedBox(height: 24.h),

            // Selection options
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: _postTypes.length,
                itemBuilder: (context, index) {
                  final type = _postTypes[index];
                  final isSelected = _selectedIndex == index;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: const Color(0xff111111),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isSelected ? AppColors.yellow : Colors.white10,
                          width: isSelected ? 1.5.w : 1.0.w,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Icon container
                          Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                              color: const Color(0xff1A1A1A),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              type['icon'] as IconData,
                              color: isSelected ? AppColors.yellow : Colors.white70,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 14.w),

                          // Text Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: type['title'] as String,
                                  color: isSelected ? AppColors.yellow : Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w900,
                                  textAlign: TextAlign.start,
                                  letterSpacing: 0.5,
                                ),
                                SizedBox(height: 4.h),
                                CustomText(
                                  text: type['description'] as String,
                                  color: Colors.white38,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: isSelected ? AppColors.yellow : Colors.white24,
                            size: 18.sp,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Continue section
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, MediaQuery.of(context).padding.bottom + 16.h),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _selectedIndex != null ? _onContinue : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 50.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: _selectedIndex != null ? AppColors.yellow : const Color(0xff2A2A2A),
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: Center(
                        child: Text(
                          "CONTINUE →",
                          style: TextStyle(
                            color: _selectedIndex != null ? Colors.black : Colors.white24,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  CustomText(
                    text: "SELECT A CATEGORY TO PROCEED TO THE EDITOR",
                    color: Colors.white24,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onContinue() {
    if (_selectedIndex == 0) {
      Get.toNamed(AppRoutes.businessCreateSessionPostScreen);
    } else if (_selectedIndex == 1) {
      Get.toNamed(AppRoutes.businessCreateSpotPostScreen);
    } else if (_selectedIndex == 2) {
      Get.toNamed(AppRoutes.businessCreateTrackUpdateScreen);
    } else if (_selectedIndex == 3) {
      Get.toNamed(AppRoutes.businessCreateClubPostScreen);
    } else if (_selectedIndex == 4) {
      // Business Post
      Get.toNamed(AppRoutes.businessRegistrationStep1); // Or back/mock
    }
  }
}

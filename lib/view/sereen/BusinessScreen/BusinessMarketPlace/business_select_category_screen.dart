import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';

class BusinessSelectCategoryScreen extends StatelessWidget {
  const BusinessSelectCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Reactive selected index
    final RxInt selectedIndex = (-1).obs;

    final List<Map<String, String>> categories = [
      {
        'id': 'CAT-01',
        'title': 'VEHICLES',
        'desc': 'High-performance cars, GT3 racers, and luxury collectibles.',
        'image': 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=800&fit=crop',
      },
      {
        'id': 'CAT-02',
        'title': 'MOTORCYCLES',
        'desc': 'Superbikes, custom builds, and professional racing machinery.',
        'image': 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800&fit=crop',
      },
      {
        'id': 'CAT-03',
        'title': 'PERFORMANCE PARTS',
        'desc': 'Engine components, aero kits, and technical hardware.',
        'image': 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800&fit=crop',
      },
      {
        'id': 'CAT-04',
        'title': 'EXPERT SERVICES',
        'desc': 'Tuning, coaching, track-side support, and logistics.',
        'image': 'https://images.unsplash.com/photo-1517524206127-48bbd363f3d7?w=800&fit=crop',
      },
    ];

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.yellow),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "CREATE LISTING",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "ASSET CONFIGURATION",
                      color: AppColors.yellow,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 6.h),
                    CustomText(
                      text: "SELECT CATEGORY",
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 8.h),
                    CustomText(
                      text: "Choose the asset class you wish to list on the global marketplace.",
                      color: Colors.white60,
                      fontSize: 12.sp,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 24.h),

                    // Cards list
                    Obx(
                      () => Column(
                        children: List.generate(categories.length, (index) {
                          final cat = categories[index];
                          final isSelected = selectedIndex.value == index;

                          return GestureDetector(
                            onTap: () {
                              selectedIndex.value = index;
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              height: 120.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xff111111),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: isSelected ? AppColors.yellow : Colors.white10,
                                  width: isSelected ? 1.5.w : 1.0.w,
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Stack(
                                children: [
                                  // Faded background image
                                  Opacity(
                                    opacity: 0.15,
                                    child: Image.network(
                                      cat['image']!,
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
                                    ),
                                  ),

                                  // Card Content
                                  Padding(
                                    padding: EdgeInsets.all(20.w),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            CustomText(
                                              text: cat['id']!,
                                              color: AppColors.yellow,
                                              fontSize: 9.sp,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 1.0,
                                            ),
                                            SizedBox(width: 8.w),
                                            Container(
                                              height: 1.h,
                                              width: 24.w,
                                              color: AppColors.yellow.withValues(alpha: 0.5),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6.h),
                                        CustomText(
                                          text: cat['title']!,
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                        SizedBox(height: 4.h),
                                        CustomText(
                                          text: cat['desc']!,
                                          color: Colors.white60,
                                          fontSize: 11.sp,
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Continue Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Obx(() {
                final hasSelection = selectedIndex.value != -1;
                return CustomButton(
                  height: 48.h,
                  title: "CONTINUE",
                  fontSize: 12.sp,
                  fillColor: hasSelection ? AppColors.yellow : const Color(0xff222222),
                  textColor: hasSelection ? Colors.black : Colors.white30,
                  borderRadius: 10.r,
                  onTap: hasSelection
                      ? () {
                          // Route based on selection
                          switch (selectedIndex.value) {
                            case 0:
                              Get.toNamed(AppRoutes.businessCreateVehicleListingScreen);
                              break;
                            case 1:
                              Get.toNamed(AppRoutes.businessCreateMotorcycleListingScreen);
                              break;
                            case 2:
                              Get.toNamed(AppRoutes.businessCreatePartsListingScreen);
                              break;
                            case 3:
                              Get.toNamed(AppRoutes.businessCreateServicesListingScreen);
                              break;
                          }
                        }
                      : null,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../core/app_routes/app_routes.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({super.key});

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  int selectedIndex = 0;

  final List<Map<String, String>> categories = [
    {
      "code": "CAT-01",
      "title": "VEHICLES",
      "description":
          "High-performance cars, GT3 racers, and luxury collectibles.",
      "image":
          "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=500&fit=crop",
    },
    {
      "code": "CAT-02",
      "title": "MOTORCYCLES",
      "description":
          "Superbikes, custom builds, and professional racing machinery.",
      "image":
          "https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=500&fit=crop",
    },
    {
      "code": "CAT-03",
      "title": "PERFORMANCE PARTS",
      "description": "Engine components, aero kits, and technical hardware.",
      "image":
          "https://images.unsplash.com/photo-1486006920555-c77dce18193b?w=500&fit=crop",
    },
    {
      "code": "CAT-04",
      "title": "EXPERT SERVICES",
      "description": "Tuning, coaching, track-side support, and logistics.",
      "image":
          "https://images.unsplash.com/photo-1486006920555-c77dce18193b?w=500&fit=crop",
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
            icon: const Icon(Icons.close, color: AppColors.yellow),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "CREATE LISTING",
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      CustomText(
                        text: "ASSET CONFIGURATION",
                        color: AppColors.yellow,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        text: "SELECT CATEGORY",
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 12.h),
                      CustomText(
                        text:
                            "Choose the asset class you wish to list on the global marketplace.",
                        color: Colors.white60,
                        fontSize: 12,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 24.h),

                      /// Category Options
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categories.length,
                        itemBuilder: (context, idx) {
                          final cat = categories[idx];
                          final bool isSel = selectedIndex == idx;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = idx;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              height: 140.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: isSel
                                      ? AppColors.yellow
                                      : Colors.white12,
                                  width: isSel ? 2 : 1,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(cat["image"]!),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withValues(alpha:
                                      isSel ? 0.65 : 0.8,
                                    ),
                                    BlendMode.srcOver,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomText(
                                      text: cat["code"]!,
                                      color: isSel
                                          ? AppColors.yellow
                                          : Colors.white38,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(height: 4.h),
                                    CustomText(
                                      text: cat["title"]!,
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(height: 4.h),
                                    CustomText(
                                      text: cat["description"]!,
                                      color: Colors.white60,
                                      fontSize: 10,
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              /// Footer Continue Button
              Padding(
                padding: EdgeInsets.all(16.w),
                child: CustomButton(
                  height: 50.h,
                  title: "CONTINUE",
                  fontSize: 14,
                  onTap: () {
                    if (selectedIndex == 0) {
                      Get.toNamed(AppRoutes.createVehicleListingScreen);
                    } else if (selectedIndex == 1) {
                      Get.toNamed(AppRoutes.createMotorcycleListingScreen);
                    } else {
                      Get.snackbar(
                        "Listing Category Selected",
                        "Listing category details: ${categories[selectedIndex]["title"]}",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xff181818),
                        colorText: Colors.white,
                        borderColor: AppColors.yellow,
                        borderWidth: 1,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

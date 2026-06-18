import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../../core/app_routes/app_routes.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../business_navbar.dart';

class AddAssetCategoryScreen extends StatelessWidget {
  const AddAssetCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "SELECT ASSET CATEGORY",
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
              ),
              SizedBox(height: 4.h),
              CustomText(
                text: "Choose the type of inventory sequence to initialize.",
                color: Colors.white60,
                fontSize: 12.sp,
              ),
              SizedBox(height: 24.h),
      
              // Vehicles Category Card
              _buildCategoryCard(
                label: "VEHICLES",
                title: "HIGH-PERFORMANCE VEHICLES",
                desc: "GT3, Formula, and Road-Legal track specials.",
                imageUrl: "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=800&fit=crop",
                onTap: () {
                  // Route to vehicle listing creation screen
                  Get.toNamed(AppRoutes.createVehicleListingScreen);
                },
              ),
              SizedBox(height: 16.h),
      
              // Motorcycles Category Card
              _buildCategoryCard(
                label: "MOTORCYCLES",
                title: "SUPERBIKES",
                desc: "Elite two-wheel performance machinery.",
                imageUrl: "https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800&fit=crop",
                onTap: () {
                  Get.toNamed(AppRoutes.createMotorcycleListingScreen);
                },
              ),
              SizedBox(height: 16.h),
      
              // Parts Category Card
              _buildCategoryCard(
                label: "PARTS",
                title: "PERFORMANCE PARTS",
                desc: "Individual components and engineering modules.",
                imageUrl: "https://images.unsplash.com/photo-1486006920555-c77dce18193b?w=800&fit=crop",
                onTap: () {
                  Get.toNamed(AppRoutes.createPartsListingScreen);
                },
              ),
              SizedBox(height: 16.h),
      
              // Services Category Card
              _buildCategoryCard(
                label: "SERVICES",
                title: "EXPERT SERVICES",
                desc: "Workshop tuning, coaching, and maintenance.",
                imageUrl: "https://images.unsplash.com/photo-1517524206127-48bbd363f3d7?w=800&fit=crop",
                onTap: () {
                  Get.toNamed(AppRoutes.createServicesListingScreen);
                },
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBusinessNavBar(currentIndex: 1),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: AppColors.yellow),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        "ADD ASSET",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: const CircleAvatar(
            backgroundColor: Color(0xff222222),
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required String label,
    required String title,
    required String desc,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xff111111),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white10),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Faded background image
            Opacity(
              opacity: 0.2,
              child: Image.network(
                imageUrl,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
              ),
            ),

            // Content Overlay
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: label,
                    color: AppColors.yellow,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                  SizedBox(height: 6.h),
                  CustomText(
                    text: title,
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: desc,
                    color: Colors.white70,
                    fontSize: 11.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

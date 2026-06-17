import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_text/custom_text.dart';
import '../BusinessHome/business_navbar.dart';

class BusinessMarketplaceScreen extends StatefulWidget {
  const BusinessMarketplaceScreen({super.key});

  @override
  State<BusinessMarketplaceScreen> createState() => _BusinessMarketplaceScreenState();
}

class _BusinessMarketplaceScreenState extends State<BusinessMarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _marketplaceItems = [
    {
      'id': '1',
      'category': 'VEHICLE',
      'title': 'APEX-7 TURBO S',
      'subtitle': '2024 PRODUCTION MODEL',
      'price': r'$245,000',
      'imageUrl': 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=800&fit=crop',
    },
    {
      'id': '2',
      'category': 'MOTORCYCLE',
      'title': 'V-CORE 1100R',
      'subtitle': 'RACING SPECIFICATION',
      'price': r'$42,900',
      'imageUrl': 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800&fit=crop',
    },
    {
      'id': '3',
      'category': 'VEHICLE',
      'title': 'STRATOS GT3',
      'subtitle': 'TRACK ONLY EDITION',
      'price': r'$510,000',
      'imageUrl': 'https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=800&fit=crop',
    },
    {
      'id': '4',
      'category': 'PARTS',
      'title': 'FORGED CARBON SET',
      'subtitle': 'ULTRA-LIGHTWEIGHT COMPONENTS',
      'price': r'$18,500',
      'imageUrl': 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800&fit=crop',
    },
    {
      'id': '5',
      'category': 'SERVICES',
      'title': 'MASTER SUSPENSION TUNING',
      'subtitle': 'Pit Garage Service',
      'price': r'$250/hr',
      'imageUrl': 'https://images.unsplash.com/photo-1517524206127-48bbd363f3d7?w=800&fit=crop',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
          title: Image.asset(
            AppImages.logo,
            height: 26.h,
            fit: BoxFit.contain,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 12.h),

            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                height: 44.h,
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.white10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.white30, size: 18.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "What do you want to buy?",
                          hintStyle: TextStyle(color: Colors.white30, fontSize: 13),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Actions Buttons Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        minimumSize: Size(double.infinity, 38.h),
                      ),
                      onPressed: () => Get.toNamed(AppRoutes.addAssetCategoryScreen),
                      icon: const Icon(Icons.add_circle_outline, size: 16),
                      label: Text(
                        "START LISTING",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1E1E1E),
                        foregroundColor: Colors.white38,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          side: const BorderSide(color: Colors.white10),
                        ),
                        minimumSize: Size(double.infinity, 38.h),
                      ),
                      onPressed: () {
                        // Select category action
                      },
                      icon: const Icon(Icons.tune_rounded, size: 16, color: Colors.white38),
                      label: Text(
                        "SELECT CATEGORY",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Marketplace items feed list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: _marketplaceItems.length,
                itemBuilder: (context, index) {
                  final item = _marketplaceItems[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 20.h),
                    decoration: BoxDecoration(
                      color: const Color(0xff111111),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image with Category Badge overlay
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.r),
                                topRight: Radius.circular(16.r),
                              ),
                              child: Container(
                                height: 180.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(item['imageUrl'] as String),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            // Category Badge
                            Positioned(
                              top: 12.h,
                              left: 12.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: AppColors.yellow,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  item['category'] as String,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Title, Subtitle, Price, and Buttons
                        Padding(
                          padding: EdgeInsets.all(14.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: item['title'] as String,
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w900,
                                          textAlign: TextAlign.start,
                                        ),
                                        SizedBox(height: 2.h),
                                        CustomText(
                                          text: item['subtitle'] as String,
                                          color: Colors.white38,
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.bold,
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                  CustomText(
                                    text: item['price'] as String,
                                    color: AppColors.yellow,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ],
                              ),
                              SizedBox(height: 14.h),

                              // Card Actions Row
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.yellow,
                                        foregroundColor: Colors.black,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        minimumSize: Size(double.infinity, 38.h),
                                      ),
                                      onPressed: () => Get.toNamed(
                                        AppRoutes.itemDetailScreen,
                                        arguments: {'title': item['title']},
                                      ),
                                      icon: const Icon(Icons.remove_red_eye_outlined, size: 15),
                                      label: Text(
                                        "VIEW DETAILS",
                                        style: TextStyle(
                                          fontSize: 9.5.sp,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  GestureDetector(
                                    onTap: () => Get.toNamed(
                                      AppRoutes.inboxScreen,
                                      arguments: {
                                        'userName': item['title'],
                                        'avatarUrl': item['imageUrl'],
                                        'isOnline': true,
                                      },
                                    ),
                                    child: Container(
                                      width: 38.h,
                                      height: 38.h,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff1E1E1E),
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(color: Colors.white10),
                                      ),
                                      child: const Icon(
                                        Icons.chat_bubble_outline_rounded,
                                        color: Colors.white70,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CustomBusinessNavBar(currentIndex: 3),
      ),
    );
  }
}

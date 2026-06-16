import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../core/app_routes/app_routes.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  String activeCategory = "ALL";

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
        title: const Text(
          "MY LISTINGS",
          style: TextStyle(
            color: AppColors.yellow,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: AppColors.yellow),
            onPressed: () => Get.toNamed(AppRoutes.selectCategoryScreen),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Metric boxes
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xff111111),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "ACTIVE LISTINGS",
                          color: Colors.white38,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 4.h),
                        const CustomText(
                          text: "03",
                          color: AppColors.yellow,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xff111111),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "TOTAL VALUATION",
                          color: Colors.white38,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 4.h),
                        const CustomText(
                          text: "\$1,450,000",
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            /// Categories chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip("ALL", "ALL (3)"),
                  SizedBox(width: 8.w),
                  _buildCategoryChip("VEHICLES", "VEHICLES (1)"),
                  SizedBox(width: 8.w),
                  _buildCategoryChip("MOTORCYCLES", "MOTORCYCLES (1)"),
                  SizedBox(width: 8.w),
                  _buildCategoryChip("PARTS", "PARTS (1)"),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            /// Listings items list
            if (activeCategory == "ALL" || activeCategory == "VEHICLES") ...[
              _buildListingCard(
                imageUrl: "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=500&fit=crop",
                statusLabel: "ACTIVE",
                statusColor: AppColors.yellow,
                statusTextColor: Colors.black,
                title: "Porsche 911 GT3 RS",
                idLabel: "VEHICLE ID: #GT3-992-04",
                price: "\$285,000",
                priceColor: AppColors.yellow,
                specs: {
                  "ENGINE OUTPUT": "525 HP",
                  "DISPLACEMENT": "3996 CC",
                },
                isEditButton: true,
              ),
              SizedBox(height: 16.h),
            ],
            if (activeCategory == "ALL" || activeCategory == "MOTORCYCLES") ...[
              _buildListingCard(
                imageUrl: "https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=500&fit=crop",
                statusLabel: "PENDING VERIFICATION",
                statusColor: Colors.orange,
                statusTextColor: Colors.white,
                title: "Ducati Panigale V4 R",
                idLabel: "MOTO ID: #V4R-DU-01",
                price: "\$45,000",
                priceColor: Colors.white,
                specs: {
                  "MAX POWER": "240 HP",
                  "CAPACITY": "998 CC",
                },
                isEditButton: false,
              ),
              SizedBox(height: 16.h),
            ],
            if (activeCategory == "ALL" || activeCategory == "PARTS") ...[
              _buildListingCard(
                imageUrl: "https://images.unsplash.com/photo-1486006920555-c77dce18193b?w=500&fit=crop",
                statusLabel: "SOLD",
                statusColor: Colors.white24,
                statusTextColor: Colors.white60,
                title: "BREMBO GTR BRAKING SYSTEM",
                idLabel: "PART ID: #B-GTR-092",
                price: "\$12,500",
                priceColor: Colors.white54,
                specs: {
                  "SPECIFICATION": "6-Piston Front",
                },
                isEditButton: false,
              ),
              SizedBox(height: 16.h),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String categoryId, String label) {
    final bool isSelected = activeCategory == categoryId;
    return GestureDetector(
      onTap: () {
        setState(() {
          activeCategory = categoryId;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.yellow : const Color(0xff111111),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: isSelected ? AppColors.yellow : Colors.white10),
        ),
        child: CustomText(
          text: label,
          color: isSelected ? Colors.black : Colors.white60,
          fontSize: 9.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListingCard({
    required String imageUrl,
    required String statusLabel,
    required Color statusColor,
    required Color statusTextColor,
    required String title,
    required String idLabel,
    required String price,
    required Color priceColor,
    required Map<String, String> specs,
    required bool isEditButton,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Image Stack
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: Image.network(
                  imageUrl,
                  height: 180.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: CustomText(
                    text: statusLabel,
                    color: statusTextColor,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          /// Card Details
          Padding(
            padding: EdgeInsets.all(16.w),
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
                            text: title,
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                          SizedBox(height: 2.h),
                          CustomText(
                            text: idLabel,
                            color: Colors.white38,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    CustomText(
                      text: price,
                      color: priceColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                /// Specs Row
                Row(
                  children: specs.entries.map((e) {
                    return Padding(
                      padding: EdgeInsets.only(right: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: e.key,
                            color: Colors.white38,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 2.h),
                          CustomText(
                            text: e.value,
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.h),

                /// Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: isEditButton
                          ? CustomButton(
                              height: 38.h,
                              title: "EDIT LISTING",
                              fontSize: 11,
                              borderRadius: 6.r,
                              onTap: () {},
                            )
                          : Container(
                              height: 38.h,
                              decoration: BoxDecoration(
                                color: const Color(0xff1a1a1a),
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(6.r),
                                child: const Center(
                                  child: CustomText(
                                    text: "VIEW DETAILS",
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      height: 38.h,
                      width: 44.w,
                      decoration: BoxDecoration(
                        color: const Color(0xff1d1717),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: Colors.red.withOpacity(0.2)),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                        onPressed: () {},
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
  }
}

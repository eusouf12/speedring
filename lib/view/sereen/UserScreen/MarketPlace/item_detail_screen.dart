import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../components/custom_nav_bar/navbar.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../core/app_routes/app_routes.dart';
import 'widgets/spec_tile.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({super.key});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  bool isFollowing = false;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
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
          title: Image.network(
            "https://picsum.photos/seed/speedringlogo/130/40",
            height: 30,
            width: 100,
            fit: BoxFit.contain,
            errorBuilder: (context, _, _) => const Text(
              "SPEEDRING",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.share, color: AppColors.yellow),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: AppColors.yellow,
              ),
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Showcase Image
              Container(
                height: 220.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white10),
                  image: const DecorationImage(
                    image: NetworkImage("https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=800&fit=crop"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
      
              /// Title & Price
              CustomText(
                text: "2024 PORSCHE 911 GT3 RS",
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 4.h),
              CustomText(
                text: "\$324,500",
                color: AppColors.yellow,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 24.h),
      
              /// Purchase & Offer Actions
              CustomButton(
                height: 48.h,
                title: "MESSAGE SELLER",
                fontSize: 13,
                borderRadius: 8.r,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.inboxScreen,
                    arguments: {
                      "userName": "Anderson Racing",
                      "avatarUrl": "https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=100&fit=crop",
                      "isOnline": true,
                    },
                  );
                },
              ),
              SizedBox(height: 12.h),
              CustomButton(
                height: 48.h,
                title: "SEND OFFER",
                fontSize: 13,
                fillColor: Colors.black,
                textColor: AppColors.yellow,
                isBorder: true,
                borderColor: AppColors.yellow,
                borderRadius: 8.r,
                onTap: () {
                  Get.snackbar(
                    "Offer Sent",
                    "Your offer has been submitted to the seller.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xff181818),
                    colorText: Colors.white,
                    borderColor: AppColors.yellow,
                    borderWidth: 1,
                  );
                },
              ),
              SizedBox(height: 24.h),
      
              /// PHASE 01: TECH SPECS
              _buildSectionHeader("PHASE 01: TECH SPECS"),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 2.2,
                children: const [
                  SpecTile(label: "FUEL TYPE", value: "98 Octane"),
                  SpecTile(label: "TRANSMISSION", value: "7-Speed PDK"),
                  SpecTile(label: "COLORWAY", value: "GT Silver"),
                  SpecTile(label: "INTERIOR", value: "Race-Tex"),
                ],
              ),
              SizedBox(height: 24.h),
      
              /// PHASE 02: NARRATIVE
              _buildSectionHeader("PHASE 02: NARRATIVE"),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "PRECISION ENGINEERED HISTORY",
                      color: AppColors.yellow,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 8.h),
                    CustomText(
                      text: "This 2024 iteration of the 911 GT3 RS represents the pinnacle of naturally aspirated performance. "
                          "Delivered in January 2024 to a private collection in Stuttgart, the vehicle has undergone strict "
                          "run-in procedures under professional supervision. Every component, from the DRS-enabled rear wing "
                          "to the carbon-fiber reinforced plastic doors, remains in showroom condition.",
                      color: Colors.white70,
                      fontSize: 11,
                      textAlign: TextAlign.start,
                      height: 1.5,
                    ),
                    SizedBox(height: 16.h),
                    Container(height: 1, color: Colors.white10),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetricCol("518 HP", "POWER"),
                        _buildMetricCol("3.2s", "0-60 MPH"),
                        _buildMetricCol("3,260 LB", "WEIGHT"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
      
              /// VERIFIED SELLER
              CustomText(
                text: "VERIFIED SELLER",
                color: Colors.white38,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage("https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=100&fit=crop"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "ANDERSON RACING",
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                textAlign: TextAlign.start,
                                letterSpacing: 0.5,
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: AppColors.yellow, size: 12),
                                  SizedBox(width: 4.w),
                                  const CustomText(
                                    text: "4.9 / 5.0",
                                    color: Colors.white60,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isFollowing = !isFollowing;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: isFollowing ? Colors.transparent : Colors.black,
                              border: Border.all(color: AppColors.yellow),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: CustomText(
                              text: isFollowing ? "FOLLOWING" : "FOLLOW",
                              color: isFollowing ? Colors.white70 : AppColors.yellow,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Container(height: 1, color: Colors.white10),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSellerCount("12", "ACTIVE LISTINGS"),
                        _buildSellerCount("142", "SUCCESSFUL SALES"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
      
              /// LOCATION TELEMETRY
              Container(
                margin: EdgeInsets.only(bottom: 30.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        CustomText(
                          text: "LOCATION TELEMETRY",
                          color: Colors.white38,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        CustomText(
                          text: "STUTTGART, DE",
                          color: Colors.white70,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
      
                    /// Styled map placeholder
                    Container(
                      height: 180.h,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.white.withValues(alpha:0.05)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: MapWireframePainter(),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 14.w,
                              height: 14.w,
                              decoration: BoxDecoration(
                                color: AppColors.yellow,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.yellow.withValues(alpha:0.5),
                                    blurRadius: 10,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12.h,
                            left: 12.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                CustomText(
                                  text: "LAT 48.7826 N",
                                  color: AppColors.yellow,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                                CustomText(
                                  text: "LON 9.1853 E",
                                  color: AppColors.yellow,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    CustomText(
                      text: "Stuttgart Performance District. Secured climate-controlled facility with 24/7 technical monitoring.",
                      color: Colors.white38,
                      fontSize: 10,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomNavBar(currentIndex: 3),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: CustomText(
        text: title,
        color: AppColors.yellow,
        fontSize: 9,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildMetricCol(String value, String label) {
    return Column(
      children: [
        CustomText(
          text: value,
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: label,
          color: Colors.white38,
          fontSize: 8,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ],
    );
  }

  Widget _buildSellerCount(String count, String label) {
    return Column(
      children: [
        CustomText(
          text: count,
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: label,
          color: Colors.white38,
          fontSize: 8,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ],
    );
  }
}

class MapWireframePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha:0.08)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha:0.15)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw some contour grid lines
    for (int i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i.toDouble(), 0), Offset(i.toDouble(), size.height), paint);
    }
    for (int j = 0; j < size.height; j += 30) {
      canvas.drawLine(Offset(0, j.toDouble()), Offset(size.width, j.toDouble()), paint);
    }

    // Draw some wireframe road paths
    final path = Path()
      ..moveTo(0, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.1, size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.9, size.width, size.height * 0.7);

    final path2 = Path()
      ..moveTo(size.width * 0.2, size.height)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.4, size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.6, size.height * 0.6, size.width * 0.8, 0);

    canvas.drawPath(path, roadPaint);
    canvas.drawPath(path2, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

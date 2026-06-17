import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_text/custom_text.dart';
import '../BusinessHome/business_navbar.dart';
import '../BusinessMarketPlace/business_profile_sheet_helper.dart';

class BusinessClubsScreen extends StatefulWidget {
  const BusinessClubsScreen({super.key});

  @override
  State<BusinessClubsScreen> createState() => _BusinessClubsScreenState();
}

class _BusinessClubsScreenState extends State<BusinessClubsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _myClubs = [
    {
      'name': 'GT3 COLL.',
      'imageUrl': 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=200&fit=crop',
    },
    {
      'name': 'NUR ENDO',
      'imageUrl': 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=200&fit=crop',
    },
    {
      'name': 'APEX PREP',
      'imageUrl': 'https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=200&fit=crop',
    },
  ];

  final List<Map<String, dynamic>> _trendingClubs = [
    {
      'name': 'Porsche GT3 Collective',
      'members': '1,240 ACTIVE MEMBERS',
      'imageUrl': 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=200&fit=crop',
    },
    {
      'name': 'Nürburgring Endurance Group',
      'members': '856 ACTIVE MEMBERS',
      'imageUrl': 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=200&fit=crop',
    },
    {
      'name': 'Apex Strategy Masters',
      'members': '412 ACTIVE MEMBERS',
      'imageUrl': 'https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=200&fit=crop',
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
          leading: Padding(
            padding: EdgeInsets.all(12.w),
            child: GestureDetector(
              onTap: () => BusinessProfileSheetHelper.show(context),
              child: CircleAvatar(
                backgroundColor: const Color(0xff222222),
                backgroundImage: const NetworkImage(
                  "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=100&fit=crop",
                ),
              ),
            ),
          ),
          title: Image.asset(
            AppImages.logo,
            height: 26.h,
            fit: BoxFit.contain,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),

            // Search clubs text field
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
                          hintText: "Search Clubs",
                          hintStyle: TextStyle(color: Colors.white30, fontSize: 13),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // YOUR CLUBS SECTION
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomText(
                text: "YOUR CLUBS",
                color: AppColors.yellow,
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: 14.h),

            // Horizontal Clubs list
            SizedBox(
              height: 96.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: _myClubs.length + 1,
                itemBuilder: (context, index) {
                  // Add NEW CLUB dashed button at the end
                  if (index == _myClubs.length) {
                    return Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: Column(
                        children: [
                          CustomPaint(
                            painter: CircleDashedBorderPainter(color: AppColors.yellow, strokeWidth: 1.5, gap: 4, dashLength: 4),
                            child: Container(
                              width: 58.w,
                              height: 58.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: const Center(
                                child: Icon(Icons.add, color: AppColors.yellow, size: 18),
                              ),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          CustomText(
                            text: "NEW CLUB",
                            color: Colors.white54,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    );
                  }

                  final club = _myClubs[index];
                  return Padding(
                    padding: EdgeInsets.only(right: 14.w),
                    child: Column(
                      children: [
                        Container(
                          width: 58.w,
                          height: 58.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.yellow, width: 1.2),
                            image: DecorationImage(
                              image: NetworkImage(club['imageUrl'] as String),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        CustomText(
                          text: club['name'] as String,
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Colors.white10, height: 16),
            SizedBox(height: 12.h),

            // TRENDING CLUBS SECTION
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomText(
                text: "TRENDING CLUBS",
                color: AppColors.yellow,
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(height: 16.h),

            // Trending list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: _trendingClubs.length,
                itemBuilder: (context, index) {
                  final club = _trendingClubs[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xff111111),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            image: DecorationImage(
                              image: NetworkImage(club['imageUrl'] as String),
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
                                text: club['name'] as String,
                                color: Colors.white,
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w900,
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 2.h),
                              CustomText(
                                text: club['members'] as String,
                                color: Colors.white38,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.yellow,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            minimumSize: Size(78.w, 30.h),
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                          ),
                          onPressed: () {
                            Get.snackbar(
                              "Joined Club",
                              "Successfully joined ${club['name']}. Group dashboard loaded.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: const Color(0xff181818),
                              colorText: Colors.white,
                              borderColor: AppColors.yellow,
                              borderWidth: 1,
                            );
                          },
                          child: Text(
                            "JOIN CLUB",
                            style: TextStyle(
                              fontSize: 8.5.sp,
                              fontWeight: FontWeight.w900,
                            ),
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
        bottomNavigationBar: const CustomBusinessNavBar(currentIndex: 4),
      ),
    );
  }
}

// Circle dashed border painter for dashed NEW CLUB circle button
class CircleDashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;

  CircleDashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.dashLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    final double circumference = 2 * 3.14159265 * radius;
    final double step = dashLength + gap;
    final int dashCount = (circumference / step).round();

    for (int i = 0; i < dashCount; i++) {
      final double startAngle = (i * step / circumference) * 2 * 3.14159265;
      final double sweepAngle = (dashLength / circumference) * 2 * 3.14159265;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

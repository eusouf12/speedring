import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_text/custom_text.dart';
import '../BusinessHome/business_navbar.dart';

class BusinessAnalyticsScreen extends StatelessWidget {
  const BusinessAnalyticsScreen({super.key});

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
          title: const Text(
            "BUSINESS ANALYTICS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
              onPressed: () => Get.toNamed(AppRoutes.businessAccountSettingsScreen),
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PHASE 01: STATUS
              _buildSectionHeader("PHASE 01: STATUS"),
              _buildStatusCard(),
              SizedBox(height: 16.h),

              // METRICS GRID
              _buildMetricCard(
                title: "TOTAL REVENUE",
                value: "\$142.8K",
                change: "+12.4%",
                isPositive: true,
                child: CustomPaint(
                  size: Size(double.infinity, 36.h),
                  painter: SparklinePainter(color: AppColors.yellow),
                ),
              ),
              SizedBox(height: 12.h),

              _buildMetricCard(
                title: "PROFILE REACH",
                value: "24.5K",
                subtext: "LATEST 30 DAYS",
                icon: Icons.remove_red_eye_outlined,
              ),
              SizedBox(height: 12.h),

              _buildMetricCard(
                title: "ACTIVE LEADS",
                value: "86",
                suffix: "INQUIRIES",
                subtext: "8 UNREAD MESSAGES",
                icon: Icons.chat_bubble_outline,
              ),
              SizedBox(height: 12.h),

              _buildMetricCard(
                title: "CONVERSION %",
                value: "4.2%",
                suffix: "VS 3.8% AVG",
                child: Column(
                  children: [
                    SizedBox(height: 8.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: 0.75,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.yellow),
                        minHeight: 6.h,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // REVENUE TREND (30D)
              _buildSectionHeader("REVENUE TREND (30D)"),
              _buildRevenueTrendChart(),
              SizedBox(height: 24.h),

              // TOP ASSETS
              _buildSectionHeader("TOP ASSETS"),
              _buildTopAssetsSection(),
              SizedBox(height: 24.h),

              // MARKETING IMPACT
              _buildSectionHeader("MARKETING IMPACT"),
              _buildMarketingImpactSection(context),
              SizedBox(height: 24.h),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBusinessNavBar(currentIndex: 4),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: CustomText(
        text: title,
        color: AppColors.yellow,
        fontSize: 9.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      CustomText(
                        text: "92",
                        color: Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w900,
                      ),
                      CustomText(
                        text: "/100",
                        color: Colors.white38,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: "BUSINESS HEALTH RATING: EXCELLENT",
                    color: AppColors.yellow,
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ],
              ),
              CustomText(
                text: "92%",
                color: Colors.white70,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: 0.92,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.yellow),
              minHeight: 6.h,
            ),
          ),
          SizedBox(height: 6.h),
          CustomText(
            text: "OPERATIONAL EFFICIENCY",
            color: Colors.white38,
            fontSize: 7.5.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    String? change,
    String? suffix,
    String? subtext,
    bool isPositive = true,
    IconData? icon,
    Widget? child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: title,
                color: Colors.white38,
                fontSize: 8.5.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              if (icon != null) Icon(icon, color: Colors.white38, size: 14.sp),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              CustomText(
                text: value,
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
              ),
              if (suffix != null) ...[
                SizedBox(width: 6.w),
                CustomText(
                  text: suffix,
                  color: Colors.white54,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                ),
              ],
              if (change != null) ...[
                SizedBox(width: 8.w),
                CustomText(
                  text: change,
                  color: isPositive ? AppColors.green : Colors.redAccent,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w900,
                ),
              ],
            ],
          ),
          if (subtext != null) ...[
            SizedBox(height: 6.h),
            CustomText(
              text: subtext,
              color: Colors.white38,
              fontSize: 8.sp,
              fontWeight: FontWeight.bold,
            ),
          ],
          if (child != null) child,
        ],
      ),
    );
  }

  Widget _buildRevenueTrendChart() {
    final List<double> barHeights = [40, 56, 74, 110, 80, 100, 130];
    final List<String> dates = ["01 OCT", "15 OCT", "30 OCT"];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 140.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(barHeights.length, (index) {
                final double val = barHeights[index];
                final bool isHighlighted = index == 3 || index == 6; // Image highlights some bars in yellow
                return Container(
                  width: 22.w,
                  height: val.h,
                  decoration: BoxDecoration(
                    color: isHighlighted ? AppColors.yellow : const Color(0xff222222),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.r),
                      topRight: Radius.circular(4.r),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: dates.map((date) {
              return CustomText(
                text: date,
                color: Colors.white38,
                fontSize: 8.sp,
                fontWeight: FontWeight.bold,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAssetsSection() {
    final assets = [
      {
        'title': 'GT-R SPEC-V',
        'views': '8.4K VIEWS',
        'imageUrl': 'https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=100&fit=crop',
      },
      {
        'title': '911 GT3 RS',
        'views': '6.2K VIEWS',
        'imageUrl': 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=100&fit=crop',
      },
      {
        'title': 'MODEL S PLAID',
        'views': '5.7K VIEWS',
        'imageUrl': 'https://images.unsplash.com/photo-1617788138017-80ad40651399?w=100&fit=crop',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Column(
        children: assets.map((asset) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: asset == assets.last ? BorderSide.none : const BorderSide(color: Colors.white10, width: 0.8),
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: Image.network(
                    asset['imageUrl']!,
                    width: 44.r,
                    height: 44.r,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: asset['title']!,
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w900,
                      ),
                      SizedBox(height: 2.h),
                      CustomText(
                        text: asset['views']!,
                        color: AppColors.yellow,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.white24, size: 18.sp),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMarketingImpactSection(BuildContext context) {
    return Container(
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
            text: "Campaign efficiency and spend analytics.",
            color: Colors.white54,
            fontSize: 9.sp,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 16.h),

          // Boost Promotions Button
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.businessSelectPlanScreen);
            },
            child: Container(
              height: 38.h,
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.campaign, color: Colors.black, size: 16.sp),
                  SizedBox(width: 8.w),
                  CustomText(
                    text: "BOOST PROMOTIONS",
                    color: Colors.black,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),

          _buildBillingRow("TOTAL AD SPEND", "\$4,250.00"),
          const Divider(color: Colors.white10, height: 16),
          _buildBillingRow("COST PER INQUIRY", "\$49.41"),
          const Divider(color: Colors.white10, height: 16),
          _buildBillingRow("AD REACH TOTAL", "112,400"),
          SizedBox(height: 24.h),

          // Efficiency Graph (ROAS overlay)
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 80.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    return Container(
                      width: 1.5.w,
                      color: Colors.white12,
                    );
                  }),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: AppColors.yellow, width: 1.2),
                ),
                child: CustomText(
                  text: "ROAS: 3.4x",
                  color: AppColors.yellow,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Center(
            child: CustomText(
              text: "CAMPAIGN EFFICIENCY VS BUDGET",
              color: Colors.white24,
              fontSize: 7.5.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingRow(String label, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          color: Colors.white38,
          fontSize: 8.5.sp,
          fontWeight: FontWeight.bold,
        ),
        CustomText(
          text: val,
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w900,
        ),
      ],
    );
  }
}

class SparklinePainter extends CustomPainter {
  final Color color;

  SparklinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.85);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.8,
      size.width * 0.4,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.1,
      size.width * 0.8,
      size.height * 0.55,
    );
    path.lineTo(size.width, size.height * 0.2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

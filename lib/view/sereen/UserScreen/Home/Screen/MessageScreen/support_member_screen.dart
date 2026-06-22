import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_button/custom_button.dart';

class CornerTickPainter extends CustomPainter {
  final Color color;
  CornerTickPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Top left L-shape tick
    const double tickSize = 6.0;
    final path = Path()
      ..moveTo(0, tickSize)
      ..lineTo(0, 0)
      ..lineTo(tickSize, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SupportMemberScreen extends StatefulWidget {
  const SupportMemberScreen({super.key});

  @override
  State<SupportMemberScreen> createState() => _SupportMemberScreenState();
}

class _SupportMemberScreenState extends State<SupportMemberScreen> {
  final Random _random = Random();
  String _selectedId = 'fuel'; // Default selected item matches the screenshot (Fuel)

  final List<Map<String, dynamic>> _supportItems = [
    {
      'id': 'screw',
      'title': 'Screw',
      'icon': Icons.hexagon_outlined,
      'price': '€0.25',
    },
    {
      'id': 'espresso',
      'title': 'Espresso',
      'icon': Icons.local_cafe_outlined,
      'price': '€1.00',
    },
    {
      'id': 'energy_drink',
      'title': 'Energy Drink',
      'icon': Icons.local_drink_outlined,
      'price': '€2.00',
    },
    {
      'id': 'fuel',
      'title': 'Fuel',
      'icon': Icons.local_gas_station_outlined,
      'price': '€10.00',
    },
    {
      'id': 'bronze_cup',
      'title': 'Bronze Cup',
      'icon': Icons.emoji_events_outlined,
      'price': '€25.00',
    },
    {
      'id': 'silver_cup',
      'title': 'Silver Cup',
      'icon': Icons.emoji_events_outlined,
      'price': '€50.00',
    },
    {
      'id': 'gold_cup',
      'title': 'Gold Cup',
      'icon': Icons.emoji_events_outlined,
      'price': '€100.00',
    },
    {
      'id': 'champion_trophy',
      'title': 'Champion Trophy',
      'icon': Icons.emoji_events_outlined,
      'price': '€500.00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments (like recipient's name)
    final Map<String, dynamic> args = Get.arguments ?? {
      "userName": "Alex Racer",
      "avatarUrl": "https://picsum.photos/seed/alex/100/100"
    };
    final String userName = args["userName"];

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SUPPORT THIS MEMBER",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "DRIVER ID: PX-772-BETA",
                          style: TextStyle(
                            color: Colors.white30,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white60),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                /// Current Balance Box
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff0E0E0E),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.yellow.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.monetization_on,
                          color: AppColors.yellow,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CURRENT BALANCE",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                "12,450",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "COINS",
                                style: TextStyle(
                                  color: AppColors.yellow,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                /// Grid of support options
                Expanded(
                  child: GridView.builder(
                    itemCount: _supportItems.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 1.15,
                    ),
                    itemBuilder: (context, index) {
                      final item = _supportItems[index];
                      final isSelected = item['id'] == _selectedId;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedId = item['id'];
                          });
                        },
                        child: CustomPaint(
                          foregroundPainter: CornerTickPainter(
                            color: isSelected ? Colors.transparent : AppColors.yellow.withValues(alpha: 0.5),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: const Color(0xff0E0E0E),
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(
                                color: isSelected ? AppColors.yellow : Colors.white.withValues(alpha: 0.04),
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  item['icon'] as IconData,
                                  color: isSelected ? AppColors.yellow : Colors.white70,
                                  size: 20.sp,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      item['price'] as String,
                                      style: TextStyle(
                                        color: AppColors.yellow,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// Info Banner at bottom
             SizedBox(height: 16.h),

                /// Send Support Button
                CustomButton(
                  title: "SEND SUPPORT",
                  fillColor: AppColors.yellow,
                  textColor: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 13.sp,
                  borderRadius: 8.r,
                  height: 48.h,
                  onTap: () {
                    final selectedItem = _supportItems.firstWhere((item) => item['id'] == _selectedId);
                    Get.toNamed(
                      AppRoutes.supportSuccessScreen,
                      arguments: {
                        "amount": selectedItem['price'],
                        "recipient": userName.toUpperCase(),
                        "txId": "SRX-${100 + _random.nextInt(899)}-${100 + _random.nextInt(899)}-M7"
                      },
                    );
                  },
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

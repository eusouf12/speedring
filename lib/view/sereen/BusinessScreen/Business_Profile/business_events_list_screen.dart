import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_text/custom_text.dart';
import '../BusinessHome/business_navbar.dart';
import '../BusinessMarketPlace/business_profile_sheet_helper.dart';

class BusinessEventsListScreen extends StatefulWidget {
  const BusinessEventsListScreen({super.key});

  @override
  State<BusinessEventsListScreen> createState() => _BusinessEventsListScreenState();
}

class _BusinessEventsListScreenState extends State<BusinessEventsListScreen> {
  final List<Map<String, dynamic>> _events = [
    {
      'id': '1',
      'title': 'SILVERSTONE PERFORMANCE PADDOCK',
      'organizer': 'ANDERSON RACING',
      'imageUrl': 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=800&fit=crop',
      'date': 'OCT 24',
      'type': 'TRACK DAY',
      'location': 'SILVERSTONE',
      'slots': '42/50',
      'isSlotsFull': false,
      'likes': '2.4K',
      'comments': '128',
      'isFeatured': true,
    },
    {
      'id': '2',
      'title': 'NÜRBURGRING ENDURANCE SERIES',
      'organizer': 'SPEEDRING ELITE',
      'imageUrl': 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800&fit=crop',
      'date': 'NOV 17',
      'type': 'ENDURANCE',
      'location': 'ADENAU',
      'slots': 'FULL',
      'isSlotsFull': true,
      'likes': '1.8K',
      'comments': '86',
      'isFeatured': false,
    },
    {
      'id': '3',
      'title': 'YAS MARINA NIGHT SESSIONS',
      'organizer': 'SPEEDRING ELITE',
      'imageUrl': 'https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=800&fit=crop',
      'date': 'DEC 05',
      'type': 'EXPERIENCE',
      'location': 'ABU DHABI',
      'slots': '12/25',
      'isSlotsFull': false,
      'likes': '3.1K',
      'comments': '215',
      'isFeatured': false,
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
              onPressed: () => Get.toNamed(AppRoutes.notificationScreen),
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 12.h),

            // CREATE NEW EVENT BUTTON
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.businessCreateEventScreen),
                child: Container(
                  height: 48.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.yellow, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, color: AppColors.yellow, size: 18),
                      SizedBox(width: 6.w),
                      Text(
                        "CREATE NEW EVENT",
                        style: TextStyle(
                          color: AppColors.yellow,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Events List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  final event = _events[index];
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
                        // Event Banner with Optional Featured Badge
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.r),
                                topRight: Radius.circular(16.r),
                              ),
                              child: Container(
                                height: 140.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(event['imageUrl'] as String),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            if (event['isFeatured'] == true)
                              Positioned(
                                top: 12.h,
                                right: 12.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.yellow,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    "FEATURED",
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

                        // Event Info Body
                        Padding(
                          padding: EdgeInsets.all(14.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Organizer row
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 10.r,
                                    backgroundColor: const Color(0xff222222),
                                    child: Icon(Icons.person, size: 10.r, color: Colors.white60),
                                  ),
                                  SizedBox(width: 8.w),
                                  CustomText(
                                    text: event['organizer'] as String,
                                    color: AppColors.yellow,
                                    fontSize: 8.5.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  SizedBox(width: 4.w),
                                  const Icon(Icons.verified, color: AppColors.yellow, size: 12),
                                ],
                              ),
                              SizedBox(height: 10.h),

                              // Title
                              CustomText(
                                text: event['title'] as String,
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w900,
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 12.h),

                              // Event specifics row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildSpecRow(Icons.calendar_today_outlined, event['date'] as String),
                                  _buildSpecRow(Icons.flag_outlined, event['type'] as String),
                                  _buildSpecRow(Icons.location_on_outlined, event['location'] as String),
                                  _buildSpecRow(
                                    Icons.group_outlined,
                                    event['slots'] as String,
                                    color: event['isSlotsFull'] == true ? Colors.red : AppColors.yellow,
                                  ),
                                ],
                              ),
                              const Divider(color: Colors.white10, height: 28),

                              // Likes, Comments, Share & Actions row
                              Row(
                                children: [
                                  Icon(Icons.favorite_border_rounded, color: Colors.white24, size: 16.sp),
                                  SizedBox(width: 4.w),
                                  CustomText(
                                    text: event['likes'] as String,
                                    color: Colors.white38,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(width: 14.w),
                                  Icon(Icons.chat_bubble_outline_rounded, color: Colors.white24, size: 15.sp),
                                  SizedBox(width: 4.w),
                                  CustomText(
                                    text: event['comments'] as String,
                                    color: Colors.white38,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(width: 14.w),
                                  Icon(Icons.share_outlined, color: Colors.white24, size: 15.sp),
                                  const Spacer(),

                                  // Manage & Delete buttons
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.yellow,
                                      foregroundColor: Colors.black,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.r),
                                      ),
                                      minimumSize: Size(96.w, 32.h),
                                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                                    ),
                                    onPressed: () => Get.toNamed(
                                      AppRoutes.businessEventDetailsScreen,
                                      arguments: event,
                                    ),
                                    icon: const Icon(Icons.edit_outlined, size: 13),
                                    label: Text(
                                      "MANAGE EVENT",
                                      style: TextStyle(
                                        fontSize: 8.5.sp,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  GestureDetector(
                                    onTap: () {
                                      Get.snackbar(
                                        "Delete Event",
                                        "Hold to permanently remove this event.",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: const Color(0xff181818),
                                        colorText: Colors.white,
                                        borderColor: Colors.redAccent,
                                        borderWidth: 1,
                                      );
                                    },
                                    child: Container(
                                      width: 32.h,
                                      height: 32.h,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(8.r),
                                        border: Border.all(color: Colors.white10),
                                      ),
                                      child: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 15),
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
        bottomNavigationBar: const CustomBusinessNavBar(currentIndex: 4),
      ),
    );
  }

  Widget _buildSpecRow(IconData icon, String label, {Color color = Colors.white60}) {
    return Row(
      children: [
        Icon(icon, color: Colors.white24, size: 11.sp),
        SizedBox(width: 4.w),
        CustomText(
          text: label,
          color: color,
          fontSize: 8.sp,
          fontWeight: FontWeight.w800,
        ),
      ],
    );
  }
}

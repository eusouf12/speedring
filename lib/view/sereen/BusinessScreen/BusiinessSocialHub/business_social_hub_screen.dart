import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_appbar_user/custom_appbar_user.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../UserScreen/Home/widget/story_item.dart';
import '../BusinessHome/business_navbar.dart';

class BusinessSocialHubScreen extends StatefulWidget {
  const BusinessSocialHubScreen({super.key});

  @override
  State<BusinessSocialHubScreen> createState() => _BusinessSocialHubScreenState();
}

class _BusinessSocialHubScreenState extends State<BusinessSocialHubScreen> {
  int _selectedFilter = 0; // 0: ALL, 1: EVENTS, 2: CLUBS

  final List<Map<String, dynamic>> _stories = [
    {'isMe': true, 'name': 'CREATE', 'image': null, 'icon': Icons.add},
    {
      'isMe': false,
      'name': 'MY DRIVE',
      'image': AppImages.helmet,
      'icon': null,
    },
    {
      'isMe': false,
      'name': 'TELEMETRY',
      'image': null,
      'icon': Icons.speed_outlined,
    },
    {
      'isMe': false,
      'name': 'LAP 4',
      'image': AppImages.electricBg,
      'icon': null,
    },
    {
      'isMe': false,
      'name': 'NÜRBURG',
      'image': AppImages.oldtimerBg,
      'icon': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomAppBarUser(
          showSearchIcon: true,
          onNotificationTap: () => Get.toNamed(AppRoutes.notificationScreen),
          onMailTap: () => Get.toNamed(AppRoutes.messageScreen),
        ),
        body: Column(
          children: [
            SizedBox(height: 10.h),

            // STORIES HORIZONTAL ROW
            SizedBox(
              height: 105.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: _stories.length,
                itemBuilder: (context, index) {
                  final story = _stories[index];
                  return GestureDetector(
                    onTap: () {
                      if (story['isMe'] == true) {
                        Get.toNamed(AppRoutes.businessCreatePostScreen);
                      } else {
                        Get.snackbar(
                          "Story Player",
                          "Playing sequence: ${story['name']}",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xff181818),
                          colorText: Colors.white,
                          borderColor: AppColors.yellow,
                          borderWidth: 1,
                        );
                      }
                    },
                    child: StoryItem(
                      isMe: story['isMe'],
                      name: story['name'],
                      imageSrc: story['image'],
                      icon: story['icon'],
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Colors.white10),
            SizedBox(height: 4.h),

            // SEGMENTED TAB FILTERS
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFilterTab("ALL", 0),
                  SizedBox(width: 8.w),
                  _buildFilterTab("EVENTS", 1),
                  SizedBox(width: 8.w),
                  _buildFilterTab("CLUBS", 2),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // RENDER ACTIVE FEED CONTENT
            Expanded(
              child: IndexedStack(
                index: _selectedFilter,
                children: [
                  _buildAllFeedTab(),
                  _buildEventsTab(),
                  _buildClubsTab(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CustomBusinessNavBar(currentIndex: 2),
      ),
    );
  }

  Widget _buildFilterTab(String label, int index) {
    final bool isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.yellow : const Color(0xff181818),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.white10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white60,
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildAllFeedTab() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        // ADD POST BUTTON
        _buildAddPostButton(),
        SizedBox(height: 16.h),

        // POST 1: Lap Telemetry Overlay Post
        _buildTelemetryPostCard(
          username: "CHASE_PERFORMANCE",
          location: "SILVERSTONE CIRCUIT • 2H AGO",
          imageUrl: "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=800&fit=crop",
          lapTime: "07:12.45",
          topSpeed: "284 KM/H",
          vehicle: "SF90",
          gForce: "1.82 G",
          caption: "Dialing in the aero today. The SF90 feels planted through Maggotts and Becketts. New personal best! #TrackLife #Ferrari #Speedring",
          likes: "1.2k",
          comments: "48",
        ),
        SizedBox(height: 16.h),

        // POST 2: Spot Post with Chiron
        _buildSpotPostCard(
          username: "EURO_SPOTTER",
          location: "MONACO, MC",
          imageUrl: "https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=800&fit=crop",
          tagLabel: "RARE SPOT",
          caption: "Spotted this rare beast in the wild. #SupercarSpotting #Monaco #Bugatti",
          likes: "956",
          comments: "12",
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildAddPostButton() {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.businessCreatePostScreen),
      child: Container(
        height: 48.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.yellow,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.yellow.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_outline_rounded, color: Colors.black, size: 18),
            SizedBox(width: 8.w),
            Text(
              "ADD POST",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTelemetryPostCard({
    required String username,
    required String location,
    required String imageUrl,
    required String lapTime,
    required String topSpeed,
    required String vehicle,
    required String gForce,
    required String caption,
    required String likes,
    required String comments,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          _buildPostHeader(username: username, subtitle: location),

          // High-contrast lap telemetry overlay box inside the image Stack
          Container(
            height: 200.h,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Frosted glass telemetry overlay box
                Positioned(
                  bottom: 12.h,
                  left: 12.w,
                  right: 12.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildTelemetryDetail("LAP TIME", lapTime),
                                _buildTelemetryDetail("TOP SPEED", topSpeed),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildTelemetryDetail("VEHICLE", vehicle),
                                _buildTelemetryDetail("G-FORCE", gForce),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Actions Bar & Content
          _buildPostFooter(username: username, caption: caption, likes: likes, comments: comments),
        ],
      ),
    );
  }

  Widget _buildSpotPostCard({
    required String username,
    required String location,
    required String imageUrl,
    required String tagLabel,
    required String caption,
    required String likes,
    required String comments,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          _buildPostHeader(username: username, subtitle: location),

          // Image Stack with tag label
          Container(
            height: 200.h,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Tag label
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Text(
                      tagLabel,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 7.5.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Footer Row
          _buildPostFooter(username: username, caption: caption, likes: likes, comments: comments),
        ],
      ),
    );
  }

  Widget _buildPostHeader({required String username, required String subtitle}) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xff222222),
            radius: 16.r,
            child: const Icon(Icons.person, color: Colors.white, size: 16),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: username,
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text: subtitle,
                  color: Colors.white38,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white60),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPostFooter({
    required String username,
    required String caption,
    required String likes,
    required String comments,
  }) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Action Icons
          Row(
            children: [
              const Icon(Icons.favorite_border_rounded, color: Colors.white, size: 20),
              SizedBox(width: 4.w),
              CustomText(
                text: likes,
                color: Colors.white70,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(width: 16.w),
              const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 18),
              SizedBox(width: 4.w),
              CustomText(
                text: comments,
                color: Colors.white70,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(width: 16.w),
              const Icon(Icons.share_outlined, color: Colors.white, size: 18),
              const Spacer(),
              const Icon(Icons.bookmark_border_rounded, color: Colors.white, size: 18),
            ],
          ),
          SizedBox(height: 12.h),

          // Caption Text
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$username ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 11.sp,
                    fontFamily: 'Barlow Condensed',
                  ),
                ),
                TextSpan(
                  text: caption,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11.sp,
                    fontFamily: 'Barlow Condensed',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          color: Colors.white38,
          fontSize: 7.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w900,
            fontFamily: 'Courier',
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildEventsTab() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        SizedBox(height: 8.h),
        _buildMockEventCard(
          imageUrl: "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=800&fit=crop",
          organizer: "ANDRUIA RACING",
          title: "SILVERSTONE PERFORMANCE PADDOCK",
          date: "OCT 24",
          type: "TRACK DAY",
          location: "SILVERSTONE",
          slots: "47/50",
          likes: "2.4k",
          comments: "128",
          status: "JOIN",
        ),
        SizedBox(height: 16.h),
        _buildMockEventCard(
          imageUrl: "https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800&fit=crop",
          organizer: "SPEEDRING ELITE",
          title: "NÜRBURGRING ENDURANCE SERIES",
          date: "NOV 11",
          type: "ENDURANCE",
          location: "NÜRBURG",
          slots: "FULL",
          likes: "1.9M",
          comments: "64",
          status: "WAITLIST",
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildMockEventCard({
    required String imageUrl,
    required String organizer,
    required String title,
    required String date,
    required String type,
    required String location,
    required String slots,
    required String likes,
    required String comments,
    required String status,
  }) {
    final bool isJoin = status == "JOIN";
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Banner Image
          Container(
            height: 140.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      organizer,
                      style: TextStyle(
                        color: AppColors.yellow,
                        fontSize: 7.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Info Grid
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 12.h),

                // Stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetaRow(Icons.calendar_today_rounded, date),
                    _buildMetaRow(Icons.flag_rounded, type),
                    _buildMetaRow(Icons.location_on_outlined, location),
                    _buildMetaRow(Icons.people_outline, slots),
                  ],
                ),
                const Divider(color: Colors.white10, height: 24),

                // Bottom row: Actions & Likes
                Row(
                  children: [
                    const Icon(Icons.favorite_border_rounded, color: Colors.white24, size: 16),
                    SizedBox(width: 4.w),
                    CustomText(
                      text: likes,
                      color: Colors.white38,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(width: 16.w),
                    const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white24, size: 16),
                    SizedBox(width: 4.w),
                    CustomText(
                      text: comments,
                      color: Colors.white38,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    const Spacer(),

                    // JOIN / WAITLIST button
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isJoin ? AppColors.yellow : const Color(0xff222222),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: isJoin ? Colors.black : Colors.white60,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w900,
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
  }

  Widget _buildMetaRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.white24, size: 12.sp),
        SizedBox(width: 4.w),
        CustomText(
          text: label,
          color: Colors.white60,
          fontSize: 8.sp,
          fontWeight: FontWeight.w800,
        ),
      ],
    );
  }

  Widget _buildClubsTab() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        SizedBox(height: 12.h),
        CustomText(
          text: "YOUR CLUBS",
          color: AppColors.yellow,
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 12.h),

        // Clubs list
        Row(
          children: [
            _buildClubCircle("GT3 COLL.", "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=200&fit=crop"),
            SizedBox(width: 14.w),
            _buildClubCircle("CUP RACERS", "https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=200&fit=crop"),
            SizedBox(width: 14.w),
            _buildClubCircle("V4 OWNERS", "https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=200&fit=crop"),
          ],
        ),

        const Divider(color: Colors.white10, height: 32),

        CustomText(
          text: "POPULAR CLUBS",
          color: AppColors.yellow,
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 16.h),

        _buildPopularClubRow("PORSCHE GT3 COLLECTIVE", "1,248 members", "GT3 TRACK DRIVERS"),
        SizedBox(height: 12.h),
        _buildPopularClubRow("DESMOSEDICI OWNER CLUB", "852 members", "DUCATI SPORTBIKES"),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildClubCircle(String label, String imageUrl) {
    return Column(
      children: [
        Container(
          width: 58.w,
          height: 58.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.yellow, width: 1.5),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        CustomText(
          text: label,
          color: Colors.white,
          fontSize: 8.sp,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  Widget _buildPopularClubRow(String name, String members, String type) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xff222222),
            radius: 18.r,
            child: const Icon(Icons.group_outlined, color: AppColors.yellow),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: name,
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w900,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    CustomText(
                      text: members,
                      color: Colors.white38,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 3.w,
                      height: 3.w,
                      decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                    ),
                    SizedBox(width: 8.w),
                    CustomText(
                      text: type,
                      color: AppColors.yellow.withValues(alpha: 0.7),
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 14),
        ],
      ),
    );
  }
}

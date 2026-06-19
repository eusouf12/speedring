import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../core/app_routes/app_routes.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_text/custom_text.dart';
import '../BusinessHome/business_navbar.dart';

class BusinessClubDetailsScreen extends StatelessWidget {
  const BusinessClubDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve club info from arguments or use fallback defaults
    final Map<String, dynamic> clubArgs = Get.arguments as Map<String, dynamic>? ?? {
      'name': 'Porsche GT3 Collective',
      'members': '1,240 ACTIVE MEMBERS',
      'imageUrl': 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=800&fit=crop',
    };

    // Joined state reactivity
    final RxBool isJoined = true.obs;

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
            "CLUB DETAILS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                // Navigate to edit club screen
                Get.toNamed(AppRoutes.businessEditClubScreen, arguments: clubArgs);
              },
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Image & Logo Badge
              _buildClubCoverHeader(clubArgs),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Club Title & Sub-headers
                    CustomText(
                      text: (clubArgs['name'] as String).toUpperCase(),
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xff1a1a00),
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border.all(color: AppColors.yellow.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.verified, color: AppColors.yellow, size: 10),
                              SizedBox(width: 4.w),
                              Text(
                                "VERIFIED MEMBER",
                                style: TextStyle(
                                  color: AppColors.yellow,
                                  fontSize: 7.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    CustomText(
                      text: "ACTIVE MEMBERS: ${clubArgs['members']?.toString().replaceAll(' ACTIVE MEMBERS', '') ?? '1,248'}",
                      color: Colors.white38,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    SizedBox(height: 24.h),

                    // Dynamic Joined/Not-Joined Layout
                    Obx(() {
                      if (isJoined.value) {
                        return _buildJoinedView(context);
                      } else {
                        return _buildNotJoinedView(isJoined);
                      }
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBusinessNavBar(currentIndex: 4),
      ),
    );
  }

  Widget _buildClubCoverHeader(Map<String, dynamic> club) {
    return SizedBox(
      height: 220.h,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Banner Image
          Container(
            height: 160.h,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(club['imageUrl'] as String),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
            ),
          ),

          // Circle Avatar Badge overlay
          Positioned(
            bottom: 15.h,
            left: 20.w,
            child: Container(
              width: 76.r,
              height: 76.r,
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: Colors.white10, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(12.w),
              child: Center(
                child: Image.network(
                  "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=100&fit=crop",
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.shield_outlined,
                    color: AppColors.yellow,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinedView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Command Center Section
        CustomText(
          text: "COMMAND CENTER",
          color: Colors.white38,
          fontSize: 8.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.8,
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xff111111),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              // Group Chat Button
              GestureDetector(
                onTap: () => _showMockSnackbar("Group Chat", "Connecting to encrypted radio channel..."),
                child: Container(
                  height: 44.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline_rounded, color: Colors.black, size: 16),
                      SizedBox(width: 10.w),
                      CustomText(
                        text: "GROUP CHAT",
                        color: Colors.black,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right, color: Colors.black, size: 18),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Create Post Button
              _buildCenterOutlineButton(
                icon: Icons.edit_outlined,
                label: "CREATE POST",
                onTap: () => Get.toNamed(AppRoutes.businessCreatePostScreen),
              ),
              SizedBox(height: 12.h),

              // Share Media Button
              _buildCenterOutlineButton(
                icon: Icons.photo_outlined,
                label: "SHARE MEDIA",
                onTap: () => _showMockSnackbar("Share Media", "Initializing media capture device..."),
              ),
            ],
          ),
        ),
        SizedBox(height: 28.h),

        // Collective Feed Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "COLLECTIVE FEED",
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
            ),
            CustomText(
              text: "LIVE_STREAM_v2.0",
              color: Colors.white24,
              fontSize: 8.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ],
        ),
        SizedBox(height: 14.h),

        // Feed Item List
        _buildFeedCard(
          username: "MAXIMILLIAN_R",
          time: "84M AGO",
          avatarUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&fit=crop",
          content: "Shared a new MoTeC data log from Spa-Francorchamps. Optimization on Sector 2 seems solid.",
          likes: 24,
          comments: 8,
        ),
        SizedBox(height: 12.h),
        _buildFeedCard(
          username: "ELARA_GT3",
          time: "12M AGO",
          avatarUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&fit=crop",
          content: "Uploaded onboard footage: Nordschleife Sunset Session. Bridge-to-Gantry: 7:02.",
          videoUrl: "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=400&fit=crop",
          likes: 56,
          comments: 14,
        ),
        SizedBox(height: 12.h),
        _buildFeedCard(
          username: "TECH_LEAD_SAM",
          time: "1H AGO",
          avatarUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&fit=crop",
          content: "New guide posted: Dampening Adjustments for high-speed undulations at Portimão.",
          likes: 38,
          comments: 4,
        ),
      ],
    );
  }

  Widget _buildNotJoinedView(RxBool isJoined) {
    return Column(
      children: [
        // Join Button
        GestureDetector(
          onTap: () {
            isJoined.value = true;
            Get.snackbar(
              "Club Joined",
              "Welcome to the Porsche GT3 Collective command network.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xff111111),
              colorText: Colors.white,
              borderColor: AppColors.yellow,
              borderWidth: 1,
            );
          },
          child: Container(
            height: 48.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: CustomText(
                text: "JOIN CLUB",
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),

        // Grid Metrics
        Row(
          children: [
            Expanded(child: _buildMetricBox("MEMBERS", "1,240")),
            SizedBox(width: 8.w),
            Expanded(child: _buildMetricBox("GLOBAL RANK", "#04")),
            SizedBox(width: 8.w),
            Expanded(child: _buildMetricBox("ACCESS", "PUBLIC")),
          ],
        ),
        SizedBox(height: 24.h),

        // About Section Card
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
                text: "About",
                color: AppColors.yellow,
                fontSize: 9.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
              SizedBox(height: 12.h),
              CustomText(
                text: "The Porsche GT3 Collective is an elite alliance dedicated to the pursuit of mechanical perfection. We focus exclusively on the 911 GT3 lineage, prioritizing technical telemetry, precision driving, and structural engineering insights. Our mission is to bridge the gap between amateur enthusiasm and professional endurance standards, providing a sanctuary for those who view driving as a data-driven discipline rather than a casual leisure activity.",
                color: const Color(0xffB0B0B0),
                fontSize: 11.sp,
                textAlign: TextAlign.start,
                height: 1.5,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCenterOutlineButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.white10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          children: [
            Icon(icon, color: Colors.white60, size: 16),
            SizedBox(width: 10.w),
            CustomText(
              text: label,
              color: Colors.white70,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBox(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          CustomText(
            text: label,
            color: Colors.white38,
            fontSize: 7.5.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: value,
            color: label == "GLOBAL RANK" ? Colors.white60 : AppColors.yellow,
            fontSize: 13.sp,
            fontWeight: FontWeight.w900,
          ),
        ],
      ),
    );
  }

  Widget _buildFeedCard({
    required String username,
    required String time,
    required String avatarUrl,
    required String content,
    String? videoUrl,
    required int likes,
    required int comments,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              CircleAvatar(
                radius: 12.r,
                backgroundImage: NetworkImage(avatarUrl),
                backgroundColor: const Color(0xff222222),
              ),
              SizedBox(width: 8.w),
              CustomText(
                text: username,
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
              ),
              const Spacer(),
              CustomText(
                text: time,
                color: Colors.white24,
                fontSize: 7.5.sp,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Content Text with highlighted keywords
          RichText(
            text: TextSpan(
              style: TextStyle(color: const Color(0xffB0B0B0), fontSize: 10.5.sp, height: 1.4),
              children: _parseContentWithHighlights(content),
            ),
          ),
          SizedBox(height: 12.h),

          // Video Preview
          if (videoUrl != null) ...[
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    videoUrl,
                    height: 150.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, color: AppColors.yellow, size: 20),
                ),
              ],
            ),
            SizedBox(height: 12.h),
          ],

          // Footer Row
          Row(
            children: [
              const Icon(Icons.thumb_up_alt_outlined, color: Colors.white24, size: 13),
              SizedBox(width: 4.w),
              CustomText(
                text: likes.toString(),
                color: Colors.white38,
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(width: 14.w),
              const Icon(Icons.mode_comment_outlined, color: Colors.white24, size: 12),
              SizedBox(width: 4.w),
              CustomText(
                text: comments.toString(),
                color: Colors.white38,
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<TextSpan> _parseContentWithHighlights(String content) {
    final List<TextSpan> spans = [];
    final List<String> highlights = [
      "MoTeC data log",
      "Nordschleife Sunset Session",
      "Dampening Adjustments"
    ];

    String current = content;
    bool matched = true;

    while (matched) {
      matched = false;
      String firstMatch = "";
      int firstIndex = -1;

      for (var highlight in highlights) {
        int index = current.indexOf(highlight);
        if (index != -1 && (firstIndex == -1 || index < firstIndex)) {
          firstIndex = index;
          firstMatch = highlight;
          matched = true;
        }
      }

      if (matched) {
        if (firstIndex > 0) {
          spans.add(TextSpan(text: current.substring(0, firstIndex)));
        }
        spans.add(TextSpan(
          text: firstMatch,
          style: const TextStyle(color: AppColors.yellow, fontWeight: FontWeight.bold),
        ));
        current = current.substring(firstIndex + firstMatch.length);
      } else {
        spans.add(TextSpan(text: current));
      }
    }

    return spans;
  }

  void _showMockSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff111111),
      colorText: Colors.white,
      borderColor: AppColors.yellow,
      borderWidth: 1,
    );
  }
}

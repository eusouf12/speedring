import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';

class BusinessCreateClubPostScreen extends StatefulWidget {
  const BusinessCreateClubPostScreen({super.key});

  @override
  State<BusinessCreateClubPostScreen> createState() => _BusinessCreateClubPostScreenState();
}

class _BusinessCreateClubPostScreenState extends State<BusinessCreateClubPostScreen> {
  final contentController = TextEditingController();
  bool isPinned = false;
  String selectedClub = "Apex Racing League";

  @override
  void dispose() {
    contentController.dispose();
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
          leading: const SizedBox.shrink(),
          title: const Text(
            "CREATE CLUB POST",
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SELECT TARGET CLUB
              _buildFieldLabel("SELECT TARGET CLUB"),
              Row(
                children: [
                  Expanded(
                    child: _buildClubSelectCard(
                      name: "Apex Racing League",
                      drivers: "1,248 Drivers",
                      imageUrl: "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=100&fit=crop",
                      isSelected: selectedClub == "Apex Racing League",
                      onTap: () => setState(() => selectedClub = "Apex Racing League"),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildClubSelectCard(
                      name: "Nürburgring Locals",
                      drivers: "856 Drivers",
                      imageUrl: "https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=100&fit=crop",
                      isSelected: selectedClub == "Nürburgring Locals",
                      onTap: () => setState(() => selectedClub = "Nürburgring Locals"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // POST DETAILS EDITOR CARD
              _buildFieldLabel("POST DETAILS"),
              _buildEditorCard(),
              SizedBox(height: 16.h),

              // PINNED ANNOUNCEMENT SWITCH
              _buildPinnedAnnouncementTile(),
              SizedBox(height: 20.h),

              // LINKED PERFORMANCE DATA
              _buildFieldLabel("Linked Performance Data"),
              _buildLinkedPerformanceCard(),
              SizedBox(height: 24.h),

              // STATS LIST
              _buildBulletStat("CHARACTERS: 240 / 2000"),
              SizedBox(height: 8.h),
              _buildBulletStat("NETWORK LOAD: OPTIMIZED"),
              SizedBox(height: 8.h),
              _buildBulletStat("VISIBILITY: PUBLIC (CLUB)"),
              SizedBox(height: 32.h),

              // Bottom publish button (matching SS: "PUBLISH SESSION")
              CustomButton(
                height: 46.h,
                title: "PUBLISH SESSION",
                fillColor: AppColors.yellow,
                textColor: Colors.black,
                borderRadius: 8.r,
                onTap: _onPublish,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: label.toUpperCase(),
        color: Colors.white38,
        fontSize: 8.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildClubSelectCard({
    required String name,
    required String drivers,
    required String imageUrl,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: const Color(0xff111111),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.yellow : Colors.white10,
            width: isSelected ? 1.5.w : 1.0.w,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 18.r,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle_rounded, color: AppColors.yellow, size: 16),
              ],
            ),
            SizedBox(height: 16.h),
            CustomText(
              text: name,
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w900,
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 4.h),
            CustomText(
              text: drivers,
              color: Colors.white38,
              fontSize: 9.sp,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          // Toolbar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Row(
              children: [
                _buildToolbarIcon(Icons.format_bold_rounded),
                _buildToolbarIcon(Icons.format_italic_rounded),
                _buildToolbarIcon(Icons.tag_rounded),
                _buildToolbarIcon(Icons.link_rounded),
                const SizedBox(width: 8),
                Container(height: 16.h, width: 1.w, color: Colors.white10),
                const SizedBox(width: 8),
                _buildToolbarIcon(Icons.format_list_bulleted_rounded),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),

          // Main text area
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: TextFormField(
              controller: contentController,
              maxLines: 6,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Brief the club on the next stage...",
                hintStyle: TextStyle(color: Colors.white24, fontSize: 12),
                isDense: true,
              ),
            ),
          ),

          // Add Media box
          Container(
            height: 100.h,
            width: double.infinity,
            margin: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.white10, style: BorderStyle.solid),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_a_photo_outlined, color: AppColors.yellow, size: 24),
                  SizedBox(height: 8.h),
                  CustomText(
                    text: "Add Media (Max 50MB)",
                    color: Colors.white38,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarIcon(IconData icon) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Icon(icon, color: Colors.white60, size: 16.sp),
    );
  }

  Widget _buildPinnedAnnouncementTile() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.campaign_outlined, color: AppColors.yellow, size: 18),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "PINNED ANNOUNCEMENT",
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 2.h),
                CustomText(
                  text: "Prioritize this post for all club members",
                  color: Colors.white38,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Switch(
            value: isPinned,
            activeThumbColor: AppColors.yellow,
            activeTrackColor: AppColors.yellow.withValues(alpha: 0.3),
            inactiveThumbColor: Colors.white38,
            inactiveTrackColor: Colors.black26,
            onChanged: (val) => setState(() => isPinned = val),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkedPerformanceCard() {
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
          // Banner with Event Info
          Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              image: const DecorationImage(
                image: NetworkImage("https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?w=800&fit=crop"),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        "LIVE QUALIFIER",
                        style: TextStyle(
                          color: AppColors.yellow,
                          fontSize: 7.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Text(
                        "Change Event",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 7.5.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                CustomText(
                  text: "Night Attack: Silverstone",
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                ),
              ],
            ),
          ),

          // Detail Grid
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLinkedDetail("TRACK", "Silverstone GP"),
                _buildLinkedDetail("SCHEDULE", "22 OCT // 21:00"),
                _buildLinkedDetail("GRID SLOTS", "18 / 24"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkedDetail(String label, String value) {
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
        SizedBox(height: 4.h),
        CustomText(
          text: value,
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
        ),
      ],
    );
  }

  Widget _buildBulletStat(String label) {
    return Row(
      children: [
        Container(
          width: 5.w,
          height: 5.w,
          decoration: const BoxDecoration(
            color: AppColors.yellow,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10.w),
        CustomText(
          text: label,
          color: Colors.white70,
          fontSize: 8.sp,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }

  void _onPublish() {
    Get.back(); // Pop create club post screen
    Get.back(); // Pop choices screen
    Get.snackbar(
      "Club Post Published",
      "Event brief added successfully to Apex Racing League active notices.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff181818),
      colorText: Colors.white,
      borderColor: AppColors.yellow,
      borderWidth: 1,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../components/custom_nav_bar/navbar.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../core/app_routes/app_routes.dart';
import 'widgets/profile_post_card.dart';
import 'widgets/garage_vehicle_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int activeTab = 0; // 0: POSTS, 1: OVERVIEW, 2: GARAGE, 3: SUPPORT

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.yellow),
          onPressed: () {},
        ),
        title: Image.network(
          "https://picsum.photos/seed/speedringlogo/130/40",
          height: 30,
          width: 100,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Text(
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
            icon: const Icon(Icons.notifications_none, color: AppColors.yellow),
            onPressed: () => Get.toNamed(AppRoutes.notificationScreen),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.yellow),
            onPressed: () => Get.toNamed(AppRoutes.userParametersScreen),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Banner & Avatar Stack
            Stack(
              clipBehavior: Clip.none,
              children: [
                /// Banner Image
                Container(
                  height: 180.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://images.unsplash.com/photo-1611245801312-51345985c6e8?w=800&fit=crop"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.editProfileScreen),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.edit, color: Colors.white70, size: 12),
                          SizedBox(width: 4.w),
                          const Text(
                            "EDIT",
                            style: TextStyle(color: Colors.white70, fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// Profile Avatar
                Positioned(
                  bottom: -40.h,
                  left: 16.w,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 3),
                          image: const DecorationImage(
                            image: NetworkImage("https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=150&fit=crop"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppColors.yellow,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: Colors.black, size: 12),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Coins indicator
                Positioned(
                  bottom: -36.h,
                  right: 16.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xff161616),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.wallet, color: AppColors.yellow, size: 14),
                            SizedBox(width: 4.w),
                            CustomText(
                              text: "12,450 COINS",
                              color: AppColors.yellow1,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 48.h),

            /// Profile Identity Details
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "MAX VERSTAPPEN",
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      const Icon(Icons.flag, color: Colors.blue, size: 14), // placeholder for Dutch flag
                      SizedBox(width: 6.w),
                      CustomText(
                        text: "@max_verstappen_33   da",
                        color: AppColors.yellow,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  CustomText(
                    text: "3-time World Champion. Pushing the limits of engineering and performance.",
                    color: Colors.white70,
                    fontSize: 11,
                    textAlign: TextAlign.start,
                    height: 1.4,
                  ),
                  SizedBox(height: 16.h),

                  /// Social Toggles and Support button
                  Row(
                    children: [
                      _buildSocialIcon(Icons.camera_alt_outlined),
                      SizedBox(width: 10.w),
                      _buildSocialIcon(Icons.music_note_outlined),
                      SizedBox(width: 10.w),
                      _buildSocialIcon(Icons.play_circle_outline),
                      SizedBox(width: 10.w),
                      _buildSocialIcon(Icons.facebook_outlined),
                      const Spacer(),
                      CustomButton(
                        height: 34.h,
                        width: 110.w,
                        title: "SUPPORT",
                        fontSize: 10,
                        borderRadius: 18.r,
                        icon: const Icon(Icons.sell_outlined, color: Colors.black, size: 12),
                        onTap: () {
                          setState(() {
                            activeTab = 3;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            /// Stats section
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  _buildStatItem("POSTS", "1.2K"),
                  _buildStatDivider(),
                  _buildStatItem("FOLLOWERS", "32M"),
                  _buildStatDivider(),
                  _buildStatItem("SESSIONS", "8.4K"),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            /// Scrollable quick actions / highlights
            SizedBox(
              height: 70.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                children: [
                  _buildQuickActionCircle(Icons.add, "CREATE", isYellowBg: true),
                  _buildQuickThumb("https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=100&fit=crop", "MY DRIVE"),
                  _buildQuickThumb("https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=100&fit=crop", "TELEMETRY"),
                  _buildQuickThumb("https://images.unsplash.com/photo-1611245801312-51345985c6e8?w=100&fit=crop", "SPA LAPS"),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            /// Nested Tab Navigation
            _buildTabSelector(),

            /// Active Tab Body
            _buildActiveTabBody(),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 4),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24),
      ),
      child: Icon(icon, color: Colors.white70, size: 16),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          CustomText(
            text: label,
            color: Colors.white38,
            fontSize: 8,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: value,
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 24.h,
      color: Colors.white10,
    );
  }

  Widget _buildQuickActionCircle(IconData icon, String label, {bool isYellowBg = false}) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: isYellowBg ? AppColors.yellow : const Color(0xff1a1a1a),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isYellowBg ? Colors.black : Colors.white70, size: 20),
          ),
          SizedBox(height: 6.h),
          CustomText(
            text: label,
            color: Colors.white70,
            fontSize: 7.5,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickThumb(String imageUrl, String label) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
              image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 6.h),
          CustomText(
            text: label,
            color: Colors.white70,
            fontSize: 7.5,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTabItem(0, "POSTS"),
          _buildTabItem(1, "OVERVIEW"),
          _buildTabItem(2, "GARAGE"),
          _buildTabItem(3, "SUPPORT"),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    final bool isSelected = activeTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          activeTab = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.yellow : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: CustomText(
          text: label,
          color: isSelected ? Colors.white : Colors.white38,
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildActiveTabBody() {
    switch (activeTab) {
      case 0:
        return _buildPostsTab();
      case 1:
        return _buildOverviewTab();
      case 2:
        return _buildGarageTab();
      case 3:
        return _buildSupportTab();
      default:
        return _buildPostsTab();
    }
  }

  /// ── Tab 01: Posts Tab ──────────────────────────────────────────────────
  Widget _buildPostsTab() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          CustomButton(
            height: 44.h,
            title: "ADD POST",
            fontSize: 12,
            borderRadius: 8.r,
            icon: const Icon(Icons.add_circle_outline, color: Colors.black, size: 16),
            onTap: () => Get.toNamed(AppRoutes.createPostScreen),
          ),
          SizedBox(height: 20.h),
          const ProfilePostCard(
            authorName: "MAX VERSTAPPEN",
            authorAvatar: "https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=100&fit=crop",
            timeAgo: "3 hours ago",
            imageUrl: "https://images.unsplash.com/photo-1611245801312-51345985c6e8?w=500&fit=crop",
            likes: "1.2M",
            comments: "45K",
            username: "max_verstappen_33",
            caption: "Late night sessions at the limit. The machine is ready.",
            hashtags: ["#TrackLife", "#Speedring", "#GT3", "#NightRacing"],
          ),
          const ProfilePostCard(
            authorName: "MAX VERSTAPPEN",
            authorAvatar: "https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=100&fit=crop",
            timeAgo: "Yesterday",
            imageUrl: "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=500&fit=crop",
            likes: "2.8M",
            comments: "82K",
            username: "max_verstappen_33",
            caption: "Pure engineering perfection. The RB20 feels incredible this season.",
            hashtags: ["#F1", "#RedBullRacing", "#PushingLimits"],
          ),
        ],
      ),
    );
  }

  /// ── Tab 02: Overview Tab ───────────────────────────────────────────────
  Widget _buildOverviewTab() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "STABLE / RECENT ACTIVITY",
            color: AppColors.yellow,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
          SizedBox(height: 16.h),
          _buildActivityCard(
            "https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=500&fit=crop",
            "SIM VALIDATOR",
            "LOGGED: 12.4H",
          ),
          SizedBox(height: 16.h),
          _buildActivityCard(
            "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=500&fit=crop",
            "GP HIGHLIGHT",
            "PLAY REPLAY",
            hasPlayButton: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(String imageUrl, String tag, String title, {bool hasPlayButton = false}) {
    return Container(
      height: 240.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
              ),
            ),
          ),
          if (hasPlayButton)
            Center(
              child: Container(
                width: 48.w,
                height: 48.w,
                decoration: const BoxDecoration(
                  color: AppColors.yellow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow, color: Colors.black),
              ),
            ),
          Positioned(
            bottom: 16.h,
            left: 16.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: tag,
                  color: AppColors.yellow,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: title,
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ── Tab 03: Garage Tab ─────────────────────────────────────────────────
  Widget _buildGarageTab() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Slots usage details
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xff111111),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "SLOTS FILLED",
                  style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "02 / 12",
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2.r),
                  child: LinearProgressIndicator(
                    value: 2 / 12,
                    backgroundColor: Colors.white10,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.yellow),
                    minHeight: 4.h,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          CustomButton(
            height: 44.h,
            title: "ADD VEHICLE",
            fontSize: 12,
            borderRadius: 8.r,
            icon: const Icon(Icons.add_circle_outline, color: Colors.black, size: 16),
            onTap: () => Get.toNamed(AppRoutes.addVehicleScreen),
          ),

          SizedBox(height: 24.h),

          CustomText(
            text: "VEHICLE STABLE",
            color: AppColors.yellow,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
          SizedBox(height: 16.h),

          const GarageVehicleCard(
            imageUrl: "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=500&fit=crop",
            title: "ORACLE RED BULL RACING RB20",
            category: "FORMULA 1 2024",
            version: "V01",
            power: "1,024 HP",
            weight: "798 KG",
            displacement: "1600 CC",
            driveType: "RWD",
            propulsion: "HYBRID",
          ),
          const GarageVehicleCard(
            imageUrl: "https://images.unsplash.com/photo-1611245801312-51345985c6e8?w=500&fit=crop",
            title: "PORSCHE 911 GT3 RS (992)",
            category: "STREET LEGAL / TRACK PREPARED",
            version: "V02",
            power: "518 HP",
            weight: "1,450 KG",
            displacement: "3996 CC",
            driveType: "RWD",
            propulsion: "COMBUSTION",
          ),
        ],
      ),
    );
  }

  /// ── Tab 04: Support Tab ────────────────────────────────────────────────
  Widget _buildSupportTab() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Container(
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
                    Text(
                      "REVENUE TELEMETRY",
                      style: TextStyle(color: AppColors.yellow, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.query_stats, color: AppColors.yellow, size: 16),
                  ],
                ),
                SizedBox(height: 6.h),
                const Text(
                  "FINANCIAL PERFORMANCE",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "SUPPORT RECEIVED (MTD)",
                      style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "€8,250 / €10,000",
                      style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2.r),
                  child: LinearProgressIndicator(
                    value: 8250 / 10000,
                    backgroundColor: Colors.white10,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.yellow),
                    minHeight: 5.h,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          CustomButton(
            height: 48.h,
            title: "SUPPORT THIS USER",
            fontSize: 13,
            borderRadius: 8.r,
            icon: const Icon(Icons.handshake_outlined, color: Colors.black, size: 18),
            onTap: () {
              Get.snackbar(
                "Support Process Initiated",
                "Thank you for choosing to support Max Verstappen.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xff181818),
                colorText: Colors.white,
                borderColor: AppColors.yellow,
                borderWidth: 1,
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/view/components/custom_appbar_user/custom_appbar_user.dart';
import 'package:speedring/view/components/custom_nav_bar/navbar.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  int activeSubTab = 0; // 0: Spotting, 1: Videos, 2: Network
  String activeTag = "Trending";
  String activeVideoTag = "All";

  final List<String> spottingTags = ["Trending", "GT3 Series", "Nürburgring", "Spa-Francorchamps"];
  final List<String> videoTags = ["All", "Onboard", "Technical", "Vlogs"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBarUser(
        showSearchIcon: true,
        onNotificationTap: () => Get.toNamed(AppRoutes.notificationScreen),
        onMailTap: () => Get.toNamed(AppRoutes.messageScreen),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          /// 1. Tab Selector: Spotting, Videos, Network
          _buildTabBar(),
          const SizedBox(height: 16),

          /// 2. Active Tab View
          Expanded(
            child: _buildActiveTabView(),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 1),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12, width: 1)),
      ),
      child: Row(
        children: [
          _buildTabItem(0, "Spotting"),
          _buildTabItem(1, "Videos"),
          _buildTabItem(2, "Network"),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    final bool isSelected = activeSubTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            activeSubTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.yellow : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white38,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabView() {
    switch (activeSubTab) {
      case 0:
        return _buildSpottingTab();
      case 1:
        return _buildVideosTab();
      case 2:
        return _buildNetworkTab();
      default:
        return _buildSpottingTab();
    }
  }

  /// ==================== 1. SPOTTING TAB ====================
  Widget _buildSpottingTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        /// Horizontal subtags list
        SizedBox(
          height: 36,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: spottingTags.length,
            itemBuilder: (context, idx) {
              final tag = spottingTags[idx];
              final isSel = activeTag == tag;
              return GestureDetector(
                onTap: () => setState(() => activeTag = tag),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.yellow : const Color(0xff181818),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: isSel ? Colors.black : Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        /// ADD NEW SPOT Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.yellow,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () => Get.toNamed(AppRoutes.addSpotScreen),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add_circle_outline, size: 18),
                SizedBox(width: 8),
                Text(
                  "ADD NEW SPOT",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        /// Spots list
        _buildSpotCard(
          imageUrl: "https://picsum.photos/seed/blue992/600/350",
          title: "Porsche 911 GT3 RS",
          tagLabel: "CHASSIS: 992 GT3 RS",
          spottedBy: "@Aerodynamicist_22",
          engine: "4.0L F6",
          power: "518 HP",
          zeroToHundred: "3.2s",
          isVerified: true,
        ),
        _buildSpotCard(
          imageUrl: "https://picsum.photos/seed/ferrarisf90/600/350",
          title: "Ferrari SF90 Assetto",
          tagLabel: "HYBRID: 4WD",
          spottedBy: "@Scuderia_Vision",
          engine: "V8 TT PHEV",
          power: "986 HP",
          zeroToHundred: "2.5s",
          isVerified: false,
        ),
        _buildSpotCard(
          imageUrl: "https://picsum.photos/seed/ferrarisf90rear/600/350",
          title: "Ferrari SF90 Assetto",
          tagLabel: "HYBRID: 4WD",
          spottedBy: "@Scuderia_Vision",
          engine: "V8 TT PHEV",
          power: "986 HP",
          zeroToHundred: "2.5s",
          isVerified: false,
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildSpotCard({
    required String imageUrl,
    required String title,
    required String tagLabel,
    required String spottedBy,
    required String engine,
    required String power,
    required String zeroToHundred,
    required bool isVerified,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Car Image & Badge Stack
          Stack(
            children: [
              Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tagLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// Description Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    if (isVerified)
                      const Icon(Icons.verified, color: AppColors.yellow, size: 18)
                    else
                      const Icon(Icons.share_outlined, color: Colors.white54, size: 18),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Spotted by $spottedBy",
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 1,
                  color: Colors.white10,
                ),
                const SizedBox(height: 12),

                /// Car Stats
                Row(
                  children: [
                    _buildStatCol("ENGINE", engine),
                    _buildVerticalDivider(),
                    _buildStatCol("POWER", power),
                    _buildVerticalDivider(),
                    _buildStatCol("0-100", zeroToHundred, isYellowValue: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCol(String label, String value, {bool isYellowValue = false}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 8,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: isYellowValue ? AppColors.yellow : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 24,
      color: Colors.white10,
    );
  }

  /// ==================== 2. VIDEOS TAB ====================
  Widget _buildVideosTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        /// Horizontal subtags list
        SizedBox(
          height: 36,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: videoTags.length,
            itemBuilder: (context, idx) {
              final tag = videoTags[idx];
              final isSel = activeVideoTag == tag;
              return GestureDetector(
                onTap: () => setState(() => activeVideoTag = tag),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.yellow : const Color(0xff181818),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: isSel ? Colors.black : Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        /// ADD NEW VIDEO Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.yellow,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () => Get.toNamed(AppRoutes.addVideoScreen),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add_circle_outline, size: 18),
                SizedBox(width: 8),
                Text(
                  "ADD NEW VIDEO",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        /// Title uploads header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "LATEST UPLOADS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              "VIEW ALL",
              style: TextStyle(
                color: AppColors.yellow,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        /// Video Feed List
        _buildVideoCard(
          thumbnailUrl: "https://picsum.photos/seed/steering/600/350",
          duration: "11:02",
          category: "TECHNICAL",
          title: "CHASSIS RIGIDITY: THE HIDDEN PERFORMANCE FACTOR",
          author: "Dr. Elena Hayes",
          views: "15K views",
          timeAgo: "2h ago",
        ),
        _buildVideoCard(
          thumbnailUrl: "https://picsum.photos/seed/sunsetlap/600/350",
          duration: "22:45",
          category: "ONBOARD",
          title: "SPA-FRANCORCHAMPS: FULL ONBOARD LAP (4K)",
          author: "Apex Hunter",
          views: "15K views",
          timeAgo: "5h ago",
        ),
        _buildVideoCard(
          thumbnailUrl: "https://picsum.photos/seed/racepit/600/350",
          duration: "12:10",
          category: "RACE",
          title: "PIT STRATEGY: HOW WE WON THE 24H ENDURANCE",
          author: "Strategy Lab",
          views: "15K views",
          timeAgo: "8h ago",
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildVideoCard({
    required String thumbnailUrl,
    required String duration,
    required String category,
    required String title,
    required String author,
    required String views,
    required String timeAgo,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Thumbnail Stack with Play Button
          Stack(
            children: [
              Image.network(
                thumbnailUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.yellow,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.black, size: 28),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    duration,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// Metadata
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    color: AppColors.yellow,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.white38, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      author,
                      style: const TextStyle(color: Colors.white38, fontSize: 10),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.visibility_outlined, color: Colors.white38, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      views,
                      style: const TextStyle(color: Colors.white38, fontSize: 10),
                    ),
                    const Spacer(),
                    const Icon(Icons.share_outlined, color: Colors.white38, size: 14),
                    const SizedBox(width: 8),
                    Text(
                      timeAgo,
                      style: const TextStyle(color: Colors.white38, fontSize: 10),
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

  /// ==================== 3. NETWORK TAB ====================
  Widget _buildNetworkTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        /// Search Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xff111111),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: const [
              Icon(Icons.search, color: Colors.white38, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  style: TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search drivers, teams, or licenses...",
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        /// Pilot Directory header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "PILOT DIRECTORY",
              style: TextStyle(
                color: AppColors.yellow,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
            Text(
              "Showing 1,248 Pilots",
              style: TextStyle(
                color: Colors.white38,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        /// Pilots list
        _buildPilotCard(
          name: "MAX VERSTAPPEN",
          rank: "RANK #1",
          avatarUrl: "https://picsum.photos/seed/maxv/100/100",
          tier: "S-TIER",
          winRate: "68.4%",
          telemetryLabel: "TELEMETRY CONFIRMED",
          races: "2,851",
          isGoldBorder: true,
        ),
        _buildPilotCard(
          name: "ELENA RICCI",
          rank: "RANK #42",
          avatarUrl: "https://picsum.photos/seed/elenar/100/100",
          tier: "A-TIER",
          winRate: "42.1%",
          telemetryLabel: "CLASS A LICENSE",
          races: "1,104",
          isGoldBorder: false,
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildPilotCard({
    required String name,
    required String rank,
    required String avatarUrl,
    required String tier,
    required String winRate,
    required String telemetryLabel,
    required String races,
    required bool isGoldBorder,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              /// Avatar Stack
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isGoldBorder ? AppColors.yellow : Colors.white38,
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(avatarUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -6,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isGoldBorder ? AppColors.yellow : const Color(0xff222222),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          rank,
                          style: TextStyle(
                            color: isGoldBorder ? Colors.black : Colors.white,
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              /// Pilot Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isGoldBorder
                            ? AppColors.yellow.withOpacity(0.15)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isGoldBorder ? AppColors.yellow : Colors.white24,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        tier,
                        style: TextStyle(
                          color: isGoldBorder ? AppColors.yellow : Colors.white70,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// Stats Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Win Rate: $winRate",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      telemetryLabel,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 24, color: Colors.white10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      races,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "TOTAL RACES",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// Follow Button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: () {},
              child: const Text(
                "Follow",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

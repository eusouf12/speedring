import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/view/components/custom_nav_bar/navbar.dart';
import '../widgets/track_appbar.dart';

class GroupDrivesScreen extends StatefulWidget {
  const GroupDrivesScreen({super.key});

  @override
  State<GroupDrivesScreen> createState() => _GroupDrivesScreenState();
}

class _GroupDrivesScreenState extends State<GroupDrivesScreen> {
  String selectedTab = "UPCOMING";

  final List<Map<String, dynamic>> mockDrives = [
    {
      "title": "MIDNIGHT COAST RUN",
      "phase": "PHASE 01 // ACTIVE",
      "status": "OPEN",
      "date": "24.OCT // 22:00",
      "members": "12/20",
      "startingPoint": "PACIFIC COAST HIGHWAY // GATE 4",
      "imageUrl": "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=600&auto=format&fit=crop",
      "isJoinable": true,
      "isFull": false,
    },
    {
      "title": "DORTMUND AUTOBAHN TEST",
      "phase": "PHASE 02 // PENDING",
      "status": "FULL",
      "date": "26.OCT // 05:30",
      "members": "38/38",
      "startingPoint": "SPEEDRING HUB // MAIN ENTRANCE",
      "imageUrl": "https://images.unsplash.com/photo-1617814076367-b759c7d7e738?w=600&auto=format&fit=crop",
      "isJoinable": false,
      "isFull": true,
    },
    {
      "title": "METRO TUNNEL SPRINT",
      "phase": "PHASE 01 // ACTIVE",
      "status": "OPEN",
      "date": "27.OCT // 01:00",
      "members": "04/15",
      "startingPoint": "SOUTH TUNNEL // SECTOR B",
      "imageUrl": "https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=600&auto=format&fit=crop",
      "isJoinable": true,
      "isFull": false,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: TrackAppBar(
        title: "GROUP DRIVES",
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          /// 1. START NEW DRIVE button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Get.toNamed(AppRoutes.tripConfiguratorScreen),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_circle_outline, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "START NEW DRIVE",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// 2. Tabs Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildTabButton("UPCOMING"),
                const SizedBox(width: 8),
                _buildTabButton("MY DRIVES"),
                const SizedBox(width: 8),
                _buildTabButton("HISTORY"),
              ],
            ),
          ),
          const SizedBox(height: 16),

          /// 3. Scrollable List of Group Drives
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: mockDrives.length,
              itemBuilder: (context, index) {
                final drive = mockDrives[index];
                return _buildDriveCard(drive);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 2),
    );
  }

  Widget _buildTabButton(String label) {
    final bool isSelected = selectedTab == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = label;
          });
        },
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xff222222) : const Color(0xff111111),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.yellow.withValues(alpha:0.3) : Colors.white10,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.yellow : Colors.white60,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDriveCard(Map<String, dynamic> drive) {
    final bool isOpen = drive["status"] == "OPEN";
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Card Image Banner with badge overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  drive["imageUrl"],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, _, _) => Container(
                    height: 150,
                    color: Colors.white.withValues(alpha:0.05),
                    child: const Icon(Icons.directions_car, color: Colors.white24, size: 40),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOpen ? AppColors.yellow : const Color(0xff333333),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    drive["status"],
                    style: TextStyle(
                      color: isOpen ? Colors.black : Colors.white70,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  color: Colors.black54,
                  child: Text(
                    drive["phase"],
                    style: const TextStyle(
                      color: AppColors.yellow,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// Drive Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drive["title"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "DATE & TIME",
                            style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            drive["date"],
                            style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "MEMBERS",
                            style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            drive["members"],
                            style: const TextStyle(color: AppColors.yellow, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "STARTING POINT",
                  style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  drive["startingPoint"],
                  style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                /// Button & Share section
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isOpen ? AppColors.yellow : const Color(0xff2a2a2a),
                            foregroundColor: isOpen ? Colors.black : Colors.white30,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (isOpen) {
                              Get.toNamed(AppRoutes.tripLobbyScreen);
                            }
                          },
                          child: Text(
                            isOpen ? "JOIN DRIVE" : "LOBBY FULL",
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 44,
                      width: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.share_outlined, color: Colors.white70, size: 18),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

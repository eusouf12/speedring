import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_nav_bar/navbar.dart';
import 'widgets/track_appbar.dart';

class TrackHubScreen extends StatelessWidget {
  const TrackHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: const TrackAppBar(title: "TRACK HUB"),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// 1. Laps & Safety Rank stats card
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: const [
                          Text(
                            "TOTAL LAPS",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "1,248",
                            style: TextStyle(
                              color: AppColors.yellow,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 40, color: Colors.white10),
                    Expanded(
                      child: Column(
                        children: const [
                          Text(
                            "SAFETY RANK",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "S-98",
                            style: TextStyle(
                              color: AppColors.yellow,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// 2. START NEW SESSION button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => Get.toNamed(AppRoutes.prepareSessionScreen),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.play_arrow, size: 24),
                      SizedBox(width: 8),
                      Text(
                        "START NEW SESSION",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// 3. FIND A TRACK card
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.findTrackScreen),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xff111111),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.map_outlined,
                            color: AppColors.yellow,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "FIND A TRACK",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Explore racing circuits worldwide and set your destination.",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: const [
                          Text(
                            "EXPLORE NOW",
                            style: TextStyle(
                              color: AppColors.yellow,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            color: AppColors.yellow,
                            size: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// 4. GROUP DRIVES card
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.groupDrivesScreen),
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                    image: const DecorationImage(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1617814076367-b759c7d7e738?w=600&auto=format&fit=crop",
                      ),
                      fit: BoxFit.cover,
                      opacity: 0.35,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Colors.black87, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.people_outline,
                              color: AppColors.yellow,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "GROUP DRIVES",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Join or create group road trips with the community.",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            Text(
                              "JOIN EVENT",
                              style: TextStyle(
                                color: AppColors.yellow,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.chevron_right,
                              color: AppColors.yellow,
                              size: 12,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// 5. MY PAST LAPS card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.history, color: AppColors.yellow, size: 20),
                        SizedBox(width: 8),
                        Text(
                          "MY PAST LAPS",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "View your previous track data, times, and sector performance improvements.",
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        Text(
                          "VIEW ANALYTICS",
                          style: TextStyle(
                            color: AppColors.yellow,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.yellow,
                          size: 12,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// Stats row grid
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xff1d1d1d),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "BEST LAP",
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "01:54.22",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xff1d1d1d),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "SESSIONS",
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "42",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        bottomNavigationBar: const CustomNavBar(currentIndex: 2),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments passed from the event card if any, fallback to default Silverstone values
    final String imageUrl = Get.arguments?['imageUrl'] ?? 'https://picsum.photos/seed/silverstone_event/800/400';
    final String title = Get.arguments?['title'] ?? 'SILVERSTONE PERFORMANCE PADDOCK';
    final String organizer = Get.arguments?['organizer'] ?? 'Anderson Racing';
    final String date = Get.arguments?['date'] ?? 'OCT 24, 2024';
    final String location = Get.arguments?['location'] ?? 'SILVERSTONE CIRCUIT, UK';
    final String timeWindow = Get.arguments?['timeWindow'] ?? '09:00 GMT';
    final String likes = Get.arguments?['likes'] ?? '124';
    final String comments = Get.arguments?['comments'] ?? '18';
    final String capacity = Get.arguments?['capacity'] ?? '84% FULL';
    final double capacityProgress = Get.arguments?['capacityProgress'] ?? 0.84;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.yellow, size: 24),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "EVENT DETAILS",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://picsum.photos/seed/driver_profile/100/100'),
              backgroundColor: Colors.white10,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Banner Image
            Container(
              width: double.infinity,
              height: 240,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Live Mission Header Tag
                  const Text(
                    "LIVE MISSION",
                    style: TextStyle(
                      color: AppColors.yellow,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// Event Title
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Organizer details row
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white12,
                        child: Icon(Icons.person, size: 12, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        organizer,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.verified, color: AppColors.yellow, size: 14),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// Event Description
                  const Text(
                    "Execute high-intensity technical sequences at Britain's home of racing. Our engineering team will provide real-time telemetry overlays and post-session data reviews to optimize entry speeds and braking zones.",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Social metrics row
                  Row(
                    children: [
                      const Icon(Icons.favorite_border, color: Colors.white70, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        likes,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.chat_bubble_outline, color: Colors.white70, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        comments,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.share_outlined, color: Colors.white70, size: 20),
                      const SizedBox(width: 6),
                      const Text(
                        "SHARE",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  /// Logistics Stamp Card with custom label badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
                        decoration: BoxDecoration(
                          color: const Color(0xff181818),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          children: [
                            /// Deployment Date Row
                            _buildLogisticsRow(
                              icon: Icons.calendar_today_outlined,
                              label: 'DEPLOYMENT DATE',
                              value: date,
                            ),
                            const SizedBox(height: 16),

                            /// Time Window Row
                            _buildLogisticsRow(
                              icon: Icons.access_time,
                              label: 'TIME_WINDOW',
                              value: timeWindow,
                            ),
                            const SizedBox(height: 16),

                            /// Location Row
                            _buildLogisticsRow(
                              icon: Icons.location_on_outlined,
                              label: 'LOCATION',
                              value: location,
                            ),
                          ],
                        ),
                      ),

                      /// Logistics Stamp Badge label
                      Positioned(
                        top: -10,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          color: Colors.black,
                          child: const Text(
                            "LOGISTICS_STAMP",
                            style: TextStyle(
                              color: AppColors.yellow,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  /// Weather & Data Stream Indicators
                  Row(
                    children: [
                      /// Weather
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "WEATHER",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: const [
                                Icon(Icons.wb_sunny_outlined, color: AppColors.yellow, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  "OPTIMAL (18°C)",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// Data Stream
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "DATA STREAM",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: const [
                                Icon(Icons.sensors, color: AppColors.yellow, size: 16),
                                SizedBox(width: 6),
                                Text(
                                  "FULL ACCESS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  /// Capacity Utilization Progress Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "CAPACITY UTILIZATION",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        capacity,
                        style: const TextStyle(
                          color: AppColors.yellow,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: capacityProgress,
                      backgroundColor: const Color(0xff222222),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.yellow),
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// Join Session Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // Navigate to AccessGrantedScreen
                        Get.toNamed(
                          AppRoutes.accessGrantedScreen,
                          arguments: {
                            'title': title,
                            'date': date,
                            'passId': 'XP-992-GTR',
                          },
                        );
                      },
                      child: const Text(
                        "JOIN SESSION",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogisticsRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.yellow, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

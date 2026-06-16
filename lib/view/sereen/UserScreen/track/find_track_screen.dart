import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/view/components/custom_nav_bar/navbar.dart';
import 'widgets/track_appbar.dart';

class FindTrackScreen extends StatefulWidget {
  const FindTrackScreen({super.key});

  @override
  State<FindTrackScreen> createState() => _FindTrackScreenState();
}

class _FindTrackScreenState extends State<FindTrackScreen> {
  String selectedFilter = "ALL TRACKS";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: TrackAppBar(
        title: "",
        showLogo: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.yellow),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Color(0xffD1C5AB)),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.yellow, width: 1.5),
                  image: const DecorationImage(
                    image: NetworkImage("https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=100&fit=crop"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            /// Title Finder Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "FIND A TRACK",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
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
                          hintText: "Search for a track...",
                          hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Filters Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: ["ALL TRACKS", "NEARBY", "PRO CIRCUITS"].map((filter) {
                  final bool isSelected = filter == selectedFilter;
                  return GestureDetector(
                    onTap: () => setState(() => selectedFilter = filter),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.yellow : const Color(0xff111111),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: isSelected ? Colors.transparent : Colors.white10),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white70,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            /// Tracks List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildTrackCard(
                    imageUrl: "https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=600&auto=format&fit=crop",
                    status: "OPEN",
                    isOpened: true,
                    country: "BELGIUM",
                    name: "SPA-FRANCORCHAMPS",
                    length: "7.004 KM",
                    corners: "20",
                    elevation: "102M",
                    ctaLabel: "GO TO TRACK",
                  ),
                  _buildTrackCard(
                    imageUrl: "https://images.unsplash.com/photo-1511919884226-fd3cad34687c?w=600&auto=format&fit=crop",
                    status: "CLOSED",
                    isOpened: false,
                    country: "JAPAN",
                    name: "SUZUKA CIRCUIT",
                    length: "5.807 KM",
                    corners: "18",
                    elevation: "PRO",
                    ctaLabel: "VIEW DETAILS",
                  ),
                  _buildDescTrackCard(
                    imageUrl: "https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?w=600&auto=format&fit=crop",
                    country: "GERMANY",
                    name: "NÜRBURGRING",
                    description: "The ultimate test of man and machine. 20.8 KM of pure adrenaline through the Eifel...",
                    statsLabel: "20.8 KM",
                  ),
                  _buildDescTrackCard(
                    imageUrl: "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=600&auto=format&fit=crop",
                    country: "ITALY",
                    name: "MONZA ENI",
                    description: "The Temple of Speed. Long straights and historic banked curves in a royal park...",
                    statsLabel: "5.7 KM",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// Live Global Stats Footer Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "LIVE GLOBAL STATS",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildFooterStat("TRACKS ACTIVE", "142")),
                        Expanded(child: _buildFooterStat("DRIVERS ONLINE", "2.4K")),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildFooterStat("WEATHER ALERTS", "03", isAlert: true)),
                        Expanded(child: _buildFooterStat("AVG LAP TEMP", "24°C")),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 2),
    );
  }

  Widget _buildTrackCard({
    required String imageUrl,
    required String status,
    required bool isOpened,
    required String country,
    required String name,
    required String length,
    required String corners,
    required String elevation,
    required String ctaLabel,
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
          /// Card Image
          Stack(
            children: [
              Image.network(imageUrl, height: 140, width: double.infinity, fit: BoxFit.cover),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOpened ? AppColors.yellow : const Color(0xff222222),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: isOpened ? Colors.black : Colors.white60,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// Card Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  country,
                  style: const TextStyle(
                    color: AppColors.yellow,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTrackSpec("LENGTH", length),
                    _buildTrackSpec("CORNERS", corners),
                    _buildTrackSpec(country == "JAPAN" ? "TYPE" : "ELEVATION CHANGE", elevation),
                  ],
                ),
                const SizedBox(height: 16),

                /// CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOpened ? AppColors.yellow : Colors.transparent,
                      foregroundColor: isOpened ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: isOpened ? BorderSide.none : const BorderSide(color: Colors.white24),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (isOpened) Get.toNamed(AppRoutes.prepareSessionScreen);
                    },
                    child: Text(
                      ctaLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: isOpened ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescTrackCard({
    required String imageUrl,
    required String country,
    required String name,
    required String description,
    required String statsLabel,
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
          Image.network(imageUrl, height: 140, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  country,
                  style: const TextStyle(
                    color: AppColors.yellow,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Container(height: 1, color: Colors.white10),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      statsLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Icon(Icons.arrow_forward, color: Colors.white38, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackSpec(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 7,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterStat(String label, String value, {bool isAlert = false}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: isAlert ? const Color(0xffFF6B6B) : Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

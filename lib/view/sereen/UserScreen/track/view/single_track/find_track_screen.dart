import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/utils/app_const/app_const.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_nav_bar/navbar.dart';
import '../../widgets/track_appbar.dart';
import '../../controller/track_controller.dart';
import '../../../Profile/controller/profile_controller.dart';
import '../../mode/track_model.dart';

class FindTrackScreen extends StatelessWidget {
  FindTrackScreen({super.key});

  final TrackController trackController = Get.find<TrackController>();
  final ProfileScreenController profileController =
      Get.find<ProfileScreenController>();

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: TrackAppBar(
          title: "",
          profilePic: AppConstants.profileImage,
          showLogo: true,
          leading: const BackButton(color: AppColors.yellow),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none_outlined,
                color: Color(0xffD1C5AB),
              ),
              onPressed: () {},
            ),

            //profile pic
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Obx(() {
                  String profilePic =
                      profileController.profileData.value?.profileImage ??
                      AppConstants.profileImage;
                  return GestureDetector(
                    onTap: () {
                      Get.offAllNamed(AppRoutes.profileScreen);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.yellow, width: 1.5),
                        image: DecorationImage(
                          image: NetworkImage(profilePic),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!trackController.isLoading.value &&
                !trackController.isLoadMore.value &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              trackController.getAllTracks();
            }
            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                /// Title Finder Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "findATrack".tr,
                    style: const TextStyle(
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff111111),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: Colors.white38,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                            onChanged: (val) {
                              trackController.searchTracks(val);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "searchForTrack".tr,
                              hintStyle: const TextStyle(
                                color: Colors.white24,
                                fontSize: 13,
                              ),
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
                  child: Obx(
                    () => Row(
                      children: ["allTracks".tr, "nearby".tr].map((filter) {
                        final bool isSelected =
                            filter == trackController.selectedFilter.value;
                        return GestureDetector(
                          onTap: () => trackController.changeFilter(filter),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.yellow
                                  : const Color(0xff111111),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.transparent
                                    : Colors.white10,
                              ),
                            ),
                            child: Text(
                              filter,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.white70,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                /// Tracks List
                Obx(() {
                  if (trackController.isLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: CircularProgressIndicator(
                          color: AppColors.yellow,
                        ),
                      ),
                    );
                  }
                  if (trackController.tracks.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 32.0,
                      ),
                      child: Center(
                        child: Text(
                          "noTracksFound".tr,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: trackController.tracks
                          .map((t) => _buildTrackCard(t))
                          .toList(),
                    ),
                  );
                }),

                Obx(
                  () => trackController.isLoadMore.value
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              color: AppColors.yellow,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
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
                        Text(
                          "liveGlobalStats".tr,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildFooterStat("tracksActive".tr, "142"),
                            ),
                            Expanded(
                              child: _buildFooterStat(
                                "driversOnline".tr,
                                "2.4K",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildFooterStat(
                                "weatherAlerts".tr,
                                "03",
                                isAlert: true,
                              ),
                            ),
                            Expanded(
                              child: _buildFooterStat("avgLapTemp".tr, "24°C"),
                            ),
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
        ),
        bottomNavigationBar: const CustomNavBar(currentIndex: 2),
      ),
    );
  }

  Widget _buildTrackCard(Track track) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.trackDetailsScreen, arguments: track);
      },
      child: Container(
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
                Image.network(
                  track.coverImage ??
                      "https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=600&auto=format&fit=crop",
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 140,
                    color: Colors.grey[900],
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.white38),
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
                    (track.country ?? "unknown".tr).toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.yellow,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    (track.name ?? "unknownTrack".tr).toUpperCase(),
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
                      _buildTrackSpec("length".tr, "${track.lengthKm ?? 0} KM"),
                      _buildTrackSpec("corners".tr, "${track.numCorners ?? 0}"),
                      _buildTrackSpec(
                        "elevation".tr,
                        "${track.elevationChange ?? 0}M",
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  /// CTA Button
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide.none,
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.prepareSessionScreen,
                          arguments: track,
                        );
                      },
                      child: Text(
                        "selectTrack".tr,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/app_routes/app_routes.dart';
import '../../../../../../utils/app_colors/app_colors.dart';
import '../../mode/track_model.dart';

class TrackDetailsScreen extends StatelessWidget {
  const TrackDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the track object passed as an argument
    final Track? track = Get.arguments as Track?;

    if (track == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: AppColors.yellow),
        ),
        body: Center(
          child: Text(
            "trackDetailsNotAvailable".tr,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(track),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(track),
                  const SizedBox(height: 24),
                  _buildTrackSpecs(track),
                  const SizedBox(height: 24),
                  if ((track.startLocation != null &&
                          track.startLocation!.isNotEmpty) ||
                      (track.endLocation != null &&
                          track.endLocation!.isNotEmpty)) ...[
                    _buildSectionTitle("locations".tr),
                    const SizedBox(height: 12),
                    if (track.startLocation != null &&
                        track.startLocation!.isNotEmpty)
                      _buildLocationRow("startUpper".tr, track.startLocation!),
                    if (track.endLocation != null &&
                        track.endLocation!.isNotEmpty)
                      _buildLocationRow("endUpper".tr, track.endLocation!),
                    const SizedBox(height: 16),
                  ],
                  if (track.description != null &&
                      track.description!.isNotEmpty) ...[
                    _buildSectionTitle("description".tr),
                    const SizedBox(height: 8),
                    Text(
                      track.description!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (track.layoutImage != null &&
                      track.layoutImage!.isNotEmpty) ...[
                    _buildSectionTitle("trackLayout".tr),
                    const SizedBox(height: 8),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xff111111),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        track.layoutImage!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.white38,
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomCTA(track),
    );
  }

  Widget _buildSliverAppBar(Track track) {
    return SliverAppBar(
      expandedHeight: 300.0,
      floating: false,
      pinned: true,
      backgroundColor: Colors.black,
      leading: const BackButton(color: AppColors.yellow),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              track.coverImage ??
                  "https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=600&auto=format&fit=crop",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[900],
                child: const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white38,
                    size: 40,
                  ),
                ),
              ),
            ),
            // Gradient overlay for better text visibility if we had text on image
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    Colors.black,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(Track track) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (track.country != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.yellow.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.yellow.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  track.country!.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.yellow,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            if (track.city != null) ...[
              const SizedBox(width: 8),
              Text(
                track.city!.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
            const Spacer(),
            if (track.trackType != null)
              Text(
                track.trackType!.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          (track.name ?? "unknownTrack".tr).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (track.address != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white38, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  track.address!,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTrackSpecs(Track track) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSpecItem("length".tr, "${track.lengthKm ?? 0} KM"),
          _buildDivider(),
          _buildSpecItem("corners".tr, "${track.numCorners ?? 0}"),
          _buildDivider(),
          _buildSpecItem("elevation".tr, "${track.elevationChange ?? 0}M"),
        ],
      ),
    );
  }

  Widget _buildSpecItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: Colors.white10);
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildLocationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCTA(Track track) {
    return SafeArea(
      child: Padding(
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
              elevation: 0,
            ),
            onPressed: () {
              Get.toNamed(AppRoutes.prepareSessionScreen, arguments: track);
            },
            child: Text(
              "prepareSession".tr,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

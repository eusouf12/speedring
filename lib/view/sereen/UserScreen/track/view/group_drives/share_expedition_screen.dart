import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/utils/app_const/app_const.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/view/sereen/UserScreen/track/controller/active_drive_controller.dart';
import 'package:speedring/view/sereen/UserScreen/track/widgets/track_appbar.dart';

class ShareExpeditionScreen extends StatefulWidget {
  const ShareExpeditionScreen({super.key});

  @override
  State<ShareExpeditionScreen> createState() => _ShareExpeditionScreenState();
}

class _ShareExpeditionScreenState extends State<ShareExpeditionScreen> {
  final TextEditingController narrativeController = TextEditingController();
  String selectedVisibility = "PUBLIC";

  @override
  void dispose() {
    narrativeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ActiveDriveController activeController = Get.find<ActiveDriveController>();

    String? hostProfile = activeController.drive?.host?.profileImage;
    if (hostProfile != null && hostProfile.isNotEmpty && !hostProfile.startsWith("http")) {
      hostProfile = "${ApiUrl.imageUrl}/$hostProfile";
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: TrackAppBar(
        profilePic: activeController.profileController.profileData.value?.profileImage ??
            AppConstants.profileImage2,
        title: "SHARE EXPEDITION",
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.yellow),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// POST PREVIEW
            _buildSectionHeader("POST PREVIEW"),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Driver profile & drive title
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.yellow,
                              width: 1.5,
                            ),
                            image: DecorationImage(
                              image: NetworkImage(hostProfile ?? AppConstants.profileImage2),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activeController.drive?.host?.userName != null
                                    ? "@${activeController.drive!.host!.userName!.toUpperCase()}"
                                    : "@HOST",
                                style: const TextStyle(
                                  color: AppColors.yellow,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                activeController.drive?.tripName?.toUpperCase() ?? "UNTITLED EXPEDITION",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white60,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  /// Map Graphic / Cover Image Fallback
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          activeController.drive?.coverImage != null && activeController.drive!.coverImage!.isNotEmpty
                              ? (activeController.drive!.coverImage!.startsWith("http")
                                  ? activeController.drive!.coverImage!
                                  : "${ApiUrl.imageUrl}/${activeController.drive!.coverImage}")
                              : (activeController.drive?.routeTrack != null && activeController.drive!.routeTrack['coverImage'] != null
                                  ? activeController.drive!.routeTrack['coverImage']
                                  : "https://images.unsplash.com/photo-1524661135-423995f22d0b?w=600&fit=crop"),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  /// Overlay Metrics Panel
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: const Color(0xff0d0d0d),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildPreviewMetric(
                            "DISTANCE",
                            activeController.totalDistanceKm.value.toStringAsFixed(1),
                            "KM",
                          ),
                        ),
                        Expanded(
                          child: _buildPreviewMetric(
                            "TIME",
                            activeController.getFormattedDuration(),
                            "",
                          ),
                        ),
                        Expanded(
                          child: _buildPreviewMetric(
                            "AVG VELOCITY",
                            (activeController.elapsedSeconds.value == 0
                                    ? 0.0
                                    : activeController.totalDistanceKm.value / (activeController.elapsedSeconds.value / 3600.0))
                                .toStringAsFixed(0),
                            "KM/H",
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Card Footer (Avatars + Likes/Comments/Share)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (activeController.drive?.participants != null)
                              ...activeController.drive!.participants!.take(3).map((p) {
                                String url = p.profileImage ?? AppConstants.profileImage2;
                                if (!url.startsWith("http")) {
                                  url = "${ApiUrl.imageUrl}/$url";
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: _buildMiniAvatar(url),
                                );
                              }),
                            if ((activeController.drive?.participants?.length ?? 0) > 3)
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Color(0xff222222),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "+${activeController.drive!.participants!.length - 3}",
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 7,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(
                                Icons.favorite_border,
                                color: Colors.white38,
                                size: 16,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.white38,
                                size: 15,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(
                                Icons.send_outlined,
                                color: Colors.white38,
                                size: 15,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// NARRATIVE FIELD
            _buildSectionHeader("NARRATIVE"),
            TextField(
              controller: narrativeController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xff111111),
                hintText: "Write details about this drive...",
                hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),

            /// VISIBILITY SELECTION
            _buildSectionHeader("VISIBILITY"),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  _buildVisibilityChip("PUBLIC", Icons.public),
                  const SizedBox(width: 6),
                  _buildVisibilityChip("FOLLOWERS", Icons.people_outline),
                  const SizedBox(width: 6),
                  _buildVisibilityChip("PRIVATE", Icons.lock_outline),
                ],
              ),
            ),
            const SizedBox(height: 32),

            /// POST TO FEED BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // After posting, clean up the controller
                  Get.delete<ActiveDriveController>();
                  Get.offAllNamed(AppRoutes.userHomeScreen);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.send, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "POST TO FEED",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.yellow,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildPreviewMetric(String label, String val, String unit) {
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              val,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            if (unit.isNotEmpty) ...[
              const SizedBox(width: 2),
              Text(
                unit,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildMiniAvatar(String url) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.yellow, width: 0.7),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildVisibilityChip(String label, IconData icon) {
    final bool isSelected = selectedVisibility == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedVisibility = label;
          });
        },
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xff222222) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppColors.yellow.withValues(alpha: 0.3)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.yellow : Colors.white38,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.yellow : Colors.white38,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

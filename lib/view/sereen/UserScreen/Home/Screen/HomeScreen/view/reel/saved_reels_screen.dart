import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:video_player/video_player.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_text/custom_text.dart';
import '../../controller/reels_controller.dart';
import 'reels_screen.dart';

class SavedReelsScreen extends StatelessWidget {
  const SavedReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReelsController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomRoyelAppbar(leftIcon: true, titleName: "SAVED_REELS".tr),
      body: Obx(() {
        if (controller.isSavedReelsLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.yellow),
          );
        }

        if (controller.savedReels.isEmpty) {
          return Center(
            child: CustomText(
              text: "NO_SAVED_REELS_FOUND".tr,
              color: Colors.white54,
              fontSize: 16,
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 9 / 16,
          ),
          itemCount: controller.savedReels.length,
          itemBuilder: (context, index) {
            final reel = controller.savedReels[index];
            String? videoUrl;

            // Try to extract video url
            if (reel['media'] != null &&
                reel['media'] is List &&
                reel['media'].isNotEmpty) {
              videoUrl = reel['media'][0]['url'];
            } else {
              videoUrl = reel['videoUrl'];
            }

            return GestureDetector(
              onTap: () {
                Get.to(() => SavedReelsViewerScreen(initialIndex: index));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (videoUrl != null)
                        MiniReelVideo(videoUrl: videoUrl)
                      else if (reel['imageUrl'] != null)
                        Image.network(reel['imageUrl'], fit: BoxFit.cover)
                      else
                        Container(color: Colors.grey[900]),

                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(
                            Icons.bookmark_remove_rounded,
                            color: AppColors.yellow,
                            size: 20,
                          ),
                          onPressed: () {
                            controller.removeSavedReel(
                              reel['_id'] ?? reel['id'] ?? '',
                            );
                          },
                        ),
                      ),
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

class MiniReelVideo extends StatefulWidget {
  final String videoUrl;
  const MiniReelVideo({super.key, required this.videoUrl});

  @override
  State<MiniReelVideo> createState() => _MiniReelVideoState();
}

class _MiniReelVideoState extends State<MiniReelVideo> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        _controller?.seekTo(const Duration(milliseconds: 100));
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Container(color: Colors.grey[900]);
    }
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller!.value.size.width,
          height: _controller!.value.size.height,
          child: VideoPlayer(_controller!),
        ),
      ),
    );
  }
}

class SavedReelsViewerScreen extends StatelessWidget {
  final int initialIndex;
  const SavedReelsViewerScreen({super.key, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReelsController>();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: PageController(initialPage: initialIndex),
            scrollDirection: Axis.vertical,
            itemCount: controller.savedReels.length,
            itemBuilder: (context, index) {
              return ReelItemWidget(
                index: index,
                reelData: controller.savedReels[index],
                controller: controller,
                isSavedMode: true,
              );
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: const BackButton(color: AppColors.yellow),
          ),
        ],
      ),
    );
  }
}

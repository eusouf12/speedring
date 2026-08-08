import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/sereen/UserScreen/Home/Screen/HomeScreen/view/event/event_comment_screen.dart';
import '../../../../../../../components/custom_netwrok_image/custom_network_image.dart';
import '../../../../../../../components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../controller/home_controller.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final HomeController controller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    final eventId = Get.arguments?['eventId'] as String?;
    if (eventId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.getSingleEvent(eventId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomRoyelAppbar(leftIcon: true, titleName: "eventDetails".tr),
        body: Obx(() {
          if (controller.isEventDetailLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }

          final event = controller.currentEventDetail.value;
          if (event == null) {
            return const Center(
              child: Text(
                "Event not found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          String bannerUrl = event.bannerImage ?? "";
          if (bannerUrl.isNotEmpty && !bannerUrl.startsWith("http")) {
            bannerUrl = ApiUrl.baseUrl + bannerUrl;
          }
          final String imageUrl = bannerUrl.isNotEmpty ? bannerUrl : '';

          final String title = event.eventName ?? 'UNTITLED EVENT';
          final String organizer = event.user?.name ?? 'Unknown Organizer';
          final String organizerImage = event.user?.profileImage ?? '';
          final String date = event.deploymentDate != null
              ? event.deploymentDate!.split('T')[0]
              : 'UNKNOWN DATE';
          final String location = event.locationCircuit ?? 'UNKNOWN LOCATION';
          final String timeWindow = event.timeWindow != null
              ? "${event.timeWindow!.start} - ${event.timeWindow!.end}"
              : 'UNKNOWN TIME';

          final String likes = "${event.reactCount ?? 0}";
          final String comments = "${event.commentCount ?? 0}";

          final int joinCount = event.joinCount ?? 0;
          final int maxCapacity = event.maxCapacity ?? 1;
          final double capacityProgress = (joinCount / maxCapacity).clamp(
            0.0,
            1.0,
          );
          final String capacityText =
              "${(capacityProgress * 100).toInt()}% FULL";

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Banner Image
                CustomNetworkImage(
                  imageUrl: imageUrl,
                  height: 380,
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Live Mission Header Tag
                      Text(
                        "liveMission".tr,
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
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white12,
                            backgroundImage: organizerImage.isNotEmpty
                                ? NetworkImage(
                                    organizerImage.startsWith('http')
                                        ? organizerImage
                                        : ApiUrl.baseUrl + organizerImage,
                                  )
                                : null,
                            child: organizerImage.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    size: 20,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            organizer,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// Event Description
                      Text(
                        event.briefing ?? "noDescriptionProvided".tr,
                        style: const TextStyle(
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
                          GestureDetector(
                            onTap: () =>
                                controller.reactToEvent(eventId: event.id!),
                            child: Row(
                              children: [
                                Icon(
                                  event.isReacted == true
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: event.isReacted == true
                                      ? Colors.red
                                      : Colors.white70,
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  likes,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () => showEventCommentSheet(context, event),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  comments,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              controller.shareEvent(eventId: event.id!);
                              shareEventLink(event);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.share_outlined,
                                  color: Colors.white70,
                                  size: 20,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "share".tr,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
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
                                  label: 'deploymentDate'.tr,
                                  value: date,
                                ),
                                const SizedBox(height: 16),

                                /// Time Window Row
                                _buildLogisticsRow(
                                  icon: Icons.access_time,
                                  label: 'timeWindow'.tr,
                                  value: timeWindow,
                                ),
                                const SizedBox(height: 16),

                                /// Location Row
                                _buildLogisticsRow(
                                  icon: Icons.location_on_outlined,
                                  label: 'location'.tr,
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
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
                            capacityText,
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
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.yellow,
                          ),
                          minHeight: 4,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        bottomNavigationBar: Obx(() {
          final event = controller.currentEventDetail.value;
          if (event == null) return const SizedBox.shrink();

          final isMyEvent =
              event.user?.id != null &&
              event.user!.id == controller.currentUserId.value;

          return SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(top: BorderSide(color: Colors.white10)),
              ),
              child: Row(
                children: [
                  if (isMyEvent)
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Get.dialog(
                                AlertDialog(
                                  backgroundColor: const Color(0xff1C1C1C),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: const Text(
                                    "Delete Event",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: const Text(
                                    "Are you sure you want to delete this event?",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text(
                                        "NO",
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back(); // close dialog
                                        controller.deleteEvent(
                                          eventId: event.id!,
                                        );
                                        Get.back(); // go back from details page
                                      },
                                      child: const Text(
                                        "YES",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Center(
                              child: Text(
                                "DELETE EVENT",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  if (!isMyEvent)
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: event.isEventJoined == true
                              ? Colors.white12
                              : AppColors.yellow,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              controller.joinEvent(eventId: event.id!);
                            },
                            child: Center(
                              child: Text(
                                event.isEventJoined == true
                                    ? "WITHDRAW"
                                    : "CONFIRM DEPLOYMENT",
                                style: TextStyle(
                                  color: event.isEventJoined == true
                                      ? Colors.white60
                                      : Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
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
        Expanded(
          child: Column(
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
        ),
      ],
    );
  }
}

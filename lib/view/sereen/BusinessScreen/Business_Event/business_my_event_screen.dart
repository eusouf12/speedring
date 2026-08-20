import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/sereen/UserScreen/Home/Screen/HomeScreen/controller/home_controller.dart';
import 'package:speedring/view/sereen/UserScreen/Home/Screen/HomeScreen/view/user_home_screen.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../UserScreen/Home/Screen/HomeScreen/view/event/event_comment_screen.dart';

class BusinessMyEventScreen extends StatefulWidget {
  const BusinessMyEventScreen({super.key});

  @override
  State<BusinessMyEventScreen> createState() => _BusinessMyEventScreenState();
}

class _BusinessMyEventScreenState extends State<BusinessMyEventScreen> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(HomeController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getMyEvent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: const BackButton(color: AppColors.yellow),
          title: Text(
            "organizeEvent".tr.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isEventsLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }
          if (controller.eventsList.isEmpty) {
            return Center(
              child: Text(
                "noEventsFound".tr,
                style: const TextStyle(color: Colors.white54),
              ),
            );
          }
          return RefreshIndicator(
            color: AppColors.yellow,
            backgroundColor: Colors.black,
            onRefresh: () => controller.getMyEvent(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: controller.eventsList.length,
              itemBuilder: (context, index) {
                final event = controller.eventsList[index];
                final isMyEvent =
                    event.user?.id != null &&
                    event.user!.id == controller.currentUserId.value;

                String bannerUrl = event.bannerImage ?? "";
                if (bannerUrl.isNotEmpty && !bannerUrl.startsWith("http")) {
                  bannerUrl = "http://10.10.28.90:4050$bannerUrl";
                }

                return EventCard(
                  imageUrl: bannerUrl.isNotEmpty
                      ? bannerUrl
                      : "https://picsum.photos/seed/event_${event.id}/600/300",
                  organizer: event.user?.name ?? "ORGANIZER",
                  organizerImage: event.user?.profileImage,
                  title: event.eventName ?? "UNTITLED EVENT",
                  date: event.deploymentDate != null
                      ? event.deploymentDate!.split('T')[0]
                      : "UNKNOWN",
                  type: event.missionType ?? "EVENT",
                  location: event.locationCircuit ?? "UNKNOWN",
                  slots: "${event.joinCount ?? 0}/${event.maxCapacity ?? 0}",
                  likes: "${event.reactCount ?? 0}",
                  comments: "${event.commentCount ?? 0}",
                  isJoined: event.isEventJoined ?? false,
                  isReacted: event.isReacted ?? false,
                  isMyEvent: isMyEvent,
                  eventId: event.id ?? "",
                  onJoin: () => controller.joinEvent(eventId: event.id!),
                  onLike: () => controller.reactToEvent(eventId: event.id!),
                  onComment: () => showEventCommentSheet(context, event),
                  onShare: () {
                    controller.shareEvent(eventId: event.id!);
                    shareEventLink(event);
                  },
                  onDelete: isMyEvent
                      ? () => controller.deleteEvent(eventId: event.id!)
                      : null,
                  userId: event.user?.id,
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

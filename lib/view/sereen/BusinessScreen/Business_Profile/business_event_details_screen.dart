import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../../utils/app_images/app_images.dart';
import '../../../components/custom_text/custom_text.dart';

class BusinessEventDetailsScreen extends StatefulWidget {
  const BusinessEventDetailsScreen({super.key});

  @override
  State<BusinessEventDetailsScreen> createState() => _BusinessEventDetailsScreenState();
}

class _BusinessEventDetailsScreenState extends State<BusinessEventDetailsScreen> {
  late Map<String, dynamic> _eventData;

  @override
  void initState() {
    super.initState();
    // Fetch arguments from previous screen or load default Silverstone values
    _eventData = Get.arguments as Map<String, dynamic>? ?? {
      'title': 'SILVERSTONE PERFORMANCE PADDOCK',
      'organizer': 'Anderson Racing',
      'imageUrl': 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=800&fit=crop',
      'date': 'OCT 24, 2024',
      'time': '09:00 GMT',
      'location': 'SILVERSTONE CIRCUIT, UK',
      'capacity': 0.84,
      'capacityText': '84% FULL',
      'weather': 'OPTIMAL (18°C)',
      'dataStream': 'FULL ACCESS',
    };
  }

  @override
  Widget build(BuildContext context) {
    final title = _eventData['title'] ?? 'SILVERSTONE PERFORMANCE PADDOCK';
    final imageUrl = _eventData['imageUrl'] ?? 'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=800&fit=crop';
    final organizer = _eventData['organizer'] ?? 'Anderson Racing';
    final date = _eventData['date'] ?? 'OCT 24, 2024';
    final time = _eventData['time'] ?? '09:00 GMT';
    final location = _eventData['location'] ?? 'SILVERSTONE CIRCUIT, UK';
    final capacity = _eventData['capacity'] is double ? _eventData['capacity'] as double : 0.84;
    final capacityText = _eventData['capacityText'] ?? '84% FULL';
    final weather = _eventData['weather'] ?? 'OPTIMAL (18°C)';
    final dataStream = _eventData['dataStream'] ?? 'FULL ACCESS';

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Image.asset(
            AppImages.logo,
            height: 26.h,
            fit: BoxFit.contain,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner Image
              Container(
                height: 180.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LIVE MISSION BADGE
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        "LIVE MISSION",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 7.5.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // TITLE
                    CustomText(
                      text: title,
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 10.h),

                    // ORGANIZER ROW
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12.r,
                          backgroundColor: const Color(0xff222222),
                          child: Icon(Icons.person, size: 12.r, color: Colors.white60),
                        ),
                        SizedBox(width: 8.w),
                        CustomText(
                          text: organizer,
                          color: Colors.white70,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w900,
                        ),
                        SizedBox(width: 4.w),
                        const Icon(Icons.verified, color: AppColors.yellow, size: 13),
                      ],
                    ),
                    SizedBox(height: 14.h),

                    // DESCRIPTION
                    CustomText(
                      text: "Execute high-intensity technical sequences at Britain's home of racing. Our engineering team will provide real-time telemetry overlays and post-session data reviews to optimize entry speeds and braking zones.",
                      color: Colors.white60,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 14.h),

                    // Stats icons
                    Row(
                      children: [
                        Icon(Icons.favorite_border_rounded, color: Colors.white70, size: 16.sp),
                        SizedBox(width: 6.w),
                        CustomText(
                          text: "124",
                          color: Colors.white70,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: 18.w),
                        Icon(Icons.chat_bubble_outline_rounded, color: Colors.white70, size: 15.sp),
                        SizedBox(width: 6.w),
                        CustomText(
                          text: "18",
                          color: Colors.white70,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(width: 18.w),
                        Icon(Icons.share_outlined, color: Colors.white70, size: 15.sp),
                        SizedBox(width: 6.w),
                        CustomText(
                          text: "SHARE",
                          color: Colors.white70,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white10, height: 28),

                    // LOGISTICS STAMP CARD
                    _buildFormSectionHeader("LOGISTICS_STAMP"),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xff111111),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        children: [
                          _buildLogisticsItem(Icons.calendar_today_outlined, "DEPLOYMENT DATE", date),
                          SizedBox(height: 14.h),
                          _buildLogisticsItem(Icons.access_time_rounded, "TIME_WINDOW", time),
                          SizedBox(height: 14.h),
                          _buildLogisticsItem(Icons.location_on_outlined, "LOCATION", location),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Weather / Data Stream row
                    Row(
                      children: [
                        Expanded(child: _buildDetailsMiniBox(Icons.wb_sunny_outlined, "WEATHER", weather)),
                        SizedBox(width: 12.w),
                        Expanded(child: _buildDetailsMiniBox(Icons.rss_feed_rounded, "DATA STREAM", dataStream)),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Capacity utilization progress bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: "CAPACITY UTILIZATION",
                          color: Colors.white38,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        CustomText(
                          text: capacityText,
                          color: AppColors.yellow,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3.r),
                      child: LinearProgressIndicator(
                        value: capacity,
                        backgroundColor: const Color(0xff1E1E1E),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.yellow),
                        minHeight: 5.h,
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Bottom management buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellow,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              minimumSize: Size(double.infinity, 44.h),
                            ),
                            onPressed: () {
                              Get.snackbar(
                                "Manage Event",
                                "Opening event modification matrix...",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: const Color(0xff181818),
                                colorText: Colors.white,
                                borderColor: AppColors.yellow,
                                borderWidth: 1,
                              );
                            },
                            icon: const Icon(Icons.edit_outlined, size: 16),
                            label: Text(
                              "MANAGE EVENT",
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            Get.snackbar(
                              "Event Cancelled",
                              "Successfully deleted '$title'. All participants notified.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: const Color(0xff181818),
                              colorText: Colors.white,
                              borderColor: Colors.redAccent,
                              borderWidth: 1,
                            );
                          },
                          child: Container(
                            width: 44.h,
                            height: 44.h,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSectionHeader(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xff181818),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: CustomText(
        text: label,
        color: AppColors.yellow,
        fontSize: 8.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildLogisticsItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: Colors.white10),
          ),
          child: Icon(icon, color: AppColors.yellow, size: 14.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: label,
                color: Colors.white38,
                fontSize: 7.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              SizedBox(height: 2.h),
              CustomText(
                text: value,
                color: Colors.white,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w900,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsMiniBox(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white38, size: 11.sp),
              SizedBox(width: 4.w),
              CustomText(
                text: label,
                color: Colors.white38,
                fontSize: 7.sp,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          CustomText(
            text: value,
            color: Colors.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.w900,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_button/custom_button.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../components/custom_nav_bar/navbar.dart';
import '../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../core/app_routes/app_routes.dart';
import '../controller/marketpace_controller.dart';
import '../widgets/spec_tile.dart';
import '../widgets/marketplace_map.dart';
import 'edit_listing_screen.dart';
import '../../Profile/controller/profile_controller.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MarketplaceFeedController>();
    final profileController = Get.find<ProfileScreenController>();

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          leading: const BackButton(color: AppColors.yellow),
          title: Text(
            "listingDetails".tr,
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Obx(() {
              final item = controller.itemDetail.value;
              if (item == null || item.seller?.id != profileController.profileData.value?.id) {
                return const SizedBox.shrink();
              }
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.yellow),
                color: Colors.black,
                onSelected: (value) {
                  if (value == 'edit') {
                    controller.prepareEdit(item);
                    Get.to(
                      () => EditListingScreen(
                        listingId: item.id!,
                        itemType: item.itemType ?? 'MOTORCYCLES',
                      ),
                    );
                  } else if (value == 'delete') {
                    final id = item.id;
                    if (id != null) {
                      Get.dialog(
                        AlertDialog(
                          backgroundColor: const Color(
                            0xff1e1e1e,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Text(
                            'deleteListingTitle'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Text(
                            'deleteListingConfirm'.tr,
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                'no'.tr,
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                                controller.deleteListing(id);
                              },
                              child: Text(
                                'yes'.tr,
                                style: TextStyle(
                                  color: Color(
                                    0xffD4FB54,
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('edit'.tr, style: TextStyle(color: Colors.white)),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('delete'.tr, style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            }),
          ],
        ),
        body: Obx(() {
          if (controller.isLoadingDetail.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }

          final data = controller.itemDetail.value;
          if (data == null) {
            return Center(
              child: Text(
                'listingNotFound'.tr,
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final visualAssets = data.visualAssets;
          final String imageUrl =
              (visualAssets != null && visualAssets.isNotEmpty)
              ? visualAssets[0]
              : "";
          String title = "";
          if (data.itemType == "PERFORMANCE_PARTS") {
            title = data.partName?.toUpperCase() ?? 'part'.tr;
          } else if (data.itemType == "EXPERT_SERVICES") {
            title = data.listingTitle?.toUpperCase() ?? 'service'.tr;
          } else {
            final brand = data.brand ?? "";
            final modelDesignation = data.modelDesignation ?? "";
            title = "$brand $modelDesignation".trim().toUpperCase();
            if (title.isEmpty) title = 'vehicle'.tr;
          }
          final price = data.itemType == "EXPERT_SERVICES"
              ? "\$${data.hourlyRateUSD ?? '0'}/HR"
              : "\$${data.askingPrice ?? '0'}";
          final description = data.description ?? "";

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Showcase Image
                Container(
                  height: 220.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.white10),
                    image: imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: imageUrl.isEmpty
                      ? const Icon(Icons.image, color: Colors.white38)
                      : null,
                ),
                SizedBox(height: 16.h),

                /// Title & Price
                CustomText(
                  text: title.isEmpty ? 'listingTitle'.tr : title,
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: price,
                  color: AppColors.yellow,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 24.h),

                /// Purchase & Offer Actions
                CustomButton(
                  height: 48.h,
                  title: 'messageSeller'.tr,
                  fontSize: 13,
                  borderRadius: 8.r,
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.inboxScreen,
                      arguments: {
                        "userName": "Anderson Racing",
                        "avatarUrl":
                            "https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=100&fit=crop",
                        "isOnline": true,
                      },
                    );
                  },
                ),
                SizedBox(height: 12.h),

                /// PHASE 01: TECH SPECS
                _buildSectionHeader('phase01TechSpecs'.tr),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 2.2,
                  children: [
                    if (data.itemType == "VEHICLES" ||
                        data.itemType == "MOTORCYCLES") ...[
                      if (data.productionYear != null)
                        SpecTile(
                          label: 'year'.tr,
                          value: "${data.productionYear}",
                        ),
                      if (data.mileageKM != null)
                        SpecTile(
                          label: 'mileage'.tr,
                          value: "${data.mileageKM} KM",
                        ),
                      if (data.transmission != null)
                        SpecTile(
                          label: 'transmission'.tr,
                          value: "${data.transmission}",
                        ),
                      if (data.engineType != null)
                        SpecTile(
                          label: 'engine'.tr,
                          value: "${data.engineType}",
                        ),
                      if (data.displacementCC != null)
                        SpecTile(
                          label: 'displacement'.tr,
                          value: "${data.displacementCC} CC",
                        ),
                      if (data.location != null)
                        SpecTile(
                          label: 'location'.tr,
                          value: "${data.location}",
                        ),
                      if (data.itemType != null)
                        SpecTile(label: 'type'.tr, value: "${data.itemType}"),
                      if (data.status != null)
                        SpecTile(label: 'status'.tr, value: "${data.status}"),
                      if (data.drivetrain != null)
                        SpecTile(
                          label: 'drivetrain'.tr,
                          value: "${data.drivetrain}",
                        ),
                      if (data.suspension != null)
                        SpecTile(
                          label: 'suspension'.tr,
                          value: "${data.suspension}",
                        ),
                      if (data.brakingSystem != null)
                        SpecTile(
                          label: 'brakes'.tr,
                          value: "${data.brakingSystem}",
                        ),
                      if (data.engineConfiguration != null)
                        SpecTile(
                          label: 'configuration'.tr,
                          value: "${data.engineConfiguration}",
                        ),
                      if (data.aerodynamicsBody != null)
                        SpecTile(
                          label: 'aerodynamics'.tr,
                          value: "${data.aerodynamicsBody}",
                        ),
                    ] else if (data.itemType == "PERFORMANCE_PARTS") ...[
                      if (data.brand != null)
                        SpecTile(label: 'brand'.tr, value: "${data.brand}"),
                      if (data.category != null)
                        SpecTile(
                          label: 'category'.tr,
                          value: "${data.category}",
                        ),
                      if (data.compatibility != null)
                        SpecTile(
                          label: 'compatibility'.tr,
                          value: "${data.compatibility}",
                        ),
                      if (data.condition != null)
                        SpecTile(
                          label: 'condition'.tr,
                          value: "${data.condition}",
                        ),
                      if (data.partNumber != null)
                        SpecTile(
                          label: 'partNo'.tr,
                          value: "${data.partNumber}",
                        ),
                      if (data.material != null)
                        SpecTile(
                          label: 'material'.tr,
                          value: "${data.material}",
                        ),
                      if (data.shippingStrategy != null)
                        SpecTile(
                          label: 'shipping'.tr,
                          value: "${data.shippingStrategy}",
                        ),
                    ] else if (data.itemType == "EXPERT_SERVICES") ...[
                      if (data.providerName != null)
                        SpecTile(
                          label: 'provider'.tr,
                          value: "${data.providerName}",
                        ),
                      if (data.category != null)
                        SpecTile(
                          label: 'category'.tr,
                          value: "${data.category}",
                        ),
                      if (data.locationType != null)
                        SpecTile(
                          label: 'location'.tr,
                          value: "${data.locationType}",
                        ),
                      if (data.experienceYears != null)
                        SpecTile(
                          label: 'experience'.tr,
                          value: "${data.experienceYears} YRS",
                        ),
                    ],
                  ],
                ),
                SizedBox(height: 24.h),

                /// PHASE 02: NARRATIVE
                _buildSectionHeader('phase02Narrative'.tr),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff111111),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'description'.tr,
                        color: AppColors.yellow,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        text: description,
                        color: Colors.white70,
                        fontSize: 11,
                        textAlign: TextAlign.start,
                        height: 1.5,
                      ),
                      SizedBox(height: 16.h),
                      Container(height: 1, color: Colors.white10),
                      SizedBox(height: 16.h),
                      Wrap(
                        spacing: 16.w,
                        runSpacing: 16.h,
                        alignment: WrapAlignment.spaceEvenly,
                        children: [
                          if (data.itemType == "VEHICLES" ||
                              data.itemType == "MOTORCYCLES") ...[
                            if (data.powerHP != null)
                              _buildMetricCol("${data.powerHP} HP", 'power'.tr),
                            if (data.zeroToHundred != null)
                              _buildMetricCol(
                                "${data.zeroToHundred}s",
                                'zeroToHundred'.tr,
                              ),
                            if (data.weightKG != null)
                              _buildMetricCol(
                                "${data.weightKG} KG",
                                'weight'.tr,
                              ),
                            if (data.torqueNM != null)
                              _buildMetricCol(
                                "${data.torqueNM} NM",
                                'torque'.tr,
                              ),
                            if (data.topSpeed != null)
                              _buildMetricCol(
                                "${data.topSpeed}",
                                'topSpeed'.tr,
                              ),
                          ] else if (data.itemType == "PERFORMANCE_PARTS") ...[
                            if (data.weightReductionKG != null)
                              _buildMetricCol(
                                "${data.weightReductionKG} KG",
                                'weightReduction'.tr,
                              ),
                            if (data.performanceGain != null)
                              _buildMetricCol(
                                "${data.performanceGain}",
                                'performanceGain'.tr,
                              ),
                          ] else if (data.itemType == "EXPERT_SERVICES" &&
                              data.trackSpecializations != null) ...[
                            ...data.trackSpecializations!
                                .map(
                                  (spec) => _buildMetricCol(
                                    spec.toUpperCase(),
                                    'specialization'.tr,
                                  ),
                                ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                /// VERIFIED SELLER
                CustomText(
                  text: 'verifiedSeller'.tr,
                  color: Colors.white38,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff111111),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  data.seller?.profileImage ?? "",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: data.seller != null
                                      ? data.seller!.name
                                                ?.toString()
                                                .toUpperCase() ??
                                            'unknownSeller'.tr
                                      : 'sellerFallback'.tr,
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  textAlign: TextAlign.start,
                                  letterSpacing: 0.5,
                                ),
                                SizedBox(height: 2.h),
                              ],
                            ),
                          ),
                          if (data.seller?.id != null && data.seller?.id != profileController.profileData.value?.id)
                            GestureDetector(
                              onTap: () {
                                controller.toggleFollow();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: controller.isFollowing.value
                                      ? Colors.transparent
                                      : Colors.black,
                                  border: Border.all(color: AppColors.yellow),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: CustomText(
                                  text: controller.isFollowing.value
                                      ? 'following'.tr
                                      : 'follow'.tr,
                                  color: controller.isFollowing.value
                                      ? Colors.white70
                                      : AppColors.yellow,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Container(height: 1, color: Colors.white10),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSellerCount(
                            data.seller?.activeListing?.toString() ?? "0",
                            'activeListingsSeller'.tr,
                          ),
                          _buildSellerCount(
                            data.seller?.totalSell?.toString() ?? "0",
                            'successfulSales'.tr,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                /// LOCATION TELEMETRY
                Container(
                  margin: EdgeInsets.only(bottom: 30.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xff111111),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'locationTelemetry'.tr,
                            color: Colors.white38,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          CustomText(
                            text:
                                data.location?.toUpperCase() ??
                                'unknownLocation'.tr,
                            color: Colors.white70,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      /// Styled map placeholder
                      Container(
                        height: 180.h,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child:
                            data.location != null && data.location!.isNotEmpty
                            ? MarketplaceMap(location: data.location!)
                            : Stack(
                                children: [
                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: MapWireframePainter(),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      width: 14.w,
                                      height: 14.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.yellow,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.yellow.withValues(
                                              alpha: 0.5,
                                            ),
                                            blurRadius: 10,
                                            spreadRadius: 3,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 12.h,
                                    left: 12.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        CustomText(
                                          text: "LAT 48.7826 N",
                                          color: AppColors.yellow,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        CustomText(
                                          text: "LON 9.1853 E",
                                          color: AppColors.yellow,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        bottomNavigationBar: const CustomNavBar(currentIndex: 3),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: CustomText(
        text: title,
        color: AppColors.yellow,
        fontSize: 9,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildMetricCol(String value, String label) {
    return Column(
      children: [
        CustomText(
          text: value,
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: label,
          color: Colors.white38,
          fontSize: 8,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ],
    );
  }

  Widget _buildSellerCount(String count, String label) {
    return Column(
      children: [
        CustomText(
          text: count,
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: label,
          color: Colors.white38,
          fontSize: 8,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ],
    );
  }
}

class MapWireframePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw some contour grid lines
    for (int i = 0; i < size.width; i += 30) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }
    for (int j = 0; j < size.height; j += 30) {
      canvas.drawLine(
        Offset(0, j.toDouble()),
        Offset(size.width, j.toDouble()),
        paint,
      );
    }

    // Draw some wireframe road paths
    final path = Path()
      ..moveTo(0, size.height * 0.2)
      ..quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.1,
        size.width * 0.5,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.9,
        size.width,
        size.height * 0.7,
      );

    final path2 = Path()
      ..moveTo(size.width * 0.2, size.height)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.4,
        size.width * 0.5,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.6,
        size.height * 0.6,
        size.width * 0.8,
        0,
      );

    canvas.drawPath(path, roadPaint);
    canvas.drawPath(path2, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

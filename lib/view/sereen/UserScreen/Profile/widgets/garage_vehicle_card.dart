import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import 'package:get/get.dart';

import '../model/profile_model.dart';
import '../controller/profile_controller.dart';
import '../Screen/edit_vehicle_screen.dart';
import '../../../../components/custom_button/custom_button.dart';

class GarageVehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  const GarageVehicleCard({
    required this.vehicle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Vehicle Image
          Stack(
            children: [
              Image.network(
                vehicle.vehicleImage ?? "",
                height: 170.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 170.h,
                  color: const Color(0xff222222),
                  child: const Center(
                    child: Icon(
                      Icons.directions_car_outlined,
                      color: Colors.white24,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    color: const Color(0xff1c1c1c),
                    onSelected: (value) {
                      if (value == 'edit') {
                        Get.to(() => EditVehicleScreen(vehicle: vehicle));
                      } else if (value == 'delete') {
                        _showDeleteConfirmDialog(context);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text("edit".tr, style: TextStyle(color: Colors.white)),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text("delete".tr, style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// Description & Stats
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header specs: Category and Version Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: (vehicle.brand ?? "unknownBrand".tr).toUpperCase(),
                            color: AppColors.yellow,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 4.h),
                          CustomText(
                            text: (vehicle.vehicleName ?? "unknownVehicle".tr).toUpperCase(),
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff1c1c1c),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: CustomText(
                        text: vehicle.year ?? "N/A",
                        color: Colors.white60,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(height: 1, color: Colors.white10),
                SizedBox(height: 16.h),

                /// Technical Specs Matrix
                Row(
                  children: [
                    _buildSpecCol("model".tr.toUpperCase(), vehicle.model ?? "N/A"),
                    _buildVerticalDivider(),
                    _buildSpecCol(
                      "hp".tr.toUpperCase(),
                      (vehicle.hp != null && vehicle.hp!.isNotEmpty) ? "${vehicle.hp} HP" : "N/A",
                    ),
                    _buildVerticalDivider(),
                    _buildSpecCol(
                      "engineType".tr.toUpperCase(),
                      vehicle.engineType ?? "N/A",
                      isYellowValue: true,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    _buildSpecCol("plateNumber".tr.toUpperCase(), vehicle.numberPlate ?? "N/A"),
                    _buildVerticalDivider(),
                    const Expanded(child: SizedBox.shrink()),
                    _buildVerticalDivider(),
                    const Expanded(child: SizedBox.shrink()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecCol(
    String label,
    String value, {
    bool isYellowValue = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            color: Colors.white38,
            fontSize: 8,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: value,
            color: isYellowValue ? AppColors.yellow : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 24.h,
      color: Colors.white10,
      margin: EdgeInsets.symmetric(horizontal: 12.w),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff181818),
          title: Text(
            "deleteVehicle".tr,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            "deleteVehicleConfirm".tr,
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("cancel".tr, style: const TextStyle(color: Colors.white54)),
            ),
            CustomButton(
              title: "delete".tr,
              height: 40.h,
              width: 100.w,
              onTap: () {
                Navigator.of(context).pop();
                if (vehicle.id != null) {
                  final ProfileScreenController profileController = Get.find<ProfileScreenController>();
                  profileController.deleteVehicle(vehicle.id!);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

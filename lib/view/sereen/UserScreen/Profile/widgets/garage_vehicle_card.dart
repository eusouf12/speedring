import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';

class GarageVehicleCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;
  final String version;
  final String power;
  final String weight;
  final String displacement;
  final String driveType;
  final String propulsion;

  const GarageVehicleCard({
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.version,
    required this.power,
    required this.weight,
    required this.displacement,
    required this.driveType,
    required this.propulsion,
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
          Image.network(
            imageUrl,
            height: 170.h,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 170.h,
              color: const Color(0xff222222),
              child: const Center(
                child: Icon(Icons.directions_car_outlined, color: Colors.white24, size: 40),
              ),
            ),
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
                            text: category.toUpperCase(),
                            color: AppColors.yellow,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 4.h),
                          CustomText(
                            text: title.toUpperCase(),
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
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: const Color(0xff1c1c1c),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: CustomText(
                        text: version,
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
                    _buildSpecCol("POWER", power),
                    _buildVerticalDivider(),
                    _buildSpecCol("WEIGHT", weight),
                    _buildVerticalDivider(),
                    _buildSpecCol("DISPLACEMENT", displacement),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    _buildSpecCol("DRIVE TYPE", driveType),
                    _buildVerticalDivider(),
                    _buildSpecCol("PROPULSION", propulsion, isYellowValue: true),
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

  Widget _buildSpecCol(String label, String value, {bool isYellowValue = false}) {
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
}

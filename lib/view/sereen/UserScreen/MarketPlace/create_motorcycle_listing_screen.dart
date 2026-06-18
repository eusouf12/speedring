import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../BusinessScreen/BusinessHome/Controller/business_dashboard_controller.dart';

class CreateMotorcycleListingScreen extends StatefulWidget {
  const CreateMotorcycleListingScreen({super.key});

  @override
  State<CreateMotorcycleListingScreen> createState() => _CreateMotorcycleListingScreenState();
}

class _CreateMotorcycleListingScreenState extends State<CreateMotorcycleListingScreen> {
  final manufacturerController = TextEditingController(text: "Ducati");
  final modelController = TextEditingController(text: "Panigale V4 S");
  final productionYearController = TextEditingController(text: "2024");
  final priceController = TextEditingController(text: "32,000");
  final locationController = TextEditingController(text: "Bologna, Italy");

  final outputController = TextEditingController(text: "215");
  final displacementController = TextEditingController(text: "1103");

  String engineConfig = "Desmosedici Stradale 90° V4";

  @override
  void dispose() {
    manufacturerController.dispose();
    modelController.dispose();
    productionYearController.dispose();
    priceController.dispose();
    locationController.dispose();
    outputController.dispose();
    displacementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<BusinessDashboardController>()
        ? Get.find<BusinessDashboardController>()
        : Get.put(BusinessDashboardController());

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: const SizedBox.shrink(),
          title: const Text(
            "CREATE LISTING: MOTORCYCLES",
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: AppColors.yellow),
              onPressed: () => Get.back(),
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 01 / BASIC IDENTIFICATION
              _buildPhaseHeader("01 / BASIC IDENTIFICATION"),
              _buildSectionCard([
                _buildFieldLabel("MANUFACTURER / BRAND"),
                _buildOutlineIconField(manufacturerController, Icons.motorcycle_outlined, "e.g. Ducati"),
                SizedBox(height: 14.h),
                _buildFieldLabel("MODEL NAME"),
                _buildOutlineField(modelController, "e.g. Panigale V4 S"),
                SizedBox(height: 14.h),
                _buildFieldLabel("PRODUCTION YEAR"),
                _buildOutlineIconField(productionYearController, Icons.calendar_today_outlined, "2024", keyboardType: TextInputType.number),
                SizedBox(height: 14.h),
                _buildFieldLabel("ASKING PRICE (USD)"),
                _buildOutlineIconField(priceController, Icons.payments_outlined, "32,000", keyboardType: TextInputType.number),
                SizedBox(height: 14.h),
                _buildFieldLabel("VEHICLE LOCATION"),
                _buildOutlineIconField(locationController, Icons.location_on_outlined, "City, State, Country"),
              ]),
              SizedBox(height: 24.h),

              // 02 / PERFORMANCE METRICS
              _buildPhaseHeader("02 / PERFORMANCE METRICS"),
              _buildSectionCard([
                _buildFieldLabel("ENGINE CONFIG"),
                _buildDropdownField(
                  selectedValue: engineConfig,
                  items: [
                    "Desmosedici Stradale 90° V4",
                    "Twin-Cylinder L-Twin",
                    "Inline-Four crossplane",
                    "Parallel-Twin Liquid-Cooled",
                  ],
                  icon: Icons.settings_outlined,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        engineConfig = val;
                      });
                    }
                  },
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel("MAX OUTPUT (HP)"),
                _buildOutlineIconField(outputController, Icons.bolt_outlined, "215", keyboardType: TextInputType.number),
                SizedBox(height: 14.h),
                _buildFieldLabel("DISPLACEMENT (CC)"),
                _buildOutlineIconField(displacementController, Icons.speed_outlined, "1103", keyboardType: TextInputType.number),
              ]),
              SizedBox(height: 24.h),

              // 03 / MEDIA ASSETS
              _buildPhaseHeader("03 / MEDIA ASSETS"),
              _buildSectionCard([
                // Main View Image upload box
                Container(
                  height: 140.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Stack(
                    children: [
                      // motorcycle image preview faded
                      Opacity(
                        opacity: 0.4,
                        child: Image.network(
                          "https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800&fit=crop",
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(color: Colors.black),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_a_photo_outlined, color: AppColors.yellow, size: 24),
                            SizedBox(height: 6.h),
                            CustomText(
                              text: "MAIN VIEW",
                              color: Colors.white60,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),

                // Sub views
                Row(
                  children: [
                    Expanded(child: _buildSmallUploadTile()),
                    SizedBox(width: 10.w),
                    Expanded(child: _buildSmallUploadTile()),
                  ],
                ),
              ]),
              SizedBox(height: 32.h),

              // Bottom Actions
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cancel_outlined, color: Colors.white60, size: 16),
                          SizedBox(width: 6.w),
                          CustomText(
                            text: "CANCEL",
                            color: Colors.white60,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    flex: 3,
                    child: CustomButton(
                      height: 44.h,
                      title: "PUBLISH LISTING",
                      fontSize: 11.sp,
                      fillColor: AppColors.yellow,
                      textColor: Colors.black,
                      borderRadius: 8.r,
                      isImageRight: true,
                      icon: const Icon(Icons.publish_rounded, color: Colors.black, size: 16),
                      onTap: () {
                        // Publish item to controller list
                        String title = "${productionYearController.text} ${manufacturerController.text} ${modelController.text}".trim();
                        if (title.trim().isEmpty) title = "2024 DUCATI PANIGALE V4 S";
                        String price = priceController.text.trim();
                        if (!price.startsWith(r"$")) price = r"$" + price;

                        controller.rxAssets.insert(0, AssetModel(
                          id: (controller.rxAssets.length + 1).toString(),
                          title: title.toUpperCase(),
                          status: "LIVE",
                          code: "YA-DUC-PANV4",
                          type: "MOTORCYCLES",
                          price: price,
                          views: "0",
                          leads: "0",
                          shipping: "YES",
                          imageUrl: "https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800&fit=crop",
                          description: "Desmosedici Stradale performance superbike. Ready for track utilization.",
                          power: "${outputController.text} HP",
                          torque: "112 NM",
                          zeroToSixty: "2.9 SEC",
                          engineConfig: engineConfig,
                          transmission: "6-Speed Quickshift",
                          drivetrain: "RWD",
                        ));

                        Get.back(); // Pop listing screen
                        Get.back(); // Pop Selector Screen

                        Get.snackbar(
                          "Asset Published",
                          "Superbike added to active inventory list.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xff181818),
                          colorText: Colors.white,
                          borderColor: AppColors.yellow,
                          borderWidth: 1,
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: title,
        color: AppColors.yellow,
        fontSize: 9.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: label,
        color: Colors.white38,
        fontSize: 9.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildOutlineField(TextEditingController textController, String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff0d0d0d),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: TextFormField(
        controller: textController,
        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 13, fontWeight: FontWeight.bold),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildOutlineIconField(TextEditingController textController, IconData icon, String hint, {TextInputType? keyboardType}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff0d0d0d),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 16),
          SizedBox(width: 8.w),
          Expanded(
            child: TextFormField(
              controller: textController,
              keyboardType: keyboardType,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white24, fontSize: 13, fontWeight: FontWeight.bold),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String selectedValue,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff0d0d0d),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 16),
          SizedBox(width: 10.w),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: items.contains(selectedValue) ? selectedValue : items.first,
                dropdownColor: const Color(0xff111111),
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white60),
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                items: items.map((val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallUploadTile() {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: Colors.white10, style: BorderStyle.solid),
      ),
      child: const Center(
        child: Icon(Icons.add, color: Colors.white24, size: 20),
      ),
    );
  }
}

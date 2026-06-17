import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import 'business_dashboard_controller.dart';

class ConfigureAssetScreen extends StatefulWidget {
  const ConfigureAssetScreen({super.key});

  @override
  State<ConfigureAssetScreen> createState() => _ConfigureAssetScreenState();
}

class _ConfigureAssetScreenState extends State<ConfigureAssetScreen> {
  final manufacturerController = TextEditingController();
  final modelController = TextEditingController();
  final productionYearController = TextEditingController();
  final priceController = TextEditingController();
  final locationController = TextEditingController();
  final aeroController = TextEditingController();

  String selectedEngine = "NATURALLY ASPIRATED FLAT-6";
  bool isPdkSelected = true; // PDK vs Manual
  String selectedDrivetrain = "RWD"; // RWD, AWD, FWD

  @override
  void dispose() {
    manufacturerController.dispose();
    modelController.dispose();
    productionYearController.dispose();
    priceController.dispose();
    locationController.dispose();
    aeroController.dispose();
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "CONFIGURE ASSET",
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phase 01: Core Specifications
              _buildSectionHeader("PHASE 01: CORE SPECIFICATIONS"),
              _buildCardContainer([
                _buildFieldLabel("MANUFACTURER"),
                _buildWhiteTextField(manufacturerController, "E.G. PORSCHE"),
                SizedBox(height: 14.h),
                _buildFieldLabel("MODEL DESIGNATION"),
                _buildWhiteTextField(modelController, "E.G. 911 GT3 RS"),
                SizedBox(height: 14.h),
                _buildFieldLabel("PRODUCTION YEAR"),
                _buildWhiteTextField(productionYearController, "2024", keyboardType: TextInputType.number),
                SizedBox(height: 14.h),
                _buildFieldLabel("ASKING PRICE [USD]"),
                _buildWhitePriceField(priceController, "0.00"),
                SizedBox(height: 14.h),
                _buildFieldLabel("VEHICLE LOCATION"),
                _buildWhiteLocationField(locationController, "CITY, COUNTRY"),
              ]),
              SizedBox(height: 24.h),

              // Phase 02: Telemetry & Metrics
              _buildSectionHeader("PHASE 02: TELEMETRY & METRICS"),
              _buildCardContainer([
                Row(
                  children: [
                    Expanded(child: _buildMetricTile("POWER OUTPUT", "525", "HP")),
                    SizedBox(width: 12.w),
                    Expanded(child: _buildMetricTile("PEAK TORQUE", "465", "NM")),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(child: _buildMetricTile("CURB WEIGHT", "1450", "KG")),
                    SizedBox(width: 12.w),
                    Expanded(child: _buildMetricTile("0-100 KM/H", "3.2", "S")),
                  ],
                ),
                SizedBox(height: 12.h),
                _buildMetricTile("TOP SPEED", "296", "KM/H"),
              ]),
              SizedBox(height: 24.h),

              // Phase 03: Engineering Dossier
              _buildSectionHeader("PHASE 03: ENGINEERING DOSSIER"),
              _buildCardContainer([
                _buildFieldLabel("ENGINE CONFIGURATION"),
                _buildDropdownDirect(
                  selectedValue: selectedEngine,
                  items: ["NATURALLY ASPIRATED FLAT-6", "TWIN-TURBO FLAT-6", "998CC V4", "N/A"],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedEngine = val;
                      });
                    }
                  },
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel("TRANSMISSION SYSTEM"),
                Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isPdkSelected = true),
                          child: Container(
                            height: 36.h,
                            decoration: BoxDecoration(
                              color: isPdkSelected ? AppColors.yellow : Colors.transparent,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Center(
                              child: Text(
                                "PDK / DUAL-CLUTCH",
                                style: TextStyle(
                                  color: isPdkSelected ? Colors.black : Colors.white60,
                                  fontSize: 8.5.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isPdkSelected = false),
                          child: Container(
                            height: 36.h,
                            decoration: BoxDecoration(
                              color: !isPdkSelected ? AppColors.yellow : Colors.transparent,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Center(
                              child: Text(
                                "MANUAL / SEQUENTIAL",
                                style: TextStyle(
                                  color: !isPdkSelected ? Colors.black : Colors.white60,
                                  fontSize: 8.5.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel("DRIVETRAIN LAYOUT"),
                Row(
                  children: [
                    Expanded(child: _buildDrivetrainButton("RWD")),
                    SizedBox(width: 8.w),
                    Expanded(child: _buildDrivetrainButton("AWD")),
                    SizedBox(width: 8.w),
                    Expanded(child: _buildDrivetrainButton("FWD")),
                  ],
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel("AERO / BODY PACKAGE"),
                _buildAeroTextArea(),
              ]),
              SizedBox(height: 32.h),

              // Actions
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
                      title: "PUBLISH ASSET",
                      fontSize: 11.sp,
                      fillColor: AppColors.yellow,
                      textColor: Colors.black,
                      borderRadius: 8.r,
                      isImageRight: true,
                      icon: const Icon(Icons.cloud_upload_outlined, color: Colors.black, size: 16),
                      onTap: () {
                        // Gather values and add to active inventory controller
                        String newTitle = "${productionYearController.text} ${manufacturerController.text} ${modelController.text}".trim();
                        if (newTitle.trim().isEmpty) newTitle = "2024 PORSCHE 911 GT3 RS";
                        String newPrice = priceController.text.trim();
                        if (newPrice.isEmpty) newPrice = "284,500";
                        if (!newPrice.startsWith(r"$")) newPrice = r"$" + newPrice;

                        // Mock addition
                        controller.rxAssets.insert(0, AssetModel(
                          id: (controller.rxAssets.length + 1).toString(),
                          title: newTitle.toUpperCase(),
                          status: "LIVE",
                          code: "SR-992-GT3",
                          type: "VEHICLES",
                          price: newPrice,
                          views: "0",
                          leads: "0",
                          shipping: "YES",
                          imageUrl: "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=800&fit=crop",
                          description: aeroController.text.isEmpty
                              ? "High-performance track variant with Weissach package and carbon ceramic brakes."
                              : aeroController.text,
                          power: "525 HP",
                          torque: "465 NM",
                          zeroToSixty: "3.2 SEC",
                          engineConfig: selectedEngine,
                          transmission: isPdkSelected ? "7-Speed PDK" : "6-Speed Manual",
                          drivetrain: selectedDrivetrain,
                        ));

                        // Clear navigation stack
                        Get.back(); // Pop Configure Screen
                        Get.back(); // Pop Create Listing Screen
                        Get.back(); // Pop Category selector Screen

                        Get.snackbar(
                          "Asset Published",
                          "High-Performance Vehicle added to active inventory list.",
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

  Widget _buildSectionHeader(String title) {
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

  Widget _buildCardContainer(List<Widget> children) {
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

  Widget _buildWhiteTextField(TextEditingController textController, String hint, {TextInputType? keyboardType}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextFormField(
        controller: textController,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 13, fontWeight: FontWeight.bold),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildWhitePriceField(TextEditingController textController, String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          const Text("\$ ", style: TextStyle(color: AppColors.yellow, fontSize: 13, fontWeight: FontWeight.bold)),
          Expanded(
            child: TextFormField(
              controller: textController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.black38, fontSize: 13, fontWeight: FontWeight.bold),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhiteLocationField(TextEditingController textController, String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, color: Colors.black38, size: 16),
          SizedBox(width: 8.w),
          Expanded(
            child: TextFormField(
              controller: textController,
              style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.black38, fontSize: 13, fontWeight: FontWeight.bold),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, String unit) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            color: Colors.white38,
            fontSize: 7.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
          SizedBox(height: 6.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              CustomText(
                text: value,
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
              SizedBox(width: 4.w),
              CustomText(
                text: unit,
                color: Colors.white38,
                fontSize: 8.sp,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownDirect({
    required String selectedValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(selectedValue) ? selectedValue : items.first,
          dropdownColor: Colors.black,
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
    );
  }

  Widget _buildDrivetrainButton(String label) {
    final bool isSelected = selectedDrivetrain == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDrivetrain = label;
        });
      },
      child: Container(
        height: 36.h,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.yellow : Colors.white10,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Center(
          child: CustomText(
            text: label,
            color: isSelected ? AppColors.yellow : Colors.white60,
            fontSize: 9.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAeroTextArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: TextFormField(
        controller: aeroController,
        maxLines: 3,
        style: const TextStyle(color: Colors.white, fontSize: 12),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "ENTER AERODYNAMIC SPECIFICATIONS...",
          hintStyle: TextStyle(color: Colors.white24, fontSize: 12),
          isDense: true,
        ),
      ),
    );
  }
}

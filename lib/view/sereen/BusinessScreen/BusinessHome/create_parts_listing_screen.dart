import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import 'Controller/business_dashboard_controller.dart';

class CreatePartsListingScreen extends StatefulWidget {
  const CreatePartsListingScreen({super.key});

  @override
  State<CreatePartsListingScreen> createState() => _CreatePartsListingScreenState();
}

class _CreatePartsListingScreenState extends State<CreatePartsListingScreen> {
  final partNameController = TextEditingController(text: "Brembo GTR Racing Calipers");
  final priceController = TextEditingController(text: "8,500");
  final skuController = TextEditingController(text: "BR-GTR-CAL-04");
  
  final makeController = TextEditingController(text: "Porsche");
  final modelController = TextEditingController(text: "911 GT3 / Cup");
  final yearRangeController = TextEditingController(text: "2020 - 2025");

  final weightController = TextEditingController(text: "3.2 kg");
  final materialController = TextEditingController(text: "Billet Aluminum");
  final toleranceController = TextEditingController(text: "±0.01 mm");
  final ratingController = TextEditingController(text: "Track Certified");

  String partCategory = "Brakes";

  @override
  void dispose() {
    partNameController.dispose();
    priceController.dispose();
    skuController.dispose();
    makeController.dispose();
    modelController.dispose();
    yearRangeController.dispose();
    weightController.dispose();
    materialController.dispose();
    toleranceController.dispose();
    ratingController.dispose();
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
            "CREATE LISTING: PARTS",
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
              // 01 / IDENTIFICATION
              _buildPhaseHeader("01 / IDENTIFICATION"),
              _buildSectionCard([
                _buildFieldLabel("PART CATEGORY"),
                _buildDropdownField(
                  selectedValue: partCategory,
                  items: [
                    "Brakes",
                    "Suspension",
                    "Engine Components",
                    "Transmission & Clutch",
                    "Exhaust Systems",
                    "Aero & Bodywork",
                    "Wheels & Tires",
                    "Electronics & ECU",
                    "Other",
                  ],
                  icon: Icons.category_outlined,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        partCategory = val;
                      });
                    }
                  },
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel("PART NAME / DESIGNATION"),
                _buildOutlineField(partNameController, "e.g. Brembo GTR Racing Calipers"),
                SizedBox(height: 14.h),
                _buildFieldLabel("ASKING PRICE (USD)"),
                _buildOutlineIconField(priceController, Icons.payments_outlined, "8,500", keyboardType: TextInputType.number),
                SizedBox(height: 14.h),
                _buildFieldLabel("SKU / SERIAL NUMBER"),
                _buildOutlineIconField(
                  skuController,
                  Icons.qr_code_scanner_outlined,
                  "e.g. BR-GTR-CAL-04",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.qr_code_scanner, color: AppColors.yellow, size: 20),
                    onPressed: () {
                      Get.snackbar(
                        "Scanner Active",
                        "Camera interface initialized for barcode scan.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xff181818),
                        colorText: Colors.white,
                        borderColor: AppColors.yellow,
                        borderWidth: 1,
                      );
                    },
                  ),
                ),
              ]),
              SizedBox(height: 24.h),

              // 02 / COMPATIBILITY & SPECIFICATIONS
              _buildPhaseHeader("02 / COMPATIBILITY & SPECIFICATIONS"),
              _buildSectionCard([
                _buildFieldLabel("COMPATIBLE MAKE"),
                _buildOutlineField(makeController, "e.g. Porsche"),
                SizedBox(height: 14.h),
                _buildFieldLabel("COMPATIBLE MODEL(S)"),
                _buildOutlineField(modelController, "e.g. 911 GT3 / Cup"),
                SizedBox(height: 14.h),
                _buildFieldLabel("MODEL YEAR RANGE"),
                _buildOutlineIconField(yearRangeController, Icons.calendar_today_outlined, "e.g. 2020 - 2025"),
                SizedBox(height: 18.h),
                
                // Specifications metrics in yellow font
                const Divider(color: Colors.white10),
                SizedBox(height: 10.h),
                CustomText(
                  text: "ENGINEERING SPECIFICATION METRICS",
                  color: Colors.white70,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 12.h),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("WEIGHT"),
                          _buildYellowOutlineField(weightController, "3.2 kg"),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("MATERIAL"),
                          _buildYellowOutlineField(materialController, "Billet Aluminum"),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("TOLERANCE"),
                          _buildYellowOutlineField(toleranceController, "±0.01 mm"),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel("RATING / CERTIFICATE"),
                          _buildYellowOutlineField(ratingController, "Track Certified"),
                        ],
                      ),
                    ),
                  ],
                ),
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
                      // part image preview faded
                      Opacity(
                        opacity: 0.4,
                        child: Image.network(
                          "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800&fit=crop",
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
                              text: "PRIMARY PART VIEW",
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

                // Sub views grid/row
                Row(
                  children: [
                    Expanded(child: _buildSmallUploadTile("SIDE VIEW")),
                    SizedBox(width: 8.w),
                    Expanded(child: _buildSmallUploadTile("DETAIL / SEAL")),
                    SizedBox(width: 8.w),
                    Expanded(child: _buildSmallUploadTile("SCHEMATIC")),
                    SizedBox(width: 8.w),
                    Expanded(child: _buildSmallUploadTile("BOX / ACCESS.")),
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
                        String title = partNameController.text.trim();
                        if (title.isEmpty) title = "Brembo GTR Racing Calipers";
                        String price = priceController.text.trim();
                        if (!price.startsWith(r"$")) price = r"$" + price;

                        controller.rxAssets.insert(0, AssetModel(
                          id: (controller.rxAssets.length + 1).toString(),
                          title: title.toUpperCase(),
                          status: "LIVE",
                          code: skuController.text.isEmpty ? "BR-GTR-CAL-04" : skuController.text,
                          type: "PARTS",
                          price: price,
                          views: "0",
                          leads: "0",
                          shipping: "YES",
                          imageUrl: "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=800&fit=crop",
                          description: "High performance ${partCategory.toLowerCase()} for ${makeController.text} ${modelController.text} (${yearRangeController.text}). Specs: Weight ${weightController.text}, Material ${materialController.text}.",
                          power: "N/A",
                          torque: "N/A",
                          zeroToSixty: "N/A",
                          engineConfig: "N/A",
                          transmission: "N/A",
                          drivetrain: "N/A",
                        ));

                        Get.back(); // Pop listing screen
                        Get.back(); // Pop Selector Screen

                        Get.snackbar(
                          "Asset Published",
                          "Performance part added to active inventory list.",
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
        textAlign: TextAlign.start,
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
        textAlign: TextAlign.start,
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

  Widget _buildOutlineIconField(TextEditingController textController, IconData icon, String hint, {TextInputType? keyboardType, Widget? suffixIcon}) {
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
          ?suffixIcon,
        ],
      ),
    );
  }

  Widget _buildYellowOutlineField(TextEditingController textController, String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff0d0d0d),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.yellow.withValues(alpha: 0.3)),
      ),
      child: TextFormField(
        controller: textController,
        style: const TextStyle(color: AppColors.yellow, fontSize: 13, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.yellow.withValues(alpha: 0.4), fontSize: 13, fontWeight: FontWeight.bold),
          isDense: true,
        ),
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

  Widget _buildSmallUploadTile(String label) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.upload_file_outlined, color: Colors.white24, size: 16),
          SizedBox(height: 4.h),
          CustomText(
            text: label,
            color: Colors.white38,
            fontSize: 7.sp,
            fontWeight: FontWeight.bold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

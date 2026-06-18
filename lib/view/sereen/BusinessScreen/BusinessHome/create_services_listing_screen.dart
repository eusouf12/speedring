import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import 'Controller/business_dashboard_controller.dart';

class CreateServicesListingScreen extends StatefulWidget {
  const CreateServicesListingScreen({super.key});

  @override
  State<CreateServicesListingScreen> createState() => _CreateServicesListingScreenState();
}

class _CreateServicesListingScreenState extends State<CreateServicesListingScreen> {
  final serviceNameController = TextEditingController(text: "Pro Coaching & ECU Calibration");
  final providerController = TextEditingController(text: "SpeedRing Performance");
  final priceController = TextEditingController(text: "1,200 / Day");
  
  final turnaroundController = TextEditingController(text: "Booking required 7 days prior");
  final scopeController = TextEditingController(
    text: "Complete 1-on-1 trackside coaching with comprehensive telemetry analysis and custom ECU maps tailored to track conditions."
  );

  String locationCoverage = "Trackside / On-site";
  int characterCount = 0;

  @override
  void initState() {
    super.initState();
    characterCount = scopeController.text.length;
  }

  @override
  void dispose() {
    serviceNameController.dispose();
    providerController.dispose();
    priceController.dispose();
    turnaroundController.dispose();
    scopeController.dispose();
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
            "CREATE LISTING: SERVICES",
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
              // 01 / SERVICE DEFINITION
              _buildPhaseHeader("01 / SERVICE DEFINITION"),
              _buildSectionCard([
                _buildFieldLabel("NOMENCLATURE / SERVICE NAME"),
                _buildOutlineField(serviceNameController, "e.g. Pro Coaching & ECU Calibration"),
                SizedBox(height: 14.h),
                _buildFieldLabel("PROVIDER / WORKSHOP NAME"),
                _buildOutlineField(providerController, "e.g. SpeedRing Performance"),
                SizedBox(height: 14.h),
                _buildFieldLabel("VALUATION (USD)"),
                _buildOutlineIconField(priceController, Icons.payments_outlined, "e.g. 1,200 / Day"),
              ]),
              SizedBox(height: 24.h),

              // 02 / OPERATIONAL LOGISTICS
              _buildPhaseHeader("02 / OPERATIONAL LOGISTICS"),
              _buildSectionCard([
                _buildFieldLabel("LOCATION COVERAGE"),
                _buildDropdownField(
                  selectedValue: locationCoverage,
                  items: [
                    "Trackside / On-site",
                    "Global Remote",
                    "Regional Workshop",
                    "National Coverage",
                  ],
                  icon: Icons.map_outlined,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        locationCoverage = val;
                      });
                    }
                  },
                ),
                SizedBox(height: 14.h),
                _buildFieldLabel("TURNAROUND TIME / ACCESSIBILITY"),
                _buildOutlineIconField(turnaroundController, Icons.hourglass_bottom_outlined, "e.g. 2-3 business days"),
              ]),
              SizedBox(height: 24.h),

              // 03 / TECHNICAL PHILOSOPHY
              _buildPhaseHeader("03 / TECHNICAL PHILOSOPHY"),
              _buildSectionCard([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFieldLabel("SCOPE OF WORK"),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Text(
                        "$characterCount / 500 characters",
                        style: TextStyle(
                          color: characterCount > 500 ? Colors.red : Colors.white38,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                _buildScopeTextArea(),
                SizedBox(height: 16.h),
                _buildFieldLabel("TECHNICAL DOCUMENTATION / SCHEMATIC"),
                _buildDocumentationUploadTile(),
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
                        String title = serviceNameController.text.trim();
                        if (title.isEmpty) title = "Pro Coaching & ECU Calibration";
                        String price = priceController.text.trim();
                        if (!price.startsWith(r"$") && !price.contains("/ ")) {
                          price = r"$" + price;
                        }

                        controller.rxAssets.insert(0, AssetModel(
                          id: (controller.rxAssets.length + 1).toString(),
                          title: title.toUpperCase(),
                          status: "LIVE",
                          code: "SR-SRV-ECU",
                          type: "SERVICES",
                          price: price,
                          views: "0",
                          leads: "0",
                          shipping: "NO",
                          imageUrl: "https://images.unsplash.com/photo-1517524206127-48bbd363f3d7?w=800&fit=crop",
                          description: "${scopeController.text}\nCoverage: $locationCoverage. Provider: ${providerController.text}.",
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
                          "Expert service added to active inventory list.",
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

  Widget _buildScopeTextArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xff0d0d0d),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: TextFormField(
        controller: scopeController,
        maxLines: 4,
        style: const TextStyle(color: Colors.white, fontSize: 12),
        onChanged: (text) {
          setState(() {
            characterCount = text.length;
          });
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "DESCRIBE SERVICE SCOPE, EQUIPMENT USED, AND PROCEDURES...",
          hintStyle: TextStyle(color: Colors.white24, fontSize: 12),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildDocumentationUploadTile() {
    return Container(
      height: 100.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.upload_file_outlined, color: AppColors.yellow, size: 28),
            SizedBox(height: 8.h),
            CustomText(
              text: "UPLOAD SCHEMATIC / TECHNICAL DOCS (PDF)",
              color: Colors.white60,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}

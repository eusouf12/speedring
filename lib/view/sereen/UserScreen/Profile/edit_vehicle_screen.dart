import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../../utils/app_colors/app_colors.dart';

class EditVehicleScreen extends StatefulWidget {
  const EditVehicleScreen({super.key});

  @override
  State<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  String selectedPropulsion = "COMBUSTION";
  String selectedDriveType = "RWD";
  String selectedYear = "2024";

  final TextEditingController _modelController = TextEditingController(text: "PORSCHE 911 GT3 RS (992)");
  final TextEditingController _manufacturerController = TextEditingController(text: "PORSCHE");
  final TextEditingController _designationController = TextEditingController(text: "911 GT3 RS");
  final TextEditingController _plateController = TextEditingController(text: "911 GT3 RS");

  final TextEditingController _hpController = TextEditingController(text: "525");
  final TextEditingController _weightController = TextEditingController(text: "1435");
  final TextEditingController _displacementController = TextEditingController(text: "3996");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "EDIT VEHICLE",
          style: TextStyle(
            color: AppColors.yellow,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.yellow, width: 1.5),
                  image: const DecorationImage(
                    image: NetworkImage("https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=100&fit=crop"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Media Uploader Card
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 160.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white10),
                  image: const DecorationImage(
                    image: NetworkImage("https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=500&fit=crop"),
                    fit: BoxFit.cover,
                    opacity: 0.6,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_a_photo_outlined, color: AppColors.yellow, size: 28),
                    SizedBox(height: 8.h),
                    CustomText(
                      text: "CHANGE VEHICLE MEDIA",
                      color: AppColors.yellow,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            /// PHASE 01 // IDENTITY
            _buildSectionHeader("PHASE 01 // IDENTITY"),
            _buildCardContainer([
              _buildFieldLabel("MODEL NAME"),
              _buildTextField(_modelController),
              SizedBox(height: 16.h),
              _buildFieldLabel("MANUFACTURER"),
              _buildTextField(_manufacturerController),
              SizedBox(height: 16.h),
              _buildFieldLabel("MODEL DESIGNATION"),
              _buildTextField(_designationController),
              SizedBox(height: 16.h),
              _buildFieldLabel("NUMBER PLATE"),
              _buildTextField(_plateController),
              SizedBox(height: 16.h),
              _buildFieldLabel("PRODUCTION YEAR"),
              _buildDropdown(["2024", "2023", "2022", "2021", "2020"]),
            ]),
            SizedBox(height: 20.h),

            /// TRIM / CONFIGURATION (Section divider)
            const CustomText(
              text: "TRIM / CONFIGURATION",
              color: Colors.white38,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            SizedBox(height: 12.h),

            /// PHASE 02 // TELEMETRY DATA
            _buildSectionHeader("PHASE 02 // TELEMETRY DATA"),
            _buildCardContainer([
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 2.0,
                children: [
                  _buildTelemetryField("HORSEPOWER (HP)", _hpController),
                  _buildTelemetryField("WEIGHT (KG)", _weightController),
                  _buildTelemetryField("DISPLACEMENT (CC)", _displacementController),
                  _buildTelemetryDropdown("DRIVE TYPE", ["RWD", "AWD", "FWD"]),
                ],
              ),
            ]),
            SizedBox(height: 24.h),

            /// PROPULSION SYSTEM
            _buildSectionHeader("PROPULSION SYSTEM"),
            Row(
              children: [
                Expanded(child: _buildPropulsionButton("COMBUSTION")),
                SizedBox(width: 8.w),
                Expanded(child: _buildPropulsionButton("ELECTRIC")),
                SizedBox(width: 8.w),
                Expanded(child: _buildPropulsionButton("HYBRID")),
              ],
            ),
            SizedBox(height: 32.h),

            /// Save button
            CustomButton(
              height: 50.h,
              title: "SAVE CHANGES",
              fontSize: 13,
              borderRadius: 8.r,
              onTap: () {
                Get.back();
                Get.snackbar(
                  "Vehicle Updated",
                  "The vehicle configuration changes have been saved to your stable.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xff181818),
                  colorText: Colors.white,
                  borderColor: AppColors.yellow,
                  borderWidth: 1,
                );
              },
              isImageRight: true,
              icon: const Icon(Icons.chevron_right, color: Colors.black, size: 18),
            ),
            SizedBox(height: 20.h),
          ],
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
        fontSize: 9,
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
        fontSize: 9,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildDropdown(List<String> items) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedYear,
          dropdownColor: const Color(0xff1d1d1d),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white60),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          items: items.map((val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) {
              setState(() {
                selectedYear = v;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildTelemetryField(String label, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xff181818),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            color: Colors.white38,
            fontSize: 7.5,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryDropdown(String label, List<String> items) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xff181818),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            color: Colors.white38,
            fontSize: 7.5,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedDriveType,
                dropdownColor: const Color(0xff181818),
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white60, size: 14),
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                items: items.map((val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() {
                      selectedDriveType = v;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropulsionButton(String label) {
    final bool isSelected = selectedPropulsion == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPropulsion = label;
        });
      },
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.yellow : const Color(0xff111111),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: isSelected ? AppColors.yellow : Colors.white10),
        ),
        child: Center(
          child: CustomText(
            text: label,
            color: isSelected ? Colors.black : Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

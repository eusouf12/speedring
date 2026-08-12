import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../../../components/custom_button/custom_button.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import 'dart:io';
import '../../../../../utils/ToastMsg/toast_message.dart';
import '../controller/profile_controller.dart';
import '../model/profile_model.dart';
import 'package:image_picker/image_picker.dart';

class EditVehicleScreen extends StatefulWidget {
  const EditVehicleScreen({super.key});

  @override
  State<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  final ProfileScreenController profileController =
      Get.find<ProfileScreenController>();
  late final Vehicle vehicle;

  late String selectedPropulsion;

  late final TextEditingController vehicleNameCtrl;
  late final TextEditingController brandCtrl;
  late final TextEditingController modelCtrl;
  late final TextEditingController numberPlateCtrl;
  late final TextEditingController yearCtrl;
  late final TextEditingController hpCtrl;

  File? selectedImage;

  @override
  void initState() {
    super.initState();
    vehicle = Get.arguments as Vehicle;
    selectedPropulsion = vehicle.engineType ?? "Combustion";
    vehicleNameCtrl = TextEditingController(text: vehicle.vehicleName);
    brandCtrl = TextEditingController(text: vehicle.brand);
    modelCtrl = TextEditingController(text: vehicle.model);
    numberPlateCtrl = TextEditingController(text: vehicle.numberPlate);
    yearCtrl = TextEditingController(text: vehicle.year);
    hpCtrl = TextEditingController(text: vehicle.hp);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void _updateVehicle() async {
    if (vehicleNameCtrl.text.isEmpty ||
        brandCtrl.text.isEmpty ||
        modelCtrl.text.isEmpty) {
      showCustomSnackBar(
        "Please fill in the required fields (Name, Brand, Model)",
        isError: true,
      );
      return;
    }

    final updatedVehicle = Vehicle(
      vehicleName: vehicleNameCtrl.text,
      brand: brandCtrl.text,
      model: modelCtrl.text,
      numberPlate: numberPlateCtrl.text,
      year: yearCtrl.text,
      hp: hpCtrl.text,
      engineType: selectedPropulsion,
      localImageFile: selectedImage,
    );

    if (vehicle.id == null) return;

    final success = await profileController.updateVehicle(
      vehicle.id!,
      updatedVehicle,
    );
    if (success) {
      Get.back();
    }
  }

  @override
  void dispose() {
    vehicleNameCtrl.dispose();
    brandCtrl.dispose();
    modelCtrl.dispose();
    numberPlateCtrl.dispose();
    yearCtrl.dispose();
    hpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomRoyelAppbar(
          leftIcon: true,
          titleName: "editVehicle".tr.toUpperCase(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Media Uploader Card
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 160.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xff111111),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.white10),
                    image: selectedImage != null
                        ? DecorationImage(
                            image: FileImage(selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: selectedImage == null && vehicle.vehicleImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_a_photo_outlined,
                              color: AppColors.yellow,
                              size: 28,
                            ),
                            SizedBox(height: 8.h),
                            CustomText(
                              text: "uploadPhoto".tr.toUpperCase(),
                              color: AppColors.yellow,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ],
                        )
                      : selectedImage == null && vehicle.vehicleImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.network(
                            vehicle.vehicleImage!,
                            width: double.infinity,
                            height: 160.h,
                            fit: BoxFit.cover,
                          ),
                        )
                      : null,
                ),
              ),
              SizedBox(height: 24.h),

              /// PHASE 01 // IDENTITY
              _buildSectionHeader("phase01Identity".tr),
              _buildCardContainer([
                _buildFieldLabel("vehicleName".tr.toUpperCase()),
                _buildTextField(vehicleNameCtrl, "vehicleNameHint".tr),
                SizedBox(height: 16.h),
                _buildFieldLabel("brand".tr.toUpperCase()),
                _buildTextField(brandCtrl, "brandHint".tr),
                SizedBox(height: 16.h),
                _buildFieldLabel("model".tr.toUpperCase()),
                _buildTextField(modelCtrl, "modelHint".tr),
                SizedBox(height: 16.h),
                _buildFieldLabel("plateNumber".tr.toUpperCase()),
                _buildTextField(numberPlateCtrl, "plateNumberHint".tr),
                SizedBox(height: 16.h),
                _buildFieldLabel("year".tr.toUpperCase()),
                _buildTextField(yearCtrl, "yearHint".tr),
              ]),
              SizedBox(height: 20.h),

              /// PHASE 02 // TELEMETRY DATA
              _buildSectionHeader("phase02Telemetry".tr),
              _buildCardContainer([
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 2.0,
                  children: [
                    _buildTelemetryField(
                      "hp".tr.toUpperCase(),
                      "hpHint".tr,
                      hpCtrl,
                    ),
                  ],
                ),
              ]),
              SizedBox(height: 24.h),

              /// PROPULSION SYSTEM
              _buildSectionHeader("engineType".tr.toUpperCase()),
              Row(
                children: [
                  Expanded(child: _buildPropulsionButton("Combustion")),
                  SizedBox(width: 8.w),
                  Expanded(child: _buildPropulsionButton("Electric")),
                  SizedBox(width: 8.w),
                  Expanded(child: _buildPropulsionButton("Hybrid")),
                ],
              ),
              SizedBox(height: 32.h),

              /// Save button
              Obx(() {
                return CustomButton(
                  height: 50.h,
                  title: profileController.isUpdating.value
                      ? "..."
                      : "saveToGarage".tr.toUpperCase(),
                  fontSize: 13,
                  borderRadius: 8.r,
                  onTap: profileController.isUpdating.value
                      ? () {}
                      : _updateVehicle,
                  isImageRight: true,
                  icon: const Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                    size: 18,
                  ),
                );
              }),
              SizedBox(height: 20.h),
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

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildTelemetryField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xff181818),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
                isDense: true,
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
          border: Border.all(
            color: isSelected ? AppColors.yellow : Colors.white10,
          ),
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../components/custom_text_field/custom_text_field.dart';

class BusinessCreateServicesListingScreen extends StatelessWidget {
  const BusinessCreateServicesListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Final Controllers
    final titleController = TextEditingController();
    final providerController = TextEditingController();
    final rateController = TextEditingController();
    final experienceYearsController = TextEditingController();
    final descController = TextEditingController();

    // Reactive states
    final RxString selectedCategory = "Technical Engineering".obs;
    final RxString selectedLocationType = "GLOBAL REACH".obs;
    final RxList<String> tracks = ["SPA-FRANCORCHAMPS", "NURBURGRING", "MONZA"].obs;

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
            "CREATE LISTING: EXPERT SERVICES",
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
              // 01. Service Profile
              _buildSectionHeader("01. SERVICE PROFILE"),
              _buildFormCard([
                _buildFieldLabel("LISTING TITLE"),
                CustomTextField(
                  textEditingController: titleController,
                  hintText: "e.g. Master Porsche GT3 Suspension Tech",
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
                SizedBox(height: 14.h),

                _buildFieldLabel("SERVICE CATEGORY"),
                Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: const Color(0xff111111),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory.value,
                        isExpanded: true,
                        dropdownColor: Colors.black,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white60),
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (newValue) {
                          if (newValue != null) selectedCategory.value = newValue;
                        },
                        items: [
                          "Technical Engineering",
                          "Track Coaching",
                          "Logistics & Transport",
                          "Pit Crew & Garage Support",
                          "Engine Tuning & ECU Calibration"
                        ].map((cat) {
                          return DropdownMenuItem<String>(
                            value: cat,
                            child: Text(cat),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),

                _buildFieldLabel("PROVIDER NAME / ORGANIZATION"),
                CustomTextField(
                  textEditingController: providerController,
                  hintText: "Individual name or Racing Team",
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
              ]),
              SizedBox(height: 20.h),

              // 02. Rates & Location
              _buildSectionHeader("02. RATES & LOCATION"),
              _buildFormCard([
                _buildFieldLabel("HOURLY RATE (USD)"),
                CustomTextField(
                  textEditingController: rateController,
                  hintText: "\$ 250",
                  keyboardType: TextInputType.number,
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
                SizedBox(height: 14.h),

                _buildFieldLabel("LOCATION TYPE"),
                Obx(
                  () => RadioGroup<String>(
                    groupValue: selectedLocationType.value,
                    onChanged: (val) {
                      if (val != null) selectedLocationType.value = val;
                    },
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "GLOBAL REACH",
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomText(
                                text: "Available for worldwide travel & remote consultation",
                                color: Colors.white38,
                                fontSize: 9.sp,
                              ),
                            ],
                          ),
                          value: "GLOBAL REACH",
                          activeColor: AppColors.yellow,
                          contentPadding: EdgeInsets.zero,
                        ),
                        RadioListTile<String>(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "CIRCUIT SPECIFIC",
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomText(
                                text: "Operating at specific race tracks or regional hubs",
                                color: Colors.white38,
                                fontSize: 9.sp,
                              ),
                            ],
                          ),
                          value: "CIRCUIT SPECIFIC",
                          activeColor: AppColors.yellow,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 14.h),

                // Map Placeholder Box
                Container(
                  height: 140.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Circuit map sketch mockup
                      Opacity(
                        opacity: 0.1,
                        child: Icon(
                          Icons.map_outlined,
                          size: 100.h,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        bottom: 16.h,
                        child: Row(
                          children: [
                            const Icon(Icons.location_searching, color: AppColors.yellow, size: 14),
                            SizedBox(width: 8.w),
                            CustomText(
                              text: "AWAITING LOCATION COORDINATES...",
                              color: Colors.white30,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
              SizedBox(height: 20.h),

              // 03. Expertise & Records
              _buildSectionHeader("03. EXPERTISE & RECORDS"),
              _buildFormCard([
                _buildFieldLabel("TRACK EXPERIENCE"),
                Obx(
                  () => Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      ...tracks.map((track) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: AppColors.yellow.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: AppColors.yellow, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                text: track,
                                color: AppColors.yellow,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(width: 6.w),
                              GestureDetector(
                                onTap: () => tracks.remove(track),
                                child: const Icon(
                                  Icons.close,
                                  color: AppColors.yellow,
                                  size: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      GestureDetector(
                        onTap: () {
                          // Prompt or mock add track
                          tracks.add("NÜRBURGRING GP");
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: const Color(0xff1E1E1E),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.add, color: Colors.white60, size: 12),
                              SizedBox(width: 4.w),
                              CustomText(
                                text: "ADD TRACK",
                                color: Colors.white60,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                _buildFieldLabel("EXPERIENCE (YEARS)"),
                CustomTextField(
                  textEditingController: experienceYearsController,
                  hintText: "e.g. 5",
                  keyboardType: TextInputType.number,
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
              ]),
              SizedBox(height: 20.h),

              // 04. Narrative
              _buildSectionHeader("04. NARRATIVE"),
              _buildFormCard([
                _buildFieldLabel("SERVICE OVERVIEW & MISSION"),
                CustomTextField(
                  textEditingController: descController,
                  hintText: "Describe your unique approach to performance, history in motorsport, and what clients can expect from your elite service...",
                  maxLines: 4,
                  fillColor: const Color(0xff111111),
                  fieldBorderColor: Colors.white10,
                  fieldBorderRadius: 10.r,
                ),
              ]),
              SizedBox(height: 20.h),

              // 05. Portfolio
              _buildSectionHeader("05. PORTFOLIO"),
              _buildFormCard([
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 1.3,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_a_photo_outlined, color: AppColors.yellow),
                          SizedBox(height: 6.h),
                          CustomText(
                            text: "UPLOAD MEDIA",
                            color: Colors.white60,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1517524206127-48bbd363f3d7?w=400&fit=crop",
                        fit: BoxFit.cover,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1486006920555-c77dce18193b?w=400&fit=crop",
                        fit: BoxFit.cover,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.network(
                        "https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=400&fit=crop",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ]),
              SizedBox(height: 32.h),

              // Bottom buttons
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      height: 44.h,
                      title: "CANCEL",
                      fontSize: 10.sp,
                      fillColor: const Color(0xff1E1E1E),
                      textColor: Colors.white60,
                      borderRadius: 10.r,
                      onTap: () => Get.back(),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    flex: 3,
                    child: CustomButton(
                      height: 44.h,
                      title: "PUBLISH LISTING",
                      fontSize: 10.sp,
                      fillColor: AppColors.yellow,
                      textColor: Colors.black,
                      borderRadius: 10.r,
                      onTap: () {
                        Get.back(); // Pop create screen
                        Get.back(); // Pop category selector
                        Get.snackbar(
                          "Listing Published",
                          "Your expert services listing has been published to the marketplace.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xff111111),
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
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildFormCard(List<Widget> children) {
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
}

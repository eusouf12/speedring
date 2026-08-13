import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/view/sereen/UserScreen/track/controller/track_controller.dart';
import '../../../../../../utils/app_const/app_const.dart';
import '../../widgets/track_appbar.dart';
import 'dart:io';

class TripConfiguratorScreen extends StatelessWidget {
  TripConfiguratorScreen({super.key});

  final TrackController controller = Get.find<TrackController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: TrackAppBar(
        profilePic: AppConstants.profileImage2,
        title: "tripConfigurator".tr.toUpperCase(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PHASE 01 // IDENTITY
              _buildPhaseHeader("phase1Identity".tr.toUpperCase()),
              _buildFieldLabel("tripName".tr.toUpperCase()),
              _buildTextField(controller.nameController),
              const SizedBox(height: 16),
              _buildFieldLabel("missionObjective".tr.toUpperCase()),
              _buildTextField(controller.objectiveController, maxLines: 3),
              const SizedBox(height: 16),
              _buildFieldLabel("tripCoverImage".tr.toUpperCase()),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: controller.pickConfiguratorImage,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                    image: controller.coverImagePath.value.isNotEmpty
                        ? DecorationImage(
                            image: FileImage(
                              File(controller.coverImagePath.value),
                            ),
                            fit: BoxFit.cover,
                          )
                        : (controller.editingDrive?.coverImage != null)
                        ? DecorationImage(
                            image: NetworkImage(
                              controller.editingDrive!.coverImage!.startsWith(
                                    "http",
                                  )
                                  ? controller.editingDrive!.coverImage!
                                  : "${ApiUrl.imageUrl}/${controller.editingDrive!.coverImage}",
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child:
                      (controller.coverImagePath.value.isEmpty &&
                          controller.editingDrive?.coverImage == null)
                      ? const Center(
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.white24,
                            size: 40,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 32),

              /// PHASE 02 // DEPLOYMENT LOGISTICS
              _buildPhaseHeader("phase2Deployment".tr.toUpperCase()),
              _buildFieldLabel("deploymentDate".tr.toUpperCase()),
              _buildTextField(controller.dateController),
              const SizedBox(height: 16),
              _buildFieldLabel("startTimeUTC".tr.toUpperCase()),
              _buildTextField(controller.timeController),
              const SizedBox(height: 16),
              _buildFieldLabel("meetingPoint".tr.toUpperCase()),
              _buildTextField(
                controller.meetingPointController,
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.yellow,
                  size: 20,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "maxParticipants".tr.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${controller.maxParticipants.value.toInt()}",
                    style: const TextStyle(
                      color: AppColors.yellow,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Slider(
                value: controller.maxParticipants.value,
                min: 2,
                max: 50,
                activeColor: AppColors.yellow,
                inactiveColor: Colors.white10,
                onChanged: (val) {
                  controller.maxParticipants.value = val;
                },
              ),
              const SizedBox(height: 32),

              /// PHASE 03 // CLASSIFICATION
              _buildPhaseHeader("phase3Classification".tr.toUpperCase()),
              _buildFieldLabel("vehicleClass".tr.toUpperCase()),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildVehicleClassButton(
                    "Cars",
                    Icons.directions_car_outlined,
                  ),
                  const SizedBox(width: 10),
                  _buildVehicleClassButton("Bikes", Icons.two_wheeler),
                  const SizedBox(width: 10),
                  _buildVehicleClassButton("Mixed", Icons.group_work_outlined),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: SwitchListTile(
                  value: controller.publicDeployment.value,
                  onChanged: (val) {
                    controller.publicDeployment.value = val;
                  },
                  title: Text(
                    "publicDeployment".tr.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  activeThumbColor: Colors.black,
                  activeTrackColor: AppColors.yellow,
                  inactiveThumbColor: Colors.white38,
                  inactiveTrackColor: Colors.white10,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(height: 32),

              /// PHASE 04 // NAVIGATION
              _buildPhaseHeader("phase4Navigation".tr.toUpperCase()),
              _buildFieldLabel("routeSelection".tr.toUpperCase()),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: ListTile(
                  onTap: () {},
                  leading: const Icon(
                    Icons.map_outlined,
                    color: AppColors.yellow,
                  ),
                  title: Text(
                    "selectSavedTelemetry".tr,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white38,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              /// Footer Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xffF0294A)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Get.back(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.close,
                              color: Color(0xffF0294A),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "discard".tr.toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xffF0294A),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellow,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: controller.isCreatingExpedition.value
                            ? null
                            : () {
                                controller.saveConfiguredTrip();
                              },
                        child: controller.isCreatingExpedition.value
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (controller.editingDrive != null
                                            ? "updateTrip".tr
                                            : "createTrip".tr)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.chevron_right, size: 18),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.yellow,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    int maxLines = 1,
    Widget? prefixIcon,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xff111111),
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.yellow, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildVehicleClassButton(String label, IconData icon) {
    return Obx(() {
      final bool isSelected = controller.selectedVehicleClass.value == label;
      return Expanded(
        child: GestureDetector(
          onTap: () {
            controller.selectedVehicleClass.value = label;
          },
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xff222222)
                  : const Color(0xff111111),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? AppColors.yellow.withValues(alpha: 0.3)
                    : Colors.white10,
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected ? AppColors.yellow : Colors.white38,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: isSelected ? AppColors.yellow : Colors.white60,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

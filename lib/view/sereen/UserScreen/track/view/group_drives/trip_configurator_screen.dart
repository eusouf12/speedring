import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/service/api_url.dart';
import 'package:speedring/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:speedring/view/sereen/UserScreen/track/controller/track_controller.dart';
import 'package:speedring/view/sereen/UserScreen/track/mode/track_model.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class TripConfiguratorScreen extends StatelessWidget {
  TripConfiguratorScreen({super.key});

  final TrackController controller = Get.find<TrackController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomRoyelAppbar(
        leftIcon: true,
        titleName: "tripConfigurator".tr.toUpperCase(),
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
                child: Obx(() {
                  ImageProvider? imageProvider;
                  if (controller.coverImagePath.value.isNotEmpty) {
                    imageProvider = FileImage(File(controller.coverImagePath.value));
                  } else {
                    String? networkUrl = controller.editingDrive?.coverImage;
                    if (networkUrl == null || networkUrl.isEmpty) {
                      networkUrl = controller.selectedTrack.value?.coverImage;
                    }
                    if (networkUrl != null && networkUrl.isNotEmpty) {
                      imageProvider = NetworkImage(
                        networkUrl.startsWith("http")
                            ? networkUrl
                            : "${ApiUrl.imageUrl}/$networkUrl",
                      );
                    }
                  }

                  final bool hasImage = imageProvider != null;

                  return Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                      image: hasImage
                          ? DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: !hasImage
                        ? const Center(
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.white24,
                              size: 40,
                            ),
                          )
                        : null,
                  );
                }),
              ),
              const SizedBox(height: 32),

              /// PHASE 02 // DEPLOYMENT LOGISTICS
              _buildPhaseHeader("phase2Deployment".tr.toUpperCase()),
              _buildFieldLabel("deploymentDate".tr.toUpperCase()),
              _buildTextField(
                controller.dateController,
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: AppColors.yellow,
                            onPrimary: Colors.black,
                            surface: Color(0xff111111),
                            onSurface: Colors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (date != null) {
                    controller.dateController.text = DateFormat(
                      'yyyy-MM-dd',
                    ).format(date);
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildFieldLabel("startTime".tr.toUpperCase()),
              _buildTextField(
                controller.timeController,
                readOnly: true,
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: AppColors.yellow,
                            onPrimary: Colors.black,
                            surface: Color(0xff111111),
                            onSurface: Colors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (time != null) {
                    final dt = DateTime(2020, 1, 1, time.hour, time.minute);
                    controller.timeController.text = DateFormat(
                      'hh:mm a',
                    ).format(dt);
                  }
                },
              ),
              const SizedBox(height: 16),
              _buildFieldLabel("meetingPoint".tr.toUpperCase()),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  return await controller.fetchPlaceSuggestions(
                    textEditingValue.text,
                  );
                },
                onSelected: (String selection) {
                  controller.meetingPointController.text = selection;
                  controller.fetchLatLngFromAddress(selection);
                },
                fieldViewBuilder:
                    (context, textController, focusNode, onEditingComplete) {
                      if (controller.meetingPointController.text !=
                              textController.text &&
                          textController.text.isEmpty &&
                          controller.meetingPointController.text.isNotEmpty) {
                        textController.text =
                            controller.meetingPointController.text;
                      }
                      return _buildTextField(
                        textController,
                        focusNode: focusNode,
                        prefixIcon: const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.yellow,
                          size: 20,
                        ),
                        onChanged: (val) {
                          controller.meetingPointController.text = val;
                        },
                      );
                    },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      color: const Color(0xff111111),
                      borderRadius: BorderRadius.circular(12),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 200,
                          maxWidth: 350,
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              title: Text(
                                option,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              onTap: () {
                                onSelected(option);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
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
                child: Material(
                  color: Colors.transparent,
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
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    onTap: () => _showTrackSelectionBottomSheet(context),
                    leading: const Icon(
                      Icons.map_outlined,
                      color: AppColors.yellow,
                    ),
                    title: Obx(() {
                      final selectedTrack = controller.selectedTrack.value;
                      return Text(
                        selectedTrack?.name?.toUpperCase() ??
                            "selectTrack".tr.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.white38,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              /// Footer Buttons
              SizedBox(
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
                      ? const CircularProgressIndicator(color: Colors.yellow)
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
    bool readOnly = false,
    VoidCallback? onTap,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      focusNode: focusNode,
      onChanged: onChanged,
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

  void _showTrackSelectionBottomSheet(BuildContext context) {
    if (controller.tracks.isEmpty) {
      controller.getAllTracks(refresh: true);
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "selectTrack".tr,
                style: const TextStyle(
                  color: AppColors.yellow,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value && controller.tracks.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.yellow),
                    );
                  }
                  if (controller.tracks.isEmpty) {
                    return Center(
                      child: Text(
                        "noTracksFound".tr,
                        style: const TextStyle(color: Colors.white54),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.tracks.length,
                    itemBuilder: (context, index) {
                      Track track = controller.tracks[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(track.coverImage ?? ""),
                          backgroundColor: Colors.grey[900],
                        ),
                        title: Text(
                          track.name ?? "unknownTrack".tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          track.country ?? "unknown".tr,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          controller.setTrack(track);
                          Get.back();
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
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

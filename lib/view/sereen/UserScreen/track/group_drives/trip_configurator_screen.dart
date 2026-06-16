import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import '../widgets/track_appbar.dart';

class TripConfiguratorScreen extends StatefulWidget {
  const TripConfiguratorScreen({super.key});

  @override
  State<TripConfiguratorScreen> createState() => _TripConfiguratorScreenState();
}

class _TripConfiguratorScreenState extends State<TripConfiguratorScreen> {
  final TextEditingController nameController = TextEditingController(text: "Midnight Coast Run");
  final TextEditingController objectiveController = TextEditingController(
    text: "Describe the deployment objectives, route characteristics, and pace expectations...",
  );
  final TextEditingController dateController = TextEditingController(text: "10/24/2026");
  final TextEditingController timeController = TextEditingController(text: "22:00 UTC");
  final TextEditingController meetingPointController = TextEditingController(
    text: "Pacific Coast Highway // Gate 4",
  );

  double maxParticipants = 12;
  String selectedVehicleClass = "CARS";
  bool publicDeployment = true;

  @override
  void dispose() {
    nameController.dispose();
    objectiveController.dispose();
    dateController.dispose();
    timeController.dispose();
    meetingPointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: TrackAppBar(
        title: "TRIP CONFIGURATOR",
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PHASE 01 // IDENTITY
            _buildPhaseHeader("PHASE 01 // IDENTITY"),
            _buildFieldLabel("TRIP NAME"),
            _buildTextField(nameController),
            const SizedBox(height: 16),
            _buildFieldLabel("MISSION OBJECTIVE"),
            _buildTextField(objectiveController, maxLines: 3),
            const SizedBox(height: 16),
            _buildFieldLabel("TRIP COVER IMAGE"),
            const SizedBox(height: 8),
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
                image: const DecorationImage(
                  image: NetworkImage("https://picsum.photos/seed/coastalrun/600/300"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 32),

            /// PHASE 02 // DEPLOYMENT LOGISTICS
            _buildPhaseHeader("PHASE 02 // DEPLOYMENT LOGISTICS"),
            _buildFieldLabel("DEPLOYMENT DATE"),
            _buildTextField(dateController),
            const SizedBox(height: 16),
            _buildFieldLabel("START TIME (UTC)"),
            _buildTextField(timeController),
            const SizedBox(height: 16),
            _buildFieldLabel("MEETING POINT"),
            _buildTextField(
              meetingPointController,
              prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.yellow, size: 20),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "MAXIMUM PARTICIPANTS",
                  style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${maxParticipants.toInt()}",
                  style: const TextStyle(color: AppColors.yellow, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Slider(
              value: maxParticipants,
              min: 2,
              max: 50,
              activeColor: AppColors.yellow,
              inactiveColor: Colors.white10,
              onChanged: (val) {
                setState(() {
                  maxParticipants = val;
                });
              },
            ),
            const SizedBox(height: 32),

            /// PHASE 03 // CLASSIFICATION
            _buildPhaseHeader("PHASE 03 // CLASSIFICATION"),
            _buildFieldLabel("VEHICLE CLASS"),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildVehicleClassButton("CARS", Icons.directions_car_outlined),
                const SizedBox(width: 10),
                _buildVehicleClassButton("BIKES", Icons.two_wheeler),
                const SizedBox(width: 10),
                _buildVehicleClassButton("MIXED", Icons.group_work_outlined),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: SwitchListTile(
                value: publicDeployment,
                onChanged: (val) {
                  setState(() {
                    publicDeployment = val;
                  });
                },
                title: const Text(
                  "PUBLIC DEPLOYMENT",
                  style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                activeColor: Colors.black,
                activeTrackColor: AppColors.yellow,
                inactiveThumbColor: Colors.white38,
                inactiveTrackColor: Colors.white10,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 32),

            /// PHASE 04 // NAVIGATION
            _buildPhaseHeader("PHASE 04 // NAVIGATION"),
            _buildFieldLabel("ROUTE SELECTION"),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: ListTile(
                onTap: () {},
                leading: const Icon(Icons.map_outlined, color: AppColors.yellow),
                title: const Text(
                  "Select from Saved Telemetry Routes",
                  style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.white38),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => Get.back(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.close, color: Color(0xffF0294A), size: 18),
                          SizedBox(width: 8),
                          Text("DISCARD", style: TextStyle(color: Color(0xffF0294A), fontSize: 13, fontWeight: FontWeight.bold)),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => Get.back(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("CREATE TRIP", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          SizedBox(width: 6),
                          Icon(Icons.chevron_right, size: 18),
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
    );
  }

  Widget _buildPhaseHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.yellow,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {int maxLines = 1, Widget? prefixIcon}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xff111111),
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.yellow, width: 1),
        ),
      ),
    );
  }

  Widget _buildVehicleClassButton(String label, IconData icon) {
    final bool isSelected = selectedVehicleClass == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedVehicleClass = label;
          });
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.yellow : const Color(0xff111111),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? Colors.black : Colors.white60, size: 20),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white60,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

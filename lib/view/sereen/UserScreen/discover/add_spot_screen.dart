import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';

class AddSpotScreen extends StatefulWidget {
  const AddSpotScreen({super.key});

  @override
  State<AddSpotScreen> createState() => _AddSpotScreenState();
}

class _AddSpotScreenState extends State<AddSpotScreen> {
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _engineController = TextEditingController();
  final TextEditingController _powerController = TextEditingController();
  final TextEditingController _zeroToHundredController =
      TextEditingController();

  @override
  void dispose() {
    _plateController.dispose();
    _regionController.dispose();
    _modelController.dispose();
    _engineController.dispose();
    _powerController.dispose();
    _zeroToHundredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.yellow,
              size: 24,
            ),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "NEW VEHICLE SPOT",
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 1. MEDIA CAPTURE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSectionHeader("MEDIA CAPTURE"),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: _buildCardDecoration(),
                  child: Column(
                    children: [
                      /// Primary upload area
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white12,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add_a_photo_outlined,
                              color: AppColors.yellow,
                              size: 32,
                            ),
                            SizedBox(height: 12),
                            Text(
                              "UPLOAD PRIMARY ASSET",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "RAW, JPEG, OR PNG (MAX 50MB)",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// Secondary small upload row
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xff1d1d1d),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white24,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xff1d1d1d),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white24,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// 2. VEHICLE IDENTIFICATION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSectionHeader("VEHICLE IDENTIFICATION"),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: _buildCardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "LICENSE PLATE",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller: _plateController,
                        hint: "ENTER PLATE ID",
                        icon: Icons.tag,
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        "REGION / COUNTRY",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller: _regionController,
                        hint: "SELECT REGION",
                        icon: Icons.public,
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        "MAKE & MODEL",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInputField(
                        controller: _modelController,
                        hint: "E.G. PORSCHE 911 GT3 RS",
                        icon: Icons.directions_car,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// 3. SPECIFICATION OVERRIDE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSectionHeader("SPECIFICATION OVERRIDE"),
              ),
              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: _buildCardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Engine Field
                      const Text(
                        "ENGINE",
                        style: TextStyle(
                          color: AppColors.yellow,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildSpecField(
                        controller: _engineController,
                        hint: "E.G. 4.0L FLAT-6",
                      ),
                      const SizedBox(height: 16),

                      /// Power Field
                      Row(
                        children: const [
                          Icon(
                            Icons.flash_on,
                            color: AppColors.yellow,
                            size: 10,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "POWER (HP)",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildSpecField(
                        controller: _powerController,
                        hint: "E.G. 525",
                      ),
                      const SizedBox(height: 16),

                      /// 0-100 Field
                      Row(
                        children: const [
                          Icon(
                            Icons.timer_outlined,
                            color: AppColors.yellow,
                            size: 10,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "0-100 KM/H (S)",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildSpecField(
                        controller: _zeroToHundredController,
                        hint: "E.G. 3.2",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              /// Bottom Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Get.back();
                      Get.snackbar(
                        "Spot Published",
                        "Your vehicle spot has been successfully published.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xff181818),
                        colorText: Colors.white,
                        borderColor: AppColors.yellow,
                        borderWidth: 1,
                      );
                    },
                    child: const Text(
                      "PUBLISH SPOT",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xff181818),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: AppColors.yellow.withValues(alpha:0.3)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.yellow,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: const Color(0xff111111),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: Colors.white10),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.yellow, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

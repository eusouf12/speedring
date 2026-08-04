import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import 'package:speedring/view/sereen/UserScreen/Home/Screen/HomeScreen/controller/home_controller.dart';

// ─── Controller ────────────────────────────────────────────────
class CreateClubController extends GetxController {
  final RxList<String> selectedCategories = <String>[].obs;
  final RxList<Map<String, dynamic>> dynamicCategories =
      <Map<String, dynamic>>[].obs;

  final RxString selectedAccess = "PUBLIC".obs;
  final RxBool telemetryVerification = true.obs;

  final TextEditingController clubNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final Rx<File?> logoImage = Rx<File?>(null);
  final Rx<File?> bannerImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  Future<void> pickLogo() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      logoImage.value = File(image.path);
    }
  }

  Future<void> pickBanner() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      bannerImage.value = File(image.path);
    }
  }

  @override
  void onInit() {
    super.onInit();
    dynamicCategories.addAll(CreateClubScreen.categories);
  }

  @override
  void onClose() {
    clubNameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void toggleCategory(String categoryName) {
    if (selectedCategories.contains(categoryName)) {
      selectedCategories.remove(categoryName);
    } else {
      selectedCategories.add(categoryName);
    }
  }

  void addCustomCategory(String categoryName) {
    if (categoryName.isNotEmpty) {
      final newCategory = {
        "name": categoryName.toUpperCase(),
        "icon": Icons.label_outline,
      };
      dynamicCategories.insert(dynamicCategories.length - 1, newCategory);
      selectedCategories.add(newCategory['name'] as String);
    }
  }
}

// ─── Screen ────────────────────────────────────────────────────
class CreateClubScreen extends StatelessWidget {
  const CreateClubScreen({super.key});

  static const List<Map<String, dynamic>> categories = [
    {"name": "GT3 SERIES", "icon": Icons.settings_outlined},
    {"name": "ENDURANCE", "icon": Icons.access_time},
    {"name": "STRATEGY", "icon": Icons.trending_up},
    {"name": "TUNING", "icon": Icons.tune},
    {"name": "CLASSIC & OLDTIMER", "icon": Icons.history},
    {"name": "TRUCKS & SUV", "icon": Icons.directions_car},
    {"name": "BIKES", "icon": Icons.motorcycle},
    {"name": "DRIFTING", "icon": Icons.sports_volleyball},
    {"name": "KARTING", "icon": Icons.toys},
    {"name": "RALLYE / OFFROAD", "icon": Icons.terrain},
    {"name": "TRACKDAYS", "icon": Icons.timer},
    {"name": "CAR MEETS & CRUISE", "icon": Icons.people_outline},
    {"name": "COMMUNITY & LIFESTYLE", "icon": Icons.hub_outlined},
    {"name": "YOUNG DRIVER", "icon": Icons.person_outline},
    {"name": "ADVENTURE", "icon": Icons.explore_outlined},
    {"name": "AND MORE", "icon": Icons.add},
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateClubController());

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomRoyelAppbar(leftIcon: true, titleName: "CREATE NEW CLUB"),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// SECTION 01 - IDENTITY
              _buildSectionHeader("SECTION 01 - IDENTITY"),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: _buildCardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "CLUB NAME",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      "e.g., SYNDICATE RACING",
                      controller: controller.clubNameController,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "INPUT DETAILS",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      "Describe About Club",
                      maxLines: 3,
                      controller: controller.descriptionController,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// SECTION 02 - CLASSIFICATION
              _buildSectionHeader("SECTION 02 - CLASSIFICATION"),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: _buildCardDecoration(),
                child: Obx(
                  () => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.dynamicCategories.map((cat) {
                      final bool isSelected = controller.selectedCategories
                          .contains(cat['name']);
                      return GestureDetector(
                        onTap: () {
                          if (cat['name'] == 'AND MORE') {
                            _showAddCategoryDialog(context, controller);
                          } else {
                            controller.toggleCategory(cat['name']);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.yellow
                                  : Colors.white10,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                cat['icon'],
                                color: isSelected
                                    ? AppColors.yellow
                                    : Colors.white60,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                cat['name'],
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.yellow
                                      : Colors.white60,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// SECTION 03 - VISIBILITY
              _buildSectionHeader("SECTION 03 - VISIBILITY"),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: _buildCardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ACCESS TYPE",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Define entry protocol",
                      style: TextStyle(color: Colors.white60, fontSize: 11),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => Row(
                        children: ["PUBLIC", "APPROVAL", "INVITE"].map((type) {
                          final bool isSel =
                              type == controller.selectedAccess.value;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.selectedAccess.value = type;
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isSel
                                        ? AppColors.yellow
                                        : Colors.white10,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    type,
                                    style: TextStyle(
                                      color: isSel
                                          ? AppColors.yellow
                                          : Colors.white60,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// SECTION 04 - VISUALS
              _buildSectionHeader("SECTION 04 - VISUALS"),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: _buildCardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "IDENTITY LOGO (1:1)",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: controller.pickLogo,
                      child: Obx(() {
                        return Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white12,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            image: controller.logoImage.value != null
                                ? DecorationImage(
                                    image: FileImage(
                                      controller.logoImage.value!,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: controller.logoImage.value == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.upload_file_outlined,
                                      color: Colors.white60,
                                      size: 24,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "SVG / PNG",
                                      style: TextStyle(
                                        color: Colors.white38,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "CINEMATIC BANNER (16:9)",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: controller.pickBanner,
                      child: Obx(() {
                        return Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white12),
                            borderRadius: BorderRadius.circular(8),
                            image: controller.bannerImage.value != null
                                ? DecorationImage(
                                    image: FileImage(
                                      controller.bannerImage.value!,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : const DecorationImage(
                                    image: NetworkImage(
                                      "https://picsum.photos/seed/createbanner/600/300",
                                    ),
                                    fit: BoxFit.cover,
                                    opacity: 0.3,
                                  ),
                          ),
                          child: controller.bannerImage.value == null
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        color: Colors.white70,
                                        size: 28,
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        "DEPLOY BANNER ASSET",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              /// Create Club Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Obx(() {
                  final homeController = Get.find<HomeController>();
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: homeController.isCreateClubLoading.value
                        ? null
                        : () async {
                            if (controller.clubNameController.text
                                    .trim()
                                    .isEmpty ||
                                controller.descriptionController.text
                                    .trim()
                                    .isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Club Name and Description are required.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: const Color(0xff181818),
                                colorText: Colors.white,
                              );
                              return;
                            }

                            final success = await homeController.createClub(
                              clubName: controller.clubNameController.text
                                  .trim(),
                              description: controller.descriptionController.text
                                  .trim(),
                              categories: controller.selectedCategories
                                  .toList(),
                              accessType: controller.selectedAccess.value,
                              telemetryVerification:
                                  controller.telemetryVerification.value,
                              logo: controller.logoImage.value,
                              banner: controller.bannerImage.value,
                            );

                            if (success) {
                              Get.back();
                            }
                          },
                    child: homeController.isCreateClubLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2.0,
                            ),
                          )
                        : const Text(
                            "CREATE CLUB",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              /// Cancel Button
              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    "CANCEL",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.yellow,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: const Color(0xff111111),
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: Colors.white10),
    );
  }

  Widget _buildTextField(
    String hint, {
    int maxLines = 1,
    TextEditingController? controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
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

  void _showAddCategoryDialog(
    BuildContext context,
    CreateClubController controller,
  ) {
    final TextEditingController textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff1C1C1C),
          title: const Text(
            "Add Custom Category",
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: textController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Enter category name",
              hintStyle: TextStyle(color: Colors.white38),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.yellow),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "CANCEL",
                style: TextStyle(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () {
                if (textController.text.trim().isNotEmpty) {
                  controller.addCustomCategory(textController.text.trim());
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "ADD",
                style: TextStyle(color: AppColors.yellow),
              ),
            ),
          ],
        );
      },
    );
  }
}

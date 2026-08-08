import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import 'package:speedring/view/components/custom_royel_appbar/custom_royel_appbar.dart';

// ─── Controller ────────────────────────────────────────────────
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:speedring/view/sereen/UserScreen/Home/Screen/HomeScreen/controller/home_controller.dart';
import 'package:speedring/service/api_url.dart';

class EditClubController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();

  final RxString selectedSecurity = "PRIVATE".obs;
  final TextEditingController designationController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final RxList<String> tags = <String>[].obs;

  final Rxn<File> coverImage = Rxn<File>();
  final Rxn<File> profileImage = Rxn<File>();
  final RxString currentCoverUrl = "".obs;
  final RxString currentLogoUrl = "".obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    final club = homeController.currentClubDetail.value;
    if (club != null) {
      designationController.text = club.clubName ?? "";
      aboutController.text = club.description ?? "";
      tags.value = club.categories ?? [];
      selectedSecurity.value = (club.accessType ?? "PRIVATE").toUpperCase();

      currentCoverUrl.value = club.banner != null && club.banner!.isNotEmpty
          ? (club.banner!.startsWith('http')
                ? club.banner!
                : "${ApiUrl.imageUrl}${club.banner}")
          : "";
      currentLogoUrl.value = club.logo != null && club.logo!.isNotEmpty
          ? (club.logo!.startsWith('http')
                ? club.logo!
                : "${ApiUrl.imageUrl}${club.logo}")
          : "";
    }
  }

  Future<void> pickCoverImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      coverImage.value = File(picked.path);
    }
  }

  Future<void> pickProfileImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      profileImage.value = File(picked.path);
    }
  }

  Future<void> saveChanges() async {
    final clubId = homeController.currentClubDetail.value?.id;
    if (clubId == null) return;

    bool success = await homeController.updateClub(
      clubId: clubId,
      clubName: designationController.text,
      description: aboutController.text,
      categories: tags,
      accessType: selectedSecurity.value,
      banner: coverImage.value,
      logo: profileImage.value,
    );

    if (success) {
      Get.back();
    }
  }

  Future<void> terminateClub() async {
    final clubId = homeController.currentClubDetail.value?.id;
    if (clubId == null) return;

    bool success = await homeController.deleteClub(clubId);
    if (success) {
      Get.close(3); // Close dialog, edit screen, and detail screen
    }
  }

  @override
  void onClose() {
    designationController.dispose();
    aboutController.dispose();
    super.onClose();
  }
}

// ─── Screen ────────────────────────────────────────────────────
class EditClubScreen extends StatelessWidget {
  const EditClubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditClubController());

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomRoyelAppbar(leftIcon: true, titleName: "editClub".tr.toUpperCase()),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 1. Cinematic Banner / Cover image area
              Stack(
                children: [
                  Obx(
                    () => Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: controller.coverImage.value != null
                              ? FileImage(controller.coverImage.value!)
                                    as ImageProvider
                              : (controller.currentCoverUrl.value.isNotEmpty
                                    ? NetworkImage(
                                        controller.currentCoverUrl.value,
                                      )
                                    : const NetworkImage(
                                        "https://picsum.photos/seed/purple_porsche/800/400",
                                      )),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        controller.pickCoverImage();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Update COVER",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// 2. Identity Logo / Profile Badge Box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 220,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xff111111),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Center(
                        child: Obx(
                          () => Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.yellow,
                                width: 2,
                              ),
                              gradient: const RadialGradient(
                                colors: [Color(0xff222222), Colors.black],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.yellow.withValues(
                                    alpha: 0.15,
                                  ),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                              image: controller.profileImage.value != null
                                  ? DecorationImage(
                                      image: FileImage(
                                        controller.profileImage.value!,
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  : (controller.currentLogoUrl.value.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              controller.currentLogoUrl.value,
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null),
                            ),
                            child:
                                (controller.profileImage.value == null &&
                                    controller.currentLogoUrl.value.isEmpty)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.directions_car_filled,
                                        color: AppColors.yellow,
                                        size: 40,
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        "GT3 COLLECTIVE",
                                        style: TextStyle(
                                          color: AppColors.yellow,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        height: 1,
                                        width: 60,
                                        color: Colors.white24,
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        "ELITE PORSCHE CLUB",
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () {
                          controller.pickProfileImage();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                                size: 10,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Update Logo",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// 3. Core Identity Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSectionHeader("CORE IDENTITY"),
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
                        "CLUB DESIGNATION",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDesignationField(controller),
                      const SizedBox(height: 20),

                      const Text(
                        "SECURITY PROTOCOL",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 10),

                      /// Security options
                      Obx(
                        () => Column(
                          children: [
                            _buildSecurityOption(
                              controller,
                              "PUBLIC",
                              "OPEN ENTRY",
                            ),
                            const SizedBox(height: 8),
                            _buildSecurityOption(
                              controller,
                              "PRIVATE",
                              "APPROVAL REQ.",
                            ),
                            const SizedBox(height: 8),
                            _buildSecurityOption(
                              controller,
                              "INVITE ONLY",
                              "STEALTH MODE",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// 4. About Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSectionHeader("ABOUT"),
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
                        "DETAILS",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(controller.aboutController, maxLines: 4),
                      const SizedBox(height: 20),

                      const Text(
                        "TECHNICAL TAGS",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Obx(
                        () => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ...controller.tags.map(
                              (tag) => _buildTag(controller, tag),
                            ),
                            _buildAddParameterButton(controller),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// 5. System Decommission Box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xff180707),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xff551a1a)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "SYSTEM DECOMMISSION",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Deleting this club is irreversible. All telemetry data and squadron records will be purged.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: () {
                            _showDeleteConfirmationDialog(controller);
                          },
                          child: const Text(
                            "TERMINATE CLUB",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              /// 6. Save / Discard Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.white24,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => Get.back(),
                          child: const Text(
                            "DISCARD",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 48,
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
                            controller.saveChanges();
                          },
                          child: const Text(
                            "SAVE CHANGES",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
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
        border: Border.all(color: AppColors.yellow.withValues(alpha: 0.3)),
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

  Widget _buildDesignationField(EditClubController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: Colors.white60, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller.designationController,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, {int maxLines = 1}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildSecurityOption(
    EditClubController controller,
    String title,
    String subtitle,
  ) {
    final bool isSelected = title == controller.selectedSecurity.value;
    return GestureDetector(
      onTap: () {
        controller.selectedSecurity.value = title;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xff1d1d1d),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppColors.yellow : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.yellow : Colors.white24,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.yellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white38, fontSize: 9),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(EditClubController controller, String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.yellow.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: const TextStyle(
              color: AppColors.yellow,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () {
              controller.tags.remove(tag);
            },
            child: const Icon(Icons.close, color: AppColors.yellow, size: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildAddParameterButton(EditClubController controller) {
    return GestureDetector(
      onTap: () {
        _showAddTagDialog(controller);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white24, style: BorderStyle.solid),
        ),
        child: const Text(
          "+ ADD PARAMETER",
          style: TextStyle(
            color: Colors.white60,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showAddTagDialog(EditClubController controller) {
    final TextEditingController tagController = TextEditingController();
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xff181818),
        title: const Text(
          "Add Technical Tag",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: tagController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "enterTagName".tr,
            hintStyle: TextStyle(color: Colors.white24),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.yellow),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "CANCEL",
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              if (tagController.text.trim().isNotEmpty) {
                controller.tags.add(tagController.text.trim());
              }
              Get.back();
            },
            child: Text("add".tr.toUpperCase(), style: const TextStyle(color: AppColors.yellow)),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(EditClubController controller) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xff181818),
        title: const Text(
          "Terminate Club?",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you absolutely sure you want to terminate this club? This action cannot be undone.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "CANCEL",
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.terminateClub();
            },
            child: Text("yes".tr.toUpperCase(), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

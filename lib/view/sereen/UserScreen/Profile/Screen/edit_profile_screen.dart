import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../../utils/app_const/app_const.dart' show AppConstants;
import '../../../../components/custom_button/custom_button.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../controller/profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  // All available vehicle type options
  static const List<String> _vehicleTypeOptions = [
    'Combustion',
    'Electric',
    'Motorcycle',
    'Truck',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileScreenController>();

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
            'EDIT PROFILE',
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ── Banner & Avatar Stack ──────────────────────────────
              Obx(() {
                final profile = controller.profileData.value;
                final pickedBanner = controller.selectedBannerImage.value;
                final pickedAvatar = controller.selectedProfileImage.value;

                return Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Banner / Cover image
                    SizedBox(
                      height: 180.h,
                      width: double.infinity,
                      child: pickedBanner != null
                          ? Image.file(pickedBanner, fit: BoxFit.cover)
                          : Image.network(
                              profile?.profileBanner ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, _e) => Container(
                                color: const Color(0xff1C1C1C),
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.white24,
                                    size: 48,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    // Edit banner icon
                    Positioned(
                      top: 12.h,
                      right: 12.w,
                      child: _editIconButton(onTap: () => controller.pickBannerImage()),
                    ),

                    // Avatar
                    Positioned(
                      bottom: -50.h,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 4),
                              color: Colors.black,
                            ),
                            child: ClipOval(
                              child: pickedAvatar != null
                                  ? Image.file(pickedAvatar, fit: BoxFit.cover)
                                  : Image.network(
                                      profile?.profileImage ?? AppConstants.profileImage,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, _e) => Container(
                                        color: const Color(0xff222222),
                                        child: const Center(
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white24,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: _editIconButton(
                              onTap: () => controller.pickProfileImage(),
                              size: 14,
                              padding: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),

              SizedBox(height: 70.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ── BASIC IDENTITY ────────────────────────────────
                    _sectionHeader('BASIC IDENTITY'),
                    _card([
                      _fieldLabel('FULL NAME'),
                      _textField(
                        controller: controller.nameController,
                        hint: 'Enter your full name',
                        icon: Icons.person_outline,
                      ),
                      SizedBox(height: 14.h),
                      _fieldLabel('HANDLE / USERNAME'),
                      _textField(
                        controller: controller.handleController,
                        hint: '@username',
                        icon: Icons.alternate_email,
                      ),
                      SizedBox(height: 14.h),
                      _fieldLabel('BIOGRAPHY'),
                      _textField(
                        controller: controller.bioController,
                        hint: 'Tell us about yourself...',
                        maxLines: 3,
                      ),
                    ]),
                    SizedBox(height: 20.h),

                    /// ── DRIVER PROFILE ────────────────────────────────
                    _sectionHeader('DRIVER PROFILE'),
                    _card([
                      _fieldLabel('NATIONALITY'),
                      _textField(
                        controller: controller.nationalityController,
                        hint: 'e.g. Germany',
                        icon: Icons.flag_outlined,
                      ),
                      SizedBox(height: 14.h),
                      _fieldLabel('DRIVER ROLE'),
                      _textField(
                        controller: controller.driverRoleController,
                        hint: 'e.g. Racer, Enthusiast',
                        icon: Icons.speed_outlined,
                      ),
                      SizedBox(height: 16.h),
                      // isRolePublic toggle
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'SHOW ROLE PUBLICLY',
                                  color: Colors.white70,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                                SizedBox(height: 2.h),
                                CustomText(
                                  text: 'Visible on your public profile',
                                  color: Colors.white38,
                                  fontSize: 10.sp,
                                ),
                              ],
                            ),
                            Switch(
                              value: controller.isRolePublic.value,
                              onChanged: (val) =>
                                  controller.isRolePublic.value = val,
                              activeThumbColor: AppColors.yellow,
                              inactiveTrackColor: Colors.white12,
                            ),
                          ],
                        ),
                      ),
                    ]),
                    SizedBox(height: 20.h),

                    /// ── FAVORITE VEHICLE TYPES ────────────────────────
                    _sectionHeader('FAVORITE VEHICLE TYPES'),
                    _card([
                      Obx(
                        () => Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: _vehicleTypeOptions.map((type) {
                            final selected = controller.favoriteVehicles
                                .contains(type);
                            return GestureDetector(
                              onTap: () =>
                                  controller.toggleFavoriteVehicle(type),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.yellow
                                      : const Color(0xff1d1d1d),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.yellow
                                        : Colors.white24,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (selected) ...[
                                      const Icon(
                                        Icons.check,
                                        size: 12,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 4.w),
                                    ],
                                    Text(
                                      type,
                                      style: TextStyle(
                                        color: selected
                                            ? Colors.black
                                            : Colors.white70,
                                        fontSize: 12.sp,
                                        fontWeight: selected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ]),
                    SizedBox(height: 20.h),

                    /// ── SOCIAL CONNECTIVITY ───────────────────────────
                    _sectionHeader('SOCIAL CONNECTIVITY'),
                    _card([
                      _socialField(
                        controller: controller.instagramController,
                        hint: 'instagram.com/username',
                        icon: Icons.camera_alt_outlined,
                        label: 'Instagram',
                      ),
                      SizedBox(height: 10.h),
                      _socialField(
                        controller: controller.tiktokController,
                        hint: 'tiktok.com/@username',
                        icon: Icons.video_library_outlined,
                        label: 'TikTok',
                      ),
                      SizedBox(height: 10.h),
                      _socialField(
                        controller: controller.youtubeController,
                        hint: 'youtube.com/c/channel',
                        icon: Icons.play_circle_outline,
                        label: 'YouTube',
                      ),
                      SizedBox(height: 10.h),
                      _socialField(
                        controller: controller.facebookController,
                        hint: 'facebook.com/username',
                        icon: Icons.public_outlined,
                        label: 'Facebook',
                      ),
                    ]),
                    SizedBox(height: 20.h),

                    /// ── NOTIFICATION PREFERENCES ──────────────────────
                    _sectionHeader('NOTIFICATION PREFERENCES'),
                    _card([
                      Obx(
                        () => Column(
                          children: [
                            _notifToggle(
                              'Live Telemetry',
                              'Real-time ride data alerts',
                              controller.liveTelemetry,
                            ),
                            _notifToggle(
                              'Social',
                              'Followers & activity updates',
                              controller.socialNotification,
                            ),
                            _notifToggle(
                              'Location Based',
                              'Nearby events & locations',
                              controller.locationBased,
                            ),
                            _notifToggle(
                              'Marketplace',
                              'Deals and shop notifications',
                              controller.marketplace,
                            ),
                            _notifToggle(
                              'Pro Tour',
                              'Pro events & competitions',
                              controller.proTour,
                            ),
                          ],
                        ),
                      ),
                    ]),
                    SizedBox(height: 20.h),

                    /// ── GARAGE / VEHICLES ─────────────────────────────
                    _sectionHeader('GARAGE / VEHICLES'),
                    Obx(
                      () => controller.vehicles.isEmpty
                          ? _card([
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.directions_car_outlined,
                                        color: Colors.white24,
                                        size: 36,
                                      ),
                                      SizedBox(height: 8.h),
                                      CustomText(
                                        text: 'No vehicles added yet',
                                        color: Colors.white38,
                                        fontSize: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ])
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.vehicles.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 10.h),
                              itemBuilder: (_, index) {
                                final vehicle = controller.vehicles[index];
                                return _card([
                                  Row(
                                    children: [
                                      // Vehicle image thumbnail
                                      if (vehicle.localImageFile != null)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          child: Image.file(
                                            vehicle.localImageFile!,
                                            width: 56.w,
                                            height: 56.w,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, _e) =>
                                                _vehicleIconBox(),
                                          ),
                                        )
                                      else if (vehicle.vehicleImage != null &&
                                          vehicle.vehicleImage!.isNotEmpty)
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          child: Image.network(
                                            vehicle.vehicleImage!,
                                            width: 56.w,
                                            height: 56.w,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, _e) =>
                                                _vehicleIconBox(),
                                          ),
                                        )
                                      else
                                        _vehicleIconBox(),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text:
                                                  vehicle.vehicleName
                                                      ?.toUpperCase() ??
                                                  'UNKNOWN',
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            SizedBox(height: 4.h),
                                            CustomText(
                                              text:
                                                  '${vehicle.year ?? ''} ${vehicle.brand ?? ''} ${vehicle.model ?? ''}'
                                                      .trim(),
                                              color: Colors.white54,
                                              fontSize: 11,
                                            ),
                                            if (vehicle.engineType != null &&
                                                vehicle
                                                    .engineType!
                                                    .isNotEmpty) ...[
                                              SizedBox(height: 2.h),
                                              CustomText(
                                                text: vehicle.engineType!,
                                                color: AppColors.yellow,
                                                fontSize: 10,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: AppColors.yellow,
                                          size: 18,
                                        ),
                                        onPressed: () =>
                                            controller.showVehicleDialog(
                                              vehicle: vehicle,
                                              index: index,
                                            ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.redAccent,
                                          size: 18,
                                        ),
                                        onPressed: () =>
                                            controller.vehicles.removeAt(index),
                                      ),
                                    ],
                                  ),
                                ]);
                              },
                            ),
                    ),
                    SizedBox(height: 10.h),
                    CustomButton(
                      height: 40.h,
                      title: '+ ADD VEHICLE',
                      fontSize: 11,
                      textColor: Colors.black,
                      fillColor: AppColors.yellow,
                      borderRadius: 8.r,
                      onTap: () => controller.showVehicleDialog(),
                    ),
                    SizedBox(height: 32.h),

                    /// ── SAVE CHANGES ──────────────────────────────────
                    Obx(
                      () => controller.isUpdating.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.yellow,
                              ),
                            )
                          : CustomButton(
                              height: 52.h,
                              title: 'SAVE CHANGES',
                              fontSize: 13,
                              borderRadius: 8.r,
                              onTap: () => controller.updateUserProfile(),
                            ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helper Widgets ───────────────────────────────────────────────────────────

  Widget _editIconButton({
    required VoidCallback onTap,
    double size = 16,
    double padding = 8,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: const BoxDecoration(
          color: AppColors.yellow,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.edit, color: Colors.black, size: size),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(
        text: title,
        color: AppColors.yellow,
        fontSize: 9.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 4.h),
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

  Widget _fieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: CustomText(
        text: label,
        color: Colors.white38,
        fontSize: 9.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    int maxLines = 1,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: maxLines > 1 ? 8.h : 4.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white38, size: 16),
            SizedBox(width: 8.w),
          ],
          Expanded(
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
          ),
        ],
      ),
    );
  }

  Widget _socialField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String label,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 80.w,
          child: CustomText(
            text: label,
            color: Colors.white38,
            fontSize: 10.sp,
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xff1d1d1d),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white38, size: 16),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: const TextStyle(
                        color: Colors.white24,
                        fontSize: 12,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _notifToggle(String title, String subtitle, RxBool rxValue) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: title,
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 2.h),
              CustomText(
                text: subtitle,
                color: Colors.white38,
                fontSize: 10.sp,
              ),
            ],
          ),
          Switch(
            value: rxValue.value,
            onChanged: (val) => rxValue.value = val,
            activeThumbColor: AppColors.yellow,
            inactiveTrackColor: Colors.white12,
          ),
        ],
      ),
    );
  }

  Widget _vehicleIconBox() {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: const Icon(
        Icons.directions_car_outlined,
        color: Colors.white24,
        size: 28,
      ),
    );
  }
}

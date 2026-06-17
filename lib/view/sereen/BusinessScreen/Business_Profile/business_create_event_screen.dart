import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import '../BusinessHome/business_navbar.dart';

class BusinessCreateEventScreen extends StatefulWidget {
  const BusinessCreateEventScreen({super.key});

  @override
  State<BusinessCreateEventScreen> createState() => _BusinessCreateEventScreenState();
}

class _BusinessCreateEventScreenState extends State<BusinessCreateEventScreen> {
  final _eventNameController = TextEditingController();
  final _dateTimeController = TextEditingController();
  final _locationController = TextEditingController();
  final _limitController = TextEditingController(text: "50");
  final _detailsController = TextEditingController();

  String _selectedCategory = "Technical";
  bool _isInviteOnly = true;
  String _selectedTier = "ELITE"; // PRO, ELITE, VVIP

  @override
  void dispose() {
    _eventNameController.dispose();
    _dateTimeController.dispose();
    _locationController.dispose();
    _limitController.dispose();
    _detailsController.dispose();
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "CREATE EVENT",
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: CircleAvatar(
                radius: 14.r,
                backgroundColor: const Color(0xff222222),
                backgroundImage: const NetworkImage(
                  "https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=100&fit=crop",
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // EVENT INFO CARD
              _buildFormSectionHeader("EVENT INFO"),
              _buildFormCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel("EVENT NAME"),
                    _buildTextField(_eventNameController, "e.g. GT3 Technical Briefing"),
                    SizedBox(height: 14.h),
                    _buildFieldLabel("EVENT CATEGORY"),
                    _buildDropdownField(
                      value: _selectedCategory,
                      items: ["Technical", "Social", "Qualifying", "Endurance"],
                      onChanged: (val) => setState(() => _selectedCategory = val ?? "Technical"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // SCHEDULE & LOCATION CARD
              _buildFormSectionHeader("SCHEDULE & LOCATION"),
              _buildFormCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel("DATE & START TIME"),
                    _buildTextField(_dateTimeController, "mm/dd/yyyy, --:--"),
                    SizedBox(height: 14.h),
                    _buildFieldLabel("LOCATION / TRACK LOOKUP"),
                    _buildTextField(
                      _locationController,
                      "Search track (e.g. Spa, Silverstone, Nürburgring)",
                      prefixIcon: Icons.location_on_outlined,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // GUESTS & PRIVACY CARD
              _buildFormSectionHeader("GUESTS & PRIVACY"),
              _buildFormCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel("ATTENDEE LIMIT"),
                    _buildTextField(_limitController, "50", keyboardType: TextInputType.number),
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "PRIVACY MODE",
                              color: Colors.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w900,
                            ),
                            SizedBox(height: 2.h),
                            CustomText(
                              text: "INVITE ONLY",
                              color: Colors.white38,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        Switch(
                          value: _isInviteOnly,
                          activeThumbColor: AppColors.yellow,
                          activeTrackColor: AppColors.yellow.withValues(alpha: 0.3),
                          inactiveThumbColor: Colors.white38,
                          inactiveTrackColor: Colors.black26,
                          onChanged: (val) => setState(() => _isInviteOnly = val),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    _buildFieldLabel("ACCESS TIER"),
                    Row(
                      children: [
                        _buildTierButton("PRO"),
                        SizedBox(width: 8.w),
                        _buildTierButton("ELITE"),
                        SizedBox(width: 8.w),
                        _buildTierButton("VVIP"),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // EVENT DETAILS CARD
              _buildFormSectionHeader("EVENT DETAILS"),
              _buildFormCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel("TECHNICAL OBJECTIVES & LOGISTICS"),
                    _buildTextField(
                      _detailsController,
                      "Define tactical objectives, technical parameters, and specific briefing details for all participants...",
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // BANNER IMAGE CARD
              _buildFormSectionHeader("BANNER IMAGE"),
              _buildFormCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel("EVENT BANNER"),
                    CustomPaint(
                      painter: DashedBorderPainter(color: Colors.white12, strokeWidth: 1.5, gap: 5, dashLength: 6),
                      child: Container(
                        height: 110.h,
                        width: double.infinity,
                        color: Colors.black,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_photo_alternate_outlined, color: Colors.white38, size: 22),
                              SizedBox(height: 8.h),
                              CustomText(
                                text: "UPLOAD ASSET (16:9)",
                                color: Colors.white38,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // SUBMIT BUTTONS
              CustomButton(
                height: 44.h,
                title: "PUBLISH EVENT",
                fillColor: AppColors.yellow,
                textColor: Colors.black,
                borderRadius: 8.r,
                onTap: _onPublish,
              ),
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  height: 44.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Center(
                    child: Text(
                      "SAVE AS DRAFT",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBusinessNavBar(currentIndex: 4),
      ),
    );
  }

  Widget _buildFormSectionHeader(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xff181818),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: CustomText(
        text: label,
        color: AppColors.yellow,
        fontSize: 8.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildFormCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: CustomText(
        text: label,
        color: Colors.white38,
        fontSize: 7.5.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    IconData? prefixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          if (prefixIcon != null) ...[
            Icon(prefixIcon, color: Colors.white30, size: 14.sp),
            SizedBox(width: 8.w),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: keyboardType,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xff111111),
          style: const TextStyle(color: Colors.white, fontSize: 12),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTierButton(String label) {
    final isSelected = _selectedTier == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTier = label),
        child: Container(
          height: 34.h,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.yellow : Colors.black,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: isSelected ? Colors.transparent : Colors.white10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white60,
                fontSize: 9.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onPublish() {
    Get.back();
    Get.snackbar(
      "Event Published",
      "Successfully listed ${_eventNameController.text.isNotEmpty ? _eventNameController.text : 'GT3 Technical Briefing'} to the public events board.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff181818),
      colorText: Colors.white,
      borderColor: AppColors.yellow,
      borderWidth: 1,
    );
  }
}

// Dashed border painter for dashed uploader box
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.dashLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(8.r),
    ));

    // Dash paths manually
    for (double i = 0; i < size.width; i += dashLength + gap) {
      canvas.drawLine(Offset(i, 0), Offset(i + dashLength, 0), paint);
      canvas.drawLine(Offset(i, size.height), Offset(i + dashLength, size.height), paint);
    }
    for (double i = 0; i < size.height; i += dashLength + gap) {
      canvas.drawLine(Offset(0, i), Offset(0, i + dashLength), paint);
      canvas.drawLine(Offset(size.width, i), Offset(size.width, i + dashLength), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

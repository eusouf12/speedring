import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../../../../../../../service/api_url.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';
import '../../../../../../../../../utils/app_colors/app_colors.dart';
import '../../controller/home_controller.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _maxCapacityCtrl = TextEditingController(text: "");
  final _briefingCtrl = TextEditingController();

  // Phase 01 — Mission type
  String _missionType = "TRACK DAY";
  final List<String> _missionTypes = [
    "TRACK DAY",
    "ENDURANCE",
    "EXPERIENCE",
    "DRIFT SESSIONS",
    "TIME ATTACK",
  ];

  // Phase 02 — Logistics
  DateTime? _deploymentDate;
  TimeOfDay? _timeStart;
  TimeOfDay? _timeEnd;
  String? _locationCircuit;

  // Phase 03 — Access
  String _accessType = "PUBLIC (OPEN TO ALL)";

  // Banner image
  File? _bannerImage;
  final _picker = ImagePicker();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _eventNameCtrl.dispose();
    _locationCtrl.dispose();
    _maxCapacityCtrl.dispose();
    _briefingCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickBannerImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _bannerImage = File(picked.path));
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.yellow,
            onPrimary: Colors.black,
            surface: Color(0xff1C1C1C),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _deploymentDate = picked);
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.yellow,
            onPrimary: Colors.black,
            surface: Color(0xff1C1C1C),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _timeStart = picked;
        } else {
          _timeEnd = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay? t) {
    if (t == null) return "--:--";
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_deploymentDate == null) {
      Get.snackbar(
        "Required",
        "Please select a deployment date",
        backgroundColor: Colors.red.shade900,
        colorText: Colors.white,
      );
      return;
    }
    if (_bannerImage == null) {
      Get.snackbar(
        "Required",
        "Please upload a banner image",
        backgroundColor: Colors.red.shade900,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final controller = Get.find<HomeController>();
    final eventData = {
      "eventName": _eventNameCtrl.text.trim(),
      "missionType": _missionType,
      "deploymentDate": _deploymentDate!.toIso8601String(),
      "timeWindow": {
        "start": _formatTime(_timeStart),
        "end": _formatTime(_timeEnd),
      },
      "locationCircuit": _locationCircuit ?? _locationCtrl.text.trim(),
      "maxCapacity": int.tryParse(_maxCapacityCtrl.text.trim()) ?? 50,
      "accessType": _accessType,
      "briefing": _briefingCtrl.text.trim(),
    };

    final success = await controller.createEvent(
      mediaFile: _bannerImage!,
      eventData: eventData,
    );

    setState(() => _isSubmitting = false);

    if (success) {
      Get.back();
    }
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
          title: Text(
            "CREATE EVENT",
            style: TextStyle(
              color: AppColors.yellow,
              fontSize: 13.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Banner Image ──────────────────────────────────────────
                _buildBannerPicker(),
                SizedBox(height: 24.h),

                // ── PHASE 01: IDENTITY ────────────────────────────────────
                _sectionLabel("PHASE_01: IDENTITY"),
                SizedBox(height: 10.h),
                _fieldLabel("EVENT_NAME"),
                SizedBox(height: 6.h),
                _buildTextField(
                  controller: _eventNameCtrl,
                  hint: "E.G. SILVERSTONE PERFORMANCE PADDOCK",
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? "Required" : null,
                ),
                SizedBox(height: 16.h),
                _fieldLabel("MISSION_TYPE"),
                SizedBox(height: 8.h),
                _buildMissionTypeSelector(),
                SizedBox(height: 24.h),

                // ── PHASE 02: LOGISTICS ───────────────────────────────────
                _sectionLabel("PHASE_02: LOGISTICS"),
                SizedBox(height: 10.h),
                _fieldLabel("DEPLOYMENT_DATE"),
                SizedBox(height: 6.h),
                _buildTappableField(
                  leading: const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.white38,
                  ),
                  label: _deploymentDate == null
                      ? "MM/DD/YYYY"
                      : DateFormat("MM/dd/yyyy").format(_deploymentDate!),
                  isEmpty: _deploymentDate == null,
                  onTap: _pickDate,
                ),
                SizedBox(height: 12.h),
                _fieldLabel("TIME_WINDOW"),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildTappableField(
                        leading: const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.white38,
                        ),
                        label: _timeStart == null
                            ? "START --:--"
                            : "START ${_formatTime(_timeStart)}",
                        isEmpty: _timeStart == null,
                        onTap: () => _pickTime(true),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _buildTappableField(
                        leading: const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.white38,
                        ),
                        label: _timeEnd == null
                            ? "END --:--"
                            : "END ${_formatTime(_timeEnd)}",
                        isEmpty: _timeEnd == null,
                        onTap: () => _pickTime(false),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                _fieldLabel("LOCATION_CIRCUIT"),
                SizedBox(height: 6.h),
                _buildCircuitDropdown(),
                SizedBox(height: 24.h),

                // ── PHASE 03: ACCESS PROTOCOL ─────────────────────────────
                _sectionLabel("PHASE_03: ACCESS_PROTOCOL"),
                SizedBox(height: 10.h),
                _fieldLabel("MAX_CAPACITY"),
                SizedBox(height: 6.h),
                _buildTextField(
                  controller: _maxCapacityCtrl,
                  hint: "50",
                  keyboardType: TextInputType.number,
                  leading: const Icon(
                    Icons.people_outline,
                    size: 14,
                    color: Colors.white38,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Required";
                    if (int.tryParse(v.trim()) == null) {
                      return "Must be a number";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),
                _fieldLabel("ACCESS_TYPE"),
                SizedBox(height: 6.h),
                _buildAccessTypeDropdown(),
                SizedBox(height: 24.h),

                // ── PHASE 04: BRIEFING ────────────────────────────────────
                _sectionLabel("PHASE_04: BRIEFING"),
                SizedBox(height: 10.h),
                _fieldLabel("EVENT_DETAILS_AND_REQUIREMENTS"),
                SizedBox(height: 6.h),
                _buildTextField(
                  controller: _briefingCtrl,
                  hint: "EXECUTE HIGH-INTENSITY TECHNICAL SEQUENCES...",
                  maxLines: 5,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? "Required" : null,
                ),
                SizedBox(height: 32.h),

                // ── Submit button ─────────────────────────────────────────
                GestureDetector(
                  onTap: _isSubmitting ? null : _onSubmit,
                  child: Container(
                    width: double.infinity,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: _isSubmitting
                          ? AppColors.yellow.withValues(alpha: 0.5)
                          : AppColors.yellow,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              "CREATE YOUR EVENT",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Banner Picker ──────────────────────────────────────────────────────────

  Widget _buildBannerPicker() {
    return GestureDetector(
      onTap: _pickBannerImage,
      child: Container(
        height: 160.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xff111111),
          borderRadius: BorderRadius.circular(8.r),
          image: _bannerImage != null
              ? DecorationImage(
                  image: FileImage(_bannerImage!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _bannerImage != null
            ? Stack(
                children: [
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.edit,
                            color: Colors.white70,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "CHANGE",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_photo_alternate_outlined,
                    color: Colors.white24,
                    size: 32,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "TAP TO UPLOAD BANNER",
                    style: TextStyle(
                      color: Colors.white24,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "RECOMMENDED: 16:9 RATIO",
                    style: TextStyle(
                      color: Colors.white12,
                      fontSize: 8.sp,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ── Mission Type Chips ─────────────────────────────────────────────────────

  Widget _buildMissionTypeSelector() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _missionTypes.map((type) {
        final isSelected = _missionType == type;
        return GestureDetector(
          onTap: () => setState(() => _missionType = type),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.yellow : Colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: isSelected ? AppColors.yellow : Colors.white24,
                width: 1,
              ),
            ),
            child: Text(
              type,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white54,
                fontSize: 9.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Circuit Dropdown ───────────────────────────────────────────────────────

  Widget _buildCircuitDropdown() {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }

        try {
          final query = Uri.encodeComponent(textEditingValue.text);
          final url =
              'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=${ApiUrl.mapKey}';

          final response = await http.get(Uri.parse(url));
          debugPrint("PLACES API STATUS: ${response.statusCode}");
          debugPrint("PLACES API BODY: ${response.body}");

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            if (data['status'] == 'OK') {
              final predictions = data['predictions'] as List;
              return predictions
                  .map((p) => p['description'].toString())
                  .toList();
            }
          }
        } catch (e) {
          debugPrint("PLACES API ERROR: $e");
        }

        return const Iterable<String>.empty();
      },
      onSelected: (String selection) {
        setState(() => _locationCircuit = selection);
        _locationCtrl.text = selection;
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        // Sync controllers if it's the first time
        if (_locationCtrl.text != controller.text &&
            controller.text.isEmpty &&
            _locationCtrl.text.isNotEmpty) {
          controller.text = _locationCtrl.text;
        }
        return _buildTextField(
          controller: controller,
          focusNode: focusNode,
          hint: "SEARCH CIRCUIT OR TYPE LOCATION",
          leading: const Icon(
            Icons.location_on_outlined,
            size: 14,
            color: Colors.white38,
          ),
          validator: (v) => v == null || v.trim().isEmpty ? "Required" : null,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width - 32.w,
              margin: EdgeInsets.only(top: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xff1C1C1C),
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: Colors.white12),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Access Type Dropdown ───────────────────────────────────────────────────

  Widget _buildAccessTypeDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, size: 14, color: Colors.white38),
          SizedBox(width: 8.w),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _accessType,
                dropdownColor: const Color(0xff1C1C1C),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white38,
                  size: 18,
                ),
                isExpanded: true,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
                items: const [
                  DropdownMenuItem(
                    value: "PUBLIC (OPEN TO ALL)",
                    child: Text("PUBLIC (OPEN TO ALL)"),
                  ),
                  DropdownMenuItem(value: "PRIVATE", child: Text("PRIVATE")),
                ],
                onChanged: (val) =>
                    setState(() => _accessType = val ?? _accessType),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tappable Field (date / time) ───────────────────────────────────────────

  Widget _buildTappableField({
    required Widget leading,
    required String label,
    required bool isEmpty,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: const Color(0xff111111),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            leading,
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: isEmpty ? Colors.white24 : Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Text Field ─────────────────────────────────────────────────────────────

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    Widget? leading,
    String? Function(String?)? validator,
    FocusNode? focusNode,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(
        color: Colors.white,
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
      validator: validator,
      cursorColor: AppColors.yellow,
      decoration: InputDecoration(
        prefixIcon: leading,
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white24,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        filled: true,
        fillColor: const Color(0xff111111),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: const BorderSide(color: AppColors.yellow, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        isDense: true,
      ),
    );
  }

  // ── Section label ──────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.yellow,
        fontSize: 8.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white38,
        fontSize: 8.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors/app_colors.dart';
import '../../../core/app_routes/app_routes.dart';
import '../../components/custom_appbar_speedring/custom_appbar_speedring.dart';
import '../../components/custom_button/custom_button.dart';
import '../../components/custom_gradient/custom_gradient.dart';
import '../../components/custom_text/custom_text.dart';

class CodeRequest extends StatelessWidget {
  const CodeRequest({super.key});

  static const int _codeLength = 6;

  @override
  Widget build(BuildContext context) {
    final List<TextEditingController> controllers = List.generate(
      _codeLength,
      (_) => TextEditingController(),
    );
    final List<FocusNode> focusNodes = List.generate(
      _codeLength,
      (_) => FocusNode(),
    );

    return CustomGradient(
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: const CustomAppBarSpeedring(),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 100),

                    /// ── EXCLUSIVE ACCESS label ──────────────────
                    const CustomText(
                      text: 'EXCLUSIVE ACCESS',
                      color: AppColors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.5,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    /// ── Main Heading ─────────────────────────────
                    const CustomText(
                      text: 'CLOSED BETA ACCESS',
                      color: Colors.yellow,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      textAlign: TextAlign.center,
                      height: 1.1,
                    ),

                    const SizedBox(height: 16),

                    /// ── Description ──────────────────────────────
                    const CustomText(
                      text:
                          'Enter your invite code to join the Speedring community and start your pro-license journey.',
                      color: Colors.white54,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      fontFamily: "Barlow",
                    ),

                    const SizedBox(height: 40),

                    /// ── PIN Input Boxes ───────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_codeLength, (index) {
                        return _CodeBox(
                          controller: controllers[index],
                          focusNode: focusNodes[index],
                          onChanged: (val) {
                            if (val.isNotEmpty && index < _codeLength - 1) {
                              focusNodes[index + 1].requestFocus();
                            }
                            if (val.isEmpty && index > 0) {
                              focusNodes[index - 1].requestFocus();
                            }
                          },
                        );
                      }),
                    ),

                    const SizedBox(height: 20),

                    /// ── Lock notice ──────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.lock_outline,
                          color: Colors.white38,
                          size: 14,
                        ),
                        SizedBox(width: 6),
                        CustomText(
                          text: 'Invite code required during beta phase.',
                          color: Colors.white38,
                          fontSize: 12,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    /// ── CONTINUE Button ──────────────────────────
                    CustomButton(
                      title: 'CONTINUE',
                      height: 56,
                      borderRadius: 30,
                      fillColor: AppColors.yellow,
                      textColor: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      onTap: () => Get.toNamed(AppRoutes.ageVerifyScreen),
                    ),

                    const SizedBox(height: 20),

                    /// ── Request Access link ──────────────────────
                    GestureDetector(
                      onTap: () {},
                      child: const CustomText(
                        text: 'Request Access',
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                        decoration: TextDecoration.underline,
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Single code input box
// ─────────────────────────────────────────────
class _CodeBox extends StatelessWidget {
  const _CodeBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: const Color(0xff1C1C1C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0,
        ),
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

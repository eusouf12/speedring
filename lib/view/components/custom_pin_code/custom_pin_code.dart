// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../utils/app_colors/app_colors.dart';

class CustomPinCode extends StatelessWidget {
  const CustomPinCode({
    super.key,
    required this.controller,
    this.onChanged,
    this.onCompleted,
    this.length = 6,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final int length;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: PinCodeTextField(
        keyboardType: TextInputType.number,
        appContext: context,
        length: length,
        enableActiveFill: true,
        animationType: AnimationType.fade,
        animationDuration: const Duration(milliseconds: 300),
        controller: controller,
        onChanged: onChanged ?? (_) {},
        onCompleted: onCompleted,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(8),
          fieldHeight: 55,
          fieldWidth: size.width * 0.12,
          inactiveColor: AppColors.grey_1,
          activeColor: AppColors.primary,
          activeFillColor: AppColors.white_50,
          inactiveFillColor: AppColors.white,
          selectedFillColor: AppColors.white_2,
          disabledColor: AppColors.white_50,
          selectedColor: AppColors.primary,
          borderWidth: 1.5,
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
    );
  }
}

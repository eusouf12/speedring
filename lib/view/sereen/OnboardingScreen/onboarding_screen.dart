import 'package:flutter/material.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/gallery.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: const Center(
            child: Text(
              'Onboarding Screen',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
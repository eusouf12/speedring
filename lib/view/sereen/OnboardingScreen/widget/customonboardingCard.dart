import 'dart:ui';
import 'package:flutter/material.dart';

class CustomOnboardingCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String title;
  final String description;

  const CustomOnboardingCard({
    super.key,
    required this.icon,
    required this.label,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 12,
          sigmaY: 12,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.35),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(.08),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Color(0xffF5C400),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 10,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    label.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xffF5C400),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(.75),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
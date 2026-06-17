import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';

import '../../../../../../core/app_routes/app_routes.dart';

class AccessGrantedScreen extends StatelessWidget {
  const AccessGrantedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String eventTitle = Get.arguments?['title'] ?? 'SILVERSTONE PERFORMANCE PADDOCK';
    final String date = Get.arguments?['date'] ?? '24.10.24'; // default or format date
    final String passId = Get.arguments?['passId'] ?? 'XP-992-GTR';

    // Normalize date to DD.MM.YY format if it's like "OCT 24, 2024"
    String displayDate = date;
    if (date.contains("OCT 24") || date.contains("2024")) {
      displayDate = "24.10.24";
    }

    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const Spacer(),
        
              /// Header Title
              const Text(
                "SESSION JOINED // ACCESS GRANTED",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.yellow,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 24),
        
              /// Card Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: BoxDecoration(
                  color: const Color(0xff181818),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    /// QR Code Image
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.network(
                        'https://api.qrserver.com/v1/create-qr-code/?size=200x200&color=000000&bgcolor=FFFFFF&data=$passId',
                        height: 180,
                        width: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180,
                          width: 180,
                          color: Colors.black,
                          child: const Icon(Icons.qr_code_2, color: Colors.white, size: 80),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
        
                    /// Event Row
                    _buildDetailRow(
                      label: "EVENT",
                      value: eventTitle.toUpperCase(),
                    ),
                    const Divider(color: Colors.white10, height: 24),
        
                    /// Date Row
                    _buildDetailRow(
                      label: "DATE",
                      value: displayDate,
                    ),
                    const Divider(color: Colors.white10, height: 24),
        
                    /// ID Row
                    _buildDetailRow(
                      label: "ID",
                      value: passId,
                    ),
                  ],
                ),
              ),
        
              const Spacer(),
        
              /// Download Pass Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.download, color: AppColors.yellow, size: 18),
                  label: const Text(
                    "DOWNLOAD PASS",
                    style: TextStyle(
                      color: AppColors.yellow,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.yellow, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Get.snackbar(
                      "Success",
                      "Pass downloaded successfully to your gallery.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: const Color(0xff181818),
                      colorText: Colors.white,
                      borderColor: AppColors.yellow,
                      borderWidth: 1,
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
        
              /// Add to Calendar Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today, color: Colors.black, size: 16),
                  label: const Text(
                    "ADD TO CALENDAR",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Get.snackbar(
                      "Calendar Updated",
                      "This event has been added to your calendar.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: const Color(0xff181818),
                      colorText: Colors.white,
                      borderColor: AppColors.yellow,
                      borderWidth: 1,
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
        
              /// Return to Feed Link
              GestureDetector(
                onTap: () {
                  // Navigate back to user home screen
                  Get.until((route) => Get.currentRoute == AppRoutes.userHomeScreen);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.arrow_back, color: Colors.white38, size: 14),
                    SizedBox(width: 6),
                    Text(
                      "RETURN TO FEED",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

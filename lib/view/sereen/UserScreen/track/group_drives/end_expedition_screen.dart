import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';

class EndExpeditionScreen extends StatelessWidget {
  const EndExpeditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),

              /// Logo Header & Live session badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(
                    "https://picsum.photos/seed/speedringlogo/130/40",
                    height: 24,
                    width: 90,
                    fit: BoxFit.contain,
                    errorBuilder: (context, _, _) => const Text(
                      "SPEEDRING",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.yellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "SESSION LIVE",
                        style: TextStyle(color: Colors.white70, fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(flex: 2),

              /// Large Title
              const Text(
                "END\nEXPEDITION?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.yellow,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "MIDNIGHT COAST RUN - SECTOR 04",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),

              /// Telemetry Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "TELEMETRY_SUMMARY",
                      style: TextStyle(
                        color: AppColors.yellow,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// Row 1
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("DISTANCE", style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text("42.8 KM", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("DURATION", style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text("00:42:10", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    /// Row 2
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("PARTICIPANTS", style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text("12 OPS", style: TextStyle(color: AppColors.yellow, fontSize: 18, fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("AVG SPEED", style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text("107 KM/H", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 12),

                    /// Footer details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "ENCRYPTION  AES-256 SECURE",
                          style: TextStyle(color: AppColors.yellow, fontSize: 7, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "LOG ID #SR-9921-X",
                          style: TextStyle(color: Colors.white38, fontSize: 7, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),

              /// Confirm and cancel buttons
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed(AppRoutes.shareExpeditionScreen);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "CONFIRM END TRIP",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text(
                    "CANCEL",
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

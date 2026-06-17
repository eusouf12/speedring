import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import 'package:speedring/view/components/custom_gradient/custom_gradient.dart';

class LiveSessionScreen extends StatefulWidget {
  const LiveSessionScreen({super.key});

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 16),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "LIVE SESSION",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          leadingWidth: 150,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white70),
              onPressed: () {},
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const Spacer(flex: 1),
      
              /// 1. Speed display
              const Text(
                "CURRENT VELOCITY",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: const [
                  Text(
                    "235",
                    style: TextStyle(
                      color: AppColors.yellow,
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "KM/H",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
      
              /// 2. Timer Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xff111111),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.timer_outlined, color: AppColors.yellow, size: 14),
                    SizedBox(width: 8),
                    Text(
                      "00:42:18.6",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
      
              /// 3. Wavy Track Path Graphic
              SizedBox(
                height: 100,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: TrackWavyPainter(progress: 0.68),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 10,
                      child: Column(
                        children: const [
                          Text(
                            "START",
                            style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Icon(Icons.circle, color: Colors.white24, size: 6),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 10,
                      child: Column(
                        children: const [
                          Text(
                            "FINISH",
                            style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Icon(Icons.circle_outlined, color: Colors.white24, size: 6),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
      
              /// 4. Stats Grid
              Row(
                children: [
                  Expanded(child: _buildGridItem("TIME", "00:42:15")),
                  const SizedBox(width: 12),
                  Expanded(child: _buildGridItem("DISTANCE", "114.2 KM")),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildGridItem("SPEED", "192 AVG")),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xff111111),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "PROGRESS",
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "68%",
                                style: TextStyle(
                                  color: AppColors.yellow,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          LinearProgressIndicator(
                            value: 0.68,
                            backgroundColor: Colors.white12,
                            color: AppColors.yellow,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(flex: 2),
      
              /// 5. FINISH SESSION button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => Get.toNamed(AppRoutes.driveSummaryScreen),
                  child: const Text(
                    "FINISH SESSION",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff111111),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter to draw the wavy path and the dot
class TrackWavyPainter extends CustomPainter {
  final double progress;

  TrackWavyPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final progressPaint = Paint()
      ..color = AppColors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final dotPaint = Paint()
      ..color = AppColors.yellow
      ..style = PaintingStyle.fill;

    final path = Path();
    // Starting point offset from text
    path.moveTo(0, size.height / 2);
    // Draw bezier curves representing wavy circuit line
    path.cubicTo(
      size.width * 0.25,
      size.height * 0.1,
      size.width * 0.45,
      size.height * 0.9,
      size.width * 0.65,
      size.height * 0.2,
    );
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.0,
      size.width * 0.9,
      size.height * 0.5,
      size.width,
      size.height / 2,
    );

    canvas.drawPath(path, paint);

    // Compute metrics to find dot coordinates and draw active yellow path
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      final activePath = metric.extractPath(0, metric.length * progress);
      canvas.drawPath(activePath, progressPaint);

      final tangent = metric.getTangentForOffset(metric.length * progress);
      if (tangent != null) {
        // Draw the current car position indicator
        canvas.drawCircle(tangent.position, 6, dotPaint);
        // Draw glow
        canvas.drawCircle(
          tangent.position,
          12,
          Paint()..color = AppColors.yellow.withValues(alpha:0.25)..style = PaintingStyle.fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

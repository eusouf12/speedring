import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';

class DriveSummaryScreen extends StatelessWidget {
  const DriveSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Image.network(
          "https://picsum.photos/seed/speedringlogo/130/40",
          height: 30,
          width: 100,
          fit: BoxFit.contain,
          errorBuilder: (context, _, __) => const Text(
            "SPEEDRING",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 24),
            onPressed: () => Get.offAllNamed(AppRoutes.userHomeScreen),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),

            /// 1. Drive Score Ring (Custom circular layout)
            Center(
              child: SizedBox(
                width: 180,
                height: 180,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CircularProgressIndicator(
                        value: 0.94,
                        strokeWidth: 4,
                        backgroundColor: Colors.white10,
                        color: AppColors.yellow,
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "DRIVE SCORE",
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: const [
                              Text(
                                "94",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                "/100",
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.yellow.withOpacity(0.4), width: 1),
                            ),
                            child: const Text(
                              "ELITE PERFORMANCE",
                              style: TextStyle(
                                color: AppColors.yellow,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            /// 2. Grid stats
            Row(
              children: [
                Expanded(child: _buildStatCard(Icons.access_time_filled, "TIME", "00:45:12")),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(Icons.social_distance, "DISTANCE", "124.5 KM")),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatCard(Icons.flash_on, "TOP SPEED", "294 KM/H")),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(Icons.speed, "AVG SPEED", "186 KM/H")),
              ],
            ),
            const SizedBox(height: 20),

            /// 3. SESSION TRACK CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SESSION TRACK",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: TrackPathStaticPainter(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.circle, color: AppColors.yellow, size: 6),
                      const SizedBox(width: 4),
                      const Text("START", style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      const Icon(Icons.circle, color: Colors.white70, size: 6),
                      const SizedBox(width: 4),
                      const Text("END", style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// 4. SPEED OVER TIME CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff111111),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "SPEED OVER TIME",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        "PEAK 294 KM/H",
                        style: TextStyle(
                          color: AppColors.yellow,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: SpeedGraphPainter(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("0:00", style: TextStyle(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.bold)),
                      Text("15:00", style: TextStyle(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.bold)),
                      Text("30:00", style: TextStyle(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.bold)),
                      Text("45:12", style: TextStyle(color: Colors.white24, fontSize: 9, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            /// 5. SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  Get.offAllNamed(AppRoutes.userHomeScreen);
                  Get.snackbar(
                    "Session Saved",
                    "Your track session was successfully saved in your garage log.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xff181818),
                    colorText: Colors.white,
                    borderColor: AppColors.yellow,
                    borderWidth: 1,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "SAVE",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// SHARE RESULTS LINK
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined, color: Colors.white38, size: 14),
                label: const Text(
                  "SHARE RESULTS",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value) {
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
          Row(
            children: [
              Icon(icon, color: AppColors.yellow, size: 12),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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

/// Static Painter for Wavy Track Map Path
class TrackPathStaticPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path();
    path.moveTo(size.width * 0.1, size.height / 2);
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
      size.width * 0.9,
      size.height / 2,
    );

    canvas.drawPath(path, paint);

    // Draw Start (yellow) and End (white) points
    canvas.drawCircle(Offset(size.width * 0.1, size.height / 2), 5, Paint()..color = AppColors.yellow);
    canvas.drawCircle(Offset(size.width * 0.9, size.height / 2), 5, Paint()..color = Colors.white70);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Painter to render the speed over time graph
class SpeedGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgGridPaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = AppColors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // Draw horizontal grid lines
    for (int i = 1; i <= 3; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), bgGridPaint);
    }

    final path = Path();
    final points = [
      Offset(0, size.height * 0.85),
      Offset(size.width * 0.1, size.height * 0.75),
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.35, size.height * 0.45),
      Offset(size.width * 0.45, size.height * 0.5),
      Offset(size.width * 0.55, size.height * 0.38),
      Offset(size.width * 0.65, size.height * 0.52),
      Offset(size.width * 0.75, size.height * 0.48),
      Offset(size.width * 0.85, size.height * 0.62),
      Offset(size.width * 0.92, size.height * 0.58),
      Offset(size.width, size.height * 0.3),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    // Draw graph gradient fill under path
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.yellow.withOpacity(0.25), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

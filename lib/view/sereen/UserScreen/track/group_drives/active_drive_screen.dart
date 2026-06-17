import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import '../widgets/track_appbar.dart';

class ActiveDriveScreen extends StatelessWidget {
  const ActiveDriveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: TrackAppBar(
        title: "MIDNIGHT COAST RUN",
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
          onPressed: () => Get.back(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.yellow, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
                  "LIVE TELEMETRY",
                  style: TextStyle(color: AppColors.yellow, fontSize: 8, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          /// Background Topo Map CustomPainter
          Positioned.fill(
            child: CustomPaint(
              painter: _TopoMapPainter(),
            ),
          ),

          /// Driver Avatars Nodes Overlay on Map
          const Positioned(
            top: 280,
            left: 140,
            child: _DriverNode(
              label: "LEADER",
              avatarUrl: "https://picsum.photos/seed/leaderavatar/100/100",
              isLeader: true,
            ),
          ),
          const Positioned(
            top: 350,
            left: 110,
            child: _DriverNode(
              avatarUrl: "https://picsum.photos/seed/driver2node/100/100",
              isLeader: false,
            ),
          ),
          const Positioned(
            top: 420,
            left: 90,
            child: _DriverNode(
              avatarUrl: "https://picsum.photos/seed/driver3node/100/100",
              isLeader: false,
            ),
          ),

          /// Top Metrics Grid
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(child: _buildMetricCard("CURR SPEED", "184", "KM/H", isHighlighted: true)),
                const SizedBox(width: 16),
                Expanded(child: _buildMetricCard("DISTANCE", "42.8", "KM", isHighlighted: false)),
              ],
            ),
          ),

          /// Map Control Floating Buttons (Chat, Mic, Target)
          Positioned(
            bottom: 100,
            right: 16,
            child: Column(
              children: [
                _buildMapFloatingButton(Icons.chat_bubble_outline),
                const SizedBox(height: 12),
                _buildMapFloatingButton(Icons.mic_none_outlined),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.yellow.withValues(alpha:0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.my_location, color: Colors.black, size: 22),
                  ),
                ),
              ],
            ),
          ),

          /// Bottom Actions Row
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "PAUSE TRACKING",
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppColors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: AppColors.yellow, width: 1.5),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => Get.toNamed(AppRoutes.endExpeditionScreen),
                      child: const Text(
                        "END TRIP",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, String unit, {required bool isHighlighted}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xff111111).withValues(alpha:0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: isHighlighted ? AppColors.yellow : Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapFloatingButton(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xff111111).withValues(alpha:0.9),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white10),
      ),
      child: Icon(icon, color: Colors.white70, size: 20),
    );
  }
}

class _DriverNode extends StatelessWidget {
  final String? label;
  final String avatarUrl;
  final bool isLeader;

  const _DriverNode({
    this.label,
    required this.avatarUrl,
    required this.isLeader,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label!,
              style: const TextStyle(color: Colors.black, fontSize: 7, fontWeight: FontWeight.w900),
            ),
          ),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: isLeader ? AppColors.yellow : Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: (isLeader ? AppColors.yellow : Colors.white).withValues(alpha:0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
            image: DecorationImage(
              image: NetworkImage(avatarUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class _TopoMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha:0.02)
      ..strokeWidth = 0.5;

    const double gridSpacing = 25.0;
    for (double i = 0; i < size.width; i += gridSpacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += gridSpacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // Topo contours
    final contourPaint = Paint()
      ..color = Colors.white.withValues(alpha:0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final Path topoPath1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.2, size.width * 0.6, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.6, size.width, size.height * 0.55);

    final Path topoPath2 = Path()
      ..moveTo(0, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.3, size.width * 0.6, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.7, size.width, size.height * 0.65);

    final Path topoPath3 = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.4, size.width * 0.6, size.height * 0.6)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.8, size.width, size.height * 0.75);

    canvas.drawPath(topoPath1, contourPaint);
    canvas.drawPath(topoPath2, contourPaint);
    canvas.drawPath(topoPath3, contourPaint);

    // Active Route Path
    final routePaint = Paint()
      ..color = AppColors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final routeShadowPaint = Paint()
      ..color = AppColors.yellow.withValues(alpha:0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    final Path mainRoute = Path()
      ..moveTo(size.width * 0.1, size.height * 0.8)
      ..lineTo(size.width * 0.2, size.height * 0.65)
      ..cubicTo(size.width * 0.25, size.height * 0.55, size.width * 0.45, size.height * 0.45, size.width * 0.4, size.height * 0.35)
      ..cubicTo(size.width * 0.35, size.height * 0.25, size.width * 0.7, size.height * 0.2, size.width * 0.8, size.height * 0.1);

    canvas.drawPath(mainRoute, routeShadowPaint);
    canvas.drawPath(mainRoute, routePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

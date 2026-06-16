import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';
import 'package:speedring/core/app_routes/app_routes.dart';
import '../widgets/track_appbar.dart';

class TripLobbyScreen extends StatelessWidget {
  const TripLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: TrackAppBar(
        title: "TRIP LOBBY",
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Parallax Header Image with Countdown Timer
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://images.unsplash.com/photo-1511919884226-fd3cad34687c?w=800&auto=format&fit=crop"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black, Colors.transparent, Colors.black87],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: Column(
                    children: [
                      const Text(
                        "COMMENCING IN",
                        style: TextStyle(
                          color: AppColors.yellow,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: const [
                          Text(
                            "00:42:12",
                            style: TextStyle(
                              color: AppColors.yellow,
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "T-MINUS",
                            style: TextStyle(
                              color: AppColors.yellow,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  /// PHASE 01 // INTEL
                  _buildSectionHeader("PHASE 01 // INTEL"),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xff111111),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "MIDNIGHT COAST RUN",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: const [
                            Icon(Icons.star, color: AppColors.yellow, size: 12),
                            SizedBox(width: 4),
                            Text(
                              "HOST: ",
                              style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "@COMMANDER_ALPHA",
                              style: TextStyle(color: AppColors.yellow, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        /// Stats Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 2.2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          children: [
                            _buildGridStat("DATE", "OCT 24"),
                            _buildGridStat("START TIME", "22:00 PST"),
                            _buildGridStat("DISTANCE", "142 KM"),
                            _buildGridStat("MEETING PT", "NEPTUNE'S"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// PHASE 02 // CONVOY
                  _buildSectionHeader("PHASE 02 // CONVOY"),
                  Container(
                    width: double.infinity,
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
                          children: [
                            const Text(
                              "CONVOY STATUS",
                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Text.rich(
                              TextSpan(
                                children: const [
                                  TextSpan(
                                    text: "12 / 28 ",
                                    style: TextStyle(color: AppColors.yellow, fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: "DRIVERS JOINED",
                                    style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              style: TextStyle(fontSize: 10.sp),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        /// Joined Drivers Avatars
                        Row(
                          children: [
                            _buildAvatar("https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&fit=crop"),
                            const SizedBox(width: 6),
                            _buildAvatar("https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=100&fit=crop"),
                            const SizedBox(width: 6),
                            _buildAvatar("https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&fit=crop"),
                            const SizedBox(width: 6),
                            _buildAvatar("https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&fit=crop"),
                            const SizedBox(width: 6),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: Color(0xff222222),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "+8",
                                style: TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "PENDING INVITATIONS (2)",
                          style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        _buildPendingInvite("@GHOST_RIDER_99"),
                        const SizedBox(height: 8),
                        _buildPendingInvite("@VALKYRIE_P1"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// TACTICAL ROUTE MAP
                  Container(
                    width: double.infinity,
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
                              "TACTICAL ROUTE MAP",
                              style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.fullscreen, color: Colors.white70, size: 20),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "PACIFIC COAST HIGHWAY | SECTOR 04",
                          style: TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),

                        /// styled wireframe map box
                        Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white.withOpacity(0.05)),
                            image: const DecorationImage(
                              image: NetworkImage("https://images.unsplash.com/photo-1518770660439-4636190af475?w=600&fit=crop"),
                              fit: BoxFit.cover,
                              opacity: 0.3,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "WAYPOINT 01",
                                      style: TextStyle(color: AppColors.yellow, fontSize: 7, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "34.0259° N, 118.7797° W",
                                      style: TextStyle(color: Colors.white70, fontSize: 8, fontFamily: "monospace"),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "ELEVATION",
                                      style: TextStyle(color: Colors.white38, fontSize: 7, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "1520 MSL",
                                      style: TextStyle(color: Colors.white70, fontSize: 8, fontFamily: "monospace"),
                                    ),
                                  ],
                                ),
                              ),
                              CustomPaint(
                                painter: _WireframePainter(),
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// COMMAND
                  _buildSectionHeader("COMMAND"),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Get.toNamed(AppRoutes.activeDriveScreen),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.play_arrow, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "START TRIP",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCommandButton("INVITE MEMBERS", Icons.person_add_alt_1_outlined),
                  const SizedBox(height: 10),
                  _buildCommandButton("EDIT TRIP DETAILS", Icons.edit_outlined),
                  const SizedBox(height: 10),
                  _buildCommandButton("SHARE INVITE LINK", Icons.share_outlined),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        "CANCEL TRIP ARCHIVE",
                        style: TextStyle(
                          color: Color(0xffF0294A),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.yellow,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildGridStat(String label, String val) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            val,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String url) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.yellow, width: 1),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildPendingInvite(String user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          user,
          style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xff222222),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            "AWAITING",
            style: TextStyle(color: Colors.white30, fontSize: 8, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _buildCommandButton(String label, IconData icon) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff1d1d1d),
          foregroundColor: Colors.white70,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _WireframePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const double gridSpacing = 20.0;
    for (double i = 0; i < size.width; i += gridSpacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += gridSpacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

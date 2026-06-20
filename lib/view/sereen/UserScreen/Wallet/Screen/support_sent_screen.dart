import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speedring/view/components/custom_royel_appbar/custom_royel_appbar.dart';
import '../../../../components/custom_gradient/custom_gradient.dart';
import '../../../../components/custom_text/custom_text.dart';
import '../widgets/support_stat_card.dart';
import '../widgets/supported_driver_card.dart';
import '../widgets/dossier_list_item.dart';

class SupportSentScreen extends StatelessWidget {
  const SupportSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomGradient(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomRoyelAppbar(leftIcon: true, titleName: "SUPPORT SENT"),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                // Stat cards
                Row(
                  children: [
                    const SupportStatCard(
                      label: "TOTAL CONTRIBUTIONS",
                      value: "€1,240.50",
                    ),
                    SizedBox(width: 12.w),
                    const SupportStatCard(
                      label: "MONTHLY VELOCITY",
                      value: "€185.00",
                      trend: "+12%",
                    ),
                  ],
                ),
                SizedBox(height: 28.h),

                // Section 1: Most Supported Drivers
                CustomText(
                  text: "MOST SUPPORTED DRIVERS",
                  color: Colors.white38,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 130.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      SupportedDriverCard(
                        avatarUrl:
                            "https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=100&fit=crop",
                        driverName: "MAX VERSTAPPEN",
                        supportAmount: "€450",
                      ),
                      SupportedDriverCard(
                        avatarUrl:
                            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&fit=crop",
                        driverName: "LEWIS HAMILTON",
                        supportAmount: "€320",
                      ),
                      SupportedDriverCard(
                        avatarUrl:
                            "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&fit=crop",
                        driverName: "CHARLES LECLERC",
                        supportAmount: "€215",
                      ),
                      SupportedDriverCard(
                        avatarUrl:
                            "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&fit=crop",
                        driverName: "LANDO NORRIS",
                        supportAmount: "€180",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28.h),

                // Section 2: Transaction Dossier
                CustomText(
                  text: "TRANSACTION DOSSIER",
                  color: Colors.white38,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                SizedBox(height: 14.h),
                const DossierListItem(
                  avatarUrl:
                      "https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=100&fit=crop",
                  driverName: "MAX VERSTAPPEN",
                  username: "@verstappen_official",
                  amount: "-€15.00",
                  date: "24 OCT 2023",
                  message:
                      "Dialing in the aero today for the qualifying run. Thanks for the boost!",
                ),
                const DossierListItem(
                  avatarUrl:
                      "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&fit=crop",
                  driverName: "LANDO NORRIS",
                  username: "@lando_n4",
                  amount: "-€50.00",
                  date: "22 OCT 2023",
                  message:
                      "Tire degradation telemetry looks solid. Full send on the softs tomorrow.",
                ),
                const DossierListItem(
                  avatarUrl:
                      "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=100&fit=crop",
                  driverName: "OSCAR PIASTRI",
                  username: "@oscarp_official",
                  amount: "-€25.00",
                  date: "19 OCT 2023",
                  message:
                      "Brake balance adjustments complete. The data entry helps refine the curve.",
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

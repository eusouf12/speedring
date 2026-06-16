import 'package:flutter/material.dart';

/// একটি track এর live stats দেখায় এবং track mode এ enter করার option দেয়।
class TrackModeCard extends StatelessWidget {
  const TrackModeCard({
    super.key,
    required this.trackName,
    required this.liveDrivers,
    required this.trackTemp,
    required this.bestTime,
    this.onEnterTrackMode,
  });

  final String trackName;
  final String liveDrivers;
  final String trackTemp;
  final String bestTime;
  final VoidCallback? onEnterTrackMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff1C1C1C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          /// Track Name + Map Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                trackName.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              const Icon(Icons.map, color: Colors.amber),
            ],
          ),

          const SizedBox(height: 20),

          /// Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TrackInfo(liveDrivers, "LIVE DRIVERS"),
              _TrackInfo(trackTemp, "TRACK TEMP"),
              _TrackInfo(bestTime, "BEST TODAY"),
            ],
          ),

          const SizedBox(height: 20),

          /// CTA Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onEnterTrackMode,
              child: const Text(
                "ENTER TRACK MODE",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal stat tile
class _TrackInfo extends StatelessWidget {
  final String value;
  final String label;

  const _TrackInfo(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
      ],
    );
  }
}

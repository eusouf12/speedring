import 'package:flutter/material.dart';

/// Sponsored / Advertisement card — feed এর মাঝে দেখানো হয়।
class SponsoredCard extends StatelessWidget {
  const SponsoredCard({
    super.key,
    required this.brandName,
    required this.description,
    required this.imageUrl,
    this.ctaLabel = "EXPLORE NOW",
    this.onCtaTap,
  });

  final String brandName;
  final String description;
  final String imageUrl;
  final String ctaLabel;
  final VoidCallback? onCtaTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff1C1C1C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// "SPONSORED" label
          Row(
            children: [
              const Icon(Icons.bolt, color: Colors.amber, size: 14),
              const SizedBox(width: 4),
              Text(
                "SPONSORED",
                style: TextStyle(
                  color: Colors.amber.shade700,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Brand Name
          Text(
            brandName.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 6),

          /// Description
          Text(
            description,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          /// Banner Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 16),

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
              onPressed: onCtaTap,
              child: Text(
                ctaLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

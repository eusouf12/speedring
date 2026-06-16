import 'package:flutter/material.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PostDetailScreen — Static data, no constructor params
// ─────────────────────────────────────────────────────────────────────────────

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key});

  // ── Static data ────────────────────────────────────────────────────────────
  static const String _userName = "MAX_VERSTAPPEN_33";
  static const String _subTitle = "RED BULL RB20";
  static const List<String> _imageUrls = [
    "https://picsum.photos/seed/f1spa/600/400",
    "https://picsum.photos/seed/f1race/600/400",
    "https://picsum.photos/seed/f1pit/600/400",
  ];
  static const String _caption =
      "Pushing the limits at Spa. The aero balance feels incredible through Eau Rouge. #Speedring #F1 #Motorsport #Spa";
  static const String _location = "Spa-Francorchamps";
  static const String _carSpec = "2024 F1 Technical Specification";
  static const String _likeCount = "12.4k";
  static const String _commentCount = "482";
  static const bool _isVerified = true;
  static const List<_ProfileData> _similarProfiles = [
    _ProfileData(
      name: "Lando_Norris",
      team: "McLaren F1 Team",
      imageUrl: "https://picsum.photos/seed/lando/200",
    ),
    _ProfileData(
      name: "Charles_Leclerc",
      team: "Scuderia Ferrari",
      imageUrl: "https://picsum.photos/seed/charles/200",
    ),
    _ProfileData(
      name: "Lewis_Hamilton",
      team: "Mercedes AMG",
      imageUrl: "https://picsum.photos/seed/lewis/200",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111111),
      body: CustomScrollView(
        slivers: [
          /// ── App bar ──────────────────────────────────────────────────
          SliverAppBar(
            backgroundColor: const Color(0xff111111),
            elevation: 0,
            pinned: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            title: const Text(
              "DETAILS",
              style: TextStyle(
                color: AppColors.yellow,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            centerTitle: true,
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ── Image Carousel ───────────────────────────────────
                const _ImageCarousel(imageUrls: _imageUrls),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// ── User info row ──────────────────────────────
                      Row(
                        children: [
                          /// Avatar
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.yellow,
                                width: 1.5,
                              ),
                            ),
                            child: const ClipOval(
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                          ),

                          const SizedBox(width: 10),

                          /// Name + subtitle
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _userName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    if (_isVerified) ...[
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.verified,
                                        color: AppColors.yellow,
                                        size: 14,
                                      ),
                                    ],
                                  ],
                                ),
                                SizedBox(height: 2),
                                Text(
                                  _subTitle,
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// More options
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      /// ── Caption ──────────────────────────────────
                      const _CaptionText(caption: _caption),

                      const SizedBox(height: 14),

                      /// ── Location + Spec pills ────────────────────
                      const Row(
                        children: [
                          _InfoPill(
                            icon: Icons.location_on_outlined,
                            label: _location,
                          ),
                          SizedBox(width: 12),
                          _InfoPill(
                            icon: Icons.directions_car_outlined,
                            label: _carSpec,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// ── Engagement row ───────────────────────────
                      Row(
                        children: [
                          const _LikeButton(likeCount: _likeCount),

                          const SizedBox(width: 20),

                          GestureDetector(
                            onTap: () {},
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  _commentCount,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.share_outlined,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      /// ── Similar Profiles ─────────────────────────
                      const Text(
                        "SIMILAR PROFILES",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 160,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _similarProfiles.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (_, i) =>
                              _SimilarProfileCard(profile: _similarProfiles[i]),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal data class (const-capable)
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileData {
  final String name;
  final String team;
  final String? imageUrl;

  const _ProfileData({
    required this.name,
    required this.team,
    this.imageUrl,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// _ImageCarousel — নিজস্ব page index state manage করে
// ─────────────────────────────────────────────────────────────────────────────

class _ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const _ImageCarousel({required this.imageUrls});

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            itemCount: widget.imageUrls.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (_, i) => Image.network(
              widget.imageUrls[i],
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xff1C1C1C),
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.white24,
                  size: 48,
                ),
              ),
            ),
          ),
        ),

        /// Dot indicators
        if (widget.imageUrls.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.imageUrls.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _currentIndex ? 22 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: i == _currentIndex
                        ? AppColors.yellow
                        : Colors.white38,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _LikeButton — নিজস্ব liked state manage করে
// ─────────────────────────────────────────────────────────────────────────────

class _LikeButton extends StatefulWidget {
  final String likeCount;

  const _LikeButton({required this.likeCount});

  @override
  State<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<_LikeButton> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isLiked = !_isLiked),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(_isLiked),
              color: _isLiked ? Colors.red : Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            widget.likeCount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CaptionText — hashtag গুলো yellow করে highlight করে
// ─────────────────────────────────────────────────────────────────────────────

class _CaptionText extends StatelessWidget {
  final String caption;

  const _CaptionText({required this.caption});

  @override
  Widget build(BuildContext context) {
    final words = caption.split(' ');
    return RichText(
      text: TextSpan(
        children: words.map((word) {
          final isHashtag = word.startsWith('#');
          return TextSpan(
            text: '$word ',
            style: TextStyle(
              color: isHashtag ? AppColors.yellow : Colors.white,
              fontSize: 13.5,
              height: 1.55,
              fontWeight: isHashtag ? FontWeight.w600 : FontWeight.normal,
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _InfoPill — location / car spec row
// ─────────────────────────────────────────────────────────────────────────────

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white38, size: 14),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class _SimilarProfileCard extends StatefulWidget {
  final _ProfileData profile;

  const _SimilarProfileCard({required this.profile});

  @override
  State<_SimilarProfileCard> createState() => _SimilarProfileCardState();
}

class _SimilarProfileCardState extends State<_SimilarProfileCard> {
  bool _following = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: const Color(0xff1C1C1C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.yellow, width: 1.5),
            ),
            child: ClipOval(
              child: widget.profile.imageUrl != null
                  ? Image.network(
                      widget.profile.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.person, color: Colors.white),
            ),
          ),

          const SizedBox(height: 8),

          /// Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.profile.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: 2),

          /// Team
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.profile.team.toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 9,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// Follow button
          GestureDetector(
            onTap: () => setState(() => _following = !_following),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                color: _following ? Colors.white12 : AppColors.yellow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  _following ? "FOLLOWING" : "FOLLOW",
                  style: TextStyle(
                    color: _following ? Colors.white60 : Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

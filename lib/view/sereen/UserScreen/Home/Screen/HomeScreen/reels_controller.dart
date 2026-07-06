import 'dart:io';
import 'package:get/get.dart';

class ReelsController extends GetxController {
  final RxList<Map<String, dynamic>> reels = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Seed with initial high-fidelity reels matching the theme of Speedring (racing, cars, motorsport)
    reels.addAll([
      {
        'username': 'OCTANE_ELITE',
        'avatar': 'https://picsum.photos/seed/avatar2/100/100',
        'videoUrl': '',
        'imageUrl':
            'https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=800&fit=crop',
        'caption':
            'Midnight runs on Monaco streets. The sound of twin turbos! 🏎️💨 #Chiron #Monaco #Supercar',
        'musicName': 'Hypercar Symphony - Night Edition',
        'likes': 9200,
        'comments': 412,
        'shares': 1500,
        'isLiked': true,
        'isBookmarked': true,
      },
      {
        'username': 'M3_COMPETITION',
        'avatar': 'https://picsum.photos/seed/avatar1/100/100',
        'videoUrl': '',
        'imageUrl':
            'https://images.unsplash.com/photo-1614162692292-7ac56d7f7f1e?w=800&fit=crop',
        'caption':
            'Drifting through the Nürburgring GP track! #M3 #Drift #Speedring',
        'musicName': 'Original Sound - BMW M3 V8',
        'likes': 1248,
        'comments': 84,
        'shares': 312,
        'isLiked': false,
        'isBookmarked': false,
      },
      {
        'username': 'APEX_HUNTER',
        'avatar': 'https://picsum.photos/seed/avatar3/100/100',
        'videoUrl': '',
        'imageUrl':
            'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800&fit=crop',
        'caption':
            'Early morning track day session at Silverstone. Hit 280+ km/h! #Silverstone #TrackDay',
        'musicName': 'V10 Screamer - F1 Legacy',
        'likes': 3450,
        'comments': 192,
        'shares': 560,
        'isLiked': false,
        'isBookmarked': false,
      },
    ]);
  }

  void addReel({
    required String username,
    required String caption,
    required String musicName,
    required File? videoFile,
  }) {
    reels.insert(0, {
      'username': username,
      'avatar': 'https://picsum.photos/seed/user_avatar/100/100',
      'videoUrl': videoFile?.path ?? '',
      'videoFile': videoFile,
      'imageUrl':
          'https://images.unsplash.com/photo-1544829099-b9a0c07fad1a?w=800&fit=crop', // Custom placeholder representing a uploaded video
      'caption': caption,
      'musicName': musicName.isNotEmpty
          ? musicName
          : 'Original Sound - $username',
      'likes': 0,
      'comments': 0,
      'shares': 0,
      'isLiked': false,
      'isBookmarked': false,
    });
  }

  void toggleLike(int index) {
    var reel = Map<String, dynamic>.from(reels[index]);
    reel['isLiked'] = !(reel['isLiked'] as bool);
    reel['likes'] = (reel['likes'] as int) + (reel['isLiked'] ? 1 : -1);
    reels[index] = reel;
  }

  void toggleBookmark(int index) {
    var reel = Map<String, dynamic>.from(reels[index]);
    reel['isBookmarked'] = !(reel['isBookmarked'] as bool);
    reels[index] = reel;
  }
}

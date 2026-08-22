import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:speedring/service/api_url.dart';

class MapSnapHelper {
  /// Snaps raw GPS coordinates to the road network using the Google Roads API.
  /// Falls back to the original coordinates if the API request fails.
  static Future<List<LatLng>> snapToRoads(List<LatLng> points) async {
    if (points.isEmpty) return points;

    List<LatLng> snappedPoints = [];

    // The Roads API accepts up to 100 points per request.
    // We split our points list into chunks of 100.
    const int chunkSize = 100;
    for (int i = 0; i < points.length; i += chunkSize) {
      int end = (i + chunkSize < points.length) ? i + chunkSize : points.length;
      List<LatLng> chunk = points.sublist(i, end);

      // Format paths parameter: lat1,lng1|lat2,lng2|...
      String pathString = chunk
          .map((p) => "${p.latitude},${p.longitude}")
          .join('|');

      final url = Uri.parse(
        "https://roads.googleapis.com/v1/snapToRoads?path=$pathString&interpolate=true&key=${ApiUrl.mapKey}",
      );

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['snappedPoints'] != null) {
            for (var snapped in data['snappedPoints']) {
              final loc = snapped['location'];
              if (loc != null && loc['latitude'] != null && loc['longitude'] != null) {
                snappedPoints.add(
                  LatLng(loc['latitude'] as double, loc['longitude'] as double),
                );
              }
            }
          }
        } else {
          // Fallback to original points if API fails or rate-limits
          snappedPoints.addAll(chunk);
        }
      } catch (e) {
        debugPrint("Roads API error: $e");
        // Fallback to original points on network failure
        snappedPoints.addAll(chunk);
      }
    }

    return snappedPoints.isNotEmpty ? snappedPoints : points;
  }
}

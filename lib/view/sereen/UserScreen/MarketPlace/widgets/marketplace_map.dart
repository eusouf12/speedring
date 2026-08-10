import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MarketplaceMap extends StatefulWidget {
  final String location;

  const MarketplaceMap({super.key, required this.location});

  @override
  State<MarketplaceMap> createState() => _MarketplaceMapState();
}

class _MarketplaceMapState extends State<MarketplaceMap> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  LatLng? location;

  @override
  void initState() {
    super.initState();
    loadLocation();
  }

  Future<void> loadLocation() async {
    final coordinates = await getCoordinates(widget.location);

    if (coordinates == null) return;

    if (mounted) {
      setState(() {
        location = coordinates;

        markers = {
          Marker(
            markerId: const MarkerId('marketplace_location'),
            position: coordinates,
            infoWindow: InfoWindow(title: widget.location),
          ),
        };
      });
    }
  }

  Future<LatLng?> getCoordinates(String address) async {
    try {
      final locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      debugPrint("Location error: $e");
    }

    return null;
  }

  Future<void> _openMap() async {
    if (location == null) return;
    final lat = location!.latitude;
    final lng = location!.longitude;
    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not open map app');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (location == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      );
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: location!, zoom: 12),
      markers: markers,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      onTap: (_) => _openMap(),
      onMapCreated: (controller) {
        mapController = controller;
      },
    );
  }
}

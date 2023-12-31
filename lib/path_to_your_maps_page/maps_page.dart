import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps Page'),
        backgroundColor: Colors.black,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(0.0, 0.0), // Initial map location (change as needed)
          zoom: 15.0,
        ),
        markers: markers,
        onTap: _onMapTap,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onMapTap(LatLng position) {
    // Clear existing markers
    setState(() {
      markers.clear();
      // Add a new marker at the tapped position
      markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: const InfoWindow(
            title: 'Pinned Location',
          ),
        ),
      );
    });

    // You can also get the address for the tapped position using geocoding services
    // For example, you can use the 'geocoding' package.
    // Note: You need to add the 'geocoding' package to your pubspec.yaml file.
    // After adding, run 'flutter pub get' to fetch the package.

    // ReverseGeocodingResult result = await reverseGeocoding(position.latitude, position.longitude);
    // String address = result.formattedAddress;
    // print('Address: $address');
  }
}

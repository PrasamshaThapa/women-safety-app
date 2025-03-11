import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../constants/app_colors.dart';

class MapPage extends StatefulWidget {
  final List<double> locationAddress;
  final String locationName;
  const MapPage({
    super.key,
    required this.locationAddress,
    required this.locationName,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _locationLatLng;
  List<Marker> _markers = [];
  final MapController _mapController = MapController();
  bool _isMapInitialized = false;

  @override
  void initState() {
    super.initState();
    _getCoordinates();
  }

  Future<void> _getCoordinates() async {
    try {
      final locations = widget.locationAddress;

      if (locations.isNotEmpty) {
        // final firstLocation = locations.first;

        setState(() {
          _locationLatLng = LatLng(locations[0], locations[1]);

          _markers = [
            Marker(
              width: 80.0,
              height: 80.0,
              point: _locationLatLng!,
              child: Icon(Icons.warning, color: AppColors.danger),
            ),
          ];
        });

        // Move map to the location if map is already initialized
        if (_isMapInitialized && _locationLatLng != null) {
          _mapController.move(_locationLatLng!, 14);
        }
      }
    } catch (e) {
      // Handle error or show a snackbar
      debugPrint("Error converting address: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not find location: ${e.toString()}")),
      );
    }
  }

  void _onMapCreated(MapController controller) {
    setState(() {
      _isMapInitialized = true;
    });

    // Now it's safe to move the map if we have a position
    if (_locationLatLng != null) {
      _mapController.move(_locationLatLng!, 14);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Default position if location is not available yet
    final mapCenter = _locationLatLng ?? LatLng(0, 0);
    final initialZoom = _locationLatLng != null ? 14.0 : 2.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Map View"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getCoordinates,
            tooltip: 'Refresh Location',
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,

            options: MapOptions(
              initialCenter: mapCenter,
              initialZoom: initialZoom,
              onMapReady: () {
                _onMapCreated(_mapController);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              if (_locationLatLng != null) MarkerLayer(markers: _markers),
            ],
          ),
          if (_locationLatLng == null)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Finding location..."),
                ],
              ),
            ),
          // Display the address at the bottom of the screen
          if (_locationLatLng != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  widget.locationName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

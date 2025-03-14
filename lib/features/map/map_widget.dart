// widgets/map_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/jam.dart';
import 'package:iconify_flutter/icons/maki.dart';
import 'package:latlong2/latlong.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';

class MapWidget extends StatefulWidget {
  final LatLng? currentPosition;
  final LatLng? incidentPosition;
  final LatLng? startPoint;
  final LatLng? endPoint;
  final List<LatLng> routePoints;
  final bool isIncidentMarker;
  final Function(LatLng) onMapTap;
  final List<Map<String, dynamic>> unsafeAreas;

  const MapWidget({
    super.key,
    this.currentPosition,
    this.incidentPosition,
    this.startPoint,
    this.endPoint,
    this.routePoints = const [],
    this.isIncidentMarker = false,
    required this.onMapTap,
    this.unsafeAreas = const [],
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController _mapController = MapController();
  bool _isMapInitialized = false;
  LatLng? _previousCurrentPosition;

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if currentPosition was updated and move map if needed
    if (widget.currentPosition != null &&
        widget.currentPosition != _previousCurrentPosition &&
        _isMapInitialized) {
      // Only auto-center on current position if there's no incident position
      // or if we're showing the user's location for the first time
      if (widget.incidentPosition == null || _previousCurrentPosition == null) {
        _mapController.move(widget.currentPosition!, 14);
      }

      _previousCurrentPosition = widget.currentPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the center point for the map
    final LatLng mapCenter =
        widget.startPoint ?? widget.currentPosition ?? const LatLng(0, 0);
    final double initialZoom =
        (widget.startPoint != null || widget.currentPosition != null)
            ? 14.0
            : 2.0;

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: mapCenter,
        initialZoom: initialZoom,
        onMapReady: _onMapReady,
        onTap: (_, point) => widget.onMapTap(point),
      ),
      children: [
        // Base map layer
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),

        // Markers layer
        MarkerLayer(markers: _buildMarkers()),

        // Route polyline layer
        PolylineLayer(
          polylines: [
            if (widget.routePoints.isNotEmpty)
              Polyline(
                points: widget.routePoints,
                strokeWidth: 4.0,
                color: Colors.blue,
              ),
          ],
        ),
      ],
    );
  }

  List<Marker> _buildMarkers() {
    final List<Marker> markers = [];

    // Current position marker
    if (widget.currentPosition != null &&
        widget.currentPosition != widget.incidentPosition) {
      markers.add(
        Marker(
          width: 40.0,
          height: 40.0,
          point: widget.currentPosition!,
          child: const Icon(Icons.my_location, color: Colors.blue),
        ),
      );
    }

    // Incident position marker
    if (widget.incidentPosition != null) {
      markers.add(
        Marker(
          width: 40.0,
          height: 40.0,
          point: widget.incidentPosition!,
          child: Iconify(Jam.triangle_danger_f, color: AppColors.danger),
        ),
      );
    }

    // Route endpoint marker
    if (widget.endPoint != null) {
      markers.add(
        Marker(
          width: 40.0,
          height: 40.0,
          point: widget.endPoint!,
          child: const Icon(Icons.location_pin, color: AppColors.success),
        ),
      );
    }

    // Unsafe areas markers
    for (final area in widget.unsafeAreas) {
      markers.add(
        Marker(
          width: 20,
          height: 20,
          point: LatLng(area['latitude'], area['longitude']),
          child: Tooltip(
            message: area['name'] ?? 'Unsafe Area',
            // child: Icon(Icons.dangerous, color: AppColors.danger, size: 30),
            child: Iconify(
              Maki.danger,
              color: AppColors.danger,

              size: AppConstants.mediumIconSize,
            ),
          ),
        ),
      );
    }

    return markers;
  }

  void _onMapReady() {
    setState(() {
      _isMapInitialized = true;
    });

    // Center the map on the primary location
    if (widget.startPoint != null) {
      _mapController.move(widget.startPoint!, 14);

      // Store current position to avoid duplicate centering
      _previousCurrentPosition = widget.currentPosition;
    }
  }
}

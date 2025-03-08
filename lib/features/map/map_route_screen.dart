import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class MapRouteScreen extends StatefulWidget {
  const MapRouteScreen({super.key});

  @override
  _MapRouteScreenState createState() => _MapRouteScreenState();
}

class _MapRouteScreenState extends State<MapRouteScreen> {
  LatLng? startPoint;
  LatLng? endPoint;
  List<LatLng> routePoints = [];
  final MapController mapController = MapController();
  LatLng? _currentPosition;
  List<Marker> _markers = [];
  bool _isMapInitialized = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  // Request necessary permissions
  Future<void> _requestPermissions() async {
    // Check location permission first
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions permanently denied, please enable in settings',
          ),
        ),
      );
      return;
    }

    // Request other permissions
    await Permission.sms.request();
    await FlutterContacts.requestPermission();

    // Get location after permissions are granted
    _getUserLocation();
  }

  // Get the user's current location
  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _markers = [
          Marker(
            width: 80.0,
            height: 80.0,
            point: _currentPosition!,
            child: Icon(Icons.location_on, color: Colors.red, size: 40.0),
          ),
        ];
      });

      // Only move the map if it's already initialized
      if (_currentPosition != null) {
        mapController.move(_currentPosition!, 15);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
    }
  }

  void _onMapCreated(MapController controller) {
    setState(() {
      _isMapInitialized = true;
    });

    // Now it's safe to move the map if we have a position
    if (_currentPosition != null) {
      mapController.move(_currentPosition!, 15);
    }
  }

  Future<void> getRoute() async {
    if (startPoint == null || endPoint == null) return;

    final String url =
        'https://router.project-osrm.org/route/v1/driving/${startPoint!.longitude},${startPoint!.latitude};${endPoint!.longitude},${endPoint!.latitude}?overview=full&geometries=geojson';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final geometry = data['routes'][0]['geometry'];
      final coordinates = geometry['coordinates'];
      setState(() {
        routePoints =
            coordinates
                .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
                .toList();
      });
    } else {
      throw Exception('Failed to load route');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapCenter = _currentPosition ?? LatLng(0, 0);
    final initialZoom = _currentPosition != null ? 15.0 : 2.0;
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Map Route')),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: mapCenter,
          initialZoom: initialZoom,
          onMapReady: () {
            _onMapCreated(mapController);
          },
          onTap: (tapPosition, point) {
            setState(() {
              if (startPoint == null) {
                startPoint = point;
              } else if (endPoint == null) {
                endPoint = point;
                getRoute();
              } else {
                startPoint = point;
                endPoint = null;
                routePoints.clear();
              }
            });
          },
        ),

        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              if (startPoint != null)
                Marker(
                  point: startPoint!,
                  child: Icon(Icons.location_pin, color: Colors.green),
                ),
              if (endPoint != null)
                Marker(
                  point: endPoint!,
                  child: Icon(Icons.location_pin, color: Colors.red),
                ),
            ],
          ),
          PolylineLayer(
            polylines: [
              if (routePoints.isNotEmpty)
                Polyline(
                  points: routePoints,
                  strokeWidth: 4.0,
                  color: Colors.blue,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

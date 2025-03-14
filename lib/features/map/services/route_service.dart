// services/route_service.dart
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RouteService {
  final double unsafeAreaBufferRadius =
      0.003; // roughly 300 meters in decimal degrees

  static const String apiKey =
      '5b3ce3597851110001cf6248ba2fea555e4a4f0cab538edc7a3e3987';

  // Future<List<LatLng>> getRouteSafely(
  //   LatLng start,
  //   LatLng end,
  //   List<Map<String, dynamic>> unsafeAreas,
  // ) async {
  //   String avoidAreasParam = generateAvoidAreasParameter(unsafeAreas);

  //   // Build URL with avoid areas
  //   final String url =
  //       'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson&avoid=areas:$avoidAreasParam';
  //   log(url);

  //   final response = await http.get(Uri.parse(url));

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);

  //     // Check if any routes were found
  //     if (data['routes'] == null || data['routes'].isEmpty) {
  //       throw Exception('No route found avoiding unsafe areas');
  //     }

  //     final geometry = data['routes'][0]['geometry'];
  //     final coordinates = geometry['coordinates'];

  //     return coordinates
  //         .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
  //         .toList();
  //   } else {
  //     log(response.body);
  //     throw Exception('Failed to load route: ${response.statusCode}');
  //   }
  // }

  // // Generate avoid areas parameter in OSRM format
  // String generateAvoidAreasParameter(List<Map<String, dynamic>> unsafeAreas) {
  //   List<String> avoidAreas = [];

  //   for (var area in unsafeAreas) {
  //     double lat = area['latitude'];
  //     double lng = area['longitude'];

  //     // Create a polygon around the unsafe area
  //     double minLat = lat - unsafeAreaBufferRadius;
  //     double maxLat = lat + unsafeAreaBufferRadius;
  //     double minLng = lng - unsafeAreaBufferRadius;
  //     double maxLng = lng + unsafeAreaBufferRadius;

  //     // Format as polygon: minLng,minLat;maxLng,minLat;maxLng,maxLat;minLng,maxLat;minLng,minLat
  //     String polygon =
  //         '$minLng,$minLat;$maxLng,$minLat;$maxLng,$maxLat;$minLng,$maxLat;$minLng,$minLat';
  //     avoidAreas.add(polygon);
  //   }

  //   // Join all polygons with a pipe separator
  //   return avoidAreas.join('|');
  // }

  // // Original route method (kept for fallback)
  // Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
  //   final String url =
  //       'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';

  //   final response = await http.get(Uri.parse(url));

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     final geometry = data['routes'][0]['geometry'];
  //     final coordinates = geometry['coordinates'];

  //     return coordinates
  //         .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
  //         .toList();
  //   } else {
  //     throw Exception('Failed to load route: ${response.statusCode}');
  //   }
  // }

  Future<List<LatLng>> getRouteSafely(
    LatLng startPoint,
    LatLng endPoint,
    List<Map<String, dynamic>> unsafeAreas,
  ) async {
    final polygons =
        unsafeAreas.map((area) {
          final double lat = area['latitude'];
          final double lng = area['longitude'];
          final double buffer = 0.003; // Buffer size in degrees (~300m)

          // Create square polygon around each point
          return [
            [
              [lng - buffer, lat - buffer],
              [lng + buffer, lat - buffer],
              [lng + buffer, lat + buffer],
              [lng - buffer, lat + buffer],
              [lng - buffer, lat - buffer], // Close the polygon
            ],
          ];
        }).toList();

    final requestBody = {
      "coordinates": [
        [startPoint.longitude, startPoint.latitude],
        [endPoint.longitude, endPoint.latitude],
      ],
      "preference": "recommended",
      "options": {
        "avoid_polygons": {"type": "MultiPolygon", "coordinates": polygons},
      },
    };

    log(">>>>>>>>>>>>>>>>>>>>>>$requestBody");

    // Send the request to the API
    final response = await http.post(
      Uri.parse(
        'https://api.openrouteservice.org/v2/directions/driving-car/geojson',
      ),
      headers: {
        'Accept': 'application/json, application/geo+json',
        'Authorization': apiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    log(",,,,,,,,,,,,,,,,,,,,,${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Fix: Access the correct path for coordinates in GeoJSON format
      final features = data['features'];
      if (features != null && features.isNotEmpty) {
        final geometry = features[0]['geometry'];
        if (geometry != null) {
          final coordinates = geometry['coordinates'];

          if (coordinates != null) {
            return coordinates
                .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
                .toList();
          }
        }
      }

      throw Exception('Invalid response format');
    } else {
      throw Exception('Failed to load route: ${response.statusCode}');
    }
  }

  Future<List<LatLng>> getRoute(LatLng startPoint, LatLng endPoint) async {
    final requestBody = {
      "coordinates": [
        [startPoint.longitude, startPoint.latitude],
        [endPoint.longitude, endPoint.latitude],
      ],
      "preference": "recommended",
      "instructions": true,
      "options": {
        "avoid_features": ["highways"],
      },
    };

    // Send the request to the API
    final response = await http.post(
      Uri.parse(
        'https://api.openrouteservice.org/v2/directions/driving-car/geojson',
      ),
      headers: {
        'Accept': 'application/json, application/geo+json',
        'Authorization': apiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final geometry = data['routes'][0]['geometry'];
      final coordinates = geometry['coordinates'];

      return coordinates
          .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
          .toList();
    } else {
      throw Exception('Failed to load route: ${response.statusCode}');
    }
  }
}

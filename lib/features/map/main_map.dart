// main_map_screen.dart
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

import 'contact_panel_section.dart';
import 'location_info_section.dart';
import 'map_widget.dart';
import 'services/contact_service.dart';
import 'services/location_service.dart';
import 'services/route_service.dart';
import 'services/sms_service.dart';

class MainMapScreen extends StatefulWidget {
  final List<double>? incidentLocation;
  final String? incidentLocationName;

  const MainMapScreen({
    super.key,
    this.incidentLocation,
    this.incidentLocationName,
  });

  @override
  State<MainMapScreen> createState() => _MainMapScreenState();
}

class _MainMapScreenState extends State<MainMapScreen> {
  final LocationService _locationService = LocationService();
  final RouteService _routeService = RouteService();
  final ContactService _contactService = ContactService();
  final SMSService _smsService = SMSService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _firebaseUnsafeAreas = [];

  LatLng? _currentPosition;
  LatLng? _incidentPosition;
  LatLng? _startPoint;
  LatLng? _endPoint;
  List<LatLng> _routePoints = [];
  List<Contact> _contacts = [];
  bool _showContactsPanel = false;
  bool _routeMode = false;
  String? _locationName;
  bool _isLoading = true;

  // Get reference to user's contacts collection
  CollectionReference get unsafeAreaRef =>
      _firestore.collection('unsafe_areas');

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() => _isLoading = true);

    await _requestPermissions();

    log("LOCATION: ${widget.incidentLocation}");

    // Set incident location if provided
    if (widget.incidentLocation != null &&
        widget.incidentLocation!.length >= 2) {
      _incidentPosition = LatLng(
        widget.incidentLocation![0],
        widget.incidentLocation![1],
      );
      _locationName = widget.incidentLocationName;
      //_startPoint = _incidentPosition;
    }

    // Get current location regardless of incident location
    try {
      final position = await _locationService.getCurrentPosition();
      setState(() {
        _currentPosition = position;

        _startPoint = position;
      });
    } catch (e) {
      _showError('Could not get current location: $e');
    }

    // Load contacts
    try {
      final contacts = await _contactService.getContacts();
      setState(() => _contacts = contacts);
    } catch (e) {
      _showError('Could not load contacts: $e');
    }

    // Fetch unsafe areas
    await _fetchUnsafeAreas();

    setState(() => _isLoading = false);
  }

  // Add this method to refresh current location only
  Future<void> _refreshCurrentLocation() async {
    try {
      setState(() => _isLoading = true);
      final position = await _locationService.getCurrentPosition();
      setState(() {
        _currentPosition = position;

        // Only update start point if no incident location provided
        if (_incidentPosition == null) {
          _startPoint = position;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Could not refresh location: $e');
    }
  }

  Future<void> _requestPermissions() async {
    final permissionsGranted =
        await _locationService.requestLocationPermission();
    if (!permissionsGranted) {
      _showError('Location permission is required for this app');
      return;
    }

    await Permission.sms.request();
    await FlutterContacts.requestPermission();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleRouteMode() {
    setState(() {
      _routeMode = !_routeMode;
      if (!_routeMode) {
        // Clear route when exiting route mode
        _endPoint = null;
        _routePoints = [];
      }
    });
  }

  void _handleMapTap(LatLng point) {
    if (!_routeMode) return;

    setState(() {
      if (_endPoint == null) {
        _endPoint = point;
        _calculateRoute();
      } else {
        // Reset route
        _endPoint = point;
        _calculateRoute();
      }
    });
  }

  // Future<void> _calculateRoute() async {
  //   if (_startPoint == null || _endPoint == null) return;

  //   try {
  //     setState(() => _isLoading = true);
  //     final route = await _routeService.getRoute(_startPoint!, _endPoint!);
  //     setState(() => _routePoints = route);
  //   } catch (e) {
  //     _showError('Failed to calculate route: $e');
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  Future<void> _calculateRoute() async {
    if (_startPoint == null || _endPoint == null) return;

    try {
      setState(() => _isLoading = true);

      List<LatLng> route;
      if (_firebaseUnsafeAreas.isNotEmpty) {
        // Use route that avoids unsafe areas

        route = await _routeService.getRouteSafely(
          _startPoint!,
          _endPoint!,
          _firebaseUnsafeAreas,
        );

        _showMessage('Showing safest route avoiding all danger areas');
      } else {
        route = await _routeService.getRoute(_startPoint!, _endPoint!);
      }

      setState(() => _routePoints = route);
    } catch (e) {
      log('Failed to calculate route: $e');
      _showError('Failed to calculate route: $e');

      // Fallback to direct route if avoiding unsafe areas fails
      try {
        final directRoute = await _routeService.getRoute(
          _startPoint!,
          _endPoint!,
        );
        setState(() => _routePoints = directRoute);
        _showWarning('Using direct route which may pass through unsafe areas');
      } catch (e) {
        _showError('Failed to calculate any route: $e');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showWarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.orange),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _shareLocation(Contact contact) async {
    final position = _incidentPosition ?? _currentPosition;
    if (position == null) {
      _showError('No location available to share');
      return;
    }

    final message =
        'My current location: ${position.latitude}, ${position.longitude}${_locationName != null ? ' ($_locationName)' : ''}';

    try {
      await _smsService.sendSMS(contact.phones.first.number, message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location shared with ${contact.displayName}')),
      );
    } catch (e) {
      _showError('Failed to send SMS: $e');
    }

    // Hide contacts panel after sharing
    setState(() => _showContactsPanel = false);
  }

  // Fetch unsafeAreas from Firebase
  Future<void> _fetchUnsafeAreas() async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot snapshot = await unsafeAreaRef.get();

      setState(() {
        _firebaseUnsafeAreas =
            snapshot.docs
                .map(
                  (doc) => {
                    'id': doc.id,
                    'description': doc['description'],
                    'latitude': doc['latitude'],
                    'longitude': doc['longitude'],
                    'name': doc['name'],
                  },
                )
                .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch unsafeArea: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_routeMode ? 'Route Mode' : 'Map View'),
        actions: [
          IconButton(
            icon: Icon(_routeMode ? Icons.map : Icons.directions),
            onPressed: _toggleRouteMode,
            tooltip: _routeMode ? 'Normal Map' : 'Route Mode',
          ),
          IconButton(
            icon: const Icon(Icons.share_location),
            onPressed: () => setState(() => _showContactsPanel = true),
            tooltip: 'Share Location',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initialize,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map Widget
          MapWidget(
            currentPosition: _currentPosition,
            incidentPosition: _incidentPosition,
            startPoint: _startPoint,
            endPoint: _endPoint,
            routePoints: _routePoints,
            isIncidentMarker: _incidentPosition != null,
            onMapTap: _handleMapTap,
            unsafeAreas: _firebaseUnsafeAreas,
          ),

          // Loading Indicator
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Loading..."),
                ],
              ),
            ),

          // Location Info Panel
          if (_locationName != null && _incidentPosition != null)
            LocationInfoPanel(locationName: _locationName!),

          // Contacts Panel
          if (_showContactsPanel)
            ContactsPanel(
              contacts: _contacts,
              onContactSelected: _shareLocation,
              onClose: () => setState(() => _showContactsPanel = false),
            ),

          // Route Mode Instructions
          if (_routeMode && _endPoint == null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                color: Colors.white.withOpacity(0.9),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Tap on map to set destination point"),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

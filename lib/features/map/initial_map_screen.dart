import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class InitialMapScreen extends StatefulWidget {
  const InitialMapScreen({super.key});

  @override
  State<InitialMapScreen> createState() => _InitialMapScreenState();
}

class _InitialMapScreenState extends State<InitialMapScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentPosition;
  List<Marker> _markers = [];
  bool _isSharing = false;
  Contact? _selectedContact;
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
      if (_isMapInitialized && _currentPosition != null) {
        _mapController.move(_currentPosition!, 15);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
    }
  }

  // Share location via SMS
  Future<void> _shareLocationViaSMS() async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location not available yet')),
      );
      return;
    }

    // If no contact is selected, open contacts picker
    if (_selectedContact == null) {
      await _pickContact();
      if (_selectedContact == null) return; // User cancelled selection
    }

    // Get full contact with phones
    final fullContact = await FlutterContacts.getContact(_selectedContact!.id);
    if (fullContact == null || fullContact.phones.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No phone number available for this contact'),
        ),
      );
      return;
    }

    // Prepare the SMS content with OpenStreetMap link
    String phoneNumber = fullContact.phones.first.number;
    // OpenStreetMap link format
    String locationLink =
        'https://www.openstreetmap.org/?mlat=${_currentPosition!.latitude}&mlon=${_currentPosition!.longitude}#map=17/${_currentPosition!.latitude}/${_currentPosition!.longitude}';
    String message = 'My current location: $locationLink';

    // Launch SMS app with pre-filled message
    final Uri uri = Uri.parse(
      'sms:$phoneNumber?body=${Uri.encodeComponent(message)}',
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch SMS';
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error sending SMS: $e')));
    }
  }

  // Pick a contact from contacts list
  Future<void> _pickContact() async {
    try {
      final hasPermission = await FlutterContacts.requestPermission();
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contacts permission denied')),
        );
        return;
      }

      // Get all contacts (without full details to improve performance)
      final contacts = await FlutterContacts.getContacts();

      // Show contact picker dialog
      await showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Select Contact'),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    Contact contact = contacts[index];
                    return ListTile(
                      title: Text(contact.displayName),
                      onTap: () {
                        setState(() {
                          _selectedContact = contact;
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking contact: $e')));
    }
  }

  // Start/stop sharing location
  void _toggleLocationSharing() {
    setState(() {
      _isSharing = !_isSharing;
    });

    if (_isSharing) {
      _shareLocationViaSMS();
    }
  }

  // Refresh current location
  void _refreshLocation() {
    _getUserLocation();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Updating location...')));
  }

  void _onMapCreated(MapController controller) {
    setState(() {
      _isMapInitialized = true;
    });

    // Now it's safe to move the map if we have a position
    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, 15);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Default position if current position is not available yet
    final mapCenter = _currentPosition ?? LatLng(0, 0);
    final initialZoom = _currentPosition != null ? 15.0 : 2.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Location"),
        actions: [
          IconButton(
            icon: Icon(
              _selectedContact != null ? Icons.person : Icons.person_add,
            ),
            onPressed: _pickContact,
            tooltip: 'Select Contact',
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
              if (_currentPosition != null) MarkerLayer(markers: _markers),
            ],
          ),
          if (_currentPosition == null)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Getting your location..."),
                ],
              ),
            ),
          if (_selectedContact != null)
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Contact: ${_selectedContact!.displayName}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _refreshLocation,
            heroTag: 'refresh',
            mini: true,
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: _currentPosition != null ? _toggleLocationSharing : null,
            label: Text(_isSharing ? 'Sharing...' : 'Share Location'),
            icon: Icon(_isSharing ? Icons.stop : Icons.share_location),
            backgroundColor:
                _currentPosition != null
                    ? (_isSharing ? Colors.red : Colors.blue)
                    : Colors.grey,
            heroTag: 'share',
          ),
        ],
      ),
    );
  }
}

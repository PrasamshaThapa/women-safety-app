// services/contact_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get contacts from device
  Future<List<Contact>> getDeviceContacts() async {
    if (await FlutterContacts.requestPermission()) {
      return await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );
    }
    return [];
  }

  // Get contacts from Firebase
  Future<List<Contact>> getFirebaseContacts() async {
    try {
      final snapshot = await _firestore.collection('contacts').get();
      List<Contact> contacts = [];

      // Convert Firebase data to Contact objects
      // This is a simplified version - you'll need to adapt to your actual data structure
      for (var doc in snapshot.docs) {
        final data = doc.data();
        // Create a Contact object from Firebase data
        // This is just a placeholder - adjust based on your schema
        // In a real app, you might want to create a custom contact model
      }

      return contacts;
    } catch (e) {
      throw Exception('Failed to load contacts from Firebase: $e');
    }
  }

  // Get all contacts (combines device and Firebase)
  Future<List<Contact>> getContacts() async {
    // For now, just returning device contacts
    // In a real implementation, you would merge with Firebase contacts
    return await getDeviceContacts();
  }
}

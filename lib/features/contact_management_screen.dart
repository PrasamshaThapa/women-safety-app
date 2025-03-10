import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../constants/app_colors.dart';
import '../utils/app_bars/custom_app_bar.dart';
import '../utils/nav_bar/custom_nav_bar.dart';

class ContactManagementScreen extends StatefulWidget {
  const ContactManagementScreen({super.key});

  @override
  State<ContactManagementScreen> createState() =>
      _ContactManagementScreenState();
}

class _ContactManagementScreenState extends State<ContactManagementScreen> {
  final List<Contact> _selectedContacts = [];
  List<Contact> _deviceContacts = [];
  List<Map<String, dynamic>> _firebaseContacts = [];
  bool _isLoading = false;
  bool _hasPermission = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _fetchContactsFromFirebase();
  }

  // Get the current user ID
  String? get _userId => _auth.currentUser?.uid;

  // Get reference to user's contacts collection
  CollectionReference get _userContactsRef =>
      _firestore.collection('users').doc(_userId).collection('contacts');

  Future<void> _checkPermissions() async {
    bool permission = await FlutterContacts.requestPermission();
    setState(() {
      _hasPermission = permission;
    });
  }

  // Fetch contacts from Firebase
  Future<void> _fetchContactsFromFirebase() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_userId != null) {
        QuerySnapshot snapshot = await _userContactsRef.get();

        setState(() {
          _firebaseContacts =
              snapshot.docs
                  .map(
                    (doc) => {
                      'id': doc.id,
                      'name': doc['name'],
                      'phone': doc['phone'],
                    },
                  )
                  .toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch contacts: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Save contact to Firebase
  Future<void> _saveContactToFirebase(Contact contact) async {
    try {
      if (_userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You need to be logged in to save contacts"),
          ),
        );
        return;
      }

      String name = contact.displayName;
      String phone =
          contact.phones.isNotEmpty
              ? contact.phones.first.number
              : 'No phone number';

      // Check if contact already exists
      QuerySnapshot existing =
          await _userContactsRef
              .where('phone', isEqualTo: phone)
              .limit(1)
              .get();

      if (existing.docs.isEmpty) {
        // Add new contact
        await _userContactsRef.add({
          'name': name,
          'phone': phone,
          'contactId': contact.id,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Refresh the contacts list
        _fetchContactsFromFirebase();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save contact: ${e.toString()}")),
      );
    }
  }

  // Delete contact from Firebase
  Future<void> _deleteContactFromFirebase(String docId) async {
    try {
      await _userContactsRef.doc(docId).delete();
      _fetchContactsFromFirebase();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete contact: ${e.toString()}")),
      );
    }
  }

  Future<void> _getDeviceContacts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check permission status first
      bool permission = await FlutterContacts.requestPermission();

      // Update permission state
      setState(() {
        _hasPermission = permission;
      });

      if (_hasPermission) {
        // If we have permission, get the contacts
        List<Contact> contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: false,
        );
        setState(() {
          _deviceContacts = contacts;
        });
      } else {
        // Only show the snackbar if permission is actually denied
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Contact permission denied")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to get contacts: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addContact(Contact contact) async {
    // Add to selected contacts for UI updates
    setState(() {
      if (!_selectedContacts.any((c) => c.id == contact.id)) {
        _selectedContacts.add(contact);
      }
    });

    // Save to Firebase
    await _saveContactToFirebase(contact);
  }

  void _removeContact(Contact contact) {
    setState(() {
      _selectedContacts.removeWhere((c) => c.id == contact.id);
    });
  }

  Future<void> _showContactSelectionDialog() async {
    await _getDeviceContacts();
    if (!mounted) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Contacts'),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _deviceContacts.isEmpty
                      ? const Center(child: Text('No contacts found'))
                      : ListView.builder(
                        itemCount: _deviceContacts.length,
                        itemBuilder: (context, index) {
                          Contact contact = _deviceContacts[index];
                          String displayName = contact.displayName;
                          String phone = '';
                          if (contact.phones.isNotEmpty) {
                            phone = contact.phones.first.number;
                          }

                          return ListTile(
                            title: Text(displayName),
                            subtitle: Text(phone),
                            onTap: () {
                              _addContact(contact);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "Contact"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Add New Contact Button
            BlocSelector<AuthBloc, AuthState, User?>(
              selector: (state) => state.user,
              builder:
                  (context, state) => GestureDetector(
                    onTap: _showContactSelectionDialog,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary, // Darker Purple
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 32),
                          SizedBox(width: 16),
                          Text(
                            "Add new\n${state?.email}'s contacts",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
            ),

            // Loading indicator for initial contacts load
            if (_isLoading) const Center(child: CircularProgressIndicator()),

            // Firebase Contacts List
            Column(
              children: [
                ..._firebaseContacts.map((contact) {
                  return ContactItem(
                    name: contact['name'],
                    phone: contact['phone'],
                    onDelete: () => _deleteContactFromFirebase(contact['id']),
                  );
                }),

                // Show some static contacts if no contacts are added yet
                // if (_firebaseContacts.isEmpty && !_isLoading) ...[
                //   const ContactItem(
                //     name: "Add contacts",
                //     phone: "Tap the button above to add contacts",
                //     onDelete: null,
                //   ),
                // ],
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}

class ContactItem extends StatelessWidget {
  final String name;
  final String phone;
  final VoidCallback? onDelete;

  const ContactItem({
    super.key,
    required this.name,
    required this.phone,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xE88C3BAF), // Lighter purple for contact items
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFBB86FC),
                child: Icon(Icons.person),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              Text(phone, style: const TextStyle(color: Colors.white70)),
            ],
          ),
          onDelete != null
              ? GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.delete, color: Colors.white),
              )
              : const Icon(Icons.delete, color: Colors.white54),
        ],
      ),
    );
  }
}

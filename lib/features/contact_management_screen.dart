import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

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
  bool _isLoading = false;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    bool permission = await FlutterContacts.requestPermission();
    setState(() {
      _hasPermission = permission;
    });
  }

  Future<void> _getDeviceContacts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_hasPermission) {
        List<Contact> contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: false,
        );
        setState(() {
          _deviceContacts = contacts;
        });
      } else {
        bool permission = await FlutterContacts.requestPermission();
        setState(() {
          _hasPermission = permission;
        });

        if (!permission) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Contact permission denied")),
          );
        } else {
          // Try to get contacts again if permission was just granted
          await _getDeviceContacts();
        }
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

  void _addContact(Contact contact) {
    setState(() {
      if (!_selectedContacts.any((c) => c.id == contact.id)) {
        _selectedContacts.add(contact);
      }
    });
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
            GestureDetector(
              onTap: _showContactSelectionDialog,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary, // Darker Purple
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 32),
                    SizedBox(width: 16),
                    Text(
                      "Add new\nPrasamsha's contacts",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),

            // Loading indicator for initial contacts load
            if (_isLoading) const Center(child: CircularProgressIndicator()),

            // Selected Contacts List
            Column(
              children: [
                ..._selectedContacts.map((contact) {
                  String name = contact.displayName;
                  String phone =
                      contact.phones.isNotEmpty
                          ? contact.phones.first.number
                          : 'No phone number';

                  return ContactItem(
                    name: name,
                    phone: phone,
                    onDelete: () => _removeContact(contact),
                  );
                }),

                // Show some static contacts if no contacts are selected
                if (_selectedContacts.isEmpty) ...[
                  const ContactItem(
                    name: "Mom",
                    phone: "+977 9841414141",
                    onDelete: null,
                  ),
                  const ContactItem(
                    name: "Dad",
                    phone: "+977 9841414141",
                    onDelete: null,
                  ),
                  const ContactItem(
                    name: "Louis",
                    phone: "+977 9841414141",
                    onDelete: null,
                  ),
                ],
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

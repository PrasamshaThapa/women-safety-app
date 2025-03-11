import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactsPanel extends StatelessWidget {
  final List<Contact> contacts;
  final Function(Contact) onContactSelected;
  final VoidCallback onClose;

  const ContactsPanel({
    super.key,
    required this.contacts,
    required this.onContactSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      top: MediaQuery.of(context).size.height * 0.3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Share location with',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: onClose),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child:
                  contacts.isEmpty
                      ? const Center(child: Text('No contacts available'))
                      : ListView.builder(
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          final contact = contacts[index];
                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(contact.displayName),
                            subtitle:
                                contact.phones.isNotEmpty
                                    ? Text(contact.phones.first.number)
                                    : const Text('No phone number'),
                            onTap: () => onContactSelected(contact),
                            enabled: contact.phones.isNotEmpty,
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

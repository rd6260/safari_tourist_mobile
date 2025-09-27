import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final List<EmergencyContact> _emergencyContacts = [
    EmergencyContact(
      id: '1',
      name: 'Shruti Das',
      relationship: 'Wife',
      phoneNumber: '+91 98765 43210',
      email: 'shruti@email.com',
      isPrimary: true,
      isVerified: true,
      notificationPreferences: NotificationPreferences(
        sms: true,
        call: true,
        email: true,
        whatsapp: true,
      ),
    ),
    EmergencyContact(
      id: '2',
      name: 'Dr. Rajesh Kumar',
      relationship: 'Family Doctor',
      phoneNumber: '+91 98765 43211',
      email: 'dr.rajesh@hospital.com',
      isPrimary: false,
      isVerified: true,
      notificationPreferences: NotificationPreferences(
        sms: true,
        call: true,
        email: false,
        whatsapp: false,
      ),
    ),
    EmergencyContact(
      id: '3',
      name: 'Owais Muhammad',
      relationship: 'Friend',
      phoneNumber: '+91 98765 43212',
      email: 'owais@email.com',
      isPrimary: false,
      isVerified: false,
      notificationPreferences: NotificationPreferences(
        sms: true,
        call: false,
        email: true,
        whatsapp: true,
      ),
    ),
  ];

  final List<LocalEmergencyService> _localServices = [
    LocalEmergencyService(
      name: 'Karnataka Police',
      number: '100',
      type: ServiceType.police,
      isActive: true,
    ),
    LocalEmergencyService(
      name: 'Medical Emergency',
      number: '108',
      type: ServiceType.medical,
      isActive: true,
    ),
    LocalEmergencyService(
      name: 'Fire Department',
      number: '101',
      type: ServiceType.fire,
      isActive: true,
    ),
    LocalEmergencyService(
      name: 'Tourist Helpline',
      number: '1363',
      type: ServiceType.tourist,
      isActive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.grey[700]),
          ),
        ),
        title: const Text(
          'Emergency Contacts',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () => _showAddContactDialog(),
              icon: Icon(Icons.person_add, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Alert Section
            _buildQuickAlertSection(),
            const SizedBox(height: 30),

            // Personal Emergency Contacts
            _buildPersonalContactsSection(),
            const SizedBox(height: 30),

            // Local Emergency Services
            _buildLocalServicesSection(),
            const SizedBox(height: 30),

            // Safety Tips
            _buildSafetyTips(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _testEmergencyAlert(),
        backgroundColor: Colors.orange[600],
        icon: const Icon(Icons.warning, color: Colors.white),
        label: const Text(
          'Test Alert',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildQuickAlertSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.red[400]!, Colors.red[600]!]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emergency,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Emergency Alert',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Instantly notify all your emergency contacts',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _sendQuickAlert(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Send Emergency Alert',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalContactsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Personal Contacts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              '${_emergencyContacts.length}/5',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._emergencyContacts
            .map((contact) => _buildContactCard(contact)),
      ],
    );
  }

  Widget _buildContactCard(EmergencyContact contact) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: contact.isPrimary
            ? Border.all(color: Colors.blue[300]!, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: contact.isPrimary ? Colors.blue[50] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.person,
                  color: contact.isPrimary
                      ? Colors.blue[600]
                      : Colors.grey[600],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            contact.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (contact.isPrimary)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'PRIMARY',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Icon(
                          contact.isVerified ? Icons.verified : Icons.pending,
                          color: contact.isVerified
                              ? Colors.green[600]
                              : Colors.orange[600],
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      contact.relationship,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      contact.phoneNumber,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _buildNotificationIcon(
                      Icons.sms,
                      contact.notificationPreferences.sms,
                    ),
                    const SizedBox(width: 8),
                    _buildNotificationIcon(
                      Icons.call,
                      contact.notificationPreferences.call,
                    ),
                    const SizedBox(width: 8),
                    _buildNotificationIcon(
                      Icons.email,
                      contact.notificationPreferences.email,
                    ),
                    const SizedBox(width: 8),
                    _buildNotificationIcon(
                      Icons.chat,
                      contact.notificationPreferences.whatsapp,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _callContact(contact),
                    icon: Icon(Icons.call, color: Colors.green[600]),
                  ),
                  IconButton(
                    onPressed: () => _editContact(contact),
                    icon: Icon(Icons.edit, color: Colors.blue[600]),
                  ),
                  IconButton(
                    onPressed: () => _deleteContact(contact),
                    icon: Icon(Icons.delete, color: Colors.red[600]),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationIcon(IconData icon, bool isEnabled) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isEnabled ? Colors.green[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        size: 16,
        color: isEnabled ? Colors.green[600] : Colors.grey[400],
      ),
    );
  }

  Widget _buildLocalServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Local Emergency Services',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: _localServices.length,
          itemBuilder: (context, index) {
            final service = _localServices[index];
            return _buildServiceCard(service);
          },
        ),
      ],
    );
  }

  Widget _buildServiceCard(LocalEmergencyService service) {
    return GestureDetector(
      onTap: () => _callService(service),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getServiceColor(service.type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getServiceIcon(service.type),
                color: _getServiceColor(service.type),
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              service.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              service.number,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getServiceColor(service.type),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Safety Tips',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb, color: Colors.blue[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Emergency Contact Best Practices',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                '• Keep at least 3 emergency contacts updated\n'
                '• Include contacts in different time zones\n'
                '• Add your family doctor and insurance info\n'
                '• Test emergency alerts regularly\n'
                '• Share your travel itinerary with contacts',
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getServiceColor(ServiceType type) {
    switch (type) {
      case ServiceType.police:
        return Colors.blue;
      case ServiceType.medical:
        return Colors.red;
      case ServiceType.fire:
        return Colors.orange;
      case ServiceType.tourist:
        return Colors.green;
    }
  }

  IconData _getServiceIcon(ServiceType type) {
    switch (type) {
      case ServiceType.police:
        return Icons.local_police;
      case ServiceType.medical:
        return Icons.medical_services;
      case ServiceType.fire:
        return Icons.fire_truck;
      case ServiceType.tourist:
        return Icons.support_agent;
    }
  }

  void _sendQuickAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red[600]),
            const SizedBox(width: 8),
            const Text('Send Emergency Alert'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will immediately notify all your emergency contacts with:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Text('• Your current location'),
            Text('• Emergency alert message'),
            Text('• Your tourist ID and status'),
            SizedBox(height: 12),
            Text(
              'Are you sure you want to proceed?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processEmergencyAlert();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Send Alert',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _processEmergencyAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Emergency alert sent to all contacts!'),
          ],
        ),
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _testEmergencyAlert() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Test alert sent successfully!'),
          ],
        ),
        backgroundColor: Colors.orange[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _callContact(EmergencyContact contact) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${contact.name}...'),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _callService(LocalEmergencyService service) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${service.name} (${service.number})...'),
        backgroundColor: _getServiceColor(service.type),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _editContact(EmergencyContact contact) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit contact feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteContact(EmergencyContact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Are you sure you want to remove ${contact.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _emergencyContacts.remove(contact);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contact removed'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add contact feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Data Models
class EmergencyContact {
  final String id;
  final String name;
  final String relationship;
  final String phoneNumber;
  final String email;
  final bool isPrimary;
  final bool isVerified;
  final NotificationPreferences notificationPreferences;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phoneNumber,
    required this.email,
    required this.isPrimary,
    required this.isVerified,
    required this.notificationPreferences,
  });
}

class NotificationPreferences {
  final bool sms;
  final bool call;
  final bool email;
  final bool whatsapp;

  NotificationPreferences({
    required this.sms,
    required this.call,
    required this.email,
    required this.whatsapp,
  });
}

class LocalEmergencyService {
  final String name;
  final String number;
  final ServiceType type;
  final bool isActive;

  LocalEmergencyService({
    required this.name,
    required this.number,
    required this.type,
    required this.isActive,
  });
}

enum ServiceType { police, medical, fire, tourist }

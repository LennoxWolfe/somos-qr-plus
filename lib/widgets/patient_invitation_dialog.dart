import 'package:flutter/material.dart';

enum InvitationStatus { pending, accepted, declined }

class PatientInvitation {
  final String id;
  final String patientName;
  final String patientEmail;
  final String patientPhone;
  final DateTime sentDate;
  final InvitationStatus status;
  final String? notes;

  PatientInvitation({
    required this.id,
    required this.patientName,
    required this.patientEmail,
    required this.patientPhone,
    required this.sentDate,
    required this.status,
    this.notes,
  });
}

class PatientInvitationDialog extends StatefulWidget {
  const PatientInvitationDialog({super.key});

  @override
  State<PatientInvitationDialog> createState() => _PatientInvitationDialogState();
}

class _PatientInvitationDialogState extends State<PatientInvitationDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  List<PatientInvitation> _invitations = [
    PatientInvitation(
      id: '1',
      patientName: 'John Smith',
      patientEmail: 'john.smith@email.com',
      patientPhone: '(555) 123-4567',
      sentDate: DateTime.now().subtract(const Duration(days: 2)),
      status: InvitationStatus.pending,
      notes: 'Follow up on treatment plan',
    ),
    PatientInvitation(
      id: '2',
      patientName: 'Sarah Johnson',
      patientEmail: 'sarah.j@email.com',
      patientPhone: '(555) 987-6543',
      sentDate: DateTime.now().subtract(const Duration(days: 5)),
      status: InvitationStatus.accepted,
      notes: 'New patient consultation',
    ),
    PatientInvitation(
      id: '3',
      patientName: 'Mike Davis',
      patientEmail: 'mike.davis@email.com',
      patientPhone: '(555) 456-7890',
      sentDate: DateTime.now().subtract(const Duration(days: 1)),
      status: InvitationStatus.pending,
      notes: 'Annual checkup reminder',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _sendNewInvitation() {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in required fields')),
      );
      return;
    }

    final newInvitation = PatientInvitation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientName: _nameController.text,
      patientEmail: _emailController.text,
      patientPhone: _phoneController.text,
      sentDate: DateTime.now(),
      status: InvitationStatus.pending,
      notes: _notesController.text,
    );

    setState(() {
      _invitations.add(newInvitation);
    });

    // Clear form
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _notesController.clear();

    // Switch to pending tab to show the new invitation
    _tabController.animateTo(1);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invitation sent successfully!')),
    );
  }

  void _updateInvitationStatus(String invitationId, InvitationStatus newStatus) {
    setState(() {
      final index = _invitations.indexWhere((inv) => inv.id == invitationId);
      if (index != -1) {
        _invitations[index] = PatientInvitation(
          id: _invitations[index].id,
          patientName: _invitations[index].patientName,
          patientEmail: _invitations[index].patientEmail,
          patientPhone: _invitations[index].patientPhone,
          sentDate: _invitations[index].sentDate,
          status: newStatus,
          notes: _invitations[index].notes,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Patient Invitations',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Tab Bar
            TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF2563EB),
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: const Color(0xFF2563EB),
              tabs: const [
                Tab(text: 'Send New'),
                Tab(text: 'Pending'),
                Tab(text: 'Accepted'),
              ],
            ),
            const SizedBox(height: 20),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSendNewTab(),
                  _buildPendingTab(),
                  _buildAcceptedTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendNewTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Send New Patient Invitation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          
          // Form Fields
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Patient Name *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email Address *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Notes (Optional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.note),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          
          // Send Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _sendNewInvitation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Send Invitation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingTab() {
    final pendingInvitations = _invitations.where((inv) => inv.status == InvitationStatus.pending).toList();
    
    if (pendingInvitations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No pending invitations',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: pendingInvitations.length,
      itemBuilder: (context, index) {
        final invitation = pendingInvitations[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      invitation.patientName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Pending',
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Email: ${invitation.patientEmail}'),
                Text('Phone: ${invitation.patientPhone}'),
                Text('Sent: ${_formatDate(invitation.sentDate)}'),
                if (invitation.notes?.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  Text('Notes: ${invitation.notes}'),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _updateInvitationStatus(invitation.id, InvitationStatus.declined),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _updateInvitationStatus(invitation.id, InvitationStatus.accepted),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAcceptedTab() {
    final acceptedInvitations = _invitations.where((inv) => inv.status == InvitationStatus.accepted).toList();
    
    if (acceptedInvitations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No accepted invitations',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: acceptedInvitations.length,
      itemBuilder: (context, index) {
        final invitation = acceptedInvitations[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      invitation.patientName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 16, color: Colors.green.shade800),
                          const SizedBox(width: 4),
                          Text(
                            'Accepted',
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Email: ${invitation.patientEmail}'),
                Text('Phone: ${invitation.patientPhone}'),
                Text('Sent: ${_formatDate(invitation.sentDate)}'),
                if (invitation.notes?.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  Text('Notes: ${invitation.notes}'),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

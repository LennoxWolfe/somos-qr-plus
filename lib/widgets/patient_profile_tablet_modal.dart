import 'package:flutter/material.dart';
import '../models/patient.dart';
import 'tablet_layout_widget.dart';
import 'tablet_app_header_widget.dart';

class PatientProfileTabletModal extends StatefulWidget {
  final Patient patient;

  const PatientProfileTabletModal({super.key, required this.patient});

  @override
  State<PatientProfileTabletModal> createState() => _PatientProfileTabletModalState();
}

class _PatientProfileTabletModalState extends State<PatientProfileTabletModal> {
  String _selectedTab = 'No Shows';
  String _selectedProvider = 'Select a Provider';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          TabletLayoutWidget(
            activeRoute: 'patients',
            onNavigation: _handleNavigation,
            header: Column(
              children: [
                TabletAppHeaderWidget(
                  onProfileAction: (action) {
                    _handleProfileAction(action);
                  },
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button and Title
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back, size: 24),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Patient Profile',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Provider Selection
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Provider',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _selectedProvider,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          style: const TextStyle(fontSize: 16),
                          items: [
                            'Select a Provider',
                            'Dr. Maria Garcia',
                            'Dr. Sarah Chen',
                            'Dr. John Smith',
                            'Dr. Michael Brown',
                            'Dr. James Wilson',
                          ].map((provider) => DropdownMenuItem(
                            value: provider,
                            child: Text(provider),
                          )).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedProvider = value);
                              if (value != 'Select a Provider') {
                                _showProviderChangeDialog(value);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Patient Name and Tabs
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: widget.patient.fullName,
                          readOnly: true,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Tabs
                        Row(
                          children: [
                            _buildTabButton('No Shows', _selectedTab == 'No Shows'),
                            const SizedBox(width: 12),
                            _buildTabButton('Completed Visits', _selectedTab == 'Completed Visits'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Demographics Card
                  _buildDemographicsCard(),
                  
                  const SizedBox(height: 24),
                  
                  // Care Gaps and Risk Adjustment Side by Side
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Care Gaps Section
                      Expanded(
                        child: _buildCareGapsCard(),
                      ),
                      const SizedBox(width: 24),
                      // Risk Adjustment Section
                      Expanded(
                        child: _buildRiskAdjustmentCard(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF333333) : Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF333333),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDemographicsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // First row - 4 columns
          Row(
            children: [
              Expanded(child: _buildDemographicItem('Last DOS:', '')),
              const SizedBox(width: 16),
              Expanded(child: _buildDemographicItem('DOB:', '11/30/1981')),
              const SizedBox(width: 16),
              Expanded(child: _buildDemographicItem('Phone:', '7187020504')),
              const SizedBox(width: 16),
              Expanded(child: _buildDemographicItem('Recert Date:', '09/30/2025')),
            ],
          ),
          const SizedBox(height: 16),
          // Second row - 4 columns
          Row(
            children: [
              Expanded(child: _buildDemographicItem('Next DOS:', '')),
              const SizedBox(width: 16),
              Expanded(child: _buildDemographicItem('DOS Status:', '')),
              const SizedBox(width: 16),
              Expanded(child: _buildDemographicItem('Gender:', 'F')),
              const SizedBox(width: 16),
              Expanded(child: _buildDemographicItem('Secondary Phone:', '')),
            ],
          ),
          const SizedBox(height: 16),
          // Third row - 4 columns
          Row(
            children: [
              Expanded(child: _buildDemographicItem('Email:', '')),
              const SizedBox(width: 16),
              Expanded(child: _buildDemographicItem('Language:', 'SPA')),
              const SizedBox(width: 16),
              Expanded(child: _buildDemographicItem('MCO:', 'Anthem')),
              const SizedBox(width: 16),
              const Expanded(child: SizedBox()), // Empty space for alignment
            ],
          ),
          const SizedBox(height: 16),
          // Address row - full width
          _buildDemographicItem('Address:', '8917 55th Ave # 1fl, Elmhurst NY, 11373'),
        ],
      ),
    );
  }

  Widget _buildDemographicItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildCareGapsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Care Gaps',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 40,
              dataRowHeight: 44,
              columnSpacing: 16,
              columns: const [
                DataColumn(label: Text('GAP', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                DataColumn(label: Text('Description', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                DataColumn(label: Text('Completed', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                DataColumn(label: Text('App', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                DataColumn(label: Text('EHR', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                DataColumn(label: Text('Claim', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              ],
              rows: [
                DataRow(
                  cells: [
                    const DataCell(Text('BCS', style: TextStyle(fontSize: 12))),
                    const DataCell(Text('Breast Cancer Screen...', style: TextStyle(fontSize: 12))),
                    DataCell(Checkbox(
                      value: false, 
                      onChanged: (value) => _showCareGapDialog('BCS', 'Breast Cancer Screening', 'Completed', value ?? false),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
                    DataCell(Checkbox(
                      value: false, 
                      onChanged: (value) => _showCareGapDialog('BCS', 'Breast Cancer Screening', 'App', value ?? false),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
                    DataCell(Checkbox(
                      value: false, 
                      onChanged: (value) => _showCareGapDialog('BCS', 'Breast Cancer Screening', 'EHR', value ?? false),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
                    DataCell(Checkbox(
                      value: false, 
                      onChanged: (value) => _showCareGapDialog('BCS', 'Breast Cancer Screening', 'Claim', value ?? false),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
                  ],
                ),
                DataRow(
                  cells: [
                    const DataCell(Text('AWV', style: TextStyle(fontSize: 12))),
                    const DataCell(Text('Annual Wellness Visi...', style: TextStyle(fontSize: 12))),
                    DataCell(Checkbox(
                      value: true, 
                      onChanged: (value) => _showCareGapDialog('AWV', 'Annual Wellness Visit', 'Completed', value ?? true),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
                    DataCell(Checkbox(
                      value: false, 
                      onChanged: (value) => _showCareGapDialog('AWV', 'Annual Wellness Visit', 'App', value ?? false),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
                    DataCell(Checkbox(
                      value: true, 
                      onChanged: (value) => _showCareGapDialog('AWV', 'Annual Wellness Visit', 'EHR', value ?? true),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
                    DataCell(Checkbox(
                      value: true, 
                      onChanged: (value) => _showCareGapDialog('AWV', 'Annual Wellness Visit', 'Claim', value ?? true),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildRiskAdjustmentCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Risk Adjustment',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 40,
              dataRowHeight: 44,
              columnSpacing: 16,
              columns: const [
                DataColumn(label: Text('HCC', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                DataColumn(label: Text('ICD 10', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                DataColumn(label: Text('Present', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                DataColumn(label: Text('Inact', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                DataColumn(label: Text('App', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                DataColumn(label: Text('EHR', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                DataColumn(label: Text('Claim', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              ],
              rows: [
                DataRow(
                  cells: [
                    const DataCell(Text('')),
                    const DataCell(Text('')),
                    const DataCell(Text('')),
                    const DataCell(Text('')),
                    const DataCell(Text('')),
                    const DataCell(Text('')),
                    const DataCell(Text('')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Match the exact height of Care Gaps table (40px header + 44px * 2 rows = 128px)
          Container(
            height: 128,
            child: const Center(
              child: Text(
                'No records found.',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: null,
          icon: const Icon(Icons.first_page, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey.shade100,
            padding: const EdgeInsets.all(6),
            minimumSize: const Size(32, 32),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: null,
          icon: const Icon(Icons.chevron_left, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey.shade100,
            padding: const EdgeInsets.all(6),
            minimumSize: const Size(32, 32),
          ),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1976D2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            '1',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: null,
          icon: const Icon(Icons.chevron_right, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey.shade100,
            padding: const EdgeInsets.all(6),
            minimumSize: const Size(32, 32),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: null,
          icon: const Icon(Icons.last_page, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey.shade100,
            padding: const EdgeInsets.all(6),
            minimumSize: const Size(32, 32),
          ),
        ),
      ],
    );
  }

  void _handleNavigation(String route) {
    switch (route) {
      case 'dashboard':
        Navigator.of(context).pop();
        // Navigate to dashboard
        break;
      case 'quality':
        Navigator.of(context).pop();
        // Navigate to quality scorecards
        break;
      case 'schedule':
        Navigator.of(context).pop();
        // Navigate to schedule
        break;
      case 'patients':
        // Already on patients page
        break;
      case 'reports':
        Navigator.of(context).pop();
        // Navigate to reports
        break;
      case 'tsm':
        Navigator.of(context).pop();
        break;
      case 'resources':
        Navigator.of(context).pop();
        // Navigate to resources
        break;
      case 'settings':
        Navigator.of(context).pop();
        // Navigate to settings
        break;
      case 'logout':
        // Handle logout logic
        break;
    }
  }

  void _handleProfileAction(String action) {
    switch (action) {
      case 'language':
        // Handle language change
        break;
      case 'invitations':
        // Handle invitations
        break;
      case 'logout':
        // Handle logout logic
        break;
    }
  }

  void _showCareGapDialog(String gapCode, String gapName, String field, bool value) {
    // Check if provider is selected first
    if (_selectedProvider == 'Select a Provider') {
      _showProviderRequiredDialog();
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update $gapName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Gap: $gapCode - $gapName'),
              const SizedBox(height: 8),
              Text('Field: $field'),
              const SizedBox(height: 8),
              Text('Provider: $_selectedProvider'),
              const SizedBox(height: 8),
              Text('Current Status: ${value ? "Completed" : "Not Completed"}'),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to ${value ? "mark as completed" : "mark as not completed"}?',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Here you would typically update the data
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$gapName $field status updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showProviderChangeDialog(String providerName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Provider Assignment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Assigning patient to: $providerName'),
              const SizedBox(height: 16),
              const Text(
                'This will update the patient\'s primary care provider. Are you sure you want to proceed?',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Patient assigned to $providerName successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showProviderRequiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Provider Required'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You must select a provider before updating care gaps.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Please select a provider from the dropdown above, then try again.',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/tablet_layout_widget.dart';
import '../widgets/tablet_app_header_widget.dart';
import '../widgets/provider_dropdown_widget.dart';
import '../core/constants/providers.dart';
import '../widgets/perfect_table_widget.dart';

class QualityScorecardsTabletScreen extends StatefulWidget {
  const QualityScorecardsTabletScreen({super.key});

  @override
  State<QualityScorecardsTabletScreen> createState() => _QualityScorecardsTabletScreenState();
}

class _QualityScorecardsTabletScreenState extends State<QualityScorecardsTabletScreen> {
  String _selectedProvider = 'All';
  String _selectedMCO = 'ANTHEM';
  String _selectedLOB = 'MCD';
  String _selectedProduct = 'All';
  String _selectedMeasure = 'All';
  
  
  final List<Map<String, dynamic>> _qualityMetrics = [
    {
      'measureCode': 'COA-PA',
      'measureName': 'Care for Older Adults: Pain Assessment',
      'open': '-',
      'numerator': '-',
      'denominator': '-',
      'closedApp': '-',
      'closedClaim': '-',
      'closedEmr': '-',
      'complianceRate': '%',
      'benchmark50th': '%',
      'benchmark75th': '%',
      'benchmark90th': '%',
      'hitsToTarget': '-',
      'weight': '-',
      'achieved': '%',
    },
    {
      'measureCode': 'CCS',
      'measureName': 'Cervical Cancer Screening',
      'open': '-',
      'numerator': '-',
      'denominator': '-',
      'closedApp': '-',
      'closedClaim': '-',
      'closedEmr': '-',
      'complianceRate': '%',
      'benchmark50th': '%',
      'benchmark75th': '%',
      'benchmark90th': '%',
      'hitsToTarget': '-',
      'weight': '-',
      'achieved': '%',
    },
    {
      'measureCode': 'CAW',
      'measureName': 'Child and Adolescent Well-Care Visits',
      'open': '-',
      'numerator': '-',
      'denominator': '-',
      'closedApp': '-',
      'closedClaim': '-',
      'closedEmr': '-',
      'complianceRate': '%',
      'benchmark50th': '%',
      'benchmark75th': '%',
      'benchmark90th': '%',
      'hitsToTarget': '-',
      'weight': '-',
      'achieved': '%',
    },
    {
      'measureCode': 'CIS-3',
      'measureName': 'Childhood Immunization Status: Combination 3',
      'open': '-',
      'numerator': '-',
      'denominator': '-',
      'closedApp': '-',
      'closedClaim': '-',
      'closedEmr': '-',
      'complianceRate': '%',
      'benchmark50th': '%',
      'benchmark75th': '%',
      'benchmark90th': '%',
      'hitsToTarget': '-',
      'weight': '-',
      'achieved': '%',
    },
    {
      'measureCode': 'CRC',
      'measureName': 'Colorectal Cancer Screening',
      'open': '-',
      'numerator': '-',
      'denominator': '-',
      'closedApp': '-',
      'closedClaim': '-',
      'closedEmr': '-',
      'complianceRate': '%',
      'benchmark50th': '%',
      'benchmark75th': '%',
      'benchmark90th': '%',
      'hitsToTarget': '-',
      'weight': '-',
      'achieved': '%',
    },
    {
      'measureCode': 'CDC-EE',
      'measureName': 'Comprehensive Diabetes Care: Eye Exams',
      'open': '-',
      'numerator': '-',
      'denominator': '-',
      'closedApp': '-',
      'closedClaim': '-',
      'closedEmr': '-',
      'complianceRate': '%',
      'benchmark50th': '%',
      'benchmark75th': '%',
      'benchmark90th': '%',
      'hitsToTarget': '-',
      'weight': '-',
      'achieved': '%',
    },
    {
      'measureCode': 'CDC-HbA1c',
      'measureName': 'Comprehensive Diabetes Care: HbA1c Control (8.0% or 9.0%)',
      'open': '-',
      'numerator': '-',
      'denominator': '-',
      'closedApp': '-',
      'closedClaim': '-',
      'closedEmr': '-',
      'complianceRate': '%',
      'benchmark50th': '%',
      'benchmark75th': '%',
      'benchmark90th': '%',
      'hitsToTarget': '-',
      'weight': '-',
      'achieved': '%',
    },
    {
      'measureCode': 'CHBP',
      'measureName': 'Controlling High Blood Pressure',
      'open': '-',
      'numerator': '-',
      'denominator': '-',
      'closedApp': '-',
      'closedClaim': '-',
      'closedEmr': '-',
      'complianceRate': '%',
      'benchmark50th': '%',
      'benchmark75th': '%',
      'benchmark90th': '%',
      'hitsToTarget': '-',
      'weight': '-',
      'achieved': '%',
    },
    {
      'measureCode': 'FUA-7',
      'measureName': 'Follow-Up After ED Visit for Alcohol and Other Drug Abuse: Within 7 Days Post-Discharge',
      'open': '-',
      'numerator': '-',
      'denominator': '-',
      'closedApp': '-',
      'closedClaim': '-',
      'closedEmr': '-',
      'complianceRate': '%',
      'benchmark50th': '%',
      'benchmark75th': '%',
      'benchmark90th': '%',
      'hitsToTarget': '-',
      'weight': '-',
      'achieved': '%',
    },
    {
      'measureCode': 'MAC',
      'measureName': 'Medication Adherence for Cholesterol',
      'open': '-',
      'numerator': '-',
      'denominator': '-',
      'closedApp': '-',
      'closedClaim': '-',
      'closedEmr': '-',
      'complianceRate': '%',
      'benchmark50th': '%',
      'benchmark75th': '%',
      'benchmark90th': '%',
      'hitsToTarget': '-',
      'weight': '-',
      'achieved': '%',
    },
    {
      'measureCode': 'MAH',
      'measureName': 'Medication Adherence for Hypertension',
      'open': '-',
      'numerator': '-',
      'denominator': '-',
      'closedApp': '-',
      'closedClaim': '-',
      'closedEmr': '-',
      'complianceRate': '%',
      'benchmark50th': '%',
      'benchmark75th': '%',
      'benchmark90th': '%',
      'hitsToTarget': '-',
      'weight': '-',
      'achieved': '%',
    },
    {
      'measureCode': 'MAD',
      'measureName': 'Medication Adherence for Oral Diabetes Medications',
      'open': '-',
      'numerator': '-',
      'denominator': '-',
      'closedApp': '-',
      'closedClaim': '-',
      'closedEmr': '-',
      'complianceRate': '%',
      'benchmark50th': '%',
      'benchmark75th': '%',
      'benchmark90th': '%',
      'hitsToTarget': '-',
      'weight': '-',
      'achieved': '%',
    },
    {
      'measureCode': 'OMF',
      'measureName': 'Osteoporosis Management in Women Who Had a Fracture',
      'open': '-',
      'numerator': '-',
      'denominator': '-',
      'closedApp': '-',
      'closedClaim': '-',
      'closedEmr': '-',
      'complianceRate': '%',
      'benchmark50th': '%',
      'benchmark75th': '%',
      'benchmark90th': '%',
      'hitsToTarget': '-',
      'weight': '-',
      'achieved': '%',
    },
    {
      'measureCode': 'PPC-PP',
      'measureName': 'Prenatal and Postpartum Care: Postpartum Care',
      'open': '-',
      'numerator': '-',
      'denominator': '-',
      'closedApp': '-',
      'closedClaim': '-',
      'closedEmr': '-',
      'complianceRate': '%',
      'benchmark50th': '%',
      'benchmark75th': '%',
      'benchmark90th': '%',
      'hitsToTarget': '-',
      'weight': '-',
      'achieved': '%',
    },
    {
      'measureCode': 'ST-DM',
      'measureName': 'Statin Therapy for Patients with Diabetes- Received Statin Therapy',
      'open': '-',
      'numerator': '-',
      'denominator': '-',
      'closedApp': '-',
      'closedClaim': '-',
      'closedEmr': '-',
      'complianceRate': '%',
      'benchmark50th': '%',
      'benchmark75th': '%',
      'benchmark90th': '%',
      'hitsToTarget': '-',
      'weight': '-',
      'achieved': '%',
    },
    {
      'measureCode': 'TOC-MR',
      'measureName': 'Transitions of Care: Medication Reconciliation',
      'open': '-',
      'numerator': '-',
      'denominator': '-',
      'closedApp': '-',
      'closedClaim': '-',
      'closedEmr': '-',
      'complianceRate': '%',
      'benchmark50th': '%',
      'benchmark75th': '%',
      'benchmark90th': '%',
      'hitsToTarget': '-',
      'weight': '-',
      'achieved': '%',
    },
    {
      'measureCode': 'TOC-PE',
      'measureName': 'Transitions of Care: Patient Engagement after Inpatient Discharge',
      'open': '-',
      'numerator': '-',
      'denominator': '-',
      'closedApp': '-',
      'closedClaim': '-',
      'closedEmr': '-',
      'complianceRate': '%',
      'benchmark50th': '%',
      'benchmark75th': '%',
      'benchmark90th': '%',
      'hitsToTarget': '-',
      'weight': '-',
      'achieved': '%',
    },
    {
      'measureCode': 'VLS',
      'measureName': 'Viral Load Suppression',
      'open': '-',
      'numerator': '-',
      'denominator': '-',
      'closedApp': '-',
      'closedClaim': '-',
      'closedEmr': '-',
      'complianceRate': '%',
      'benchmark50th': '%',
      'benchmark75th': '%',
      'benchmark90th': '%',
      'hitsToTarget': '-',
      'weight': '-',
      'achieved': '%',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          TabletLayoutWidget(
            activeRoute: 'quality',
            onNavigation: _handleNavigation,
            header: Column(
              children: [
                TabletAppHeaderWidget(
                  onProfileAction: (action) {
                    _handleProfileAction(action);
                  },
                ),
                
                // Provider Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ProviderDropdownWidget(
                          selectedProvider: _selectedProvider,
                          providers: AppProviders.providers,
                          onProviderChanged: (provider) {
                            setState(() {
                              _selectedProvider = provider;
                            });
                            _showSuccessMessage('Quality scorecards updated for $provider');
                          },
                          maxWidth: 300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Page Title
                      const Padding(
                        padding: EdgeInsets.only(bottom: 24),
                        child: Text(
                          'Quality Score Cards',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),

                      // Practice Information Section
                      _buildPracticeInfoSection(),
                      const SizedBox(height: 16),
                      _buildClearAllButton(),
                      const SizedBox(height: 24),
                    
                      // Perfect Table
                      _buildPerfectTable(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(String route) {
    switch (route) {
      case 'dashboard':
        context.go('/dashboard');
        break;
      case 'quality':
        // Already on quality page
        break;
      case 'schedule':
        context.go('/schedule');
        break;
      case 'patients':
        context.go('/patients');
        break;
      case 'reports':
        context.go('/reports');
        break;
      case 'resources':
        context.go('/resources');
        break;
      case 'settings':
        context.go('/settings');
        break;
      case 'logout':
        // TODO: Handle logout
        break;
    }
  }

  void _handleProfileAction(String action) {
    switch (action) {
      case 'language':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Language clicked')),
        );
        break;
      case 'invitations':
        context.go('/invitations');
        break;
      case 'logout':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout clicked')),
        );
        break;
    }
  }





  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildPracticeInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildPracticeDropdown(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildMCODropdown(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildLOBDropdown(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildProductDropdown(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildMeasureDropdown(),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PRACTICE NAME:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF666666),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedProvider,
              isExpanded: true,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
              items: AppProviders.providers.map((String provider) {
                return DropdownMenuItem<String>(
                  value: provider,
                  child: Text(provider),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedProvider = newValue;
                  });
                  _showSuccessMessage('Quality scorecards updated for $newValue');
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMCODropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MCO:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF666666),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedMCO,
              isExpanded: true,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
              items: const [
                'ANTHEM',
                'HealthFirst',
                'MetroPlus',
                'Fidelis Care',
                'Empire BCBS',
                'UHC Community',
                'Emblem',
                'Molina',
              ].map((String mco) {
                return DropdownMenuItem<String>(
                  value: mco,
                  child: Text(mco),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedMCO = newValue;
                  });
                  _showSuccessMessage('Quality scorecards updated for $newValue');
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLOBDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'LOB:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF666666),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedLOB,
              isExpanded: true,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
              items: const [
                'MCD',
                'MCR',
              ].map((String lob) {
                return DropdownMenuItem<String>(
                  value: lob,
                  child: Text(lob),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedLOB = newValue;
                  });
                  _showSuccessMessage('Quality scorecards updated for $newValue');
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF666666),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedProduct,
              isExpanded: true,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
              items: const [
                'All',
                'EPP',
                'Medicaid/CHP',
                'HARP',
              ].map((String product) {
                return DropdownMenuItem<String>(
                  value: product,
                  child: Text(product),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedProduct = newValue;
                  });
                  _showSuccessMessage('Quality scorecards updated for $newValue');
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMeasureDropdown() {
    // Get all unique measure names from the data
    List<String> measureNames = _qualityMetrics
        .map((metric) => metric['measureName'] as String)
        .toSet()
        .toList();
    measureNames.insert(0, 'All'); // Add 'All' option at the beginning

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Measure:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF666666),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedMeasure,
              isExpanded: true,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
              items: measureNames.map((String measure) {
                return DropdownMenuItem<String>(
                  value: measure,
                  child: Text(
                    measure,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedMeasure = newValue;
                  });
                  _showSuccessMessage('Quality scorecards updated for $newValue');
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClearAllButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF667EEA),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: _clearAllFields,
              child: const Icon(
                Icons.clear_all,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _clearAllFields() {
    setState(() {
      _selectedProvider = 'All';
      _selectedMCO = 'ANTHEM';
      _selectedLOB = 'MCD';
      _selectedProduct = 'All';
      _selectedMeasure = 'All';
    });
    _showSuccessMessage('All fields cleared successfully');
  }



  Widget _buildPracticeInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF666666),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }




  Widget _buildPerfectTable() {
    final columns = [
      const TableColumn(title: 'Code', key: 'measureCode', width: 100, alignment: TextAlign.center),
      const TableColumn(title: 'Measure Name', key: 'measureName', width: 250),
      const TableColumn(title: 'Open', key: 'open', width: 80, alignment: TextAlign.center),
      const TableColumn(title: 'Num.', key: 'numerator', width: 80, alignment: TextAlign.center),
      const TableColumn(title: 'Den.', key: 'denominator', width: 80, alignment: TextAlign.center),
      const TableColumn(title: 'APP', key: 'closedApp', width: 80, alignment: TextAlign.center),
      const TableColumn(title: 'CLAIM', key: 'closedClaim', width: 100, alignment: TextAlign.center),
      const TableColumn(title: 'EMR', key: 'closedEmr', width: 80, alignment: TextAlign.center),
      const TableColumn(title: 'Comp %', key: 'complianceRate', width: 100, alignment: TextAlign.center),
      const TableColumn(title: '50TH', key: 'benchmark50th', width: 80, alignment: TextAlign.center),
      const TableColumn(title: '75TH', key: 'benchmark75th', width: 80, alignment: TextAlign.center),
      const TableColumn(title: '90TH', key: 'benchmark90th', width: 80, alignment: TextAlign.center),
      const TableColumn(title: 'Target', key: 'hitsToTarget', width: 100, alignment: TextAlign.center),
      const TableColumn(title: 'Weight', key: 'weight', width: 100, alignment: TextAlign.center),
      const TableColumn(title: 'Achieved', key: 'achieved', width: 100, alignment: TextAlign.center),
    ];

    return PerfectTableWidget(
      data: _qualityMetrics,
      columns: columns,
      height: 600,
      headerColor: const Color(0xFF4F46E5),
      rowColor: Colors.white,
      alternateRowColor: const Color(0xFFF8F9FA),
    );
  }

}

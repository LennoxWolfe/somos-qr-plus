import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/patient_profile_tablet_modal.dart';
import '../widgets/patient_filter_modal.dart';
import '../widgets/tablet_layout_widget.dart';
import '../widgets/tablet_app_header_widget.dart';
import '../widgets/provider_dropdown_widget.dart';
import '../core/constants/providers.dart';
import '../models/patient.dart';

class PatientsTabletScreen extends StatefulWidget {
  final String? patientName;
  
  const PatientsTabletScreen({super.key, this.patientName});

  @override
  State<PatientsTabletScreen> createState() => _PatientsTabletScreenState();
}

class _PatientsTabletScreenState extends State<PatientsTabletScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedProvider = 'All';
  List<Patient> _patients = [];
  List<Patient> _filteredPatients = [];
  String _mcoFilter = '';
  String _providerFilter = '';
  String _dobFilter = '';
  int _currentPage = 1;
  int _rowsPerPage = 20;

  @override
  void initState() {
    super.initState();
    _initializePatients();
    _filteredPatients = _patients;
    
    // If a patient name is provided, automatically open their profile
    if (widget.patientName != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openPatientProfileFromName(widget.patientName!);
      });
    }
  }

  void _openPatientProfileFromName(String patientName) {
    // Find the patient by name
    final patient = _patients.firstWhere(
      (p) => p.fullName.toLowerCase() == patientName.toLowerCase(),
      orElse: () => _patients.first, // fallback to first patient if not found
    );
    
    // Open the patient profile modal
    showDialog(
      context: context,
      builder: (context) => PatientProfileTabletModal(
        patient: patient,
      ),
    );
  }

  void _initializePatients() {
    _patients = [
      Patient('James Anderson', '3/15/1965', 'HealthFirst', 85, 92),
      Patient('Maria Rodriguez', '7/22/1978', 'MetroPlus', 67, 74),
      Patient('Robert Johnson', '11/30/1982', 'Fidelis Care', 91, 88),
      Patient('Sarah Williams', '4/12/1995', 'Empire BlueCross BlueShield', 78, 82),
      Patient('David Chen', '9/3/1973', 'UnitedHealthcare Community Plan', 73, 79),
      Patient('Jennifer Lopez', '2/28/1988', 'HealthFirst', 89, 95),
      Patient('Michael Davis', '6/17/1969', 'MetroPlus', 71, 68),
      Patient('Lisa Thompson', '12/5/1991', 'Fidelis Care', 94, 91),
      Patient('William Martinez', '8/9/1984', 'Empire BlueCross BlueShield', 76, 83),
      Patient('Emily Wilson', '1/14/1976', 'UnitedHealthcare Community Plan', 82, 87),
      Patient('Christopher Lee', '5/20/1993', 'HealthFirst', 88, 93),
      Patient('Amanda Brown', '10/8/1987', 'MetroPlus', 75, 81),
      Patient('Daniel Kim', '7/31/1972', 'Fidelis Care', 69, 76),
      Patient('Jessica Taylor', '3/25/1990', 'Empire BlueCross BlueShield', 86, 89),
      Patient('Kevin Patel', '11/12/1981', 'UnitedHealthcare Community Plan', 72, 77),
    ];
  }

  void _applyFilters() {
    setState(() {
      _filteredPatients = _patients.where((patient) {
        bool matchesMCO = _mcoFilter.isEmpty || _mcoFilter == 'All' || patient.mco == _mcoFilter;
        bool matchesProvider = _providerFilter.isEmpty || _providerFilter == 'All';
        bool matchesDOB = _dobFilter.isEmpty || patient.dob == _dobFilter;
        bool matchesSearch = _searchController.text.isEmpty ||
            patient.fullName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            patient.dob.contains(_searchController.text) ||
            patient.mco.toLowerCase().contains(_searchController.text.toLowerCase());
        
        return matchesMCO && matchesProvider && matchesDOB && matchesSearch;
      }).toList();
      
      _currentPage = 1;
    });
  }

  void _showPatientProfile(Patient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientProfileTabletModal(patient: patient),
      ),
    );
  }

  void _showFilterModal() {
    showDialog(
      context: context,
      builder: (context) => PatientFilterModal(
        mcoFilter: _mcoFilter,
        providerFilter: _providerFilter,
        dobFilter: _dobFilter,
        onApply: (mco, provider, dob) {
          setState(() {
            _mcoFilter = mco;
            _providerFilter = provider;
            _dobFilter = dob;
          });
          _applyFilters();
        },
      ),
    );
  }

  List<Patient> get _paginatedPatients {
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage;
    return _filteredPatients.sublist(
      startIndex,
      endIndex > _filteredPatients.length ? _filteredPatients.length : endIndex,
    );
  }

  int get _totalPages => (_filteredPatients.length / _rowsPerPage).ceil();

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
                            setState(() => _selectedProvider = provider);
                          },
                          maxWidth: 300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Title
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Text(
                      'My Patients',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  
                  // Search and Filter Bar
                  Container(
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
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search patients...',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey.shade500,
                                  size: 20,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              onChanged: (value) => _applyFilters(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: IconButton(
                            onPressed: _showFilterModal,
                            icon: Icon(
                              Icons.filter_list,
                              color: Colors.grey.shade700,
                              size: 20,
                            ),
                            tooltip: 'Filter by MCO, Provider, or DOB',
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Patients Table
                  Container(
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
                        // Table Header
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                          ),
                          child: const Row(
                            children: [
                              Expanded(flex: 3, child: Text('Full Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
                              Expanded(flex: 2, child: Text('DOB', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
                              Expanded(flex: 3, child: Text('MCO', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
                              Expanded(flex: 1, child: Text('GIC', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
                              Expanded(flex: 1, child: Text('RA', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
                            ],
                          ),
                        ),
                        // Table Rows
                        ..._paginatedPatients.map((patient) => GestureDetector(
                          onTap: () => _showPatientProfile(patient),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 3, child: Text(patient.fullName, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16))),
                                Expanded(flex: 2, child: Text(patient.dob, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16))),
                                Expanded(flex: 3, child: Text(patient.mco, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16))),
                                Expanded(flex: 1, child: Text(patient.gic.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16))),
                                Expanded(flex: 1, child: Text(patient.ra.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16))),
                              ],
                            ),
                          ),
                        )).toList(),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Pagination
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
                    child: Row(
                      children: [
                        // Left side
                        Row(
                          children: [
                            Text('Rows per page: ', style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: DropdownButton<int>(
                                value: _rowsPerPage,
                                underline: const SizedBox(),
                                style: const TextStyle(fontSize: 16),
                                items: [20, 35, 50, 100].map((size) => DropdownMenuItem(
                                  value: size,
                                  child: Text(size.toString()),
                                )).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _rowsPerPage = value;
                                      _currentPage = 1;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Right side
                        Row(
                          children: [
                            Text(
                              'Page $_currentPage of $_totalPages',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                            ),
                            const SizedBox(width: 20),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                                  icon: const Icon(Icons.chevron_left, size: 24),
                                  style: IconButton.styleFrom(
                                    backgroundColor: _currentPage > 1 ? Colors.grey.shade100 : Colors.grey.shade50,
                                    padding: const EdgeInsets.all(12),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: _currentPage < _totalPages ? () => setState(() => _currentPage++) : null,
                                  icon: const Icon(Icons.chevron_right, size: 24),
                                  style: IconButton.styleFrom(
                                    backgroundColor: _currentPage < _totalPages ? Colors.grey.shade100 : Colors.grey.shade50,
                                    padding: const EdgeInsets.all(12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
        context.go('/quality-scorecards');
        break;
      case 'schedule':
        context.go('/schedule');
        break;
      case 'patients':
        // Already on patients page
        break;
      case 'reports':
        context.go('/reports');
        break;
      case 'tsm':
        context.go('/tsm-measures');
        break;
      case 'resources':
        context.go('/resources');
        break;
      case 'settings':
        context.go('/settings');
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
        context.go('/invitations');
        break;
      case 'logout':
        // Handle logout logic
        break;
    }
  }
}

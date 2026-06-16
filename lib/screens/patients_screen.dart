import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/patient_profile_modal.dart';
import '../widgets/patient_filter_modal.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/provider_dropdown_widget.dart';
import '../core/constants/providers.dart';
import '../models/patient.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  bool _isDrawerOpen = false;
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
        builder: (context) => PatientProfileModal(patient: patient),
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
      body: Stack(
        children: [
          // Main Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              AppHeaderWidget(
                onMenuPressed: () {
                  setState(() {
                    _isDrawerOpen = true;
                  });
                },
                onProfileAction: (action) {
                  _handleProfileAction(action);
                },
              ),
              
              // Provider Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              
              // Page Title
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: const Text(
                  'My Patients',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              
              // Search and Filter Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search patients...',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey.shade500,
                              size: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          onChanged: (value) => _applyFilters(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: _showFilterModal,
                        icon: Icon(
                          Icons.filter_list,
                          color: Colors.grey.shade700,
                          size: 16,
                        ),
                        tooltip: 'Filter by MCO, Provider, or DOB',
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Patients Table
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          // Table Header
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                            ),
                            child: const Row(
                              children: [
                                Expanded(flex: 3, child: Text('Full Name', style: TextStyle(fontWeight: FontWeight.w600))),
                                Expanded(flex: 2, child: Text('DOB', style: TextStyle(fontWeight: FontWeight.w600))),
                                Expanded(flex: 3, child: Text('MCO', style: TextStyle(fontWeight: FontWeight.w600))),
                                Expanded(flex: 1, child: Text('GIC', style: TextStyle(fontWeight: FontWeight.w600))),
                                Expanded(flex: 1, child: Text('RA', style: TextStyle(fontWeight: FontWeight.w600))),
                              ],
                            ),
                          ),
                          // Table Rows
                          ..._paginatedPatients.map((patient) => GestureDetector(
                            onTap: () => _showPatientProfile(patient),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 3, child: Text(patient.fullName, overflow: TextOverflow.ellipsis)),
                                  Expanded(flex: 2, child: Text(patient.dob, overflow: TextOverflow.ellipsis)),
                                  Expanded(flex: 3, child: Text(patient.mco, overflow: TextOverflow.ellipsis)),
                                  Expanded(flex: 1, child: Text(patient.gic.toString(), overflow: TextOverflow.ellipsis)),
                                  Expanded(flex: 1, child: Text(patient.ra.toString(), overflow: TextOverflow.ellipsis)),
                                ],
                              ),
                            ),
                          )).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Pagination
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  children: [
                    // Left side
                    Row(
                      children: [
                        Text('Rows per page: ', style: TextStyle(color: Colors.grey.shade600)),
                        DropdownButton<int>(
                          value: _rowsPerPage,
                          underline: const SizedBox(),
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
                      ],
                    ),
                    const Spacer(),
                    // Right side
                    Row(
                      children: [
                        Text(
                          'Page $_currentPage of $_totalPages',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                              icon: const Icon(Icons.chevron_left),
                            ),
                            IconButton(
                              onPressed: _currentPage < _totalPages ? () => setState(() => _currentPage++) : null,
                              icon: const Icon(Icons.chevron_right),
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
          
          // Drawer Overlay (transparent)
          if (_isDrawerOpen)
            GestureDetector(
              onTap: () => setState(() => _isDrawerOpen = false),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          
          // Navigation Drawer
          AppDrawerWidget(
            isOpen: _isDrawerOpen,
            onClose: () {
              setState(() {
                _isDrawerOpen = false;
              });
            },
            onNavigation: (route) {
              setState(() {
                _isDrawerOpen = false;
              });
              _handleNavigation(route);
            },
            activeRoute: 'patients',
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
      case 'risk-adjustment':
        context.go('/risk-adjustment-scorecards');
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
        context.go('/invitation');
        break;
      case 'logout':
        // Handle logout logic
        break;
    }
  }

}



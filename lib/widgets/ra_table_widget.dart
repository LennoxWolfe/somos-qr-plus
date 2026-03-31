import 'package:flutter/material.dart';

import 'report_pagination_bar.dart';

class RATableWidget extends StatefulWidget {
  const RATableWidget({super.key});

  @override
  State<RATableWidget> createState() => _RATableWidgetState();
}

class _RATableWidgetState extends State<RATableWidget> {
  List<RAPatient> _patients = [];
  List<RAPatient> _filteredPatients = [];
  String _sortColumn = 'name';
  bool _sortAscending = true;
  
  // Pagination
  int _currentPage = 1;
  int _rowsPerPage = 10;
  
  // Filter controllers
  final TextEditingController _nameFilterController = TextEditingController();
  final TextEditingController _dobFilterController = TextEditingController();
  final TextEditingController _hccFilterController = TextEditingController();
  final TextEditingController _dosFilterController = TextEditingController();
  final TextEditingController _phoneFilterController = TextEditingController();
  String _mcoFilter = '';
  String _statusFilter = '';

  @override
  void initState() {
    super.initState();
    _loadSampleData();
    _applyFilters();
  }

  void _loadSampleData() {
    _patients = [
      RAPatient(
        name: 'Miriam Bernal',
        mco: 'Healthfirst',
        dob: '05-05-1940',
        hccIcd10: 'F333',
        status: 'Completed',
        lastDos: '',
        phone: '2129239344',
      ),
      RAPatient(
        name: 'Andres Estevez',
        mco: 'Healthfirst',
        dob: '10-17-1949',
        hccIcd10: 'G40A09',
        status: 'Completed',
        lastDos: '',
        phone: '2125684972',
      ),
      RAPatient(
        name: 'Carlos Gonzalez',
        mco: 'Healthfirst',
        dob: '08-14-1956',
        hccIcd10: 'C180, C182, C189',
        status: 'Completed',
        lastDos: '',
        phone: '3475892631',
      ),
      RAPatient(
        name: 'Carlos Yciano Jimenez',
        mco: 'Healthfirst',
        dob: '08-12-1953',
        hccIcd10: 'E119',
        status: 'Completed',
        lastDos: '',
        phone: '9174032576',
      ),
      RAPatient(
        name: 'Fiordaliza Jorge',
        mco: 'Healthfirst',
        dob: '05-19-1962',
        hccIcd10: '',
        status: 'Completed',
        lastDos: '',
        phone: '3474655701',
      ),
      RAPatient(
        name: 'Elizabeth Hernandez',
        mco: 'Healthfirst',
        dob: '05-12-1953',
        hccIcd10: '',
        status: 'Completed',
        lastDos: '',
        phone: '16465252673',
      ),
      RAPatient(
        name: 'Juan M Santos Tavarez',
        mco: 'Healthfirst',
        dob: '01-23-1958',
        hccIcd10: '',
        status: 'Completed',
        lastDos: '',
        phone: '13479805448',
      ),
      RAPatient(
        name: 'Juana Serrano',
        mco: 'Healthfirst',
        dob: '12-21-1953',
        hccIcd10: '',
        status: 'Completed',
        lastDos: '',
        phone: '6463162672',
      ),
      RAPatient(
        name: 'Francisco Monsanto',
        mco: 'Healthfirst',
        dob: '11-06-1939',
        hccIcd10: '',
        status: 'Open',
        lastDos: '',
        phone: '7185378048',
      ),
      RAPatient(
        name: 'Nury Caraballo',
        mco: 'Healthfirst',
        dob: '05-09-1952',
        hccIcd10: '',
        status: 'Completed',
        lastDos: '',
        phone: '3473260066',
      ),
      RAPatient(
        name: 'Elias Sepulveda Quinones',
        mco: 'Healthfirst',
        dob: '04-02-1947',
        hccIcd10: '',
        status: 'Completed',
        lastDos: '',
        phone: '6464846810',
      ),
    ];
    _filteredPatients = List.from(_patients);
  }

  void _applyFilters() {
    setState(() {
      _filteredPatients = _patients.where((patient) {
        final nameMatch = patient.name.toLowerCase().contains(_nameFilterController.text.toLowerCase());
        final mcoMatch = _mcoFilter.isEmpty || patient.mco == _mcoFilter;
        final dobMatch = patient.dob.contains(_dobFilterController.text);
        final hccMatch = patient.hccIcd10.contains(_hccFilterController.text);
        final statusMatch = _statusFilter.isEmpty || patient.status == _statusFilter;
        final dosMatch = patient.lastDos.contains(_dosFilterController.text);
        final phoneMatch = patient.phone.contains(_phoneFilterController.text);
        
        return nameMatch && mcoMatch && dobMatch && hccMatch && statusMatch && dosMatch && phoneMatch;
      }).toList();
      _currentPage = 1; // Reset to first page when filtering
    });
  }

  List<RAPatient> get _paginatedPatients {
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage;
    return _filteredPatients.sublist(
      startIndex,
      endIndex > _filteredPatients.length ? _filteredPatients.length : endIndex,
    );
  }

  int get _totalPages {
    final n = _filteredPatients.length;
    if (n == 0) return 1;
    return (n / _rowsPerPage).ceil();
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  void _sortTable(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = column;
        _sortAscending = true;
      }
      
      _filteredPatients.sort((a, b) {
        var aValue = _getValueForColumn(a, column);
        var bValue = _getValueForColumn(b, column);
        
        int comparison = aValue.compareTo(bValue);
        return _sortAscending ? comparison : -comparison;
      });
    });
  }

  dynamic _getValueForColumn(RAPatient patient, String column) {
    switch (column) {
      case 'name':
        return patient.name;
      case 'mco':
        return patient.mco;
      case 'dob':
        return patient.dob;
      case 'hccIcd10':
        return patient.hccIcd10;
      case 'status':
        return patient.status;
      case 'lastDos':
        return patient.lastDos;
      case 'phone':
        return patient.phone;
      default:
        return patient.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing
        double fontSize, padding;
        if (constraints.maxWidth < 600) {
          fontSize = 11;
          padding = 6;
        } else if (constraints.maxWidth < 900) {
          fontSize = 12;
          padding = 8;
        } else {
          fontSize = 14;
          padding = 12;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Table Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: const Color(0xFFf8f9fa),
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'RA Detailed Report',
                      style: TextStyle(
                        fontSize: fontSize + 2,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Export functionality - silent for now
                    },
                    icon: const Icon(Icons.file_download, size: 20),
                    tooltip: 'Export',
                  ),
                ],
              ),
            ),
            
            // Filter Row
            Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Column(
                children: [
                  // First row of filters - 3 columns for better fit
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterField(
                          controller: _nameFilterController,
                          hint: 'Name...',
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: _buildFilterDropdown(
                          value: _mcoFilter,
                          items: ['', 'Healthfirst', 'Anthem', 'Emblem', 'Molina'],
                          hint: 'MCO',
                          onChanged: (value) {
                            _mcoFilter = value ?? '';
                            _applyFilters();
                          },
                        ),
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: _buildFilterField(
                          controller: _dobFilterController,
                          hint: 'DOB...',
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: padding),
                  // Second row of filters - 3 columns for better fit
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterField(
                          controller: _hccFilterController,
                          hint: 'HCC/ICD10...',
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: _buildFilterDropdown(
                          value: _statusFilter,
                          items: ['', 'Completed', 'Open'],
                          hint: 'Status',
                          onChanged: (value) {
                            _statusFilter = value ?? '';
                            _applyFilters();
                          },
                        ),
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: _buildFilterField(
                          controller: _dosFilterController,
                          hint: 'DOS...',
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: padding),
                  // Third row of filters - 1 column for phone
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterField(
                          controller: _phoneFilterController,
                          hint: 'Phone...',
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Table
            Expanded(
              child: Column(
                children: [
                  // Table with horizontal scroll
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          columnSpacing: padding * 2,
                          dataTextStyle: TextStyle(fontSize: fontSize),
                          headingTextStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF333333),
                          ),
                          columns: [
                            _buildDataColumn('NAME', 'name', fontSize),
                            _buildDataColumn('MCO', 'mco', fontSize),
                            _buildDataColumn('DOB', 'dob', fontSize),
                            _buildDataColumn('HCC/ICD10', 'hccIcd10', fontSize),
                            _buildDataColumn('STATUS', 'status', fontSize),
                            _buildDataColumn('LAST DOS', 'lastDos', fontSize),
                            _buildDataColumn('PHONE', 'phone', fontSize),
                          ],
                          rows: _paginatedPatients.map((patient) {
                            return DataRow(
                              cells: [
                                DataCell(Text(patient.name)),
                                DataCell(Text(patient.mco)),
                                DataCell(Text(patient.dob)),
                                DataCell(Text(patient.hccIcd10.isEmpty ? '-' : patient.hccIcd10)),
                                DataCell(Text(patient.status)),
                                DataCell(Text(patient.lastDos.isEmpty ? '-' : patient.lastDos)),
                                DataCell(Text(patient.phone)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  // Pagination Controls
                  const SizedBox(height: 16),
                  _buildPaginationControls(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  DataColumn _buildDataColumn(String label, String column, double fontSize) {
    return DataColumn(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          SizedBox(width: 4),
          Icon(
            _sortColumn == column
                ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                : Icons.unfold_more,
            size: fontSize,
            color: Colors.grey.shade600,
          ),
        ],
      ),
      onSort: (columnIndex, ascending) => _sortTable(column),
    );
  }

  Widget _buildPaginationControls() {
    return ReportPaginationBar(
      total: _filteredPatients.length,
      currentPage: _currentPage,
      rowsPerPage: _rowsPerPage,
      onPageChanged: _goToPage,
      onRowsPerPageChanged: (r) {
        setState(() {
          _rowsPerPage = r;
          _currentPage = 1;
        });
      },
    );
  }

  Widget _buildFilterField({
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 80), // Minimum width constraint
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          isDense: true,
        ),
        style: const TextStyle(fontSize: 11),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 80), // Minimum width constraint
      child: DropdownButtonFormField<String>(
        value: value!.isEmpty ? null : value,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          isDense: true,
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item.isEmpty ? null : item,
            child: Text(
              item.isEmpty ? hint : item,
              style: TextStyle(
                fontSize: 11,
                color: item.isEmpty ? Colors.grey.shade500 : Colors.black,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  void dispose() {
    _nameFilterController.dispose();
    _dobFilterController.dispose();
    _hccFilterController.dispose();
    _dosFilterController.dispose();
    _phoneFilterController.dispose();
    super.dispose();
  }
}

class RAPatient {
  final String name;
  final String mco;
  final String dob;
  final String hccIcd10;
  final String status;
  final String lastDos;
  final String phone;

  RAPatient({
    required this.name,
    required this.mco,
    required this.dob,
    required this.hccIcd10,
    required this.status,
    required this.lastDos,
    required this.phone,
  });
}

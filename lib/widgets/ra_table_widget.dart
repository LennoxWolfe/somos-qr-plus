import 'package:flutter/material.dart';
import '../core/theme/report_table_tokens.dart';
import 'report_table_card.dart';
import 'report_table_toolbar.dart';

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

  int get _totalPages => (_filteredPatients.length / _rowsPerPage).ceil();

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  void _toolbarRefresh() {
    _nameFilterController.clear();
    _dobFilterController.clear();
    _hccFilterController.clear();
    _dosFilterController.clear();
    _phoneFilterController.clear();
    _mcoFilter = '';
    _statusFilter = '';
    _applyFilters();
  }

  void _toolbarExport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export (demo)'),
        behavior: SnackBarBehavior.floating,
      ),
    );
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

        return ReportTableCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ReportTableToolbar(
                title: 'RA Detailed Report',
                onRefresh: _toolbarRefresh,
                onExport: _toolbarExport,
              ),
              Container(
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade300)),
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
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        child: ReportTableTokens.themedDataTable(
                          context: context,
                          dataTable: DataTable(
                            columnSpacing: padding * 2,
                            columns: [
                              _buildDataColumn('NAME', 'name', fontSize),
                              _buildDataColumn('MCO', 'mco', fontSize),
                              _buildDataColumn('DOB', 'dob', fontSize),
                              _buildDataColumn('HCC/ICD10', 'hccIcd10', fontSize),
                              _buildDataColumn('STATUS', 'status', fontSize),
                              _buildDataColumn('LAST DOS', 'lastDos', fontSize),
                              _buildDataColumn('PHONE', 'phone', fontSize),
                            ],
                            rows: _paginatedPatients
                                .asMap()
                                .entries
                                .map((e) {
                              final i = e.key;
                              final patient = e.value;
                              return DataRow(
                                color: WidgetStateProperty.all(
                                  i.isEven
                                      ? Colors.white
                                      : ReportTableTokens.zebraOdd,
                                ),
                                cells: [
                                  DataCell(Text(patient.name)),
                                  DataCell(Text(patient.mco)),
                                  DataCell(Text(patient.dob)),
                                  DataCell(Text(patient.hccIcd10.isEmpty
                                      ? '-'
                                      : patient.hccIcd10)),
                                  DataCell(Text(patient.status)),
                                  DataCell(Text(patient.lastDos.isEmpty
                                      ? '-'
                                      : patient.lastDos)),
                                  DataCell(Text(patient.phone)),
                                ],
                              );
                            }).toList(),
                          ),
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
          ),
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
          const SizedBox(width: 4),
          Icon(
            _sortColumn == column
                ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                : Icons.unfold_more,
            size: 14,
            color: const Color(0xFF666666),
          ),
        ],
      ),
      onSort: (columnIndex, ascending) => _sortTable(column),
    );
  }

  Widget _buildPaginationControls() {
    final startIndex = (_currentPage - 1) * _rowsPerPage + 1;
    final endIndex = (_currentPage * _rowsPerPage).clamp(0, _filteredPatients.length);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // If width is too small, stack vertically
          if (constraints.maxWidth < 600) {
            return Column(
              children: [
                // Rows per page selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Rows per page:',
                      style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
                    ),
                    const SizedBox(width: 6),
                    DropdownButton<int>(
                      value: _rowsPerPage,
                      items: [10, 20, 50, 100].map((value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value', style: const TextStyle(fontSize: 11)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _rowsPerPage = value;
                            _currentPage = 1;
                          });
                        }
                      },
                      underline: Container(),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Page info and navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Showing $startIndex-$endIndex of ${_filteredPatients.length}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
                    ),
                    const SizedBox(width: 12),
                    _buildCompactNavigation(),
                  ],
                ),
              ],
            );
          } else {
            // Horizontal layout for wider screens
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Rows per page selector
                Row(
                  children: [
                    const Text(
                      'Rows per page:',
                      style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
                    ),
                    const SizedBox(width: 6),
                    DropdownButton<int>(
                      value: _rowsPerPage,
                      items: [10, 20, 50, 100].map((value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value', style: const TextStyle(fontSize: 11)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _rowsPerPage = value;
                            _currentPage = 1;
                          });
                        }
                      },
                      underline: Container(),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                
                // Page info and navigation
                Row(
                  children: [
                    Text(
                      'Showing $startIndex-$endIndex of ${_filteredPatients.length}',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
                    ),
                    const SizedBox(width: 12),
                    _buildCompactNavigation(),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildCompactNavigation() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous button
        IconButton(
          onPressed: _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
          icon: const Icon(Icons.chevron_left),
          iconSize: 18,
          padding: const EdgeInsets.all(2),
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
        
        // Current page number only (to save space)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1976D2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '$_currentPage',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        // Next button
        IconButton(
          onPressed: _currentPage < _totalPages ? () => _goToPage(_currentPage + 1) : null,
          icon: const Icon(Icons.chevron_right),
          iconSize: 18,
          padding: const EdgeInsets.all(2),
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
      ],
    );
  }

  Widget _buildFilterField({
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 80),
      child: TextField(
        controller: controller,
        decoration: ReportTableTokens.filterFieldDecoration(hint: hint),
        style: const TextStyle(fontSize: 11),
        textAlign: TextAlign.center,
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
      constraints: const BoxConstraints(minWidth: 80),
      child: DropdownButtonFormField<String>(
        value: value!.isEmpty ? null : value,
        decoration: ReportTableTokens.dropdownFieldDecoration(hint: hint),
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

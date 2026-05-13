import 'package:flutter/material.dart';

class TSMTableWidget extends StatefulWidget {
  const TSMTableWidget({super.key});

  @override
  State<TSMTableWidget> createState() => _TSMTableWidgetState();
}

class _TSMTableWidgetState extends State<TSMTableWidget> {
  List<TSMRecord> _records = [];
  List<TSMRecord> _filteredRecords = [];
  String _sortColumn = 'mcoMemberId';
  bool _sortAscending = true;

  // Pagination
  int _currentPage = 1;
  int _rowsPerPage = 10;

  // Filter controllers (same style as GIC)
  final TextEditingController _memberNameFilterController =
      TextEditingController();
  final TextEditingController _memberIdFilterController =
      TextEditingController();
  final TextEditingController _dobFilterController = TextEditingController();
  final TextEditingController _measureCodeFilterController =
      TextEditingController();
  final TextEditingController _phoneFilterController = TextEditingController();
  final TextEditingController _deadlineFilterController =
      TextEditingController();
  String _mcoFilter = '';
  String _measureFilter = '';
  String _ipaFilter = '';

  @override
  void initState() {
    super.initState();
    _loadSampleData();
    _applyFilters();
  }

  void _loadSampleData() {
    _records = [
      TSMRecord(
        pcpTin: '12-3456789',
        pcpPractice: 'Bronx Family Care',
        pcpNpi: '1234567890',
        mco: 'Healthfirst',
        ipa: 'Metro IPA',
        product: 'Medicaid',
        mcoProduct: 'HF Gold',
        mcoMemberId: '1240',
        memberName: 'Maria Alvarez',
        memberDob: '03-10-1972',
        memberAddress1: '110 E 170th St',
        memberAddress2: 'Apt 3B',
        memberCity: 'Bronx',
        memberZip: '10452',
        memberPhone1: '7185550121',
        memberPhone2: '3475551212',
        emrPhone3: '2125550100',
        measureCode: 'TSM-01',
        measure: 'Medication Reconciliation',
        eventDate: '04-10-2026',
        alertDate: '03-20-2026',
        deadlineCalculation: '7 due',
        diagnosisCode: 'I10',
        diagnosisDescription: 'Essential (primary) hypertension',
        admitFacility: 'Lincoln Medical Center',
      ),
      TSMRecord(
        pcpTin: '98-7654321',
        pcpPractice: 'Washington Heights Clinic',
        pcpNpi: '9876543210',
        mco: 'Anthem',
        ipa: 'North IPA',
        product: 'Medicare',
        mcoProduct: 'Anthem Plus',
        mcoMemberId: '1318',
        memberName: 'Jose Martinez',
        memberDob: '11-22-1968',
        memberAddress1: '450 W 181st St',
        memberAddress2: '',
        memberCity: 'New York',
        memberZip: '10033',
        memberPhone1: '6465559182',
        memberPhone2: '',
        emrPhone3: '2125550200',
        measureCode: 'TSM-03',
        measure: 'Follow-up Call',
        eventDate: '04-02-2026',
        alertDate: '03-19-2026',
        deadlineCalculation: '3 due',
        diagnosisCode: 'E11.9',
        diagnosisDescription: 'Type 2 diabetes mellitus without complications',
        admitFacility: 'NewYork-Presbyterian',
      ),
      TSMRecord(
        pcpTin: '11-2345678',
        pcpPractice: 'Queens Community Health',
        pcpNpi: '1122334455',
        mco: 'Emblem',
        ipa: 'East IPA',
        product: 'Commercial',
        mcoProduct: 'Emblem Core',
        mcoMemberId: '1407',
        memberName: 'Ana Gomez',
        memberDob: '07-04-1980',
        memberAddress1: '76-12 Roosevelt Ave',
        memberAddress2: 'Floor 2',
        memberCity: 'Jackson Heights',
        memberZip: '11372',
        memberPhone1: '9175552334',
        memberPhone2: '7185552334',
        emrPhone3: '7185550300',
        measureCode: 'TSM-02',
        measure: 'Transition of Care',
        eventDate: '04-15-2026',
        alertDate: '03-23-2026',
        deadlineCalculation: '12 due',
        diagnosisCode: 'J44.9',
        diagnosisDescription: 'Chronic obstructive pulmonary disease, unspecified',
        admitFacility: 'Elmhurst Hospital',
      ),
      TSMRecord(
        pcpTin: '55-6677889',
        pcpPractice: 'Brooklyn Medical Group',
        pcpNpi: '5566778899',
        mco: 'Molina',
        ipa: 'South IPA',
        product: 'Medicaid',
        mcoProduct: 'Molina Basic',
        mcoMemberId: '1529',
        memberName: 'Carlos Torres',
        memberDob: '01-29-1975',
        memberAddress1: '204 Court St',
        memberAddress2: '',
        memberCity: 'Brooklyn',
        memberZip: '11201',
        memberPhone1: '7185559923',
        memberPhone2: '',
        emrPhone3: '7185550400',
        measureCode: 'TSM-04',
        measure: 'Medication Review',
        eventDate: '04-05-2026',
        alertDate: '03-18-2026',
        deadlineCalculation: '5 due',
        diagnosisCode: 'N18.3',
        diagnosisDescription: 'Chronic kidney disease, stage 3',
        admitFacility: 'Maimonides Medical Center',
      ),
      TSMRecord(
        pcpTin: '44-3322110',
        pcpPractice: 'Harlem Health Partners',
        pcpNpi: '4433221100',
        mco: 'Healthfirst',
        ipa: 'Metro IPA',
        product: 'Medicare',
        mcoProduct: 'HF Silver',
        mcoMemberId: '1642',
        memberName: 'Elena Ruiz',
        memberDob: '09-14-1963',
        memberAddress1: '12 Lenox Ave',
        memberAddress2: 'Unit 5A',
        memberCity: 'New York',
        memberZip: '10027',
        memberPhone1: '2125554733',
        memberPhone2: '6465554733',
        emrPhone3: '2125550500',
        measureCode: 'TSM-01',
        measure: 'Medication Reconciliation',
        eventDate: '03-28-2026',
        alertDate: '03-15-2026',
        deadlineCalculation: 'Completed',
        diagnosisCode: 'I25.10',
        diagnosisDescription: 'Atherosclerotic heart disease of native coronary artery',
        admitFacility: 'Mount Sinai Hospital',
      ),
    ];
    _filteredRecords = List.from(_records);
  }

  void _applyFilters() {
    setState(() {
      _filteredRecords = _records.where((record) {
        final memberNameMatch = record.memberName
            .toLowerCase()
            .contains(_memberNameFilterController.text.toLowerCase());
        final memberIdMatch =
            record.mcoMemberId.contains(_memberIdFilterController.text);
        final dobMatch = record.memberDob.contains(_dobFilterController.text);
        final measureCodeMatch =
            record.measureCode.contains(_measureCodeFilterController.text);
        final phoneMatch = record.memberPhone1.contains(_phoneFilterController.text);
        final deadlineMatch = record.deadlineCalculation
            .toLowerCase()
            .contains(_deadlineFilterController.text.toLowerCase());

        final mcoMatch = _mcoFilter.isEmpty || record.mco == _mcoFilter;
        final measureMatch =
            _measureFilter.isEmpty || record.measure == _measureFilter;
        final ipaMatch =
            _ipaFilter.isEmpty || record.ipa == _ipaFilter;

        return memberNameMatch &&
            memberIdMatch &&
            dobMatch &&
            measureCodeMatch &&
            phoneMatch &&
            deadlineMatch &&
            mcoMatch &&
            measureMatch &&
            ipaMatch;
      }).toList();
      _currentPage = 1;
    });
  }

  List<TSMRecord> get _paginatedRecords {
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage;
    return _filteredRecords.sublist(
      startIndex,
      endIndex > _filteredRecords.length ? _filteredRecords.length : endIndex,
    );
  }

  int get _totalPages {
    if (_filteredRecords.isEmpty) return 1;
    return (_filteredRecords.length / _rowsPerPage).ceil();
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

      _filteredRecords.sort((a, b) {
        final aValue = _getValueForColumn(a, column);
        final bValue = _getValueForColumn(b, column);
        final comparison = aValue.compareTo(bValue);
        return _sortAscending ? comparison : -comparison;
      });
    });
  }

  String _getValueForColumn(TSMRecord record, String column) {
    switch (column) {
      case 'pcpTin':
        return record.pcpTin;
      case 'pcpPractice':
        return record.pcpPractice;
      case 'pcpNpi':
        return record.pcpNpi;
      case 'mco':
        return record.mco;
      case 'ipa':
        return record.ipa;
      case 'product':
        return record.product;
      case 'mcoProduct':
        return record.mcoProduct;
      case 'mcoMemberId':
        return record.mcoMemberId;
      case 'memberName':
        return record.memberName;
      case 'memberDob':
        return record.memberDob;
      case 'memberAddress1':
        return record.memberAddress1;
      case 'memberAddress2':
        return record.memberAddress2;
      case 'memberCity':
        return record.memberCity;
      case 'memberZip':
        return record.memberZip;
      case 'memberPhone1':
        return record.memberPhone1;
      case 'memberPhone2':
        return record.memberPhone2;
      case 'emrPhone3':
        return record.emrPhone3;
      case 'measureCode':
        return record.measureCode;
      case 'measure':
        return record.measure;
      case 'eventDate':
        return record.eventDate;
      case 'alertDate':
        return record.alertDate;
      case 'deadlineCalculation':
        return record.deadlineCalculation;
      case 'diagnosisCode':
        return record.diagnosisCode;
      case 'diagnosisDescription':
        return record.diagnosisDescription;
      case 'admitFacility':
        return record.admitFacility;
      default:
        return record.mcoMemberId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
                      'FUA,FUM and TRC',
                      style: TextStyle(
                        fontSize: fontSize + 2,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('TSM export coming soon'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.file_download, size: 20),
                    tooltip: 'Export',
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterField(
                          controller: _memberNameFilterController,
                          hint: 'Member name...',
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: _buildFilterField(
                          controller: _memberIdFilterController,
                          hint: 'MCO member ID...',
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
                    ],
                  ),
                  SizedBox(height: padding),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterField(
                          controller: _dobFilterController,
                          hint: 'DOB...',
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: _buildFilterField(
                          controller: _measureCodeFilterController,
                          hint: 'Measure code...',
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: _buildFilterDropdown(
                          value: _measureFilter,
                          items: [
                            '',
                            'Medication Reconciliation',
                            'Transition of Care',
                            'Follow-up Call',
                            'Medication Review',
                          ],
                          hint: 'Measure',
                          onChanged: (value) {
                            _measureFilter = value ?? '';
                            _applyFilters();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: padding),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterField(
                          controller: _phoneFilterController,
                          hint: 'Phone...',
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: _buildFilterField(
                          controller: _deadlineFilterController,
                          hint: 'Deadline...',
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: _buildFilterDropdown(
                          value: _ipaFilter,
                          items: ['', 'Metro IPA', 'North IPA', 'East IPA', 'South IPA'],
                          hint: 'IPA',
                          onChanged: (value) {
                            _ipaFilter = value ?? '';
                            _applyFilters();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
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
                            _buildDataColumn('PCP TIN', 'pcpTin', fontSize),
                            _buildDataColumn('PCP PRACTICE', 'pcpPractice', fontSize),
                            _buildDataColumn('PCP NPI', 'pcpNpi', fontSize),
                            _buildDataColumn('MCO', 'mco', fontSize),
                            _buildDataColumn('IPA', 'ipa', fontSize),
                            _buildDataColumn('PRODUCT', 'product', fontSize),
                            _buildDataColumn('MCO PRODUCT', 'mcoProduct', fontSize),
                            _buildDataColumn(
                              'MCO MEMBER ID (was incorrectly MCP MEMBER ID)',
                              'mcoMemberId',
                              fontSize,
                            ),
                            _buildDataColumn('MEMBER NAME', 'memberName', fontSize),
                            _buildDataColumn('MEMBER DOB', 'memberDob', fontSize),
                            _buildDataColumn('MEMBER ADDRESS 1', 'memberAddress1', fontSize),
                            _buildDataColumn('MEMBER ADDRESS 2', 'memberAddress2', fontSize),
                            _buildDataColumn('MEMBER CITY', 'memberCity', fontSize),
                            _buildDataColumn('MEMBER ZIP', 'memberZip', fontSize),
                            _buildDataColumn('MEMBER PHONE 1', 'memberPhone1', fontSize),
                            _buildDataColumn('MEMBER PHONE 2', 'memberPhone2', fontSize),
                            _buildDataColumn('EMR PHONE 3', 'emrPhone3', fontSize),
                            _buildDataColumn('MEASURE CODE', 'measureCode', fontSize),
                            _buildDataColumn('MEASURE', 'measure', fontSize),
                            _buildDataColumn('EVENT DATE', 'eventDate', fontSize),
                            _buildDataColumn('ALERT DATE', 'alertDate', fontSize),
                            _buildDataColumn(
                              'DEADLINE CALCULATION',
                              'deadlineCalculation',
                              fontSize,
                            ),
                            _buildDataColumn(
                              'DIAGNOSIS CODE',
                              'diagnosisCode',
                              fontSize,
                            ),
                            _buildDataColumn(
                              'DIAGNOSIS DESCRIPTION',
                              'diagnosisDescription',
                              fontSize,
                            ),
                            _buildDataColumn('ADMIT FACILITY', 'admitFacility', fontSize),
                          ],
                          rows: _paginatedRecords.map((record) {
                            return DataRow(
                              cells: [
                                DataCell(Text(record.pcpTin)),
                                DataCell(Text(record.pcpPractice)),
                                DataCell(Text(record.pcpNpi)),
                                DataCell(Text(record.mco)),
                                DataCell(Text(record.ipa)),
                                DataCell(Text(record.product)),
                                DataCell(Text(record.mcoProduct)),
                                DataCell(Text(record.mcoMemberId)),
                                DataCell(Text(record.memberName)),
                                DataCell(Text(record.memberDob)),
                                DataCell(Text(record.memberAddress1)),
                                DataCell(Text(record.memberAddress2.isEmpty ? '-' : record.memberAddress2)),
                                DataCell(Text(record.memberCity)),
                                DataCell(Text(record.memberZip)),
                                DataCell(Text(record.memberPhone1)),
                                DataCell(Text(record.memberPhone2.isEmpty ? '-' : record.memberPhone2)),
                                DataCell(Text(record.emrPhone3)),
                                DataCell(Text(record.measureCode)),
                                DataCell(Text(record.measure)),
                                DataCell(Text(record.eventDate)),
                                DataCell(Text(record.alertDate)),
                                DataCell(Text(record.deadlineCalculation)),
                                DataCell(Text(record.diagnosisCode)),
                                DataCell(Text(record.diagnosisDescription)),
                                DataCell(Text(record.admitFacility)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
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
          const SizedBox(width: 4),
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

  Widget _buildFilterField({
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 80),
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
      constraints: const BoxConstraints(minWidth: 80),
      child: DropdownButtonFormField<String>(
        initialValue: value!.isEmpty ? null : value,
        isExpanded: true,
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
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: item.isEmpty ? Colors.grey.shade500 : Colors.black,
              ),
            ),
          );
        }).toList(),
        selectedItemBuilder: (context) {
          return items.map((item) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.isEmpty ? hint : item,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: item.isEmpty ? Colors.grey.shade500 : Colors.black,
                ),
              ),
            );
          }).toList();
        },
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildPaginationControls() {
    final totalRecords = _filteredRecords.length;
    final startIndex = totalRecords == 0 ? 0 : (_currentPage - 1) * _rowsPerPage + 1;
    final endIndex = (_currentPage * _rowsPerPage).clamp(0, totalRecords);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Column(
              children: [
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Showing $startIndex-$endIndex of $totalRecords',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
                    ),
                    const SizedBox(width: 12),
                    _buildCompactNavigation(),
                  ],
                ),
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              Row(
                children: [
                  Text(
                    'Showing $startIndex-$endIndex of $totalRecords',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
                  ),
                  const SizedBox(width: 12),
                  _buildCompactNavigation(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCompactNavigation() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
          icon: const Icon(Icons.chevron_left),
          iconSize: 18,
          padding: const EdgeInsets.all(2),
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
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

  @override
  void dispose() {
    _memberNameFilterController.dispose();
    _memberIdFilterController.dispose();
    _dobFilterController.dispose();
    _measureCodeFilterController.dispose();
    _phoneFilterController.dispose();
    _deadlineFilterController.dispose();
    super.dispose();
  }
}

class TSMRecord {
  final String pcpTin;
  final String pcpPractice;
  final String pcpNpi;
  final String mco;
  final String ipa;
  final String product;
  final String mcoProduct;
  final String mcoMemberId;
  final String memberName;
  final String memberDob;
  final String memberAddress1;
  final String memberAddress2;
  final String memberCity;
  final String memberZip;
  final String memberPhone1;
  final String memberPhone2;
  final String emrPhone3;
  final String measureCode;
  final String measure;
  final String eventDate;
  final String alertDate;
  final String deadlineCalculation;
  final String diagnosisCode;
  final String diagnosisDescription;
  final String admitFacility;

  TSMRecord({
    required this.pcpTin,
    required this.pcpPractice,
    required this.pcpNpi,
    required this.mco,
    required this.ipa,
    required this.product,
    required this.mcoProduct,
    required this.mcoMemberId,
    required this.memberName,
    required this.memberDob,
    required this.memberAddress1,
    required this.memberAddress2,
    required this.memberCity,
    required this.memberZip,
    required this.memberPhone1,
    required this.memberPhone2,
    required this.emrPhone3,
    required this.measureCode,
    required this.measure,
    required this.eventDate,
    required this.alertDate,
    required this.deadlineCalculation,
    required this.diagnosisCode,
    required this.diagnosisDescription,
    required this.admitFacility,
  });
}

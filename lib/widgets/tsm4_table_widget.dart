import 'package:flutter/material.dart';

class TSM4TableWidget extends StatefulWidget {
  const TSM4TableWidget({super.key});

  @override
  State<TSM4TableWidget> createState() => _TSM4TableWidgetState();
}

class _TSM4TableWidgetState extends State<TSM4TableWidget> {
  List<TSM4Record> _records = [];
  List<TSM4Record> _filteredRecords = [];
  String _sortColumn = 'plan_member_id';
  bool _sortAscending = true;

  // Pagination
  int _currentPage = 1;
  int _rowsPerPage = 10;

  // Filter controllers (same style as TSM 1/2/3)
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
      TSM4Record(
        plan: 'Healthfirst',
        tin: '12-3456789',
        practice_name: 'Bronx Family Care',
        npi: '1234567890',
        pcp_name: 'Joel Cedano',
        pcp_address: '110 E 170th St',
        pcp_city: 'Bronx',
        pcp_state: 'NY',
        pcp_zip: '10452',
        measure_code: 'W30',
        measure_description: 'Well-Child Visits in the Third, Fourth, Fifth and Sixth Years of Life',
        denominator: '80',
        numerator: '53',
        line_of_business: 'Medicaid',
        plan_member_id: 'W30001',
        first_name: 'Maria',
        last_name: 'Alvarez',
        date_of_birth: '03-10-2021',
        language: 'Spanish',
        race_ethnicity: 'Hispanic/Latino',
        gender: 'F',
        member_address: '110 E 170th St Apt 3B',
        member_city: 'Bronx',
        member_state: 'NY',
        member_zip: '10452',
        member_phone: '7185550121',
        member_emr_phone_number: '2125550100',
        month_15_as_of: '06-10-2022',
        month_30_as_of: '09-10-2023',
        visit_1: 'Y',
        visit_2: 'Y',
        visit_3: 'Y',
        visit_4: 'N',
        visit_5: 'N',
        visit_6: 'N',
        visit_7: 'N',
        visit_8: 'N',
        total_visits: '3',
        daterun: '04-16-2026',
      ),
      TSM4Record(
        plan: 'Anthem',
        tin: '98-7654321',
        practice_name: 'Washington Heights Clinic',
        npi: '9876543210',
        pcp_name: 'Maria Garcia',
        pcp_address: '450 W 181st St',
        pcp_city: 'New York',
        pcp_state: 'NY',
        pcp_zip: '10033',
        measure_code: 'W30',
        measure_description: 'Well-Child Visits in the Third, Fourth, Fifth and Sixth Years of Life',
        denominator: '120',
        numerator: '101',
        line_of_business: 'Commercial',
        plan_member_id: 'W30002',
        first_name: 'Jose',
        last_name: 'Martinez',
        date_of_birth: '11-22-2020',
        language: 'English',
        race_ethnicity: 'White',
        gender: 'M',
        member_address: '450 W 181st St',
        member_city: 'New York',
        member_state: 'NY',
        member_zip: '10033',
        member_phone: '6465559182',
        member_emr_phone_number: '2125550200',
        month_15_as_of: '02-22-2022',
        month_30_as_of: '05-22-2023',
        visit_1: 'Y',
        visit_2: 'Y',
        visit_3: 'Y',
        visit_4: 'Y',
        visit_5: 'N',
        visit_6: 'N',
        visit_7: 'N',
        visit_8: 'N',
        total_visits: '4',
        daterun: '04-16-2026',
      ),
      TSM4Record(
        plan: 'Emblem',
        tin: '11-2345678',
        practice_name: 'Queens Community Health',
        npi: '1122334455',
        pcp_name: 'John Smith',
        pcp_address: '76-12 Roosevelt Ave',
        pcp_city: 'Jackson Heights',
        pcp_state: 'NY',
        pcp_zip: '11372',
        measure_code: 'W30',
        measure_description: 'Well-Child Visits in the Third, Fourth, Fifth and Sixth Years of Life',
        denominator: '60',
        numerator: '25',
        line_of_business: 'Medicaid',
        plan_member_id: 'W30003',
        first_name: 'Ana',
        last_name: 'Gomez',
        date_of_birth: '07-04-2021',
        language: 'Spanish',
        race_ethnicity: 'Hispanic/Latino',
        gender: 'F',
        member_address: '76-12 Roosevelt Ave Floor 2',
        member_city: 'Jackson Heights',
        member_state: 'NY',
        member_zip: '11372',
        member_phone: '9175552334',
        member_emr_phone_number: '7185550300',
        month_15_as_of: '10-04-2022',
        month_30_as_of: '01-04-2024',
        visit_1: 'Y',
        visit_2: 'N',
        visit_3: 'N',
        visit_4: 'N',
        visit_5: 'N',
        visit_6: 'N',
        visit_7: 'N',
        visit_8: 'N',
        total_visits: '1',
        daterun: '04-16-2026',
      ),
    ];

    _filteredRecords = List.from(_records);
  }

  void _applyFilters() {
    setState(() {
      _filteredRecords = _records.where((record) {
        final memberNameMatch = ('${record.first_name} ${record.last_name}')
            .toLowerCase()
            .contains(_memberNameFilterController.text.toLowerCase());
        final memberIdMatch =
            record.plan_member_id.contains(_memberIdFilterController.text);
        final dobMatch =
            record.date_of_birth.contains(_dobFilterController.text);
        final measureCodeMatch =
            record.measure_code.contains(_measureCodeFilterController.text);
        final phoneMatch =
            record.member_phone.contains(_phoneFilterController.text);
        final deadlineMatch = record.daterun
            .toLowerCase()
            .contains(_deadlineFilterController.text.toLowerCase());

        final mcoMatch = _mcoFilter.isEmpty || record.plan == _mcoFilter;
        final measureMatch = _measureFilter.isEmpty ||
            record.measure_description == _measureFilter;
        final ipaMatch =
            _ipaFilter.isEmpty || record.line_of_business == _ipaFilter;

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

  List<TSM4Record> get _paginatedRecords {
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

  String _getValueForColumn(TSM4Record record, String column) {
    switch (column) {
      case 'plan':
        return record.plan;
      case 'tin':
        return record.tin;
      case 'practice_name':
        return record.practice_name;
      case 'npi':
        return record.npi;
      case 'pcp_name':
        return record.pcp_name;
      case 'pcp_address':
        return record.pcp_address;
      case 'pcp_city':
        return record.pcp_city;
      case 'pcp_state':
        return record.pcp_state;
      case 'pcp_zip':
        return record.pcp_zip;
      case 'measure_code':
        return record.measure_code;
      case 'measure_description':
        return record.measure_description;
      case 'denominator':
        return record.denominator;
      case 'numerator':
        return record.numerator;
      case 'line_of_business':
        return record.line_of_business;
      case 'plan_member_id':
        return record.plan_member_id;
      case 'first_name':
        return record.first_name;
      case 'last_name':
        return record.last_name;
      case 'date_of_birth':
        return record.date_of_birth;
      case 'language':
        return record.language;
      case 'race_ethnicity':
        return record.race_ethnicity;
      case 'gender':
        return record.gender;
      case 'member_address':
        return record.member_address;
      case 'member_city':
        return record.member_city;
      case 'member_state':
        return record.member_state;
      case 'member_zip':
        return record.member_zip;
      case 'member_phone':
        return record.member_phone;
      case 'member_emr_phone_number':
        return record.member_emr_phone_number;
      case 'month_15_as_of':
        return record.month_15_as_of;
      case 'month_30_as_of':
        return record.month_30_as_of;
      case 'visit_1':
        return record.visit_1;
      case 'visit_2':
        return record.visit_2;
      case 'visit_3':
        return record.visit_3;
      case 'visit_4':
        return record.visit_4;
      case 'visit_5':
        return record.visit_5;
      case 'visit_6':
        return record.visit_6;
      case 'visit_7':
        return record.visit_7;
      case 'visit_8':
        return record.visit_8;
      case 'total_visits':
        return record.total_visits;
      case 'daterun':
        return record.daterun;
      default:
        return record.plan_member_id;
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
                      'W30',
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
                          content: Text('W30 export coming soon'),
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
                          hint: 'Member ID...',
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
                            'Well-Child Visits in the Third, Fourth, Fifth and Sixth Years of Life',
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
                          items: ['', 'Medicaid', 'Commercial', 'Medicare'],
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
                            _buildDataColumn('PLAN', 'plan', fontSize),
                            _buildDataColumn('TIN', 'tin', fontSize),
                            _buildDataColumn('PRACTICE NAME', 'practice_name', fontSize),
                            _buildDataColumn('NPI', 'npi', fontSize),
                            _buildDataColumn('PCP NAME', 'pcp_name', fontSize),
                            _buildDataColumn('PCP ADDRESS', 'pcp_address', fontSize),
                            _buildDataColumn('PCP CITY', 'pcp_city', fontSize),
                            _buildDataColumn('PCP STATE', 'pcp_state', fontSize),
                            _buildDataColumn('PCP ZIP', 'pcp_zip', fontSize),
                            _buildDataColumn('MEASURE CODE', 'measure_code', fontSize),
                            _buildDataColumn(
                              'MEASURE DESCRIPTION',
                              'measure_description',
                              fontSize,
                            ),
                            _buildDataColumn('DENOMINATOR', 'denominator', fontSize),
                            _buildDataColumn('NUMERATOR', 'numerator', fontSize),
                            _buildDataColumn('LINE OF BUSINESS', 'line_of_business', fontSize),
                            _buildDataColumn('PLAN MEMBER ID', 'plan_member_id', fontSize),
                            _buildDataColumn('FIRST NAME', 'first_name', fontSize),
                            _buildDataColumn('LAST NAME', 'last_name', fontSize),
                            _buildDataColumn('DATE OF BIRTH', 'date_of_birth', fontSize),
                            _buildDataColumn('LANGUAGE', 'language', fontSize),
                            _buildDataColumn('RACE ETHNICITY', 'race_ethnicity', fontSize),
                            _buildDataColumn('GENDER', 'gender', fontSize),
                            _buildDataColumn('MEMBER ADDRESS', 'member_address', fontSize),
                            _buildDataColumn('MEMBER CITY', 'member_city', fontSize),
                            _buildDataColumn('MEMBER STATE', 'member_state', fontSize),
                            _buildDataColumn('MEMBER ZIP', 'member_zip', fontSize),
                            _buildDataColumn('MEMBER PHONE', 'member_phone', fontSize),
                            _buildDataColumn(
                              'MEMBER EMR PHONE NUMBER',
                              'member_emr_phone_number',
                              fontSize,
                            ),
                            _buildDataColumn('MONTH 15 AS OF', 'month_15_as_of', fontSize),
                            _buildDataColumn('MONTH 30 AS OF', 'month_30_as_of', fontSize),
                            _buildDataColumn('VISIT 1', 'visit_1', fontSize),
                            _buildDataColumn('VISIT 2', 'visit_2', fontSize),
                            _buildDataColumn('VISIT 3', 'visit_3', fontSize),
                            _buildDataColumn('VISIT 4', 'visit_4', fontSize),
                            _buildDataColumn('VISIT 5', 'visit_5', fontSize),
                            _buildDataColumn('VISIT 6', 'visit_6', fontSize),
                            _buildDataColumn('VISIT 7', 'visit_7', fontSize),
                            _buildDataColumn('VISIT 8', 'visit_8', fontSize),
                            _buildDataColumn('TOTAL VISITS', 'total_visits', fontSize),
                            _buildDataColumn('DATERUN', 'daterun', fontSize),
                          ],
                          rows: _paginatedRecords.map((record) {
                            return DataRow(
                              cells: [
                                DataCell(Text(record.plan)),
                                DataCell(Text(record.tin)),
                                DataCell(Text(record.practice_name)),
                                DataCell(Text(record.npi)),
                                DataCell(Text(record.pcp_name)),
                                DataCell(Text(record.pcp_address)),
                                DataCell(Text(record.pcp_city)),
                                DataCell(Text(record.pcp_state)),
                                DataCell(Text(record.pcp_zip)),
                                DataCell(Text(record.measure_code)),
                                DataCell(Text(record.measure_description)),
                                DataCell(Text(record.denominator)),
                                DataCell(Text(record.numerator)),
                                DataCell(Text(record.line_of_business)),
                                DataCell(Text(record.plan_member_id)),
                                DataCell(Text(record.first_name)),
                                DataCell(Text(record.last_name)),
                                DataCell(Text(record.date_of_birth)),
                                DataCell(Text(record.language)),
                                DataCell(Text(record.race_ethnicity)),
                                DataCell(Text(record.gender)),
                                DataCell(Text(record.member_address)),
                                DataCell(Text(record.member_city)),
                                DataCell(Text(record.member_state)),
                                DataCell(Text(record.member_zip)),
                                DataCell(Text(record.member_phone)),
                                DataCell(Text(record.member_emr_phone_number)),
                                DataCell(Text(record.month_15_as_of)),
                                DataCell(Text(record.month_30_as_of)),
                                DataCell(Text(record.visit_1)),
                                DataCell(Text(record.visit_2)),
                                DataCell(Text(record.visit_3)),
                                DataCell(Text(record.visit_4)),
                                DataCell(Text(record.visit_5)),
                                DataCell(Text(record.visit_6)),
                                DataCell(Text(record.visit_7)),
                                DataCell(Text(record.visit_8)),
                                DataCell(Text(record.total_visits)),
                                DataCell(Text(record.daterun)),
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
    final startIndex =
        totalRecords == 0 ? 0 : (_currentPage - 1) * _rowsPerPage + 1;
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
                          child:
                              Text('$value', style: const TextStyle(fontSize: 11)),
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
                      style:
                          const TextStyle(fontSize: 11, color: Color(0xFF666666)),
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
                        child:
                            Text('$value', style: const TextStyle(fontSize: 11)),
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
          onPressed:
              _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
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
          onPressed: _currentPage < _totalPages
              ? () => _goToPage(_currentPage + 1)
              : null,
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

class TSM4Record {
  final String plan;
  final String tin;
  final String practice_name;
  final String npi;
  final String pcp_name;
  final String pcp_address;
  final String pcp_city;
  final String pcp_state;
  final String pcp_zip;
  final String measure_code;
  final String measure_description;
  final String denominator;
  final String numerator;
  final String line_of_business;
  final String plan_member_id;
  final String first_name;
  final String last_name;
  final String date_of_birth;
  final String language;
  final String race_ethnicity;
  final String gender;
  final String member_address;
  final String member_city;
  final String member_state;
  final String member_zip;
  final String member_phone;
  final String member_emr_phone_number;
  final String month_15_as_of;
  final String month_30_as_of;
  final String visit_1;
  final String visit_2;
  final String visit_3;
  final String visit_4;
  final String visit_5;
  final String visit_6;
  final String visit_7;
  final String visit_8;
  final String total_visits;
  final String daterun;

  TSM4Record({
    required this.plan,
    required this.tin,
    required this.practice_name,
    required this.npi,
    required this.pcp_name,
    required this.pcp_address,
    required this.pcp_city,
    required this.pcp_state,
    required this.pcp_zip,
    required this.measure_code,
    required this.measure_description,
    required this.denominator,
    required this.numerator,
    required this.line_of_business,
    required this.plan_member_id,
    required this.first_name,
    required this.last_name,
    required this.date_of_birth,
    required this.language,
    required this.race_ethnicity,
    required this.gender,
    required this.member_address,
    required this.member_city,
    required this.member_state,
    required this.member_zip,
    required this.member_phone,
    required this.member_emr_phone_number,
    required this.month_15_as_of,
    required this.month_30_as_of,
    required this.visit_1,
    required this.visit_2,
    required this.visit_3,
    required this.visit_4,
    required this.visit_5,
    required this.visit_6,
    required this.visit_7,
    required this.visit_8,
    required this.total_visits,
    required this.daterun,
  });
}


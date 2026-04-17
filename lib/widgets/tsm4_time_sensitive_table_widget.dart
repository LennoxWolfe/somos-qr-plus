import 'dart:math' show min;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'report_pagination_bar.dart';

class _W30Column {
  const _W30Column(this.key, this.header, [this.width = 150]);
  final String key;
  final String header;
  final double width;
}

class W30TableWidget extends StatefulWidget {
  const W30TableWidget({super.key});

  @override
  State<W30TableWidget> createState() => _W30TableWidgetState();
}

class _W30TableWidgetState extends State<W30TableWidget> {
  static const List<_W30Column> _columns = [
    _W30Column('plan', 'PLAN', 120),
    _W30Column('tin', 'TIN', 120),
    _W30Column('practice_name', 'PRACTICE NAME', 170),
    _W30Column('npi', 'NPI', 120),
    _W30Column('pcp_name', 'PCP NAME', 170),
    _W30Column('pcp_address', 'PCP ADDRESS', 220),
    _W30Column('pcp_city', 'PCP CITY', 150),
    _W30Column('pcp_state', 'PCP STATE', 120),
    _W30Column('pcp_zip', 'PCP ZIP', 120),
    _W30Column('measure_code', 'MEASURE CODE', 150),
    _W30Column('measure_description', 'MEASURE DESCRIPTION', 240),
    _W30Column('denominator', 'DENOMINATOR', 140),
    _W30Column('numerator', 'NUMERATOR', 140),
    _W30Column('line_of_business', 'LINE OF BUSINESS', 180),
    _W30Column('plan_member_id', 'PLAN MEMBER ID', 170),
    _W30Column('first_name', 'FIRST NAME', 140),
    _W30Column('last_name', 'LAST NAME', 140),
    _W30Column('date_of_birth', 'DATE OF BIRTH', 150),
    _W30Column('language', 'LANGUAGE', 140),
    _W30Column('race_ethnicity', 'RACE ETHNICITY', 180),
    _W30Column('gender', 'GENDER', 120),
    _W30Column('member_address', 'MEMBER ADDRESS', 220),
    _W30Column('member_city', 'MEMBER CITY', 150),
    _W30Column('member_state', 'MEMBER STATE', 140),
    _W30Column('member_zip', 'MEMBER ZIP', 130),
    _W30Column('member_phone', 'MEMBER PHONE', 150),
    _W30Column('member_emr_phone_number', 'MEMBER EMR PHONE NUMBER', 220),
    _W30Column('month_15_as_of', 'MONTH 15 AS OF', 170),
    _W30Column('month_30_as_of', 'MONTH 30 AS OF', 170),
    _W30Column('visit_1', 'VISIT 1', 120),
    _W30Column('visit_2', 'VISIT 2', 120),
    _W30Column('visit_3', 'VISIT 3', 120),
    _W30Column('visit_4', 'VISIT 4', 120),
    _W30Column('visit_5', 'VISIT 5', 120),
    _W30Column('visit_6', 'VISIT 6', 120),
    _W30Column('visit_7', 'VISIT 7', 120),
    _W30Column('visit_8', 'VISIT 8', 120),
    _W30Column('total_visits', 'TOTAL VISITS', 140),
    _W30Column('daterun', 'DATERUN', 140),
  ];

  static double get _tableWidth =>
      _columns.fold<double>(0, (s, c) => s + c.width);

  static Map<String, String> _placeholderRow(int rowIndex) {
    const p = '—';
    return {
      'plan': ['PLAN A', 'PLAN B', 'PLAN C'][rowIndex % 3],
      'tin': p,
      'practice_name': 'SAMPLE PRACTICE',
      'npi': '1234567890',
      'pcp_name': 'SAMPLE PCP',
      'pcp_address': '123 MAIN ST',
      'pcp_city': 'NEW YORK',
      'pcp_state': 'NY',
      'pcp_zip': '10001',
      'measure_code': 'W30',
      'measure_description': 'SAMPLE MEASURE DESCRIPTION',
      'denominator': '${10 + rowIndex}',
      'numerator': '${5 + (rowIndex % 5)}',
      'line_of_business': ['MCD', 'MAP', 'CHIP'][rowIndex % 3],
      'plan_member_id': 'MEM-${100000 + rowIndex}',
      'first_name': 'FIRST${rowIndex + 1}',
      'last_name': 'LAST${rowIndex + 1}',
      'date_of_birth': '01-01-2018',
      'language': ['EN', 'ES', 'ZH'][rowIndex % 3],
      'race_ethnicity': ['UNKNOWN', 'HISPANIC', 'NON-HISPANIC'][rowIndex % 3],
      'gender': ['M', 'F', 'U'][rowIndex % 3],
      'member_address': '456 MEMBER ST',
      'member_city': ['NEW YORK', 'BRONX', 'BROOKLYN'][rowIndex % 3],
      'member_state': 'NY',
      'member_zip': '10001',
      'member_phone': '5550100',
      'member_emr_phone_number': p,
      'month_15_as_of': p,
      'month_30_as_of': p,
      'visit_1': p,
      'visit_2': p,
      'visit_3': p,
      'visit_4': p,
      'visit_5': p,
      'visit_6': p,
      'visit_7': p,
      'visit_8': p,
      'total_visits': p,
      'daterun': '02-03-2026',
    };
  }

  late final List<Map<String, String>> _allRows;
  late List<Map<String, String>> _filtered;

  late final List<TextEditingController> _filterControllers;

  String? _sortKey;
  bool _sortAsc = true;

  int _currentPage = 1;
  int _rowsPerPage = 10;

  int get _totalPages {
    final n = _filtered.length;
    if (n == 0) return 1;
    return (n / _rowsPerPage).ceil();
  }

  List<Map<String, String>> get _paginatedRows {
    final start = (_currentPage - 1) * _rowsPerPage;
    if (start >= _filtered.length) return [];
    final end = min(start + _rowsPerPage, _filtered.length);
    return _filtered.sublist(start, end);
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  Widget _buildPaginationControls() {
    return ReportPaginationBar(
      total: _filtered.length,
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

  late final int _idxPlan;
  late final int _idxPlanMemberId;
  late final int _idxLastName;
  late final int _idxDateOfBirth;
  late final int _idxMemberPhone;
  late final int _idxMeasureCode;
  late final int _idxLineOfBusiness;
  late final int _idxGender;

  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _allRows = List.generate(35, _placeholderRow);
    _filtered = List.from(_allRows);
    _filterControllers = List.generate(
      _columns.length,
      (_) => TextEditingController(),
    );
    for (final c in _filterControllers) {
      c.addListener(_applyFilters);
    }

    _idxPlan = _columns.indexWhere((c) => c.key == 'plan');
    _idxPlanMemberId = _columns.indexWhere((c) => c.key == 'plan_member_id');
    _idxLastName = _columns.indexWhere((c) => c.key == 'last_name');
    _idxDateOfBirth = _columns.indexWhere((c) => c.key == 'date_of_birth');
    _idxMemberPhone = _columns.indexWhere((c) => c.key == 'member_phone');
    _idxMeasureCode = _columns.indexWhere((c) => c.key == 'measure_code');
    _idxLineOfBusiness =
        _columns.indexWhere((c) => c.key == 'line_of_business');
    _idxGender = _columns.indexWhere((c) => c.key == 'gender');

    assert(_idxPlan != -1);
    assert(_idxPlanMemberId != -1);
    assert(_idxLastName != -1);
    assert(_idxDateOfBirth != -1);
    assert(_idxMemberPhone != -1);
    assert(_idxMeasureCode != -1);
    assert(_idxLineOfBusiness != -1);
    assert(_idxGender != -1);
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    for (final c in _filterControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filtered = _allRows.where((row) {
        for (var i = 0; i < _columns.length; i++) {
          final q = _filterControllers[i].text.trim().toLowerCase();
          if (q.isEmpty) continue;
          final v = (row[_columns[i].key] ?? '').toLowerCase();
          if (!v.contains(q)) return false;
        }
        return true;
      }).toList();
      _currentPage = 1;
      _sortRows();
    });
  }

  List<String> _distinctOptions(String columnKey) {
    final set = <String>{};
    for (final r in _allRows) {
      final v = (r[columnKey] ?? '').trim();
      if (v.isEmpty || v == '—') continue;
      set.add(v);
    }
    final list = set.toList()..sort();
    return list;
  }

  String _dropdownSelectedValue(TextEditingController c, List<String> options) {
    final t = c.text.trim();
    if (t.isEmpty) return '';
    if (options.contains(t)) return t;
    return t;
  }

  Widget _buildExternalFilters() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double padding;
        if (constraints.maxWidth < 600) {
          padding = 6;
        } else if (constraints.maxWidth < 900) {
          padding = 8;
        } else {
          padding = 12;
        }

        final planOptions = _distinctOptions('plan');
        final measureOptions = _distinctOptions('measure_code');
        final lobOptions = _distinctOptions('line_of_business');
        final genderOptions = _distinctOptions('gender');

        return Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildFilterField(
                      controller: _filterControllers[_idxLastName],
                      hint: 'Last name...',
                    ),
                  ),
                  SizedBox(width: padding),
                  Expanded(
                    child: _buildFilterDropdown(
                      controller: _filterControllers[_idxPlan],
                      hint: 'Plan',
                      options: planOptions,
                    ),
                  ),
                ],
              ),
              SizedBox(height: padding),
              Row(
                children: [
                  Expanded(
                    child: _buildFilterField(
                      controller: _filterControllers[_idxDateOfBirth],
                      hint: 'DOB...',
                    ),
                  ),
                  SizedBox(width: padding),
                  Expanded(
                    child: _buildFilterDropdown(
                      controller: _filterControllers[_idxMeasureCode],
                      hint: 'Measure code',
                      options: measureOptions,
                    ),
                  ),
                  SizedBox(width: padding),
                  Expanded(
                    child: _buildFilterDropdown(
                      controller: _filterControllers[_idxLineOfBusiness],
                      hint: 'Line of business',
                      options: lobOptions,
                    ),
                  ),
                ],
              ),
              SizedBox(height: padding),
              Row(
                children: [
                  Expanded(
                    child: _buildFilterField(
                      controller: _filterControllers[_idxPlanMemberId],
                      hint: 'Member ID...',
                    ),
                  ),
                  SizedBox(width: padding),
                  Expanded(
                    child: _buildFilterField(
                      controller: _filterControllers[_idxMemberPhone],
                      hint: 'Phone...',
                    ),
                  ),
                  SizedBox(width: padding),
                  Expanded(
                    child: _buildFilterDropdown(
                      controller: _filterControllers[_idxGender],
                      hint: 'Gender',
                      options: genderOptions,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterDropdown({
    required TextEditingController controller,
    required String hint,
    required List<String> options,
  }) {
    final selected = controller.text.trim();
    final orphan =
        selected.isNotEmpty && !options.contains(selected) ? selected : null;
    final items = <DropdownMenuItem<String>>[
      const DropdownMenuItem<String>(
        value: '',
        child: Text('All', style: TextStyle(fontSize: 11)),
      ),
      ...options.map(
        (v) => DropdownMenuItem<String>(
          value: v,
          child: Text(v, style: const TextStyle(fontSize: 11)),
        ),
      ),
      if (orphan != null)
        DropdownMenuItem<String>(
          value: orphan,
          child: Text(orphan, style: const TextStyle(fontSize: 11)),
        ),
    ];

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 80),
      child: DropdownButtonFormField<String>(
        isDense: true,
        isExpanded: true,
        value: _dropdownSelectedValue(controller, options),
        decoration: _filterDecoration(hint),
        style: const TextStyle(fontSize: 11, color: Color(0xFF333333)),
        items: items,
        onChanged: (v) => controller.text = v ?? '',
      ),
    );
  }

  Widget _buildFilterField({
    required TextEditingController controller,
    required String hint,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 80),
      child: TextField(
        controller: controller,
        decoration: _filterDecoration(hint),
        style: const TextStyle(fontSize: 11),
      ),
    );
  }

  void _sortRows() {
    if (_sortKey == null) return;
    _filtered.sort((a, b) {
      final av = a[_sortKey!] ?? '';
      final bv = b[_sortKey!] ?? '';
      final c = av.compareTo(bv);
      return _sortAsc ? c : -c;
    });
  }

  void _onSort(String key) {
    setState(() {
      if (_sortKey == key) {
        _sortAsc = !_sortAsc;
      } else {
        _sortKey = key;
        _sortAsc = true;
      }
      _sortRows();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildToolbar(context),
          _buildExternalFilters(),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: true,
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.stylus,
                },
              ),
              child: Scrollbar(
                controller: _horizontalScrollController,
                scrollbarOrientation: ScrollbarOrientation.bottom,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  child: Scrollbar(
                    controller: _verticalScrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _verticalScrollController,
                      scrollDirection: Axis.vertical,
                      primary: false,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      child: SizedBox(
                        width: _tableWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildHeaderRow(),
                            ..._paginatedRows.asMap().entries.map((e) {
                              final globalIndex =
                                  (_currentPage - 1) * _rowsPerPage + e.key;
                              return _buildDataRow(e.value, globalIndex);
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double fontSize;
        double padding;
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

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: const Color(0xFFf8f9fa),
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF333333)),
                padding: EdgeInsets.zero,
                onSelected: (_) => _applyFilters(),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'refresh', child: Text('Refresh')),
                ],
              ),
              Expanded(
                child: Text(
                  'W30',
                  style: TextStyle(
                    fontSize: fontSize + 2,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF333333),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Tooltip(
                message: 'Export',
                child: TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Export (demo)')),
                    );
                  },
                  icon: const Icon(
                    Icons.open_in_new,
                    size: 20,
                    color: Color(0xFF1976D2),
                  ),
                  label: const Text(
                    'Export',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1976D2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderRow() {
    const headerBg = Color(0xFFf8f9fa);
    return Container(
      decoration: BoxDecoration(
        color: headerBg,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: _columns
            .map((col) => _headerCell(col.header, col.key, col.width))
            .toList(),
      ),
    );
  }

  Widget _headerCell(String label, String key, double w) {
    final active = _sortKey == key;
    return GestureDetector(
      onTap: () => _onSort(key),
      child: Container(
        width: w,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                letterSpacing: 0.2,
                color: Color(0xFF333333),
                height: 1.25,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Icon(
              active
                  ? (_sortAsc ? Icons.arrow_upward : Icons.arrow_downward)
                  : Icons.unfold_more,
              size: 14,
              color: const Color(0xFF666666),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _filterDecoration(String hint) {
    return InputDecoration(
      isDense: true,
      hintText: hint,
      hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade500),
      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: Color(0xFF1976D2)),
      ),
    );
  }

  Widget _buildDataRow(Map<String, String> row, int index) {
    final bg = index % 2 == 0 ? Colors.white : const Color(0xFFFAFAFA);
    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: _columns.map((col) {
          return _dataCell(row[col.key] ?? '—', col.width, bg);
        }).toList(),
      ),
    );
  }

  Widget _dataCell(String text, double w, Color bg) {
    return Container(
      width: w,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}


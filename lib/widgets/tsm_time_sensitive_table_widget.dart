import 'dart:math' show min;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'report_pagination_bar.dart';

/// Column spec: storage [key] (snake_case), display [header] (ALL CAPS, spaces).
class _TsmColumn {
  const _TsmColumn(this.key, this.header, [this.width = 132]);
  final String key;
  final String header;
  final double width;
}

/// Time Sensitive Measure table: 25 columns, horizontal scroll, sortable headers, filters.
class TsmTimeSensitiveTableWidget extends StatefulWidget {
  const TsmTimeSensitiveTableWidget({super.key});

  @override
  State<TsmTimeSensitiveTableWidget> createState() =>
      _TsmTimeSensitiveTableWidgetState();
}

class _TsmTimeSensitiveTableWidgetState extends State<TsmTimeSensitiveTableWidget> {
  static const List<_TsmColumn> _columns = [
    _TsmColumn('pcp_tin', 'PCP TIN'),
    _TsmColumn('pcp_practice', 'PCP PRACTICE', 148),
    _TsmColumn('pcp_npi', 'PCP NPI'),
    _TsmColumn('mco', 'MCO'),
    _TsmColumn('ipa', 'IPA'),
    _TsmColumn('product', 'PRODUCT'),
    _TsmColumn('mco_product', 'MCO PRODUCT', 140),
    _TsmColumn('mco_member_id', 'MCO MEMBER ID', 148),
    _TsmColumn('member_name', 'MEMBER NAME', 148),
    _TsmColumn('member_dob', 'MEMBER DOB'),
    _TsmColumn('member_address_1', 'MEMBER ADDRESS 1', 160),
    _TsmColumn('member_address_2', 'MEMBER ADDRESS 2', 160),
    _TsmColumn('member_city', 'MEMBER CITY'),
    _TsmColumn('member_zip', 'MEMBER ZIP'),
    _TsmColumn('member_phone_1', 'MEMBER PHONE 1', 140),
    _TsmColumn('member_phone_2', 'MEMBER PHONE 2', 140),
    _TsmColumn('emr_phone_3', 'EMR PHONE 3', 132),
    _TsmColumn('measure_code', 'MEASURE CODE', 132),
    _TsmColumn('measure', 'MEASURE', 160),
    _TsmColumn('event_date', 'EVENT DATE'),
    _TsmColumn('alert_date', 'ALERT DATE'),
    _TsmColumn('deadline_calculation', 'DEADLINE CALCULATION', 180),
    _TsmColumn('diagnosis_code', 'DIAGNOSIS CODE', 148),
    _TsmColumn('diagnosis_description', 'DIAGNOSIS DESCRIPTION', 200),
    _TsmColumn('admit_facility', 'ADMIT FACILITY', 160),
  ];

  static double get _tableWidth =>
      _columns.fold<double>(0, (s, c) => s + c.width);

  /// Placeholder row values (demo data).
  static Map<String, String> _placeholderRow(int rowIndex) {
    const p = '—';
    return {
      'pcp_tin': p,
      'pcp_practice': 'SAMPLE PRACTICE',
      'pcp_npi': '1234567890',
      'mco': ['SAMPLE MCO', 'Healthfirst', 'Anthem'][rowIndex % 3],
      'ipa': p,
      'product': ['MCD', 'MAP', 'CHIP'][rowIndex % 3],
      'mco_product': 'SAMPLE PRODUCT',
      'mco_member_id': 'MEM-${100000 + rowIndex}',
      'member_name': 'SAMPLE MEMBER ${rowIndex + 1}',
      'member_dob': '01-01-1950',
      'member_address_1': '123 MAIN ST',
      'member_address_2': p,
      'member_city': 'NEW YORK',
      'member_zip': '10001',
      'member_phone_1': '5550100',
      'member_phone_2': p,
      'emr_phone_3': p,
      'measure_code': ['CBP', 'AWV', 'COL'][rowIndex % 3],
      'measure': 'SAMPLE MEASURE',
      'event_date': '01-15-2026',
      'alert_date': '01-20-2026',
      'deadline_calculation': '02-01-2026',
      'diagnosis_code': ['Z00.00', 'E11.9', 'I10'][rowIndex % 3],
      'diagnosis_description': 'SAMPLE DX',
      'admit_facility': 'SAMPLE FACILITY',
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

  late final int _idxMco;
  late final int _idxMcoMemberId;
  late final int _idxMemberName;
  late final int _idxMemberDob;
  late final int _idxMemberPhone1;
  late final int _idxMeasureCode;
  late final int _idxProduct;
  late final int _idxDiagnosisCode;

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

    _idxMco = _columns.indexWhere((c) => c.key == 'mco');
    _idxMcoMemberId =
        _columns.indexWhere((c) => c.key == 'mco_member_id');
    _idxMemberName =
        _columns.indexWhere((c) => c.key == 'member_name');
    _idxMemberDob =
        _columns.indexWhere((c) => c.key == 'member_dob');
    _idxMemberPhone1 =
        _columns.indexWhere((c) => c.key == 'member_phone_1');
    _idxMeasureCode =
        _columns.indexWhere((c) => c.key == 'measure_code');
    _idxProduct = _columns.indexWhere((c) => c.key == 'product');
    _idxDiagnosisCode =
        _columns.indexWhere((c) => c.key == 'diagnosis_code');

    assert(_idxMco != -1);
    assert(_idxMcoMemberId != -1);
    assert(_idxMemberName != -1);
    assert(_idxMemberDob != -1);
    assert(_idxMemberPhone1 != -1);
    assert(_idxMeasureCode != -1);
    assert(_idxProduct != -1);
    assert(_idxDiagnosisCode != -1);
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

  /// Distinct non-empty values from loaded rows for dropdown options.
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

  String _dropdownSelectedValue(
    TextEditingController c,
    List<String> options,
  ) {
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

        final mcoOptions = _distinctOptions('mco');
        final measureOptions = _distinctOptions('measure_code');
        final productOptions = _distinctOptions('product');

        return Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Row 1: Name → MCO (matches vertical tablet order)
              Row(
                children: [
                  Expanded(
                    child: _buildFilterField(
                      controller: _filterControllers[_idxMemberName],
                      hint: 'Name...',
                    ),
                  ),
                  SizedBox(width: padding),
                  Expanded(
                    child: _buildFilterDropdown(
                      controller: _filterControllers[_idxMco],
                      hint: 'MCO',
                      options: mcoOptions,
                    ),
                  ),
                ],
              ),
              SizedBox(height: padding),
              // Row 2: DOB → Measure code → Product
              Row(
                children: [
                  Expanded(
                    child: _buildFilterField(
                      controller: _filterControllers[_idxMemberDob],
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
                      controller: _filterControllers[_idxProduct],
                      hint: 'Product',
                      options: productOptions,
                    ),
                  ),
                ],
              ),
              SizedBox(height: padding),
              // Row 3: Member ID → Phone → Diagnosis code
              Row(
                children: [
                  Expanded(
                    child: _buildFilterField(
                      controller: _filterControllers[_idxMcoMemberId],
                      hint: 'Member ID...',
                    ),
                  ),
                  SizedBox(width: padding),
                  Expanded(
                    child: _buildFilterField(
                      controller: _filterControllers[_idxMemberPhone1],
                      hint: 'Phone...',
                    ),
                  ),
                  SizedBox(width: padding),
                  Expanded(
                    child: _buildFilterField(
                      controller: _filterControllers[_idxDiagnosisCode],
                      hint: 'Diagnosis code...',
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
        onChanged: (v) {
          controller.text = v ?? '';
        },
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
        // Match header sizing behavior used by the other report tables.
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
                  'Time Senstive Measures #1',
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

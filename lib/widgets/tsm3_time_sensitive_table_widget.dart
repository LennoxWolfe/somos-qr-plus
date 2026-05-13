import 'dart:math' show min;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'report_pagination_bar.dart';

class _ImaColumn {
  const _ImaColumn(this.key, this.header, [this.width = 150]);
  final String key;
  final String header;
  final double width;
}

class ImaTableWidget extends StatefulWidget {
  const ImaTableWidget({super.key});

  @override
  State<ImaTableWidget> createState() => _ImaTableWidgetState();
}

class _ImaTableWidgetState extends State<ImaTableWidget> {
  static const List<_ImaColumn> _columns = [
    _ImaColumn('mco', 'MCO', 120),
    _ImaColumn('tin', 'TIN', 120),
    _ImaColumn('practice_name', 'PRACTICE NAME', 200),
    _ImaColumn('npi', 'NPI', 120),
    _ImaColumn('pcp_name', 'PCP NAME', 200),
    _ImaColumn('pcp_address', 'PCP ADDRESS', 220),
    _ImaColumn('pcp_city', 'PCP CITY', 160),
    _ImaColumn('pcp_state', 'PCP STATE', 120),
    _ImaColumn('pcp_zip', 'PCP ZIP', 120),
    _ImaColumn('pcp_phone', 'PCP PHONE', 140),
    _ImaColumn('measure_code', 'MEASURE CODE', 160),
    _ImaColumn('measure_description', 'MEASURE DESCRIPTION', 240),
    _ImaColumn('line_of_business', 'LINE OF BUSINESS', 200),
    _ImaColumn('mco_member_id', 'MCO MEMBER ID', 180),
    _ImaColumn('first_name', 'FIRST NAME', 160),
    _ImaColumn('last_name', 'LAST NAME', 160),
    _ImaColumn('date_of_birth', 'DATE OF BIRTH', 160),
    _ImaColumn('language', 'LANGUAGE', 140),
    _ImaColumn('race_ethnicity', 'RACE ETHNICITY', 180),
    _ImaColumn('gender', 'GENDER', 120),
    _ImaColumn('member_address', 'MEMBER ADDRESS', 220),
    _ImaColumn('member_city', 'MEMBER CITY', 160),
    _ImaColumn('member_state', 'MEMBER STATE', 120),
    _ImaColumn('member_zip', 'MEMBER ZIP', 120),
    _ImaColumn('member_phone', 'MEMBER PHONE', 140),
    _ImaColumn('member_13th_birthday', 'MEMBER 13TH BIRTHDAY', 200),
    _ImaColumn('ima_meningococcal_1', 'IMA MENINGOCOCCAL 1', 200),
    _ImaColumn('ima_tdap_1', 'IMA TDAP 1', 160),
    _ImaColumn('ima_hpv_2', 'IMA HPV 2', 160),
    _ImaColumn('daterun', 'DATERUN', 140),
  ];

  static double get _tableWidth =>
      _columns.fold<double>(0, (s, c) => s + c.width);

  static Map<String, String> _placeholderRow(int rowIndex) {
    final i = rowIndex + 1;
    return {
      'mco': ['SOMOS', 'FIDELIS', 'METROPLUS', 'HIP', 'EMBLEM'][rowIndex % 5],
      'tin': '11111111$i',
      'practice_name': 'SOMOS FAMILY CARE $i',
      'npi': '19999999${10 + i}',
      'pcp_name': 'PCP LASTNAME $i, PCP FIRSTNAME $i',
      'pcp_address': '${100 + i} MAIN ST STE ${10 + i}',
      'pcp_city': ['BRONX', 'BROOKLYN', 'QUEENS', 'MANHATTAN', 'STATEN ISLAND']
          [rowIndex % 5],
      'pcp_state': 'NY',
      'pcp_zip': '1000$i',
      'pcp_phone': '21255501${10 + i}',
      'measure_code': 'IMA',
      'measure_description': 'IMMUNIZATIONS FOR ADOLESCENTS',
      'line_of_business': ['MEDICAID', 'COMMERCIAL', 'ESSENTIAL'][rowIndex % 3],
      'mco_member_id': 'PMID-0000$i',
      'first_name': ['ALEX', 'JORDAN', 'TAYLOR', 'MORGAN', 'CASEY'][rowIndex % 5],
      'last_name': ['RIVERA', 'SMITH', 'JOHNSON', 'BROWN', 'DAVIS'][rowIndex % 5],
      'date_of_birth': '01-0$i-2013',
      'language': ['ENGLISH', 'SPANISH', 'FRENCH', 'CHINESE', 'ARABIC'][rowIndex % 5],
      'race_ethnicity': [
        'HISPANIC',
        'NON-HISPANIC BLACK',
        'NON-HISPANIC WHITE',
        'ASIAN',
        'OTHER',
      ][rowIndex % 5],
      'gender': ['F', 'M', 'F', 'M', 'F'][rowIndex % 5],
      'member_address': '${200 + i} OAK AVE APT ${i}B',
      'member_city': ['NEW YORK', 'BRONX', 'BROOKLYN', 'QUEENS', 'YONKERS']
          [rowIndex % 5],
      'member_state': 'NY',
      'member_zip': '1001$i',
      'member_phone': '91755502${10 + i}',
      'member_13th_birthday': '01-0$i-2026',
      'ima_meningococcal_1': ['DUE', 'DONE', 'DUE', 'DONE', 'DUE'][rowIndex % 5],
      'ima_tdap_1': ['DONE', 'DUE', 'DONE', 'DUE', 'DONE'][rowIndex % 5],
      'ima_hpv_2': ['DUE', 'DUE', 'DONE', 'DONE', 'DUE'][rowIndex % 5],
      'daterun': '04-17-2026',
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

  late final int _idxMemberCity;
  late final int _idxMemberState;
  late final int _idxMemberZip;
  late final int _idxMemberPhone;

  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _allRows = List.generate(5, _placeholderRow);
    _filtered = List.from(_allRows);
    _filterControllers = List.generate(
      _columns.length,
      (_) => TextEditingController(),
    );
    for (final c in _filterControllers) {
      c.addListener(_applyFilters);
    }

    _idxMemberCity = _columns.indexWhere((c) => c.key == 'member_city');
    _idxMemberState = _columns.indexWhere((c) => c.key == 'member_state');
    _idxMemberZip = _columns.indexWhere((c) => c.key == 'member_zip');
    _idxMemberPhone = _columns.indexWhere((c) => c.key == 'member_phone');

    assert(_idxMemberCity != -1);
    assert(_idxMemberState != -1);
    assert(_idxMemberZip != -1);
    assert(_idxMemberPhone != -1);
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

        final cityOptions = _distinctOptions('member_city');
        final stateOptions = _distinctOptions('member_state');

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
                    child: _buildFilterDropdown(
                      controller: _filterControllers[_idxMemberCity],
                      hint: 'Member city',
                      options: cityOptions,
                    ),
                  ),
                  SizedBox(width: padding),
                  Expanded(
                    child: _buildFilterDropdown(
                      controller: _filterControllers[_idxMemberState],
                      hint: 'Member state',
                      options: stateOptions,
                    ),
                  ),
                ],
              ),
              SizedBox(height: padding),
              Row(
                children: [
                  Expanded(
                    child: _buildFilterField(
                      controller: _filterControllers[_idxMemberZip],
                      hint: 'Member zip...',
                    ),
                  ),
                  SizedBox(width: padding),
                  Expanded(
                    child: _buildFilterField(
                      controller: _filterControllers[_idxMemberPhone],
                      hint: 'Member phone...',
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
                  'IMA',
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


import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
      'mco': 'SAMPLE MCO',
      'ipa': p,
      'product': 'MCD',
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
      'measure_code': 'CBP',
      'measure': 'SAMPLE MEASURE',
      'event_date': '01-15-2026',
      'alert_date': '01-20-2026',
      'deadline_calculation': '02-01-2026',
      'diagnosis_code': 'Z00.00',
      'diagnosis_description': 'SAMPLE DX',
      'admit_facility': 'SAMPLE FACILITY',
    };
  }

  late final List<Map<String, String>> _allRows;
  late List<Map<String, String>> _filtered;

  late final List<TextEditingController> _filterControllers;

  String? _sortKey;
  bool _sortAsc = true;

  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _allRows = List.generate(7, _placeholderRow);
    _filtered = List.from(_allRows);
    _filterControllers = List.generate(
      _columns.length,
      (_) => TextEditingController(),
    );
    for (final c in _filterControllers) {
      c.addListener(_applyFilters);
    }
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
      _sortRows();
    });
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
                            _buildFilterRow(),
                            ..._filtered.asMap().entries.map((e) {
                              return _buildDataRow(e.value, e.key);
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
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF333333)),
            padding: EdgeInsets.zero,
            onSelected: (v) {
              if (v == 'refresh') _applyFilters();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'refresh', child: Text('Refresh')),
            ],
          ),
          Expanded(
            child: Text(
              'Time Senstive Measures #1',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export (demo)')),
              );
            },
            icon: const Icon(Icons.open_in_new, size: 18, color: Color(0xFF1976D2)),
            label: const Text(
              'Export',
              style: TextStyle(
                color: Color(0xFF1976D2),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    const headerBg = Color(0xFFF0F0F0);
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

  Widget _buildFilterRow() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_columns.length, (i) {
          final col = _columns[i];
          return _filterCell(
            width: col.width,
            child: TextField(
              controller: _filterControllers[i],
              textAlign: TextAlign.center,
              decoration: _filterDecoration('Filter'),
              style: const TextStyle(fontSize: 11),
            ),
          );
        }),
      ),
    );
  }

  InputDecoration _filterDecoration(String hint) {
    return InputDecoration(
      isDense: true,
      hintText: hint,
      hintStyle: TextStyle(fontSize: 10, color: Colors.grey.shade500),
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _filterCell({required double width, required Widget child}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: child,
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

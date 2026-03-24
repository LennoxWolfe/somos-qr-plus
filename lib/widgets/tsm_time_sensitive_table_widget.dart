import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Time Sensitive Measure patient table: toolbar, sortable headers, per-column filters, data rows.
/// Layout pattern mirrors [PerfectTableWidget] (card shell + horizontal scroll) with filter row added.
class TsmTimeSensitiveTableWidget extends StatefulWidget {
  const TsmTimeSensitiveTableWidget({super.key});

  @override
  State<TsmTimeSensitiveTableWidget> createState() =>
      _TsmTimeSensitiveTableWidgetState();
}

class _TsmTimeSensitiveTableWidgetState extends State<TsmTimeSensitiveTableWidget> {
  static const double _nameW = 220;
  static const double _dobW = 128;
  static const double _mcoW = 140;
  static const double _statusW = 120;
  static const double _measureW = 128;
  static const double _phoneW = 160;
  static double get _tableWidth =>
      _nameW + _dobW + _mcoW + _statusW + _measureW + _phoneW;

  final List<Map<String, String>> _allRows = [
    {
      'patientName': 'Abbas A Chowdhury',
      'dob': '12-01-1951',
      'mco': 'Healthfirst',
      'status': 'Completed',
      'measureCode': 'CBP',
      'phone': '16469824440',
    },
    {
      'patientName': 'Abbas A Chowdhury',
      'dob': '12-01-1951',
      'mco': 'Healthfirst',
      'status': 'Open',
      'measureCode': 'DSF',
      'phone': '16469824440',
    },
    {
      'patientName': 'Abbas Uddin',
      'dob': '10-10-1992',
      'mco': 'Metroplus',
      'status': 'Completed',
      'measureCode': 'CFO',
      'phone': '9292809278',
    },
    {
      'patientName': 'Abbas Uddin',
      'dob': '10-10-1992',
      'mco': 'Metroplus',
      'status': 'Open',
      'measureCode': 'EED',
      'phone': '9292809278',
    },
    {
      'patientName': 'Abbie Liss Pena',
      'dob': '09-06-2024',
      'mco': 'Healthfirst',
      'status': 'Completed',
      'measureCode': 'W30',
      'phone': '19295005563',
    },
    {
      'patientName': 'Abdellah Aa Mohamed Mused',
      'dob': '05-14-2008',
      'mco': 'Healthfirst',
      'status': 'Open',
      'measureCode': 'DSF',
      'phone': '19292637560',
    },
    {
      'patientName': 'Abdellah Aa Mohamed Mused',
      'dob': '05-14-2008',
      'mco': 'Healthfirst',
      'status': 'Open',
      'measureCode': 'WCV',
      'phone': '19292637560',
    },
  ];

  late List<Map<String, String>> _filtered;

  final TextEditingController _nameFilter = TextEditingController();
  final TextEditingController _dobFilter = TextEditingController();
  final TextEditingController _phoneFilter = TextEditingController();

  String _mcoFilter = 'All MCOs';
  String _statusFilter = 'All Statuses';
  String _measureFilter = 'All Measures';

  String? _sortKey;
  bool _sortAsc = true;

  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _filtered = List.from(_allRows);
    _nameFilter.addListener(_applyFilters);
    _dobFilter.addListener(_applyFilters);
    _phoneFilter.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    _nameFilter.dispose();
    _dobFilter.dispose();
    _phoneFilter.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      final nameQ = _nameFilter.text.trim().toLowerCase();
      final dobQ = _dobFilter.text.trim().toLowerCase();
      final phoneQ = _phoneFilter.text.trim();

      _filtered = _allRows.where((r) {
        if (nameQ.isNotEmpty &&
            !r['patientName']!.toLowerCase().contains(nameQ)) {
          return false;
        }
        if (dobQ.isNotEmpty && !r['dob']!.toLowerCase().contains(dobQ)) {
          return false;
        }
        if (_mcoFilter != 'All MCOs' && r['mco'] != _mcoFilter) {
          return false;
        }
        if (_statusFilter != 'All Statuses' && r['status'] != _statusFilter) {
          return false;
        }
        if (_measureFilter != 'All Measures' &&
            r['measureCode'] != _measureFilter) {
          return false;
        }
        if (phoneQ.isNotEmpty && !r['phone']!.contains(phoneQ)) {
          return false;
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
              'Time Sensitive Measure (FUM, FUA, TRC)',
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
        children: [
          _headerCell('Patient Name', 'patientName', _nameW, TextAlign.left),
          _headerCell('DOB', 'dob', _dobW, TextAlign.center),
          _headerCell('MCO', 'mco', _mcoW, TextAlign.center),
          _headerCell('Status', 'status', _statusW, TextAlign.center),
          _headerCell('Measure Code', 'measureCode', _measureW, TextAlign.center),
          _headerCell('Patient Phone', 'phone', _phoneW, TextAlign.center),
        ],
      ),
    );
  }

  Widget _headerCell(
    String label,
    String key,
    double w,
    TextAlign align,
  ) {
    final active = _sortKey == key;
    return GestureDetector(
      onTap: () => _onSort(key),
      child: Container(
        width: w,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          mainAxisAlignment: align == TextAlign.center
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF333333),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              active
                  ? (_sortAsc ? Icons.arrow_upward : Icons.arrow_downward)
                  : Icons.unfold_more,
              size: 16,
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
        children: [
          _filterCell(
            width: _nameW,
            child: TextField(
              controller: _nameFilter,
              decoration: _filterDecoration('Filter name...'),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          _filterCell(
            width: _dobW,
            child: TextField(
              controller: _dobFilter,
              decoration: _filterDecoration('mm/dd/yyyy').copyWith(
                suffixIcon: Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          _filterCell(
            width: _mcoW,
            child: _dropdown(
              value: _mcoFilter,
              items: const [
                'All MCOs',
                'Healthfirst',
                'Metroplus',
              ],
              onChanged: (v) {
                if (v != null) {
                  _mcoFilter = v;
                  _applyFilters();
                }
              },
            ),
          ),
          _filterCell(
            width: _statusW,
            child: _dropdown(
              value: _statusFilter,
              items: const ['All Statuses', 'Completed', 'Open'],
              onChanged: (v) {
                if (v != null) {
                  _statusFilter = v;
                  _applyFilters();
                }
              },
            ),
          ),
          _filterCell(
            width: _measureW,
            child: _dropdown(
              value: _measureFilter,
              items: const [
                'All Measures',
                'CBP',
                'DSF',
                'CFO',
                'EED',
                'W30',
                'WCV',
              ],
              onChanged: (v) {
                if (v != null) {
                  _measureFilter = v;
                  _applyFilters();
                }
              },
            ),
          ),
          _filterCell(
            width: _phoneW,
            child: TextField(
              controller: _phoneFilter,
              decoration: _filterDecoration('Filter phone...').copyWith(
                suffixIcon: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  icon: const Icon(Icons.search, color: Color(0xFFE53935), size: 20),
                  onPressed: () => _applyFilters(),
                ),
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _filterDecoration(String hint) {
    return InputDecoration(
      isDense: true,
      hintText: hint,
      hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: child,
    );
  }

  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          isExpanded: true,
          style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
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
        children: [
          _dataCell(row['patientName']!, _nameW, TextAlign.left, bg),
          _dataCell(row['dob']!, _dobW, TextAlign.center, bg),
          _dataCell(row['mco']!, _mcoW, TextAlign.center, bg),
          _dataCell(row['status']!, _statusW, TextAlign.center, bg),
          _dataCell(row['measureCode']!, _measureW, TextAlign.center, bg),
          _dataCell(row['phone']!, _phoneW, TextAlign.center, bg),
        ],
      ),
    );
  }

  Widget _dataCell(String text, double w, TextAlign align, Color bg) {
    return Container(
      width: w,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Text(
        text,
        textAlign: align,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF333333),
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

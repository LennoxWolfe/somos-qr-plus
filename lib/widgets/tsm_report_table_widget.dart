import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/report_table_tokens.dart';
import 'report_table_card.dart';
import 'report_table_toolbar.dart';

/// Time Senstive Measures #1 — report grid (modal content from Reports → TSM → View Reports).
class TsmReportTableWidget extends StatefulWidget {
  const TsmReportTableWidget({super.key});

  static const String titleLabel = 'Time Senstive Measures #1';

  @override
  State<TsmReportTableWidget> createState() => _TsmReportTableWidgetState();
}

class _TsmColumn {
  const _TsmColumn(this.key, this.header, this.width);
  final String key;
  final String header;
  final double width;
}

class _TsmReportTableWidgetState extends State<TsmReportTableWidget> {
  static const List<_TsmColumn> _columns = [
    _TsmColumn('pcp_tin', 'PCP TIN', 132),
    _TsmColumn('pcp_practice', 'PCP PRACTICE', 148),
    _TsmColumn('pcp_npi', 'PCP NPI', 132),
    _TsmColumn('mco', 'MCO', 132),
    _TsmColumn('ipa', 'IPA', 132),
    _TsmColumn('product', 'PRODUCT', 132),
    _TsmColumn('mco_product', 'MCO PRODUCT', 140),
    _TsmColumn('mco_member_id', 'MCO MEMBER ID', 148),
    _TsmColumn('member_name', 'MEMBER NAME', 148),
    _TsmColumn('member_dob', 'MEMBER DOB', 132),
    _TsmColumn('member_address_1', 'MEMBER ADDRESS 1', 160),
    _TsmColumn('member_address_2', 'MEMBER ADDRESS 2', 160),
    _TsmColumn('member_city', 'MEMBER CITY', 132),
    _TsmColumn('member_zip', 'MEMBER ZIP', 132),
    _TsmColumn('member_phone_1', 'MEMBER PHONE 1', 140),
    _TsmColumn('member_phone_2', 'MEMBER PHONE 2', 140),
    _TsmColumn('emr_phone_3', 'EMR PHONE 3', 132),
    _TsmColumn('measure_code', 'MEASURE CODE', 132),
    _TsmColumn('measure', 'MEASURE', 160),
    _TsmColumn('event_date', 'EVENT DATE', 132),
    _TsmColumn('alert_date', 'ALERT DATE', 132),
    _TsmColumn('deadline_calculation', 'DEADLINE CALCULATION', 180),
    _TsmColumn('diagnosis_code', 'DIAGNOSIS CODE', 148),
    _TsmColumn('diagnosis_description', 'DIAGNOSIS DESCRIPTION', 200),
    _TsmColumn('admit_facility', 'ADMIT FACILITY', 160),
  ];

  late final List<Map<String, String>> _seedRows;
  late final List<TextEditingController> _filterControllers;

  final ScrollController _hScroll = ScrollController();
  final ScrollController _vScroll = ScrollController();

  int? _sortColumnIndex;
  bool _sortAscending = true;

  Map<int, TableColumnWidth> get _columnWidths => {
        for (var i = 0; i < _columns.length; i++)
          i: FixedColumnWidth(_columns[i].width),
      };

  @override
  void initState() {
    super.initState();
    _seedRows = _buildSeedRows();
    _filterControllers = List.generate(
      _columns.length,
      (_) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (final c in _filterControllers) {
      c.dispose();
    }
    _hScroll.dispose();
    _vScroll.dispose();
    super.dispose();
  }

  static List<Map<String, String>> _buildSeedRows() {
    return List.generate(7, (i) {
      final n = i + 1;
      final id = 100000 + n;
      return {
        'pcp_tin': '12-345678${n % 10}',
        'pcp_practice': n.isEven ? 'Metro Community Health PC' : 'Harbor View Medical Group',
        'pcp_npi': '198765432$n',
        'mco': ['Healthfirst', 'Anthem', 'Emblem', 'Molina', 'Centene', 'WellCare', 'Fidelis'][i],
        'ipa': ['East IPA', 'Harbor IPA', 'Bright IPA', 'Lakeside PHO', 'Summit IPA', 'Metro IPA', 'Coastal IPA'][i],
        'product': ['Medicare MLTC', 'Medicaid', 'Commercial', 'Medicare FFS', 'Dual SNP', 'MA HMO', 'CHPlus'][i],
        'mco_product': 'PRD-${100 + n}',
        'mco_member_id': 'MEM-$id',
        'member_name': ['Jane A. Rivera', 'Michael T. Chen', 'Sofia L. Mendez', 'Robert K. Okonkwo', 'Patricia N. Olsen', 'Daniel J. Ortiz', 'Maria P. Santos'][i],
        'member_dob': '${(3 + n % 9).toString().padLeft(2, '0')}/${(10 + n).toString().padLeft(2, '0')}/${1955 + i * 3}',
        'member_address_1': '${400 + n * 12} ${['Park Ave', 'Queens Blvd', 'Waters Pl', 'Boston Rd', 'Fordham Plaza', 'Grand Concourse', 'Atlantic Ave'][i]}',
        'member_address_2': n % 3 == 0 ? ['Suite 200', 'Apt 4B', 'Floor 3', 'Unit 12', '', 'Ste 500', 'PH-A'][i] : '',
        'member_city': ['New York', 'Queens', 'Bronx', 'Bronx', 'Bronx', 'Brooklyn', 'Manhattan'][i],
        'member_zip': ['10022', '11375', '10461', '10469', '10458', '11201', '10029'][i],
        'member_phone_1': '212-555-${1000 + n * 11}',
        'member_phone_2': n.isEven ? '646-555-${2000 + n}' : '',
        'emr_phone_3': n % 2 == 0 ? '917-555-${3000 + n}' : '',
        'measure_code': ['CBP', 'KED', 'COL', 'AWV', 'CCS', 'HBA1C', 'CHL'][i],
        'measure': [
          'Controlling Blood Pressure',
          'Kidney Health Evaluation',
          'Colorectal Cancer Screening',
          'Annual Wellness Visit',
          'Cervical Cancer Screening',
          'Diabetes HbA1c Control',
          'Cholesterol Management',
        ][i],
        'event_date': '2026-01-${(10 + n).toString().padLeft(2, '0')}',
        'alert_date': '2026-01-${(12 + n).toString().padLeft(2, '0')}',
        'deadline_calculation': '${3 + n * 2} due',
        'diagnosis_code': ['I10', 'N18.9', 'Z12.11', 'Z00.00', 'Z12.4', 'E11.65', 'E78.5'][i],
        'diagnosis_description': [
          'Essential (primary) hypertension',
          'Chronic kidney disease, unspecified',
          'Screening for colon cancer',
          'General adult medical examination',
          'Encounter for malignant neoplasm screening',
          'Type 2 diabetes with hyperglycemia',
          'Hyperlipidemia, unspecified',
        ][i],
        'admit_facility': [
          'NYP / Columbia',
          'Mount Sinai Queens',
          'Montefiore Hutchinson',
          'Jacobi Medical Center',
          'SBH Health System',
          'Maimonides MC',
          'NYU Langone',
        ][i],
      };
    });
  }

  List<Map<String, String>> _visibleRows() {
    var rows = List<Map<String, String>>.from(_seedRows);
    rows = rows.where((row) {
      for (var i = 0; i < _columns.length; i++) {
        final q = _filterControllers[i].text.trim().toLowerCase();
        if (q.isEmpty) continue;
        final val = (row[_columns[i].key] ?? '').toLowerCase();
        if (!val.contains(q)) return false;
      }
      return true;
    }).toList();

    if (_sortColumnIndex != null) {
      final key = _columns[_sortColumnIndex!].key;
      rows.sort((a, b) {
        final ca = (a[key] ?? '').toLowerCase();
        final cb = (b[key] ?? '').toLowerCase();
        final cmp = ca.compareTo(cb);
        return _sortAscending ? cmp : -cmp;
      });
    }
    return rows;
  }

  void _onRefresh() {
    setState(() {
      for (final c in _filterControllers) {
        c.clear();
      }
      _sortColumnIndex = null;
      _sortAscending = true;
    });
  }

  void _onExport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export (demo)'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _nudgeHorizontalScroll(PointerScrollEvent event) {
    if (!_hScroll.hasClients) return;
    final pos = _hScroll.position;
    double delta = event.scrollDelta.dx;
    if (delta == 0 &&
        (HardwareKeyboard.instance.isShiftPressed ||
            HardwareKeyboard.instance.logicalKeysPressed
                .contains(LogicalKeyboardKey.shiftLeft) ||
            HardwareKeyboard.instance.logicalKeysPressed
                .contains(LogicalKeyboardKey.shiftRight))) {
      delta = event.scrollDelta.dy;
    }
    if (delta == 0) return;
    final target = (pos.pixels + delta).clamp(
      pos.minScrollExtent,
      pos.maxScrollExtent,
    );
    _hScroll.jumpTo(target.toDouble());
  }

  Widget _headerCell(int colIndex) {
    final col = _columns[colIndex];
    final sortedHere = _sortColumnIndex == colIndex;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          if (_sortColumnIndex == colIndex) {
            _sortAscending = !_sortAscending;
          } else {
            _sortColumnIndex = colIndex;
            _sortAscending = true;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          border: Border(
            right: BorderSide(color: Colors.grey.shade300),
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              col.header,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
                letterSpacing: 0.2,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 4),
            Icon(
              sortedHere
                  ? (_sortAscending
                      ? Icons.arrow_upward
                      : Icons.arrow_downward)
                  : Icons.unfold_more,
              size: 14,
              color: const Color(0xFF666666),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterCell(int colIndex) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: TextField(
        controller: _filterControllers[colIndex],
        onChanged: (_) => setState(() {}),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF333333),
        ),
        decoration:
            ReportTableTokens.filterFieldDecoration(hint: 'Filter'),
      ),
    );
  }

  Widget _dataCell(String value, bool isEvenRow) {
    final display = value.isEmpty ? '—' : value;
    final bg = isEvenRow ? Colors.white : const Color(0xFFFAFAFA);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Center(
        child: Text(
          display,
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
            height: 1.25,
          ),
        ),
      ),
    );
  }

  TableRow _headerRow() {
    return TableRow(
      children: List.generate(
        _columns.length,
        (i) => _headerCell(i),
      ),
    );
  }

  TableRow _filterRow() {
    return TableRow(
      children: List.generate(
        _columns.length,
        (i) => _filterCell(i),
      ),
    );
  }

  TableRow _dataRow(Map<String, String> row, int visibleIndex) {
    final isEven = visibleIndex.isEven;
    return TableRow(
      children: List.generate(_columns.length, (i) {
        return _dataCell(row[_columns[i].key] ?? '', isEven);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleRows();
    final table = Table(
      columnWidths: _columnWidths,
      children: [
        _headerRow(),
        _filterRow(),
        ...visible.asMap().entries.map(
              (e) => _dataRow(e.value, e.key),
            ),
      ],
    );

    final scrollBody = ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
        },
      ),
      child: Listener(
        onPointerSignal: (signal) {
          if (signal is PointerScrollEvent) {
            _nudgeHorizontalScroll(signal);
          }
        },
        child: Scrollbar(
          controller: _hScroll,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _hScroll,
            scrollDirection: Axis.horizontal,
            primary: false,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Scrollbar(
              controller: _vScroll,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _vScroll,
                scrollDirection: Axis.vertical,
                primary: false,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: table,
              ),
            ),
          ),
        ),
      ),
    );

    return ReportTableCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReportTableToolbar(
            title: TsmReportTableWidget.titleLabel,
            onRefresh: _onRefresh,
            onExport: _onExport,
          ),
          Expanded(child: scrollBody),
        ],
      ),
    );
  }
}

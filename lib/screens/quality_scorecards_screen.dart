import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/quality_scorecard_data.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';

class QualityScorecardsScreen extends StatefulWidget {
  const QualityScorecardsScreen({super.key});

  @override
  State<QualityScorecardsScreen> createState() => _QualityScorecardsScreenState();
}

class _QualityScorecardsScreenState extends State<QualityScorecardsScreen> {
  static const _pageBg = Color(0xFFF5F5F5);
  static const _purpleStart = Color(0xFF667EEA);
  static const _purpleEnd = Color(0xFF764BA2);
  static const _headerHeight = 72.0;
  static const _groupHeaderHeight = 36.0;
  static const _rowHeight = 44.0;

  bool _isDrawerOpen = false;
  String _selectedPractice = qualityScorecardDefaultPractice;
  String _selectedMco = qualityScorecardMcoAll;
  String _selectedProduct = qualityScorecardDefaultProduct;
  String _selectedMeasure = qualityScorecardDefaultMeasure;
  String? _sortColumn;
  bool _sortAscending = true;
  int _currentPage = 1;
  int _rowsPerPage = 15;
  late List<QualityScorecardRow> _rows;

  static const _identityBg = Color(0xFFE9ECEF);
  static const _measureCodeBg = Color(0xFFD6EAFE);
  static const _measureNameBg = Color(0xFFD9F0D9);
  static const _openBg = Color(0xFFE3F2FD);
  static const _numeratorBg = Color(0xFFE0F7FA);
  static const _denominatorBg = Color(0xFFE3F2FD);
  static const _closedBg = Color(0xFFFFF8E1);
  static const _benchmarkBg = Color(0xFFE8F5E8);
  static const _trailingBg = Color(0xFFFFF3E0);

  @override
  void initState() {
    super.initState();
    _applyMcoChange(qualityScorecardMcoAll, resetSort: true);
  }

  void _applyMcoChange(String mco, {bool resetSort = false}) {
    _selectedMco = mco;
    _rows = buildQualityScorecardRows(mco);
    if (resetSort) {
      _sortColumn = null;
      _sortAscending = true;
    }
    _currentPage = 1;
  }

  List<QualityScorecardRow> get _sortedRows {
    if (_sortColumn == null) return _rows;
    final rows = List<QualityScorecardRow>.from(_rows);
    rows.sort((a, b) {
      final aValue = a.valueFor(_sortColumn!);
      final bValue = b.valueFor(_sortColumn!);
      int comparison;
      if (aValue is num && bValue is num) {
        comparison = aValue.compareTo(bValue);
      } else {
        comparison = aValue.toString().toLowerCase().compareTo(
              bValue.toString().toLowerCase(),
            );
      }
      return _sortAscending ? comparison : -comparison;
    });
    return rows;
  }

  List<QualityScorecardRow> get _paginatedRows {
    final rows = _sortedRows;
    if (rows.isEmpty) return rows;
    final start = (_currentPage - 1) * _rowsPerPage;
    final end = (start + _rowsPerPage).clamp(0, rows.length);
    return rows.sublist(start.clamp(0, rows.length), end);
  }

  int get _totalPages {
    if (_sortedRows.isEmpty) return 0;
    return (_sortedRows.length / _rowsPerPage).ceil();
  }

  void _handleSort(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = column;
        _sortAscending = true;
      }
      _currentPage = 1;
    });
  }

  void _clearAll() {
    setState(() {
      _selectedPractice = qualityScorecardDefaultPractice;
      _selectedProduct = qualityScorecardDefaultProduct;
      _selectedMeasure = qualityScorecardDefaultMeasure;
      _applyMcoChange(qualityScorecardMcoAll, resetSort: true);
    });
  }

  void _stubFilter(String label, String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label set to $value'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: _pageBg,
          body: Column(
            children: [
              AppHeaderWidget(
                onMenuPressed: () {
                  setState(() => _isDrawerOpen = true);
                },
                onProfileAction: _handleProfileAction,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(isMobile ? 12 : 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitleRow(isMobile),
                          SizedBox(height: isMobile ? 12 : 16),
                          _buildFilters(isMobile),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: _buildClearAllButton(),
                          ),
                          const SizedBox(height: 16),
                          _buildScorecardTable(),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: _buildTotalScoreCard(),
                          ),
                          const SizedBox(height: 12),
                          _buildPagination(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        AppDrawerWidget(
          isOpen: _isDrawerOpen,
          onClose: () => setState(() => _isDrawerOpen = false),
          onNavigation: (route) {
            setState(() => _isDrawerOpen = false);
            _handleNavigation(route);
          },
          activeRoute: 'quality',
        ),
      ],
    );
  }

  Widget _buildTitleRow(bool isMobile) {
    return Text(
      'Quality Score Cards',
      style: TextStyle(
        fontSize: isMobile ? 22 : 26,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF333333),
      ),
    );
  }

  Widget _buildFilters(bool isMobile) {
    final dropdowns = [
      _buildFilterDropdown(
        label: 'PRACTICE NAME:',
        value: _selectedPractice,
        items: qualityScorecardPractices,
        onChanged: (value) {
          setState(() => _selectedPractice = value);
          _stubFilter('Practice Name', value);
        },
      ),
      _buildFilterDropdown(
        label: 'MCO:',
        value: _selectedMco,
        items: qualityScorecardMcoOptions,
        labelBuilder: qualityScorecardMcoDropdownLabel,
        onChanged: (value) {
          setState(() => _applyMcoChange(value));
        },
      ),
      _buildFilterDropdown(
        label: 'PRODUCT:',
        value: _selectedProduct,
        items: qualityScorecardProducts,
        onChanged: (value) {
          setState(() => _selectedProduct = value);
          _stubFilter('Product', value);
        },
      ),
      _buildFilterDropdown(
        label: 'MEASURE:',
        value: _selectedMeasure,
        items: qualityScorecardMeasureFilterOptions,
        onChanged: (value) {
          setState(() => _selectedMeasure = value);
          _stubFilter('Measure', value);
        },
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: dropdowns[0]),
              const SizedBox(width: 12),
              Expanded(child: dropdowns[1]),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: dropdowns[2]),
              const SizedBox(width: 12),
              Expanded(child: dropdowns[3]),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        for (var i = 0; i < dropdowns.length; i++) ...[
          Expanded(child: dropdowns[i]),
          if (i < dropdowns.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
    String Function(String)? labelBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF666666),
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        labelBuilder?.call(item) ?? item,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (newValue) {
                if (newValue != null) onChanged(newValue);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClearAllButton() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_purpleStart, _purpleEnd],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _clearAll,
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_outline, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text(
                  'Clear All',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScorecardTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTableHeader(),
            ..._paginatedRows.asMap().entries.map(
                  (entry) => _buildDataRow(entry.value, entry.key),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Row(
      children: [
        _singleHeader('LOB', 'lob', 68),
        _singleHeader('MCO', 'mco', 108),
        _singleHeader('PRODUCT', 'product', 96),
        _singleHeader('MEASURE CODE', 'measureCode', 118),
        _singleHeader('MEASURE NAME', 'measureName', 230),
        _singleHeader('OPEN', 'open', 68),
        _groupHeader('NUMERATOR', const ['SOMOS', 'MCO'], const [72.0, 72.0]),
        _groupHeader('DENOMINATOR', const ['SOMOS', 'MCO'], const [72.0, 72.0]),
        _singleHeader('CLOSED', 'closed', 78),
        _groupHeader(
          'BENCHMARK',
          const ['25th', '50th', '75th', '90th'],
          const [62.0, 62.0, 62.0, 62.0],
        ),
        _singleHeader('HITS', 'hits', 68),
        _singleHeader('WEIGHT', 'weight', 78),
        _singleHeader('ACHIEVED', 'achieved', 88),
        _singleHeader('POINTS', 'points', 78),
      ],
    );
  }

  Widget _singleHeader(String title, String key, double width) {
    final isActive = _sortColumn == key;
    return GestureDetector(
      onTap: () => _handleSort(key),
      child: Container(
        width: width,
        height: _headerHeight,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_purpleStart, _purpleEnd],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: Border(
            right: BorderSide(color: Colors.white.withOpacity(0.28)),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 11,
                letterSpacing: 0.3,
              ),
            ),
            Icon(
              isActive
                  ? (_sortAscending
                      ? Icons.arrow_upward
                      : Icons.arrow_downward)
                  : Icons.unfold_more,
              color: Colors.white.withOpacity(isActive ? 1 : 0.75),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _groupHeader(String title, List<String> subs, List<double> widths) {
    final width = widths.fold<double>(0, (sum, item) => sum + item);
    return SizedBox(
      width: width,
      height: _headerHeight,
      child: Column(
        children: [
          Container(
            width: width,
            height: _groupHeaderHeight,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [_purpleStart, _purpleEnd],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 11,
                letterSpacing: 0.4,
              ),
            ),
          ),
          Row(
            children: [
              for (var i = 0; i < subs.length; i++)
                Container(
                  width: widths[i],
                  height: _groupHeaderHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
                    ),
                    border: Border(
                      right: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Text(
                    subs[i],
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(QualityScorecardRow row, int index) {
    final zebra = index.isOdd ? 0.12 : 0.0;
    Color tint(Color base) => Color.lerp(base, Colors.black, zebra)!;

    final values = [
      _cell(row.lob, 68, tint(_identityBg)),
      _cell(row.mco, 108, tint(_identityBg)),
      _cell(row.product, 96, tint(_identityBg)),
      _cell(row.measureCode, 118, tint(_measureCodeBg), bold: true),
      _cell(row.measureName, 230, tint(_measureNameBg), align: TextAlign.left),
      _cell(row.open, 68, tint(_openBg)),
      _cell(row.numeratorSomos, 72, tint(_numeratorBg)),
      _cell(row.numeratorMco, 72, tint(_numeratorBg)),
      _cell(row.denominatorSomos, 72, tint(_denominatorBg)),
      _cell(row.denominatorMco, 72, tint(_denominatorBg)),
      _cell(row.closed, 78, tint(_closedBg)),
      _cell(row.benchmark25th, 62, tint(_benchmarkBg)),
      _cell(row.benchmark50th, 62, tint(_benchmarkBg)),
      _cell(row.benchmark75th, 62, tint(_benchmarkBg)),
      _cell(row.benchmark90th, 62, tint(_benchmarkBg)),
      _cell(row.hits, 68, tint(_trailingBg)),
      _cell(row.weight, 78, tint(_trailingBg)),
      _cell(row.achieved, 88, tint(_trailingBg)),
      _cell(
        formatQualityScorecardPoints(row.points),
        78,
        tint(_trailingBg),
        bold: true,
      ),
    ];

    return SizedBox(
      height: _rowHeight,
      child: Row(children: values),
    );
  }

  Widget _cell(
    String text,
    double width,
    Color background, {
    TextAlign align = TextAlign.center,
    bool bold = false,
  }) {
    return Container(
      width: width,
      height: _rowHeight,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      alignment: align == TextAlign.left
          ? Alignment.centerLeft
          : Alignment.center,
      decoration: BoxDecoration(
        color: background,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: align,
        style: TextStyle(
          fontSize: 12,
          fontWeight: bold ? FontWeight.w600 : FontWeight.w500,
          color: const Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildTotalScoreCard() {
    final score = formatQualityTotalScore(_sortedRows.map((row) => row.points).toList());
    final subtitle = qualityScorecardTotalScoreSubtitle(_selectedMco);

    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_purpleStart, _purpleEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'TOTAL SCORE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            score,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    final totalRows = _sortedRows.length;
    final start = totalRows == 0 ? 0 : (_currentPage - 1) * _rowsPerPage + 1;
    final end = (_currentPage * _rowsPerPage).clamp(0, totalRows);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 8,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Rows per page:',
                style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
              ),
              const SizedBox(width: 6),
              DropdownButton<int>(
                value: _rowsPerPage,
                underline: const SizedBox(),
                style: const TextStyle(fontSize: 11, color: Color(0xFF333333)),
                items: const [15, 25, 50, 100]
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text('$value'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _rowsPerPage = value;
                    _currentPage = 1;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$start-$end of $totalRows',
                style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
              ),
              const SizedBox(width: 4),
              _pageButton(
                Icons.first_page,
                _currentPage > 1,
                () => setState(() => _currentPage = 1),
              ),
              _pageButton(
                Icons.chevron_left,
                _currentPage > 1,
                () => setState(() => _currentPage -= 1),
              ),
              _pageButton(
                Icons.chevron_right,
                _currentPage < _totalPages,
                () => setState(() => _currentPage += 1),
              ),
              _pageButton(
                Icons.last_page,
                _currentPage < _totalPages,
                () => setState(() => _currentPage = _totalPages),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pageButton(IconData icon, bool enabled, VoidCallback onPressed) {
    return IconButton(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon),
      iconSize: 18,
      padding: const EdgeInsets.all(2),
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
    );
  }

  void _handleNavigation(String route) {
    switch (route) {
      case 'dashboard':
        context.go('/dashboard');
        break;
      case 'quality':
        break;
      case 'risk-adjustment':
        context.go('/risk-adjustment-scorecards');
        break;
      case 'schedule':
        context.go('/schedule');
        break;
      case 'patients':
        context.go('/patients');
        break;
      case 'reports':
        context.go('/reports');
        break;
      case 'resources':
        context.go('/resources');
        break;
      case 'settings':
        context.go('/settings');
        break;
      case 'logout':
        break;
    }
  }

  void _handleProfileAction(String action) {
    switch (action) {
      case 'language':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Language clicked')),
        );
        break;
      case 'invitations':
        context.go('/invitation');
        break;
      case 'logout':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout clicked')),
        );
        break;
    }
  }
}

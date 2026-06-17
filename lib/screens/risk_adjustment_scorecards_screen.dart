import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/risk_adjustment_scorecard_data.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/gic_table_widget.dart';

class RiskAdjustmentScorecardsScreen extends StatefulWidget {
  final bool useProviderShell;

  const RiskAdjustmentScorecardsScreen({
    super.key,
    this.useProviderShell = false,
  });

  @override
  State<RiskAdjustmentScorecardsScreen> createState() =>
      _RiskAdjustmentScorecardsScreenState();
}

class _RiskAdjustmentScorecardsScreenState
    extends State<RiskAdjustmentScorecardsScreen> {
  static const _primaryBlue = Color(0xFF1976D2);
  static const _alertRed = Color(0xFFE74C3C);
  static const _amberBg = Color(0xFFFFF8E1);
  static const _amberBorder = Color(0xFFFFC107);
  static const _pageBg = Color(0xFFF5F5F5);

  bool _isDrawerOpen = false;
  String _selectedMco = 'all';
  bool _mcoSortAscending = true;
  int _currentPage = 1;
  int _rowsPerPage = 10;

  final Map<String, bool> _exportFields = {
    'MCOs': true,
    'Total Membership': true,
    'Members w Outstanding Codes': true,
    'Potential PMPM (\$)': true,
    '% Members w Outstanding Codes': true,
    'Current MCO Risk Score': true,
    'Recapture Rate': true,
  };

  List<ScorecardRow> get _filteredScorecardRows {
    if (_selectedMco == 'all') return scorecardData;
    return scorecardData.where((row) => row.mco == _selectedMco).toList();
  }

  List<ScorecardRow> get _sortedScorecardRows {
    final rows = List<ScorecardRow>.from(_filteredScorecardRows);
    rows.sort((a, b) {
      final comparison =
          a.mco.toLowerCase().compareTo(b.mco.toLowerCase());
      return _mcoSortAscending ? comparison : -comparison;
    });
    return rows;
  }

  List<ScorecardRow> get _paginatedScorecardRows {
    final rows = _sortedScorecardRows;
    if (rows.isEmpty) return rows;

    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage;
    return rows.sublist(
      startIndex,
      endIndex > rows.length ? rows.length : endIndex,
    );
  }

  int get _totalPages {
    final count = _sortedScorecardRows.length;
    if (count == 0) return 0;
    return (count / _rowsPerPage).ceil();
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      setState(() => _currentPage = page);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageContent = _buildPageContent();

    if (widget.useProviderShell) {
      return pageContent;
    }

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
              Expanded(child: pageContent),
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
          activeRoute: 'risk-adjustment',
        ),
      ],
    );
  }

  Widget _buildPageContent() {
    return ColoredBox(
      color: _pageBg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageHeader(),
            const SizedBox(height: 20),
            _buildPracticeBanner(),
            const SizedBox(height: 20),
            _buildScorecardTab(),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(String route) {
    switch (route) {
      case 'dashboard':
        context.go('/dashboard');
        break;
      case 'quality':
        context.go('/quality-scorecards');
        break;
      case 'risk-adjustment':
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

  Widget _buildPageHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 500;
        final titleSection = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Risk Adjustment Score Cards',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Practice-level risk adjustment performance.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ],
        );

        final pills = Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildMetaPill(
              'Reporting Period: June 2026',
              const Color(0xFFE3F2FD),
              _primaryBlue,
            ),
            _buildMetaPill(
              'Due Date: December 31',
              const Color(0xFFFFF3E0),
              const Color(0xFFE65100),
            ),
          ],
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleSection,
              const SizedBox(height: 16),
              pills,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: titleSection),
            const SizedBox(width: 24),
            pills,
          ],
        );
      },
    );
  }

  Widget _buildMetaPill(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  Widget _buildPracticeBanner() {
    final practice = riskAdjustmentPractices.first;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 500;
        final cards = [
          _buildPracticeCard('Practice Name', practice.name),
          _buildPracticeCard('TIN#', practice.tin),
        ];

        if (isNarrow) {
          return Column(children: [
            cards[0],
            const SizedBox(height: 12),
            cards[1],
          ]);
        }

        return Row(
          children: [
            Expanded(child: cards[0]),
            const SizedBox(width: 16),
            Expanded(child: cards[1]),
          ],
        );
      },
    );
  }

  Widget _buildPracticeCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: _amberBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _amberBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111111),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScorecardTab() {
    final rows = _paginatedScorecardRows;
    final totalRows = _sortedScorecardRows.length;
    final totals = computeScorecardTotals(_filteredScorecardRows);
    final showGrandTotal = _selectedMco == 'all';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildScorecardToolbar(),
        const SizedBox(height: 16),
        _buildScorecardTable(rows, totals, showGrandTotal, totalRows),
      ],
    );
  }

  Widget _buildScorecardToolbar() {
    return _buildMcoFilter();
  }

  Widget _buildMcoFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FILTER BY MCO',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFD0D0D0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedMco,
              isExpanded: true,
              items: [
                const DropdownMenuItem(value: 'all', child: Text('All MCOs')),
                ...scorecardData.map(
                  (row) => DropdownMenuItem(
                    value: row.mco,
                    child: Text(row.mco),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedMco = value;
                    _currentPage = 1;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScorecardTable(
    List<ScorecardRow> rows,
    ScorecardTotals totals,
    bool showGrandTotal,
    int totalRows,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFf8f9fa),
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Risk Adjustment Scorecard',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _showExportDialog,
                  icon: const Icon(Icons.file_download, size: 20),
                  tooltip: 'Export',
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 900),
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(180),
                  1: FixedColumnWidth(120),
                  2: FixedColumnWidth(150),
                  3: FixedColumnWidth(120),
                  4: FixedColumnWidth(150),
                  5: FixedColumnWidth(140),
                  6: FixedColumnWidth(110),
                  7: FixedColumnWidth(110),
                },
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey.shade200),
                ),
                children: [
                  _buildScorecardHeaderRow(),
                  ...rows.map(_buildScorecardDataRow),
                  if (showGrandTotal) _buildGrandTotalRow(totals),
                ],
              ),
            ),
          ),
          _buildPaginationControls(totalRows),
        ],
      ),
    );
  }

  TableRow _buildScorecardHeaderRow() {
    const headerStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 13,
    );

    return TableRow(
      decoration: const BoxDecoration(color: _primaryBlue),
      children: [
        _buildMcoHeaderCell(headerStyle),
        _tableHeaderCell('Total Membership', headerStyle),
        _tableHeaderCell('Members w Outstanding Codes', headerStyle),
        _tableHeaderCell('Potential PMPM (\$)', headerStyle),
        _tableHeaderCell('% Members w Outstanding Codes', headerStyle),
        _tableHeaderCell('Current MCO Risk Score', headerStyle),
        _tableHeaderCell('Recapture Rate', headerStyle),
        _tableHeaderCell('Action', headerStyle),
      ],
    );
  }

  TableRow _buildScorecardDataRow(ScorecardRow row) {
    TextStyle cellStyle({bool isAlert = false}) => TextStyle(
          fontSize: 13,
          fontWeight: isAlert ? FontWeight.w600 : FontWeight.w400,
          color: isAlert ? _alertRed : const Color(0xFF333333),
        );

    return TableRow(
      children: [
        _tableDataCell(Text(row.mco, style: cellStyle())),
        _tableDataCell(
          Text(formatRaNumber(row.membership),
              style: cellStyle(isAlert: row.alert)),
        ),
        _tableDataCell(
          Text(formatRaNumber(row.outstanding),
              style: cellStyle(isAlert: row.alert)),
        ),
        _tableDataCell(
          Text(formatRaCurrency(row.pmpm),
              style: cellStyle(isAlert: row.alert)),
        ),
        _tableDataCell(
          Text('${row.pctOutstanding}%', style: cellStyle(isAlert: row.alert)),
        ),
        _tableDataCell(
          Text(row.riskScore.toStringAsFixed(2),
              style: cellStyle(isAlert: row.alert)),
        ),
        _tableDataCell(
          Text('${row.recaptureRate}%', style: cellStyle(isAlert: row.alert)),
        ),
        _tableDataCell(
          TextButton(
            onPressed: () => context.go(
              '/reports?open=ra&mco=${Uri.encodeQueryComponent(row.mco)}',
            ),
            child: const Text(
              'View Codes',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildGrandTotalRow(ScorecardTotals totals) {
    const style = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Color(0xFF333333),
    );

    return TableRow(
      decoration: const BoxDecoration(color: _amberBg),
      children: [
        _tableDataCell(const Text('Grand Total', style: style)),
        _tableDataCell(Text(formatRaNumber(totals.membership), style: style)),
        _tableDataCell(Text(formatRaNumber(totals.outstanding), style: style)),
        _tableDataCell(Text(totals.avgPmpm, style: style)),
        _tableDataCell(Text('${totals.pctOutstanding}%', style: style)),
        _tableDataCell(Text(totals.avgRiskScore, style: style)),
        _tableDataCell(Text('${totals.avgRecapture}%', style: style)),
        const SizedBox(),
      ],
    );
  }

  Widget _buildMcoHeaderCell(TextStyle style) {
    return InkWell(
      onTap: () => setState(() {
        _mcoSortAscending = !_mcoSortAscending;
        _currentPage = 1;
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('MCOs', style: style),
            const SizedBox(width: 4),
            Icon(
              _mcoSortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 14,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableHeaderCell(String text, TextStyle style,
      {bool alignLeft = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Text(
        text,
        textAlign: alignLeft ? TextAlign.left : TextAlign.center,
        style: style,
      ),
    );
  }

  Widget _tableDataCell(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Center(child: child),
    );
  }

  void _showExportDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return SelectFieldsDialog(
          exportFields: _exportFields,
          onApply: (selectedFields) {
            setState(() {
              _exportFields
                ..clear()
                ..addAll(selectedFields);
            });
            _exportReport();
          },
        );
      },
    );
  }

  void _exportReport() {
    final selectedFields = _exportFields.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedFields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one field to export')),
      );
      return;
    }

    final rowCount = _sortedScorecardRows.length +
        (_selectedMco == 'all' && _sortedScorecardRows.isNotEmpty ? 1 : 0);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Exporting $rowCount row(s) with fields: ${selectedFields.join(', ')}',
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );

    // TODO: Implement actual export functionality (CSV, PDF, etc.)
  }

  Widget _buildPaginationControls(int totalRows) {
    final startIndex =
        totalRows == 0 ? 0 : (_currentPage - 1) * _rowsPerPage + 1;
    final endIndex = (_currentPage * _rowsPerPage).clamp(0, totalRows);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final rowsPerPageControl = Row(
            mainAxisSize: MainAxisSize.min,
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
          );

          final pageInfo = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Showing $startIndex-$endIndex of $totalRows',
                style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
              ),
              const SizedBox(width: 12),
              _buildCompactNavigation(),
            ],
          );

          if (constraints.maxWidth < 600) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [rowsPerPageControl],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [pageInfo],
                ),
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [rowsPerPageControl, pageInfo],
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
}

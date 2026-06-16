import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/risk_adjustment_scorecard_data.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';

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

  List<ScorecardRow> get _filteredScorecardRows {
    if (_selectedMco == 'all') return scorecardData;
    return scorecardData.where((row) => row.mco == _selectedMco).toList();
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
    final rows = _filteredScorecardRows;
    final totals = computeScorecardTotals(rows);
    final showGrandTotal = _selectedMco == 'all';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildScorecardToolbar(),
        const SizedBox(height: 16),
        _buildScorecardTable(rows, totals, showGrandTotal),
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
                  setState(() => _selectedMco = value);
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
      child: SingleChildScrollView(
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
        _tableHeaderCell('MCOs', headerStyle, alignLeft: true),
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
            onPressed: () => context.go('/reports?open=ra'),
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
}

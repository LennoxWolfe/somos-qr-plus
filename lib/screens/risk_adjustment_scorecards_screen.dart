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
    extends State<RiskAdjustmentScorecardsScreen>
    with SingleTickerProviderStateMixin {
  static const _primaryBlue = Color(0xFF1976D2);
  static const _alertRed = Color(0xFFE74C3C);
  static const _amberBg = Color(0xFFFFF8E1);
  static const _amberBorder = Color(0xFFFFC107);
  static const _pageBg = Color(0xFFF5F5F5);

  late final TabController _tabController;
  late final List<OptimusSuggestion> _feedbackData;
  bool _isDrawerOpen = false;

  String _selectedMco = 'all';
  final _optimusPatientFilter = TextEditingController();
  final _optimusDobFilter = TextEditingController();
  final _optimusSubscriberFilter = TextEditingController();
  String _optimusInsuranceFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    _feedbackData = createOptimusSuggestions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _optimusPatientFilter.dispose();
    _optimusDobFilter.dispose();
    _optimusSubscriberFilter.dispose();
    super.dispose();
  }

  List<ScorecardRow> get _filteredScorecardRows {
    if (_selectedMco == 'all') return scorecardData;
    return scorecardData.where((row) => row.mco == _selectedMco).toList();
  }

  List<OptimusSuggestion> get _filteredOptimusSuggestions {
    final patient = _optimusPatientFilter.text.trim().toLowerCase();
    final dob = _optimusDobFilter.text.trim().toLowerCase();
    final subscriber = _optimusSubscriberFilter.text.trim().toLowerCase();

    return createOptimusSuggestions().where((item) {
      if (patient.isNotEmpty && !item.patient.toLowerCase().contains(patient)) {
        return false;
      }
      if (dob.isNotEmpty && !item.dob.toLowerCase().contains(dob)) {
        return false;
      }
      if (subscriber.isNotEmpty &&
          !item.subscriberId.toLowerCase().contains(subscriber)) {
        return false;
      }
      if (_optimusInsuranceFilter != 'all' &&
          item.insurance != _optimusInsuranceFilter) {
        return false;
      }
      return true;
    }).toList();
  }

  int get _respondedCount =>
      _feedbackData.where((item) => item.feedback.isNotEmpty).length;

  int _feedbackCount(String value) =>
      _feedbackData.where((item) => item.feedback == value).length;

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
            _buildSectionTabs(),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _tabController,
              builder: (context, _) {
                switch (_tabController.index) {
                  case 1:
                    return _buildOptimusTab();
                  case 2:
                    return _buildFeedbackTab();
                  case 0:
                  default:
                    return _buildScorecardTab();
                }
              },
            ),
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
              'Practice-level risk adjustment performance, Optimus suggestions, and provider feedback.',
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

  Widget _buildSectionTabs() {
    const tabs = [
      'Scorecard',
      'Optimus Daily Suggestions',
      'Risk Adjustment Feedback',
    ];

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(tabs.length, (index) {
          final isSelected = _tabController.index == index;
          return GestureDetector(
            onTap: () => _tabController.animateTo(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? _primaryBlue : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? _primaryBlue : Colors.transparent,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: _primaryBlue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                tabs[index],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF555555),
                ),
              ),
            ),
          );
        }),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 500;
        final filter = _buildMcoFilter();
        final button = OutlinedButton(
          onPressed: () {
            final mco =
                _selectedMco == 'all' ? scorecardData.first.mco : _selectedMco;
            _showOutstandingCodesDialog(mco);
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: _primaryBlue,
            side: const BorderSide(color: _primaryBlue),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: const Text(
            'View Outstanding Codes',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              filter,
              const SizedBox(height: 12),
              button,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: filter),
            const SizedBox(width: 16),
            button,
          ],
        );
      },
    );
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
            onPressed: () => _showOutstandingCodesDialog(row.mco),
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

  void _showOutstandingCodesDialog(String mco) {
    final codes = outstandingCodesByMco[mco] ?? [];

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Outstanding Codes — $mco'),
          content: SizedBox(
            width: double.maxFinite,
            child: codes.isEmpty
                ? Text('No outstanding codes for $mco.')
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(_primaryBlue),
                        headingTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        columns: const [
                          DataColumn(label: Text('Patient Name')),
                          DataColumn(label: Text('DOB')),
                          DataColumn(label: Text('Subscriber ID')),
                          DataColumn(label: Text('ICD Code')),
                          DataColumn(label: Text('Diagnosis Description')),
                          DataColumn(label: Text('Last Documented')),
                        ],
                        rows: codes
                            .map(
                              (code) => DataRow(
                                cells: [
                                  DataCell(Text(code.patient)),
                                  DataCell(Text(code.dob)),
                                  DataCell(Text(code.subscriberId)),
                                  DataCell(Text(code.code)),
                                  DataCell(Text(code.description)),
                                  DataCell(Text(code.lastDocumented)),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOptimusTab() {
    final suggestions = _filteredOptimusSuggestions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOptimusFilters(),
        const SizedBox(height: 16),
        if (suggestions.isEmpty)
          _buildEmptyState(
              'No Optimus daily suggestions match the current filters.')
        else
          ...suggestions.map(_buildSuggestionCard),
      ],
    );
  }

  Widget _buildOptimusFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 500;
          final fields = [
            _buildFilterField(
                'Patient Name', _optimusPatientFilter, 'Search patient name'),
            _buildFilterField('DOB', _optimusDobFilter, 'MM-DD-YYYY'),
            _buildFilterField(
                'Subscriber ID', _optimusSubscriberFilter, 'Subscriber ID'),
            _buildInsuranceFilter(),
          ];

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...fields.expand((f) => [f, const SizedBox(height: 12)]),
                OutlinedButton(
                  onPressed: _clearOptimusFilters,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primaryBlue,
                    side: const BorderSide(color: _primaryBlue),
                  ),
                  child: const Text('Clear Filters'),
                ),
              ],
            );
          }

          return Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              ...fields,
              OutlinedButton(
                onPressed: _clearOptimusFilters,
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primaryBlue,
                  side: const BorderSide(color: _primaryBlue),
                ),
                child: const Text('Clear Filters'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD0D0D0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD0D0D0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsuranceFilter() {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INSURANCE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade600,
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
                value: _optimusInsuranceFilter,
                isExpanded: true,
                items: [
                  const DropdownMenuItem(
                    value: 'all',
                    child: Text('All Insurance'),
                  ),
                  ...scorecardData.map(
                    (row) => DropdownMenuItem(
                      value: row.mco,
                      child: Text(row.mco),
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _optimusInsuranceFilter = value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clearOptimusFilters() {
    setState(() {
      _optimusPatientFilter.clear();
      _optimusDobFilter.clear();
      _optimusSubscriberFilter.clear();
      _optimusInsuranceFilter = 'all';
    });
  }

  Widget _buildSuggestionCard(OptimusSuggestion item) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.patient,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'DOB: ${item.dob} · Subscriber ID: ${item.subscriberId}',
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.insurance,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.diagnosis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.evidence,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Recommended action: ${item.action}',
              style: const TextStyle(fontSize: 13, color: Color(0xFF333333)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFeedbackSummary(),
        const SizedBox(height: 16),
        _buildFeedbackTable(),
      ],
    );
  }

  Widget _buildFeedbackSummary() {
    final stats = [
      ('Suggestions', _feedbackData.length.toString()),
      ('Responded', _respondedCount.toString()),
      ('Assessed, Present', _feedbackCount('assessed_present').toString()),
      (
        'Assessed, Not Present',
        _feedbackCount('assessed_not_present').toString()
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth < 500
            ? constraints.maxWidth
            : (constraints.maxWidth - 36) / 4;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: stats
              .map(
                (stat) => SizedBox(
                  width: cardWidth,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stat.$1.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          stat.$2,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildFeedbackTable() {
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
          constraints: const BoxConstraints(minWidth: 1000),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(_primaryBlue),
            headingTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            columns: const [
              DataColumn(label: Text('Patient')),
              DataColumn(label: Text('DOB')),
              DataColumn(label: Text('Insurance')),
              DataColumn(label: Text('Suggested Diagnosis')),
              DataColumn(label: Text('Evidence / Reason')),
              DataColumn(label: Text('Provider Feedback')),
            ],
            rows: _feedbackData.map((item) {
              return DataRow(
                cells: [
                  DataCell(Text(item.patient)),
                  DataCell(Text(item.dob)),
                  DataCell(Text(item.insurance)),
                  DataCell(SizedBox(width: 200, child: Text(item.diagnosis))),
                  DataCell(SizedBox(width: 240, child: Text(item.evidence))),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: item.feedback.isNotEmpty
                            ? const Color(0xFFF1F8E9)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: item.feedback.isNotEmpty
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFD0D0D0),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: item.feedback.isEmpty ? '' : item.feedback,
                          isExpanded: true,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF333333),
                          ),
                          items: feedbackOptions
                              .map(
                                (option) => DropdownMenuItem<String>(
                                  value: option.value,
                                  child: Text(
                                    option.label,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              item.feedback = value ?? '';
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      ),
    );
  }
}

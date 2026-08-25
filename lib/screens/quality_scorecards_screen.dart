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
  static const _headerGrey = Color(0xFFF3F3F3);
  static const _borderGrey = Color(0xFFD0D0D0);
  static const _textGrey = Color(0xFF555555);
  static const _titleGrey = Color(0xFF6B6B6B);

  final QualityScorecardRepository _repository = QualityScorecardRepository();

  bool _isDrawerOpen = false;
  bool _isLoading = true;
  String? _error;
  QualityScorecardFilters _filters = const QualityScorecardFilters(
    month: QualityScorecardFilters.defaultMonth,
  );
  List<QualityScorecardGroup> _groups = const [];

  static const _columns = <_ScorecardColumn>[
    _ScorecardColumn('LOB', 72, TextAlign.left),
    _ScorecardColumn('MCO', 100, TextAlign.left),
    _ScorecardColumn('Product', 120, TextAlign.left),
    _ScorecardColumn('Measure Code', 110, TextAlign.left),
    _ScorecardColumn('Measure ID', 100, TextAlign.left),
    _ScorecardColumn('MCO Den', 90, TextAlign.right),
    _ScorecardColumn('MCO Num', 90, TextAlign.right),
    _ScorecardColumn('Somos Num', 100, TextAlign.right),
    _ScorecardColumn('Compliance Rate', 120, TextAlign.right),
    _ScorecardColumn('25th', 72, TextAlign.right),
    _ScorecardColumn('50th', 72, TextAlign.right),
    _ScorecardColumn('75th', 72, TextAlign.right),
    _ScorecardColumn('90th', 72, TextAlign.right),
    _ScorecardColumn('Achieved', 90, TextAlign.center),
    _ScorecardColumn('Hits to Next', 110, TextAlign.right),
    _ScorecardColumn('Weight', 72, TextAlign.right),
    _ScorecardColumn('Points', 72, TextAlign.right),
  ];

  @override
  void initState() {
    super.initState();
    _loadScorecards();
  }

  Future<void> _loadScorecards() async {
    final isInitialLoad = _groups.isEmpty && _error == null;
    if (isInitialLoad) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final response = await _repository.fetch(_filters);
      if (!mounted) return;
      setState(() {
        _groups = response.groups;
        _error = null;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Unable to load quality scorecards.';
        _isLoading = false;
      });
    }
  }

  void _applyFilters(QualityScorecardFilters filters) {
    setState(() => _filters = filters);
    _loadScorecards();
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
                      padding: EdgeInsets.all(isMobile ? 16 : 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPageHeader(isMobile),
                          const SizedBox(height: 28),
                          _buildBody(),
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

  Widget _buildPageHeader(bool isMobile) {
    const title = Text(
      'Internal Provider Scorecard by MCO',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w500,
        color: _titleGrey,
      ),
    );

    final filters = _buildFilters(isMobile);

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: 16),
          filters,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: title),
        const SizedBox(width: 24),
        filters,
      ],
    );
  }

  Widget _buildFilters(bool isMobile) {
    final dropdowns = [
      _buildFilterDropdown(
        label: 'Month',
        value: _filters.month,
        items: qualityScorecardMonths
            .map((month) => _FilterOption(month, month))
            .toList(),
        onChanged: (value) => _applyFilters(_filters.copyWith(month: value)),
      ),
      _buildFilterDropdown(
        label: 'Product',
        value: _filters.product,
        items: qualityScorecardProducts
            .map((product) => _FilterOption(
                  product,
                  product == 'all' ? '(All)' : product,
                ))
            .toList(),
        onChanged: (value) => _applyFilters(_filters.copyWith(product: value)),
      ),
      _buildFilterDropdown(
        label: 'Measure Code',
        value: _filters.measureCode,
        items: qualityScorecardMeasureCodes
            .map((code) => _FilterOption(
                  code,
                  code == 'all' ? '(All)' : code,
                ))
            .toList(),
        onChanged: (value) =>
            _applyFilters(_filters.copyWith(measureCode: value)),
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          for (var i = 0; i < dropdowns.length; i++) ...[
            dropdowns[i],
            if (i < dropdowns.length - 1) const SizedBox(height: 12),
          ],
        ],
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.end,
      children: dropdowns
          .map((dropdown) => SizedBox(width: 160, child: dropdown))
          .toList(),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<_FilterOption> items,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _textGrey,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: _borderGrey),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: _textGrey),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF333333),
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item.value,
                      child: Text(
                        item.label,
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

  Widget _buildBody() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text(
            _error!,
            style: const TextStyle(color: Color(0xFF666666)),
          ),
        ),
      );
    }

    if (_groups.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text(
            'No scorecards match the selected filters.',
            style: TextStyle(color: Color(0xFF666666)),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _groups.length; i++) ...[
          _buildGroupSection(_groups[i]),
          if (i < _groups.length - 1) const SizedBox(height: 40),
        ],
      ],
    );
  }

  Widget _buildGroupSection(QualityScorecardGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: _buildTotalScoreBadge(group),
        ),
        const SizedBox(height: 8),
        Text(
          group.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: _titleGrey,
          ),
        ),
        const SizedBox(height: 12),
        _buildScorecardTable(group),
      ],
    );
  }

  Widget _buildTotalScoreBadge(QualityScorecardGroup group) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          group.totalScoreLabel,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _textGrey,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          constraints: const BoxConstraints(minWidth: 56),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            group.totalScore,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScorecardTable(QualityScorecardGroup group) {
    final minWidth = _columns.fold<double>(0, (sum, col) => sum + col.width);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _borderGrey),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth),
          child: Table(
            columnWidths: {
              for (var i = 0; i < _columns.length; i++)
                i: FixedColumnWidth(_columns[i].width),
            },
            border: TableBorder(
              horizontalInside: BorderSide(color: Colors.grey.shade300),
              verticalInside: BorderSide(color: Colors.grey.shade300),
            ),
            children: [
              _buildHeaderRow(),
              ...group.rows.map(_buildDataRow),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildHeaderRow() {
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: _textGrey,
    );

    return TableRow(
      decoration: const BoxDecoration(color: _headerGrey),
      children: _columns
          .map(
            (column) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Text(
                column.title,
                textAlign: column.align,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: style,
              ),
            ),
          )
          .toList(),
    );
  }

  TableRow _buildDataRow(QualityScorecardRow row) {
    final values = [
      row.lob,
      row.mco,
      row.product,
      row.measureCode,
      row.measureId,
      row.mcoDenominator,
      row.mcoNumerator,
      row.somosNumerator,
      row.complianceRate,
      row.benchmark25th,
      row.benchmark50th,
      row.benchmark75th,
      row.benchmark90th,
      row.achieved,
      row.hitsToNextThreshold,
      row.weight,
      row.points,
    ];

    return TableRow(
      children: [
        for (var i = 0; i < _columns.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              values[i],
              textAlign: _columns[i].align,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
              ),
            ),
          ),
      ],
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

class _ScorecardColumn {
  final String title;
  final double width;
  final TextAlign align;

  const _ScorecardColumn(this.title, this.width, this.align);
}

class _FilterOption {
  final String value;
  final String label;

  const _FilterOption(this.value, this.label);
}

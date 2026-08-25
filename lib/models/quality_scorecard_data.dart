/// Quality Score Card data layer.
///
/// Swap [QualityScorecardRepository.fetch] with a live API call. Keep
/// [QualityScorecardFilters], [QualityScorecardRow], and
/// [QualityScorecardResponse] as the contract.
///
/// Expected query params:
/// - `month` — YYYYMM (e.g. `202512`)
/// - `product` — omit or `all` for every product
/// - `measure_code` — omit or `all` for every measure

const String qualityScorecardPlaceholder = '-';

class QualityScorecardFilters {
  final String month;
  final String product;
  final String measureCode;

  const QualityScorecardFilters({
    required this.month,
    this.product = 'all',
    this.measureCode = 'all',
  });

  static const defaultMonth = '202512';

  QualityScorecardFilters copyWith({
    String? month,
    String? product,
    String? measureCode,
  }) {
    return QualityScorecardFilters(
      month: month ?? this.month,
      product: product ?? this.product,
      measureCode: measureCode ?? this.measureCode,
    );
  }

  /// Query string the live endpoint should accept.
  Map<String, String> toQueryParameters() {
    return {
      'month': month,
      if (product != 'all') 'product': product,
      if (measureCode != 'all') 'measure_code': measureCode,
    };
  }
}

class QualityScorecardRow {
  final String month;
  final String lob;
  final String mco;
  final String product;
  final String measureCode;
  final String measureId;
  final String mcoDenominator;
  final String mcoNumerator;
  final String somosNumerator;
  final String complianceRate;
  final String benchmark25th;
  final String benchmark50th;
  final String benchmark75th;
  final String benchmark90th;
  final String achieved;
  final String hitsToNextThreshold;
  final String weight;
  final String points;

  const QualityScorecardRow({
    required this.month,
    required this.lob,
    required this.mco,
    required this.product,
    required this.measureCode,
    required this.measureId,
    this.mcoDenominator = qualityScorecardPlaceholder,
    this.mcoNumerator = qualityScorecardPlaceholder,
    this.somosNumerator = qualityScorecardPlaceholder,
    this.complianceRate = qualityScorecardPlaceholder,
    this.benchmark25th = qualityScorecardPlaceholder,
    this.benchmark50th = qualityScorecardPlaceholder,
    this.benchmark75th = qualityScorecardPlaceholder,
    this.benchmark90th = qualityScorecardPlaceholder,
    this.achieved = qualityScorecardPlaceholder,
    this.hitsToNextThreshold = qualityScorecardPlaceholder,
    this.weight = qualityScorecardPlaceholder,
    this.points = qualityScorecardPlaceholder,
  });

  /// Map a live API JSON object onto this model.
  factory QualityScorecardRow.fromJson(Map<String, dynamic> json) {
    String read(String key, [String fallback = qualityScorecardPlaceholder]) {
      final value = json[key];
      if (value == null) return fallback;
      return value.toString();
    }

    return QualityScorecardRow(
      month: read('month', ''),
      lob: read('lob', ''),
      mco: read('mco', ''),
      product: read('product', ''),
      measureCode: read('measure_code', ''),
      measureId: read('measure_id', ''),
      mcoDenominator: read('mco_denominator'),
      mcoNumerator: read('mco_numerator'),
      somosNumerator: read('somos_numerator'),
      complianceRate: read('compliance_rate'),
      benchmark25th: read('benchmark_25th'),
      benchmark50th: read('benchmark_50th'),
      benchmark75th: read('benchmark_75th'),
      benchmark90th: read('benchmark_90th'),
      achieved: read('achieved'),
      hitsToNextThreshold: read('hits_to_next_threshold'),
      weight: read('weight'),
      points: read('points'),
    );
  }
}

class QualityScorecardGroup {
  final String mco;
  final String lob;
  final String totalScore;
  final List<QualityScorecardRow> rows;

  const QualityScorecardGroup({
    required this.mco,
    required this.lob,
    required this.totalScore,
    required this.rows,
  });

  String get title => '${_titleCase(mco)} $lob';

  String get totalScoreLabel => '$title Total Score';

  factory QualityScorecardGroup.fromJson(Map<String, dynamic> json) {
    final rawRows = json['rows'];
    return QualityScorecardGroup(
      mco: json['mco']?.toString() ?? '',
      lob: json['lob']?.toString() ?? '',
      totalScore: json['total_score']?.toString() ?? qualityScorecardPlaceholder,
      rows: rawRows is List
          ? rawRows
              .whereType<Map<String, dynamic>>()
              .map(QualityScorecardRow.fromJson)
              .toList()
          : const [],
    );
  }
}

class QualityScorecardResponse {
  final List<QualityScorecardGroup> groups;

  const QualityScorecardResponse({required this.groups});

  factory QualityScorecardResponse.fromJson(Map<String, dynamic> json) {
    final rawGroups = json['groups'];
    if (rawGroups is List) {
      return QualityScorecardResponse(
        groups: rawGroups
            .whereType<Map<String, dynamic>>()
            .map(QualityScorecardGroup.fromJson)
            .toList(),
      );
    }

    final rawRows = json['rows'];
    final rows = rawRows is List
        ? rawRows
            .whereType<Map<String, dynamic>>()
            .map(QualityScorecardRow.fromJson)
            .toList()
        : <QualityScorecardRow>[];
    return QualityScorecardResponse(groups: groupQualityScorecardRows(rows));
  }
}

class QualityScorecardRepository {
  /// Replace this body with the live HTTP call. Example:
  /// `GET /api/quality-scorecards?${filters.toQueryParameters()}`
  Future<QualityScorecardResponse> fetch(QualityScorecardFilters filters) async {
    final rows = placeholderQualityScorecardRows.where((row) {
      if (row.month != filters.month) return false;
      if (filters.product != 'all' && row.product != filters.product) {
        return false;
      }
      if (filters.measureCode != 'all' &&
          row.measureCode != filters.measureCode) {
        return false;
      }
      return true;
    }).toList();

    return QualityScorecardResponse(groups: groupQualityScorecardRows(rows));
  }
}

const List<String> qualityScorecardMonths = ['202512', '202511'];

const List<String> qualityScorecardProducts = [
  'all',
  'EPP',
  'HARP',
  'Medicaid/CHP',
];

const List<String> qualityScorecardMeasureCodes = [
  'all',
  'GSD',
  'PCP',
  'POD',
  'PPC',
  'BCS',
  'CBP',
  'SAA',
  'VLS',
  'W30',
  'WCV',
];

List<QualityScorecardGroup> groupQualityScorecardRows(
  List<QualityScorecardRow> rows,
) {
  final order = <String>[];
  final grouped = <String, List<QualityScorecardRow>>{};

  for (final row in rows) {
    final key = '${row.mco}|${row.lob}';
    if (!grouped.containsKey(key)) {
      order.add(key);
      grouped[key] = [];
    }
    grouped[key]!.add(row);
  }

  return order.map((key) {
    final groupRows = grouped[key]!;
    final first = groupRows.first;
    return QualityScorecardGroup(
      mco: first.mco,
      lob: first.lob,
      totalScore: qualityScorecardPlaceholder,
      rows: groupRows,
    );
  }).toList();
}

String _titleCase(String value) {
  if (value.isEmpty) return value;
  return value[0].toUpperCase() + value.substring(1).toLowerCase();
}

QualityScorecardRow _placeholderRow({
  required String month,
  required String mco,
  required String product,
  required String measureCode,
  required String measureId,
  String lob = 'MCD',
}) {
  return QualityScorecardRow(
    month: month,
    lob: lob,
    mco: mco,
    product: product,
    measureCode: measureCode,
    measureId: measureId,
  );
}

List<QualityScorecardRow> _rowsForMonth(String month) {
  return [
    _placeholderRow(
      month: month,
      mco: 'ANTHEM',
      product: 'EPP',
      measureCode: 'GSD',
      measureId: 'GSD1',
    ),
    _placeholderRow(
      month: month,
      mco: 'ANTHEM',
      product: 'EPP',
      measureCode: 'PCP',
      measureId: 'PCP1',
    ),
    _placeholderRow(
      month: month,
      mco: 'ANTHEM',
      product: 'HARP',
      measureCode: 'PCP',
      measureId: 'PCP1',
    ),
    _placeholderRow(
      month: month,
      mco: 'ANTHEM',
      product: 'Medicaid/CHP',
      measureCode: 'PCP',
      measureId: 'PCP1',
    ),
    _placeholderRow(
      month: month,
      mco: 'ANTHEM',
      product: 'EPP',
      measureCode: 'POD',
      measureId: 'POD-N',
    ),
    _placeholderRow(
      month: month,
      mco: 'ANTHEM',
      product: 'HARP',
      measureCode: 'POD',
      measureId: 'POD-N',
    ),
    _placeholderRow(
      month: month,
      mco: 'ANTHEM',
      product: 'Medicaid/CHP',
      measureCode: 'POD',
      measureId: 'POD-N',
    ),
    _placeholderRow(
      month: month,
      mco: 'ANTHEM',
      product: 'EPP',
      measureCode: 'PPC',
      measureId: 'PPC2',
    ),
    _placeholderRow(
      month: month,
      mco: 'ANTHEM',
      product: 'HARP',
      measureCode: 'PPC',
      measureId: 'PPC2',
    ),
    _placeholderRow(
      month: month,
      mco: 'ANTHEM',
      product: 'Medicaid/CHP',
      measureCode: 'PPC',
      measureId: 'PPC2',
    ),
    _placeholderRow(
      month: month,
      mco: 'EMBLEM',
      product: 'All',
      measureCode: 'BCS',
      measureId: 'BCS',
    ),
    _placeholderRow(
      month: month,
      mco: 'EMBLEM',
      product: 'All',
      measureCode: 'CBP',
      measureId: 'CBP',
    ),
    _placeholderRow(
      month: month,
      mco: 'FIDELIS',
      product: 'All',
      measureCode: 'PPC',
      measureId: 'PPC1',
    ),
    _placeholderRow(
      month: month,
      mco: 'FIDELIS',
      product: 'All',
      measureCode: 'SAA',
      measureId: 'SAA',
    ),
    _placeholderRow(
      month: month,
      mco: 'FIDELIS',
      product: 'All',
      measureCode: 'VLS',
      measureId: 'VLS',
    ),
    _placeholderRow(
      month: month,
      mco: 'FIDELIS',
      product: 'All',
      measureCode: 'W30',
      measureId: 'W30',
    ),
    _placeholderRow(
      month: month,
      mco: 'FIDELIS',
      product: 'All',
      measureCode: 'WCV',
      measureId: 'WCV',
    ),
  ];
}

final List<QualityScorecardRow> placeholderQualityScorecardRows = [
  ..._rowsForMonth('202512'),
  ..._rowsForMonth('202511'),
];

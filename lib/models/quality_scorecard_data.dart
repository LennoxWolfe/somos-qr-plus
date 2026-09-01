/// Quality Score Card demo data, filters, and MCO points.
/// Swap fetch/points with live data later; keep these maps as the UI contract.

const String qualityScorecardMcoAll = 'all';
const String qualityScorecardDefaultPractice = 'Delmont Medical, PC';
const String qualityScorecardDefaultProduct = 'Medicaid/CHP';
const String qualityScorecardDefaultMeasure = 'All Measures';

class QualityScorecardMeasure {
  final String code;
  final String name;

  const QualityScorecardMeasure({required this.code, required this.name});
}

const List<QualityScorecardMeasure> qualityScorecardMeasures = [
  QualityScorecardMeasure(
    code: 'COA-PA',
    name: 'Care for Older Adults: Pain Assessment',
  ),
  QualityScorecardMeasure(
    code: 'CCS',
    name: 'Cervical Cancer Screening',
  ),
  QualityScorecardMeasure(
    code: 'CAW',
    name: 'Child and Adolescent Well-Care Visits',
  ),
  QualityScorecardMeasure(
    code: 'CIS-3',
    name: 'Childhood Immunization Status: Combination 3',
  ),
  QualityScorecardMeasure(
    code: 'CRC',
    name: 'Colorectal Cancer Screening',
  ),
  QualityScorecardMeasure(
    code: 'CDC-EE',
    name: 'Comprehensive Diabetes Care: Eye Exams',
  ),
  QualityScorecardMeasure(
    code: 'CDC-HbA1c',
    name: 'Comprehensive Diabetes Care: HbA1c Control (8.0% or 9.0%)',
  ),
  QualityScorecardMeasure(
    code: 'CHBP',
    name: 'Controlling High Blood Pressure',
  ),
  QualityScorecardMeasure(
    code: 'FUA-7',
    name:
        'Follow-Up After ED Visit for Alcohol and Other Drug Abuse: Within 7 Days Post-Discharge',
  ),
  QualityScorecardMeasure(
    code: 'MAC',
    name: 'Medication Adherence for Cholesterol',
  ),
  QualityScorecardMeasure(
    code: 'MAH',
    name: 'Medication Adherence for Hypertension',
  ),
  QualityScorecardMeasure(
    code: 'MAD',
    name: 'Medication Adherence for Oral Diabetes Medications',
  ),
  QualityScorecardMeasure(
    code: 'OMF',
    name: 'Osteoporosis Management in Women Who Had a Fracture',
  ),
  QualityScorecardMeasure(
    code: 'PPC-PP',
    name: 'Prenatal and Postpartum Care: Postpartum Care',
  ),
  QualityScorecardMeasure(
    code: 'ST-DM',
    name: 'Statin Therapy for Patients with Diabetes- Received Statin Therapy',
  ),
  QualityScorecardMeasure(
    code: 'TOC-MR',
    name: 'Transitions of Care: Medication Reconciliation',
  ),
  QualityScorecardMeasure(
    code: 'TOC-PE',
    name: 'Transitions of Care: Patient Engagement after Inpatient Discharge',
  ),
  QualityScorecardMeasure(
    code: 'VLS',
    name: 'Viral Load Suppression',
  ),
];

const List<String> qualityScorecardPractices = [
  'Delmont Medical, PC',
  'Provider 2',
  'Provider 3',
  'Provider 4',
];

const List<String> qualityScorecardMcoOptions = [
  qualityScorecardMcoAll,
  'ANTHEM',
  'AETNA',
  'CIGNA',
  'HUMANA',
  'UNITEDHEALTH',
];

const List<String> qualityScorecardProducts = [
  'EPP',
  'Medicaid/CHP',
  'HARP',
  'All',
];

List<String> get qualityScorecardMeasureFilterOptions => [
      qualityScorecardDefaultMeasure,
      ...qualityScorecardMeasures.map((measure) => measure.name),
    ];

const Map<String, String> qualityScorecardMcoTableLabels = {
  'ANTHEM': 'Anthem',
  'AETNA': 'Aetna',
  'CIGNA': 'Cigna',
  'HUMANA': 'Humana',
  'UNITEDHEALTH': 'UnitedHealth',
};

const Map<String, List<int>> qualityScorecardMcoPoints = {
  'ANTHEM': [0, 5, 9, 3, 7, 1, 4, 8, 2, 6, 5, 0, 9, 3, 7, 4, 1, 8],
  'AETNA': [2, 4, 6, 8, 1, 3, 5, 7, 0, 9, 2, 4, 6, 8, 1, 3, 5, 7],
  'CIGNA': [1, 3, 5, 7, 9, 0, 2, 4, 6, 8, 1, 3, 5, 7, 9, 0, 2, 4],
  'HUMANA': [9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 9, 8, 7, 6, 5, 4, 3, 2],
  'UNITEDHEALTH': [4, 4, 5, 5, 6, 6, 7, 7, 3, 3, 2, 2, 8, 8, 1, 1, 9, 0],
};

const List<String> _mcoPointKeys = [
  'ANTHEM',
  'AETNA',
  'CIGNA',
  'HUMANA',
  'UNITEDHEALTH',
];

String qualityScorecardMcoDropdownLabel(String mco) {
  if (mco == qualityScorecardMcoAll) return 'Select All';
  return mco;
}

String qualityScorecardMcoCellValue(String mco) {
  if (mco == qualityScorecardMcoAll) return '-';
  return qualityScorecardMcoTableLabels[mco] ?? mco;
}

String qualityScorecardTotalScoreSubtitle(String mco) {
  if (mco == qualityScorecardMcoAll) return 'All';
  final label = qualityScorecardMcoTableLabels[mco];
  return label == null ? mco : '$label MCO';
}

List<double> qualityScorecardPointsForMco(String mco) {
  final rowCount = qualityScorecardMeasures.length;
  if (mco != qualityScorecardMcoAll) {
    final points = qualityScorecardMcoPoints[mco];
    if (points == null) {
      return List<double>.filled(rowCount, 0);
    }
    return points.map((value) => value.toDouble()).toList();
  }

  return List<double>.generate(rowCount, (index) {
    final sum = _mcoPointKeys.fold<double>(
      0,
      (total, key) => total + qualityScorecardMcoPoints[key]![index],
    );
    return double.parse((sum / _mcoPointKeys.length).toStringAsFixed(1));
  });
}

String formatQualityScorecardPoints(double points) {
  if (points == points.roundToDouble()) return points.toInt().toString();
  return points.toStringAsFixed(1);
}

String formatQualityTotalScore(List<double> points) {
  if (points.isEmpty) return '—';
  final average = points.reduce((a, b) => a + b) / points.length;
  return average.toStringAsFixed(1);
}

class QualityScorecardRow {
  final String lob;
  final String mco;
  final String product;
  final String measureCode;
  final String measureName;
  final String open;
  final String numeratorSomos;
  final String numeratorMco;
  final String denominatorSomos;
  final String denominatorMco;
  final String closed;
  final String benchmark25th;
  final String benchmark50th;
  final String benchmark75th;
  final String benchmark90th;
  final String hits;
  final String weight;
  final String achieved;
  final double points;

  const QualityScorecardRow({
    required this.lob,
    required this.mco,
    required this.product,
    required this.measureCode,
    required this.measureName,
    required this.open,
    required this.numeratorSomos,
    required this.numeratorMco,
    required this.denominatorSomos,
    required this.denominatorMco,
    required this.closed,
    required this.benchmark25th,
    required this.benchmark50th,
    required this.benchmark75th,
    required this.benchmark90th,
    required this.hits,
    required this.weight,
    required this.achieved,
    required this.points,
  });

  dynamic valueFor(String key) {
    switch (key) {
      case 'lob':
        return lob;
      case 'mco':
        return mco;
      case 'product':
        return product;
      case 'measureCode':
        return measureCode;
      case 'measureName':
        return measureName;
      case 'open':
        return open;
      case 'closed':
        return closed;
      case 'hits':
        return hits;
      case 'weight':
        return weight;
      case 'achieved':
        return achieved;
      case 'points':
        return points;
      default:
        return '';
    }
  }
}

List<QualityScorecardRow> buildQualityScorecardRows(String selectedMco) {
  final points = qualityScorecardPointsForMco(selectedMco);
  final mcoCell = qualityScorecardMcoCellValue(selectedMco);

  return [
    for (var i = 0; i < qualityScorecardMeasures.length; i++)
      QualityScorecardRow(
        lob: '-',
        mco: mcoCell,
        product: '-',
        measureCode: qualityScorecardMeasures[i].code,
        measureName: qualityScorecardMeasures[i].name,
        open: '-',
        numeratorSomos: '-',
        numeratorMco: '-',
        denominatorSomos: '-',
        denominatorMco: '-',
        closed: '%',
        benchmark25th: '%',
        benchmark50th: '%',
        benchmark75th: '%',
        benchmark90th: '%',
        hits: '-',
        weight: '-',
        achieved: '%',
        points: points[i],
      ),
  ];
}

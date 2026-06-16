/// Demo data layer for Risk Adjustment Score Cards.
/// Replace with API-backed models when real data is available.

class RiskAdjustmentPractice {
  final String id;
  final String name;
  final String tin;

  const RiskAdjustmentPractice({
    required this.id,
    required this.name,
    required this.tin,
  });
}

class ScorecardRow {
  final String mco;
  final int membership;
  final int outstanding;
  final double pmpm;
  final int pctOutstanding;
  final double riskScore;
  final int recaptureRate;
  final bool alert;

  const ScorecardRow({
    required this.mco,
    required this.membership,
    required this.outstanding,
    required this.pmpm,
    required this.pctOutstanding,
    required this.riskScore,
    required this.recaptureRate,
    this.alert = false,
  });
}

class OutstandingCode {
  final String patient;
  final String dob;
  final String subscriberId;
  final String code;
  final String description;
  final String lastDocumented;

  const OutstandingCode({
    required this.patient,
    required this.dob,
    required this.subscriberId,
    required this.code,
    required this.description,
    required this.lastDocumented,
  });
}

class OptimusSuggestion {
  final String id;
  final String patient;
  final String dob;
  final String subscriberId;
  final String insurance;
  final String diagnosis;
  final String evidence;
  final String action;
  String feedback;

  OptimusSuggestion({
    required this.id,
    required this.patient,
    required this.dob,
    required this.subscriberId,
    required this.insurance,
    required this.diagnosis,
    required this.evidence,
    required this.action,
    this.feedback = '',
  });
}

class FeedbackOption {
  final String value;
  final String label;

  const FeedbackOption({required this.value, required this.label});
}

class ScorecardTotals {
  final int membership;
  final int outstanding;
  final int pctOutstanding;
  final String avgRiskScore;
  final int avgRecapture;
  final String avgPmpm;

  const ScorecardTotals({
    required this.membership,
    required this.outstanding,
    required this.pctOutstanding,
    required this.avgRiskScore,
    required this.avgRecapture,
    required this.avgPmpm,
  });
}

const List<RiskAdjustmentPractice> riskAdjustmentPractices = [
  RiskAdjustmentPractice(
    id: 'delmont',
    name: 'Delmont Medical, PC',
    tin: '12-3456789',
  ),
  RiskAdjustmentPractice(
    id: 'provider2',
    name: 'Provider 2',
    tin: '98-7654321',
  ),
  RiskAdjustmentPractice(
    id: 'provider3',
    name: 'Provider 3',
    tin: '11-2233445',
  ),
  RiskAdjustmentPractice(
    id: 'provider4',
    name: 'Provider 4',
    tin: '55-6677889',
  ),
];

const List<ScorecardRow> scorecardData = [
  ScorecardRow(
    mco: 'Healthfirst',
    membership: 1241,
    outstanding: 462,
    pmpm: 18.45,
    pctOutstanding: 37,
    riskScore: 1.10,
    recaptureRate: 81,
    alert: true,
  ),
  ScorecardRow(
    mco: 'WellCare',
    membership: 543,
    outstanding: 128,
    pmpm: 12.30,
    pctOutstanding: 24,
    riskScore: 1.23,
    recaptureRate: 88,
  ),
  ScorecardRow(
    mco: 'VNSHealth SelectHealth',
    membership: 312,
    outstanding: 134,
    pmpm: 15.75,
    pctOutstanding: 43,
    riskScore: 1.07,
    recaptureRate: 76,
  ),
  ScorecardRow(
    mco: 'Metroplus',
    membership: 426,
    outstanding: 158,
    pmpm: 14.20,
    pctOutstanding: 37,
    riskScore: 1.09,
    recaptureRate: 68,
  ),
  ScorecardRow(
    mco: 'Elderplan',
    membership: 219,
    outstanding: 48,
    pmpm: 9.85,
    pctOutstanding: 22,
    riskScore: 1.24,
    recaptureRate: 88,
  ),
  ScorecardRow(
    mco: 'UHC',
    membership: 87,
    outstanding: 43,
    pmpm: 21.10,
    pctOutstanding: 49,
    riskScore: 1.18,
    recaptureRate: 73,
  ),
  ScorecardRow(
    mco: 'Affinity',
    membership: 85,
    outstanding: 21,
    pmpm: 8.60,
    pctOutstanding: 25,
    riskScore: 1.14,
    recaptureRate: 90,
  ),
  ScorecardRow(
    mco: 'Fidelis',
    membership: 0,
    outstanding: 0,
    pmpm: 0,
    pctOutstanding: 0,
    riskScore: 0,
    recaptureRate: 0,
  ),
];

const Map<String, List<OutstandingCode>> outstandingCodesByMco = {
  'Healthfirst': [
    OutstandingCode(
      patient: 'Maria Gonzalez',
      dob: '03-14-1958',
      subscriberId: 'HF-102938',
      code: 'E11.9',
      description: 'Type 2 diabetes mellitus without complications',
      lastDocumented: '01-2024',
    ),
    OutstandingCode(
      patient: 'James Rivera',
      dob: '07-22-1963',
      subscriberId: 'HF-445566',
      code: 'I10',
      description: 'Essential (primary) hypertension',
      lastDocumented: '11-2023',
    ),
    OutstandingCode(
      patient: 'Ana Martinez',
      dob: '09-03-1982',
      subscriberId: 'HF-778899',
      code: 'J44.9',
      description: 'Chronic obstructive pulmonary disease, unspecified',
      lastDocumented: '02-2024',
    ),
  ],
  'WellCare': [
    OutstandingCode(
      patient: 'Robert Chen',
      dob: '12-01-1955',
      subscriberId: 'WC-223344',
      code: 'N18.3',
      description: 'Chronic kidney disease, stage 3',
      lastDocumented: '03-2024',
    ),
  ],
  'VNSHealth SelectHealth': [
    OutstandingCode(
      patient: 'Carmen Diaz',
      dob: '05-18-1949',
      subscriberId: 'VNS-556677',
      code: 'I50.9',
      description: 'Heart failure, unspecified',
      lastDocumented: '12-2023',
    ),
  ],
  'Metroplus': [
    OutstandingCode(
      patient: 'David Thompson',
      dob: '08-30-1971',
      subscriberId: 'MP-889900',
      code: 'F32.A',
      description: 'Depression, unspecified',
      lastDocumented: '10-2023',
    ),
  ],
  'Elderplan': [
    OutstandingCode(
      patient: 'Rosa Flores',
      dob: '01-25-1944',
      subscriberId: 'EP-112233',
      code: 'M81.0',
      description:
          'Age-related osteoporosis without current pathological fracture',
      lastDocumented: '04-2023',
    ),
  ],
  'UHC': [
    OutstandingCode(
      patient: 'Michael Brown',
      dob: '06-11-1968',
      subscriberId: 'UHC-334455',
      code: 'E78.5',
      description: 'Hyperlipidemia, unspecified',
      lastDocumented: '02-2024',
    ),
  ],
  'Affinity': [
    OutstandingCode(
      patient: 'Sofia Martinez',
      dob: '11-09-1975',
      subscriberId: 'AF-667788',
      code: 'G47.33',
      description: 'Obstructive sleep apnea',
      lastDocumented: '01-2024',
    ),
  ],
  'Fidelis': [],
};

const List<FeedbackOption> feedbackOptions = [
  FeedbackOption(value: '', label: 'Select feedback...'),
  FeedbackOption(value: 'assessed_present', label: 'Assessed, Present'),
  FeedbackOption(value: 'assessed_not_present', label: 'Assessed, Not Present'),
  FeedbackOption(value: 'patient_deceased', label: 'Patient Deceased'),
  FeedbackOption(
    value: 'patient_never_seen',
    label: 'Patient Never Seen by PCP (Inactive Patient)',
  ),
];

List<OptimusSuggestion> createOptimusSuggestions() => [
      OptimusSuggestion(
        id: 'opt-1',
        patient: 'Maria Gonzalez',
        dob: '03-14-1958',
        subscriberId: 'HF-102938',
        insurance: 'Healthfirst',
        diagnosis: 'E11.65 — Type 2 diabetes mellitus with hyperglycemia',
        evidence:
            'A1C 8.9% on 05-12-2026; prior diagnosis documented in 2024 but not recaptured this measurement year.',
        action: 'Review chart and confirm active condition during next visit.',
        feedback: 'assessed_present',
      ),
      OptimusSuggestion(
        id: 'opt-2',
        patient: 'James Rivera',
        dob: '07-22-1963',
        subscriberId: 'HF-445566',
        insurance: 'Healthfirst',
        diagnosis: 'I10 — Essential (primary) hypertension',
        evidence:
            'Blood pressure 152/94 on 05-10-2026; medication list includes lisinopril but condition not coded in current encounter.',
        action:
            'Assess blood pressure control and document active hypertension.',
      ),
      OptimusSuggestion(
        id: 'opt-3',
        patient: 'Robert Chen',
        dob: '12-01-1955',
        subscriberId: 'WC-223344',
        insurance: 'WellCare',
        diagnosis: 'N18.3 — Chronic kidney disease, stage 3',
        evidence:
            'eGFR 48 on 04-28-2026; CKD stage 3 previously documented in hospital discharge summary.',
        action: 'Confirm CKD stage and update problem list if active.',
      ),
      OptimusSuggestion(
        id: 'opt-4',
        patient: 'Carmen Diaz',
        dob: '05-18-1949',
        subscriberId: 'VNS-556677',
        insurance: 'VNSHealth SelectHealth',
        diagnosis: 'I50.9 — Heart failure, unspecified',
        evidence:
            'BNP elevated; cardiology note from 03-2026 references chronic systolic heart failure.',
        action:
            'Evaluate current heart failure status and document if present.',
      ),
    ];

String formatRaNumber(int value) {
  return value.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]},',
      );
}

String formatRaCurrency(double value) {
  return '\$${value.toFixed(2)}';
}

extension _DoubleFormat on double {
  String toFixed(int fractionDigits) {
    return toStringAsFixed(fractionDigits);
  }
}

ScorecardTotals computeScorecardTotals(List<ScorecardRow> rows) {
  if (rows.isEmpty) {
    return const ScorecardTotals(
      membership: 0,
      outstanding: 0,
      pctOutstanding: 0,
      avgRiskScore: '0.00',
      avgRecapture: 0,
      avgPmpm: '\$0.00',
    );
  }

  var membership = 0;
  var outstanding = 0;
  var pmpmSum = 0.0;
  var riskScoreSum = 0.0;
  var recaptureSum = 0;

  for (final row in rows) {
    membership += row.membership;
    outstanding += row.outstanding;
    pmpmSum += row.pmpm;
    riskScoreSum += row.riskScore;
    recaptureSum += row.recaptureRate;
  }

  final pctOutstanding =
      membership > 0 ? ((outstanding / membership) * 100).round() : 0;

  return ScorecardTotals(
    membership: membership,
    outstanding: outstanding,
    pctOutstanding: pctOutstanding,
    avgRiskScore: (riskScoreSum / rows.length).toStringAsFixed(2),
    avgRecapture: (recaptureSum / rows.length).round(),
    avgPmpm: formatRaCurrency(pmpmSum / rows.length),
  );
}

import 'package:flutter/material.dart';

/// One macro KPI row for the TSM table columns shown as macro metrics on the card.
class TsmMacroMetric {
  const TsmMacroMetric(this.label, this.value);
  final String label;
  final String value;
}

/// Summary card for TSM reports: same header/time view as other Reports KPI cards
/// (`_buildKPIHeader` + `_buildTimeframeNavigation`) plus macro metric rows.
class TsmReportsCard extends StatelessWidget {
  const TsmReportsCard({
    super.key,
    required this.timeframeLabel,
    required this.dateLine,
    required this.macroMetrics,
    required this.onViewReports,
    this.onPrevious,
    this.onNext,
    this.canGoPrevious = false,
    this.canGoNext = false,
  });

  /// Opens the TSM table dialog (same pattern as other Reports KPI cards).
  final VoidCallback onViewReports;

  final String timeframeLabel;
  final String dateLine;
  /// Macro-level values for: MCO, MCO MEMBER ID, MEMBER NAME, MEMBER DOB,
  /// MEMBER PHONE 1, MEASURE CODE, DEADLINE CALCULATION (detail table columns).
  final List<TsmMacroMetric> macroMetrics;

  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool canGoPrevious;
  final bool canGoNext;

  static const Color _textPrimary = Color(0xFF333333);

  /// Light blue tints matching other Reports KPI metric rows (`_buildKPIMetrics` missed style).
  static const List<Color> _rowBackgrounds = [
    Color(0xFFE3F2FD),
    Color(0xFFE8F4FC),
    Color(0xFFEDF6FD),
    Color(0xFFE1F5FE),
    Color(0xFFE3F2FD),
    Color(0xFFE8F4FC),
    Color(0xFFEDF6FD),
  ];
  static const Color _rowBorderBlue = Color(0xFFBBDEFB);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final padding = maxW < 300 ? 16.0 : 20.0;

        double titleSize, timeframeSize, dateSize;
        double iconSize, navFontSize;
        if (maxW < 300) {
          titleSize = 16;
          timeframeSize = 11;
          dateSize = 11;
          iconSize = 16;
          navFontSize = 10;
        } else if (maxW < 500) {
          titleSize = 18;
          timeframeSize = 12;
          dateSize = 12;
          iconSize = 18;
          navFontSize = 11;
        } else {
          titleSize = 18;
          timeframeSize = 12;
          dateSize = 12;
          iconSize = 20;
          navFontSize = 12;
        }

        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'TSM',
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF333333),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: canGoPrevious ? onPrevious : null,
                            icon: Icon(
                              Icons.chevron_left,
                              color: canGoPrevious
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade300,
                            ),
                            iconSize: iconSize,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(
                              minWidth: iconSize + 8,
                              minHeight: iconSize + 8,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              timeframeLabel,
                              style: TextStyle(
                                fontSize: navFontSize,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF666666),
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            onPressed: canGoNext ? onNext : null,
                            icon: Icon(
                              Icons.chevron_right,
                              color: canGoNext
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade300,
                            ),
                            iconSize: iconSize,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(
                              minWidth: iconSize + 8,
                              minHeight: iconSize + 8,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeframeLabel,
                    style: TextStyle(
                      fontSize: timeframeSize,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF666666),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (dateLine.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      dateLine,
                      style: TextStyle(
                        fontSize: dateSize,
                        color: const Color(0xFF999999),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  ...macroMetrics.asMap().entries.map((e) {
                    final i = e.key;
                    final m = e.value;
                    return Padding(
                      padding:
                          EdgeInsets.only(bottom: i < macroMetrics.length - 1 ? 8 : 0),
                      child: _metricRow(
                        label: m.label,
                        value: m.value,
                        background: _rowBackgrounds[i % _rowBackgrounds.length],
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onViewReports,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'View Reports',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _metricRow({
    required String label,
    required String value,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _rowBorderBlue),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// One macro KPI row for the TSM table columns shown as macro metrics on the card.
class Tsm2MacroMetric {
  const Tsm2MacroMetric(this.label, this.value);
  final String label;
  final String value;
}

/// Summary card for CIS reports: same header/time view as other Reports KPI cards
/// (`_buildKPIHeader` + `_buildTimeframeNavigation`) plus macro metric rows.
class Tsm2ReportsCard extends StatelessWidget {
  const Tsm2ReportsCard({
    super.key,
    required this.timeframeLabel,
    required this.dateLine,
    required this.macroMetrics,
    required this.completedCount,
    required this.openCount,
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
  /// Macro-level values for: MCO, MEMBER NAME, MEMBER DOB, MEMBER PHONE 1,
  /// MEASURE CODE, DEADLINE CALCULATION, DIAGNOSIS CODE (keys: mco, memberName, …).
  final List<Tsm2MacroMetric> macroMetrics;

  final int completedCount;
  final int openCount;

  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool canGoPrevious;
  final bool canGoNext;

  static const Color _textPrimary = Color(0xFF333333);
  static const Color _completedBg = Color(0xFFE8F5E8);
  static const Color _completedBorder = Color(0xFFC8E6C9);
  static const Color _openBg = Color(0xFFE3F2FD);
  static const Color _openBorder = Color(0xFFBBDEFB);

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
                          'CIS',
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
                  _statusRow(
                    label: 'Completed',
                    value: completedCount.toString(),
                    background: _completedBg,
                    border: _completedBorder,
                  ),
                  _statusRow(
                    label: 'Open',
                    value: openCount.toString(),
                    background: _openBg,
                    border: _openBorder,
                  ),
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

  Widget _statusRow({
    required String label,
    required String value,
    required Color background,
    required Color border,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double horizontalPadding, verticalPadding, labelSize, valueSize, margin;
        if (constraints.maxWidth < 300) {
          horizontalPadding = 6;
          verticalPadding = 4;
          labelSize = 11;
          valueSize = 14;
          margin = 3;
        } else if (constraints.maxWidth < 500) {
          horizontalPadding = 8;
          verticalPadding = 5;
          labelSize = 12;
          valueSize = 15;
          margin = 4;
        } else {
          horizontalPadding = 10;
          verticalPadding = 6;
          labelSize = 13;
          valueSize = 16;
          margin = 5;
        }

        return Container(
          margin: EdgeInsets.only(bottom: margin),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: background,
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: labelSize,
                    fontWeight: FontWeight.w500,
                    color: _textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: valueSize,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


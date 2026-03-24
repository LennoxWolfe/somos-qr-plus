import 'package:flutter/material.dart';

/// Summary card for TSM reports: tab header, date navigation, and Completed / Missed rows.
class TsmReportsCard extends StatelessWidget {
  const TsmReportsCard({
    super.key,
    required this.timeframeLabel,
    required this.dateLine,
    required this.completed,
    required this.missed,
    this.onPrevious,
    this.onNext,
    this.canGoPrevious = false,
    this.canGoNext = false,
    this.onOpenFullTable,
  });

  /// Opens the full TSM measures table (e.g. `/tsm-measures`). Entire card is tappable when set.
  final VoidCallback? onOpenFullTable;

  final String timeframeLabel;
  final String dateLine;
  final int completed;
  final int missed;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool canGoPrevious;
  final bool canGoNext;

  static const Color _tabGreen = Color(0xFF28A745);
  static const Color _completedBg = Color(0xFFE8F5E9);
  static const Color _missedBg = Color(0xFFE3F2FD);
  static const Color _textPrimary = Color(0xFF333333);
  static const Color _textSecondary = Color(0xFF777777);
  static const Color _navGrey = Color(0xFF666666);

  @override
  Widget build(BuildContext context) {
    final card = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'TSM',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 3,
                      decoration: const BoxDecoration(
                        color: _tabGreen,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: canGoPrevious ? onPrevious : null,
                  icon: Icon(
                    Icons.chevron_left,
                    color: canGoPrevious ? _navGrey : Colors.grey.shade300,
                  ),
                  iconSize: 22,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
                Text(
                  timeframeLabel.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: _navGrey,
                  ),
                ),
                IconButton(
                  onPressed: canGoNext ? onNext : null,
                  icon: Icon(
                    Icons.chevron_right,
                    color: canGoNext ? _navGrey : Colors.grey.shade300,
                  ),
                  iconSize: 22,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeframeLabel.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateLine,
                    style: const TextStyle(
                      fontSize: 13,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _metricRow(
              label: 'Completed',
              value: completed,
              background: _completedBg,
            ),
            const SizedBox(height: 8),
            _metricRow(
              label: 'Missed',
              value: missed,
              background: _missedBg,
            ),
          ],
        ),
        ),
      ),
    );

    if (onOpenFullTable != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onOpenFullTable,
          borderRadius: BorderRadius.circular(8),
          child: card,
        ),
      );
    }
    return card;
  }

  Widget _metricRow({
    required String label,
    required int value,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _textPrimary,
            ),
          ),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

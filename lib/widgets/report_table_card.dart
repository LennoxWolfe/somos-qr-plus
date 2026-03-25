import 'package:flutter/material.dart';
import '../core/theme/report_table_tokens.dart';

/// White rounded card + shadow wrapping report table content (matches TSM inner shell).
class ReportTableCard extends StatelessWidget {
  const ReportTableCard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: ReportTableTokens.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}

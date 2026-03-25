import 'package:flutter/material.dart';
import '../core/theme/report_table_tokens.dart';

/// Toolbar row inside report table cards: menu, centered title, Export (matches TSM).
class ReportTableToolbar extends StatelessWidget {
  const ReportTableToolbar({
    super.key,
    required this.title,
    required this.onRefresh,
    required this.onExport,
  });

  final String title;
  final VoidCallback onRefresh;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF333333)),
            onSelected: (value) {
              if (value == 'refresh') onRefresh();
            },
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                value: 'refresh',
                child: Text('Refresh'),
              ),
            ],
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: onExport,
            style: TextButton.styleFrom(
              foregroundColor: ReportTableTokens.exportBlue,
            ),
            icon: const Icon(Icons.open_in_new, size: 18),
            label: const Text(
              'Export',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

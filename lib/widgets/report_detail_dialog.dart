import 'package:flutter/material.dart';

/// Standard modal shell for report detail tables (TSM, GIC, RA, etc.).
class ReportDetailDialog extends StatelessWidget {
  const ReportDetailDialog({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => ReportDetailDialog(title: title, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(6),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double dialogWidth = constraints.maxWidth * 0.99;
          double dialogHeight = constraints.maxHeight * 0.95;
          if (constraints.maxWidth > 1200) {
            dialogWidth = 1250;
          }

          return Container(
            width: dialogWidth,
            height: dialogHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, size: 24),
                        tooltip: 'Close',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: child,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

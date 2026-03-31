import 'dart:math' show min;

import 'package:flutter/material.dart';

/// Report table pagination bar — behavior and visuals aligned across report tables.
///
/// Contract: 1-based [currentPage], default page size 10; allowed sizes 10, 20, 50, 100;
/// changing page size resets to page 1 (caller responsibility); empty [total] shows
/// "Showing 0-0 of 0" and one logical page for navigation.
class ReportPaginationBar extends StatelessWidget {
  const ReportPaginationBar({
    super.key,
    required this.total,
    required this.currentPage,
    required this.rowsPerPage,
    required this.onPageChanged,
    required this.onRowsPerPageChanged,
  });

  static const List<int> allowedPageSizes = [10, 20, 50, 100];

  final int total;
  final int currentPage;
  final int rowsPerPage;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onRowsPerPageChanged;

  int get _totalPages {
    if (total == 0) return 1;
    return (total / rowsPerPage).ceil();
  }

  int get _displayStart {
    if (total == 0) return 0;
    return (currentPage - 1) * rowsPerPage + 1;
  }

  int get _displayEnd {
    if (total == 0) return 0;
    return min(currentPage * rowsPerPage, total);
  }

  void _goToPage(int n) {
    final tp = _totalPages;
    if (n >= 1 && n <= tp) onPageChanged(n);
  }

  @override
  Widget build(BuildContext context) {
    final safeRowsPerPage =
        allowedPageSizes.contains(rowsPerPage) ? rowsPerPage : 10;

    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 600;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: narrow ? _buildStacked(safeRowsPerPage) : _buildWide(safeRowsPerPage),
        );
      },
    );
  }

  Widget _rowsPerPageControl(int safeRowsPerPage) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Rows per page:',
          style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
        ),
        const SizedBox(width: 6),
        DropdownButton<int>(
          value: safeRowsPerPage,
          items: allowedPageSizes.map((value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(
                '$value',
                style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) onRowsPerPageChanged(value);
          },
          underline: Container(),
          style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
        ),
      ],
    );
  }

  Widget _summaryAndNav() {
    final tp = _totalPages;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Showing $_displayStart-$_displayEnd of $total',
          style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
        ),
        const SizedBox(width: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed:
                  currentPage > 1 ? () => _goToPage(currentPage - 1) : null,
              icon: const Icon(Icons.chevron_left),
              iconSize: 18,
              padding: const EdgeInsets.all(2),
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$currentPage',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: currentPage < tp
                  ? () => _goToPage(currentPage + 1)
                  : null,
              icon: const Icon(Icons.chevron_right),
              iconSize: 18,
              padding: const EdgeInsets.all(2),
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStacked(int safeRowsPerPage) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(child: _rowsPerPageControl(safeRowsPerPage)),
        const SizedBox(height: 8),
        Center(child: _summaryAndNav()),
      ],
    );
  }

  Widget _buildWide(int safeRowsPerPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _rowsPerPageControl(safeRowsPerPage),
        _summaryAndNav(),
      ],
    );
  }
}

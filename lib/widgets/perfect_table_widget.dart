import 'package:flutter/material.dart';

class PerfectTableWidget extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final List<TableColumn> columns;
  final double? height;
  final Color? headerColor;
  final Color? rowColor;
  final Color? alternateRowColor;

  const PerfectTableWidget({
    super.key,
    required this.data,
    required this.columns,
    this.height,
    this.headerColor,
    this.rowColor,
    this.alternateRowColor,
  });

  @override
  State<PerfectTableWidget> createState() => _PerfectTableWidgetState();
}

class _PerfectTableWidgetState extends State<PerfectTableWidget> {
  String? _sortColumn;
  bool _sortAscending = true;
  final ScrollController _horizontalScrollController = ScrollController();

  List<Map<String, dynamic>> get _sortedData {
    if (_sortColumn == null) return widget.data;
    
    List<Map<String, dynamic>> sortedList = List.from(widget.data);
    sortedList.sort((a, b) {
      dynamic aValue = a[_sortColumn!];
      dynamic bValue = b[_sortColumn!];
      
      if (aValue is String && bValue is String) {
        int comparison = aValue.compareTo(bValue);
        return _sortAscending ? comparison : -comparison;
      } else if (aValue is int && bValue is int) {
        int comparison = aValue.compareTo(bValue);
        return _sortAscending ? comparison : -comparison;
      } else if (aValue is double && bValue is double) {
        int comparison = aValue.compareTo(bValue);
        return _sortAscending ? comparison : -comparison;
      }
      return 0;
    });
    
    return sortedList;
  }

  void _handleSort(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = column;
        _sortAscending = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _horizontalScrollController,
        child: Column(
          children: [
            // Table Header
            _buildTableHeader(),
            
            // Table Body
            if (widget.height != null)
              SizedBox(
                height: widget.height! - 80, // Subtract header height
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: _sortedData.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> data = entry.value;
                      return _buildDataRow(data, index);
                    }).toList(),
                  ),
                ),
              )
            else
              ..._sortedData.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> data = entry.value;
                return _buildDataRow(data, index);
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.headerColor != null 
            ? [widget.headerColor!, widget.headerColor!.withOpacity(0.8)]
            : [const Color(0xFF667EEA), const Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: widget.columns.map((column) {
          return _buildHeaderCell(column.title, column.width, column.key, column.sortable);
        }).toList(),
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width, String columnKey, bool sortable) {
    bool isActive = _sortColumn == columnKey;
    return GestureDetector(
      onTap: sortable ? () => _handleSort(columnKey) : null,
      child: Container(
        width: width,
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
          border: Border(
            right: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (sortable)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(
                  isActive 
                    ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                    : Icons.unfold_more,
                  color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(Map<String, dynamic> data, int index) {
    Color rowColor = index % 2 == 0 
      ? (widget.rowColor ?? Colors.white)
      : (widget.alternateRowColor ?? const Color(0xFFF8F9FA));
    
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: rowColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: widget.columns.map((column) {
          return _buildDataCell(
            data[column.key]?.toString() ?? '',
            column.width,
            rowColor,
            column.alignment,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDataCell(String text, double width, Color backgroundColor, TextAlign alignment) {
    return Container(
      width: width,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Align(
        alignment: alignment == TextAlign.center 
          ? Alignment.center
          : alignment == TextAlign.right
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          textAlign: alignment,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class TableColumn {
  final String title;
  final String key;
  final double width;
  final bool sortable;
  final TextAlign alignment;

  const TableColumn({
    required this.title,
    required this.key,
    required this.width,
    this.sortable = true,
    this.alignment = TextAlign.left,
  });
}

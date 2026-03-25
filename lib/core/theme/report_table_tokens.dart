import 'package:flutter/material.dart';

/// Shared styling for detailed report tables (TSM, GIC, RA, APPT, MWOV, SIIP, Staff Login).
class ReportTableTokens {
  ReportTableTokens._();

  static const Color headerRowColor = Color(0xFFF0F0F0);
  static const Color zebraOdd = Color(0xFFFAFAFA);
  static const Color textPrimary = Color(0xFF333333);
  static const Color exportBlue = Color(0xFF1976D2);

  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.2,
    height: 1.25,
  );

  static const TextStyle dataTextStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: 1.25,
  );

  static List<BoxShadow> get cardShadow => const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ];

  static InputDecoration filterFieldDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 10, color: Colors.grey.shade500),
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: exportBlue, width: 1),
      ),
    );
  }

  static InputDecoration dropdownFieldDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 10, color: Colors.grey.shade500),
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: exportBlue, width: 1),
      ),
    );
  }

  static Widget themedDataTable({
    required BuildContext context,
    required DataTable dataTable,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        dataTableTheme: DataTableThemeData(
          headingRowColor: WidgetStateProperty.all(headerRowColor),
          headingTextStyle: headerTextStyle,
          dataTextStyle: dataTextStyle,
          dividerThickness: 1,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
          ),
        ),
      ),
      child: dataTable,
    );
  }
}

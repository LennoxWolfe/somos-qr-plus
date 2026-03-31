import 'package:flutter/material.dart';
import 'tablet_sidebar_widget.dart';

/// Tablet-only shell (no responsive breakpoints): horizontal split with sidebar + main.
///
/// **Structure**
/// - [Row]: left [TabletSidebarWidget], right [Expanded] main column.
/// - Main column: optional [header] (one or more stacked strips, e.g. global app bar +
///   page-specific sub-bars), then [Expanded] [child] for scrollable page content.
///
/// **Navigation**
/// [onNavigation] receives string route keys from the sidebar/profile (e.g. `dashboard`,
/// `reports`); parents wire these to [go_router] or similar — the shell does not parse URLs.
///
/// **Content**
/// Screen titles and page body live in [child], not in [TabletAppHeaderWidget]. Typical
/// [Scaffold.backgroundColor] for the scroll region is `Color(0xFFF5F5F5)`.
class TabletLayoutWidget extends StatelessWidget {
  final Widget child;
  final String activeRoute;
  final Function(String) onNavigation;
  final Widget? header;

  const TabletLayoutWidget({
    super.key,
    required this.child,
    required this.activeRoute,
    required this.onNavigation,
    this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TabletSidebarWidget(
          activeRoute: activeRoute,
          onNavigation: onNavigation,
        ),
        Expanded(
          child: Column(
            children: [
              if (header != null) header!,
              Expanded(child: child),
            ],
          ),
        ),
      ],
    );
  }
}


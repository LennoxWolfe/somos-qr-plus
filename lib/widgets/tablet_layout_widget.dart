import 'package:flutter/material.dart';
import 'tablet_sidebar_widget.dart';

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
    // Dedicated tablet layout - no responsive breakpoints
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


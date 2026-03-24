import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/tablet_layout_widget.dart';
import '../widgets/tablet_app_header_widget.dart';
import '../widgets/provider_dropdown_widget.dart';
import '../widgets/tsm_time_sensitive_table_widget.dart';
import '../core/constants/providers.dart';

/// Time Sensitive Measures detail table — opened from Reports TSM card.
/// Shell matches [QualityScorecardsTabletScreen] (tablet layout, header, provider strip).
class TsmMeasuresTabletScreen extends StatefulWidget {
  const TsmMeasuresTabletScreen({super.key});

  @override
  State<TsmMeasuresTabletScreen> createState() =>
      _TsmMeasuresTabletScreenState();
}

class _TsmMeasuresTabletScreenState extends State<TsmMeasuresTabletScreen> {
  String _selectedProvider = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: TabletLayoutWidget(
        activeRoute: 'tsm',
        onNavigation: _handleNavigation,
        header: Column(
          children: [
            TabletAppHeaderWidget(
              onProfileAction: _handleProfileAction,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ProviderDropdownWidget(
                      selectedProvider: _selectedProvider,
                      providers: AppProviders.providers,
                      onProviderChanged: (provider) {
                        setState(() => _selectedProvider = provider);
                        _showSuccessMessage('Table context: $provider');
                      },
                      maxWidth: 300,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Time Sensitive Measures',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 24),
              const Expanded(
                child: TsmTimeSensitiveTableWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavigation(String route) {
    switch (route) {
      case 'dashboard':
        context.go('/dashboard');
        break;
      case 'quality':
        context.go('/quality-scorecards');
        break;
      case 'schedule':
        context.go('/schedule');
        break;
      case 'patients':
        context.go('/patients');
        break;
      case 'reports':
        context.go('/reports');
        break;
      case 'tsm':
        break;
      case 'resources':
        context.go('/resources');
        break;
      case 'settings':
        context.go('/settings');
        break;
      case 'logout':
        break;
    }
  }

  void _handleProfileAction(String action) {
    switch (action) {
      case 'language':
        break;
      case 'invitations':
        context.go('/invitations');
        break;
      case 'logout':
        break;
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

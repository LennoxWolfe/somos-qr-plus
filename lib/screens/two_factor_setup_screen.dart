import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/tablet_layout_widget.dart';
import '../widgets/tablet_app_header_widget.dart';

class TwoFactorSetupScreen extends StatefulWidget {
  const TwoFactorSetupScreen({super.key});

  @override
  State<TwoFactorSetupScreen> createState() => _TwoFactorSetupScreenState();
}

enum TwoFactorOption { faceId, authenticator, otp, biometricLogin }

class _TwoFactorSetupScreenState extends State<TwoFactorSetupScreen> {
  TwoFactorOption? _selectedOption = TwoFactorOption.otp; // Default to OTP as per image

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: TabletLayoutWidget(
        activeRoute: 'settings',
        onNavigation: _handleNavigation,
        child: Column(
          children: [
            // Navigation Header
            TabletAppHeaderWidget(
              onProfileAction: (value) {
                switch (value) {
                  case 'language':
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Language clicked')),
                    );
                    break;
                  case 'invitations':
                    context.go('/invitations');
                    break;
                  case 'logout':
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logout clicked')),
                    );
                    break;
                }
              },
            ),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Page Title with Back Button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '2-Step Verification Setup',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                          ),
                          IconButton(
                            onPressed: () => context.go('/settings'),
                            icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Instructions
                    const Text(
                      'Select your preferred 2-Step Verification method:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // 2FA Options
                    _buildTwoFactorOptions(),
                    
                    const SizedBox(height: 32),
                    
                    // Save Button
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveSelection,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Save Selection',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTwoFactorOptions() {
    return Column(
      children: [
        _buildOptionCard(
          title: 'Face ID',
          description: 'Use Face ID for secure authentication',
          icon: Icons.face,
          option: TwoFactorOption.faceId,
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          title: 'Authenticator',
          description: 'Use authenticator app for time-based codes',
          icon: Icons.security,
          option: TwoFactorOption.authenticator,
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          title: 'OTP',
          description: 'One-Time Password via SMS or email',
          icon: Icons.lock_open,
          option: TwoFactorOption.otp,
        ),
        const SizedBox(height: 16),
        _buildOptionCard(
          title: 'Biometric Login',
          description: 'Use fingerprint or face recognition',
          icon: Icons.fingerprint,
          option: TwoFactorOption.biometricLogin,
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String description,
    required IconData icon,
    required TwoFactorOption option,
  }) {
    final isSelected = _selectedOption == option;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = option;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected 
                    ? const Color(0xFF1976D2).withOpacity(0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xFF1976D2) : const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Radio<TwoFactorOption>(
              value: option,
              groupValue: _selectedOption,
              onChanged: (TwoFactorOption? value) {
                setState(() {
                  _selectedOption = value;
                });
              },
              activeColor: const Color(0xFF1976D2),
            ),
          ],
        ),
      ),
    );
  }

  void _saveSelection() {
    if (_selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a 2FA method'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    String message = '';
    switch (_selectedOption) {
      case TwoFactorOption.faceId:
        message = 'Face ID selected for 2-Step Verification';
        break;
      case TwoFactorOption.authenticator:
        message = 'Authenticator app selected for 2-Step Verification';
        break;
      case TwoFactorOption.otp:
        message = 'OTP selected for 2-Step Verification';
        break;
      case TwoFactorOption.biometricLogin:
        message = 'Biometric Login selected for 2-Step Verification';
        break;
      default:
        message = 'No 2FA option selected';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );

    // Navigate back to settings
    context.go('/settings');
  }

  void _handleNavigation(String route) {
    switch (route) {
      case 'dashboard':
        context.go('/dashboard');
        break;
      case 'quality':
        context.go('/quality');
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
        context.go('/tsm-measures');
        break;
      case 'resources':
        context.go('/resources');
        break;
      case 'settings':
        context.go('/settings');
        break;
      case 'logout':
        // Handle logout logic
        break;
    }
  }
}

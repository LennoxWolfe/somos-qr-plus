import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class TwoFactorScreen extends StatefulWidget {
  const TwoFactorScreen({super.key});

  @override
  State<TwoFactorScreen> createState() => _TwoFactorScreenState();
}

class _TwoFactorScreenState extends State<TwoFactorScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  
  final List<FocusNode> _codeFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  
  bool _isLoading = false;
  bool _canResend = false;
  int _countdown = 60;
  Timer? _timer;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    Future.delayed(const Duration(milliseconds: 100), () {
      _animationController.forward();
    });

    _startCountdown();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var focusNode in _codeFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    _canResend = false;
    _countdown = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1976D2),
              Color(0xFF4CAF50),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildTwoFactorCard(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTwoFactorCard() {
    final screenSize = MediaQuery.of(context).size;
    final isHorizontal = screenSize.width > screenSize.height;
    
    return Container(
      constraints: BoxConstraints(
        maxWidth: isHorizontal ? 1200 : 800,
        maxHeight: isHorizontal ? 700 : double.infinity,
      ),
      child: Card(
        elevation: 20,
        shadowColor: Colors.black.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.white,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(isHorizontal ? 32 : 48),
            child: isHorizontal ? _buildHorizontalLayout() : _buildVerticalLayout(),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLogoSection(),
        const SizedBox(height: 32),
        _buildTwoFactorForm(),
      ],
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogoSection(),
              const SizedBox(height: 32),
              _buildFormHeader(),
            ],
          ),
        ),
        const SizedBox(width: 48),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCodeInputs(),
              const SizedBox(height: 24),
              _buildVerifyButton(),
              const SizedBox(height: 24),
              _buildResendButton(),
              const SizedBox(height: 16),
              _buildBackToLoginButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        Image.asset(
          'assets/images/SOMOS QR.png',
          width: 250, // Increased for tablet
          height: 250, // Increased for tablet
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 250,
              height: 250,
              color: Colors.grey[100],
              child: const Icon(
                Icons.medical_services,
                size: 100, // Increased icon size for tablet
                color: Color(0xFF1976D2),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTwoFactorForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildFormHeader(),
          const SizedBox(height: 32), // Increased spacing for tablet
          _buildCodeInputs(),
          const SizedBox(height: 24), // Increased spacing for tablet
          _buildVerifyButton(),
          const SizedBox(height: 24), // Increased spacing for tablet
          _buildResendButton(),
          const SizedBox(height: 16), // Increased spacing for tablet
          _buildBackToLoginButton(),
        ],
      ),
    );
  }

  Widget _buildFormHeader() {
    return Column(
      children: [
        Text(
          'Two-Factor Authentication',
          style: TextStyle(
            fontSize: 32, // Increased for tablet
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12), // Increased spacing
        Text(
          'Enter the 6-digit code sent to your device',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18, // Increased for tablet
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCodeInputs() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 60, // Increased for tablet
              child: TextFormField(
                controller: _codeControllers[index],
                focusNode: _codeFocusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: const TextStyle(
                  fontSize: 24, // Increased for tablet
                  fontWeight: FontWeight.w600,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20), // Increased for tablet
                  fillColor: _codeControllers[index].text.isNotEmpty 
                      ? const Color(0xFF1976D2).withOpacity(0.1) 
                      : Colors.grey[50],
                  filled: true,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < 5) {
                    _codeFocusNodes[index + 1].requestFocus();
                  }
                  setState(() {}); // Update fill color
                },
                onTap: () {
                  // Clear field when tapped if it has content
                  if (_codeControllers[index].text.isNotEmpty) {
                    _codeControllers[index].clear();
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '';
                  }
                  return null;
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 12), // Increased spacing
        // Error message area
        Container(
          height: 24, // Increased for tablet
          alignment: Alignment.center,
          child: Text(
            '', // Error messages will go here
            style: TextStyle(
              fontSize: 14, // Increased for tablet
              color: Colors.red[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleVerifyCode,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1976D2),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18), // Increased for tablet
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Verify Code',
                style: TextStyle(
                  fontSize: 18, // Increased for tablet
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildResendButton() {
    return TextButton(
      onPressed: _canResend ? _handleResendCode : null,
      style: TextButton.styleFrom(
        foregroundColor: _canResend ? const Color(0xFF1976D2) : Colors.grey[400],
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _canResend
          ? Text(
              'Resend Code',
              style: TextStyle(
                fontSize: 16, // Increased for tablet
                fontWeight: FontWeight.w500,
              ),
            )
          : Text(
              'Resend Code (${_countdown}s)',
              style: TextStyle(
                fontSize: 16, // Increased for tablet
                fontWeight: FontWeight.w500,
              ),
            ),
    );
  }

  Widget _buildBackToLoginButton() {
    return TextButton(
      onPressed: () {
        context.go('/login');
      },
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF1976D2),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'Back to Login',
        style: TextStyle(
          fontSize: 16, // Increased for tablet
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Future<void> _handleVerifyCode() async {
    // Get the complete code
    final code = _codeControllers.map((controller) => controller.text).join('');
    
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 6-digit code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1500));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Code verified successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to dashboard or wherever 2FA should lead
        context.go('/provider/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleResendCode() async {
    if (!_canResend) return;

    try {
      // Clear all input fields
      for (var controller in _codeControllers) {
        controller.clear();
      }
      
      // Focus on first field
      _codeFocusNodes[0].requestFocus();
      
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('New code sent to your device'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Restart countdown
        _startCountdown();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend code: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

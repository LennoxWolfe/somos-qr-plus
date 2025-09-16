import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final List<FocusNode> _otpFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Password strength
  double _passwordStrength = 0.0;
  String _strengthText = 'Password strength';
  Color _strengthColor = Colors.grey;

  // Password requirements
  bool _hasLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecial = false;

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

    // Listen to password changes
    _newPasswordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                  child: _buildResetPasswordCard(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetPasswordCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800), // Increased for tablet
      child: Card(
        elevation: 20,
        shadowColor: Colors.black.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Slightly larger radius for tablet
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
            padding: const EdgeInsets.all(48), // Increased padding for tablet
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLogoSection(),
                const SizedBox(height: 32), // Increased spacing
                _buildResetPasswordForm(),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildResetPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildFormHeader(),
          const SizedBox(height: 32), // Increased spacing for tablet
          _buildOtpField(),
          const SizedBox(height: 24), // Increased spacing for tablet
          _buildNewPasswordField(),
          const SizedBox(height: 24), // Increased spacing for tablet
          _buildConfirmPasswordField(),
          const SizedBox(height: 24), // Increased spacing for tablet
          _buildPasswordRequirements(),
          const SizedBox(height: 24), // Increased spacing for tablet
          _buildResetButton(),
          const SizedBox(height: 24), // Increased spacing for tablet
          _buildBackToLoginButton(),
        ],
      ),
    );
  }

  Widget _buildFormHeader() {
    return Column(
      children: [
        Text(
          'Reset Password',
          style: TextStyle(
            fontSize: 32, // Increased for tablet
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12), // Increased spacing
        Text(
          'Enter your new password below',
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

  Widget _buildOtpField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verification Code',
          style: TextStyle(
            fontSize: 16, // Increased for tablet
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12), // Increased spacing
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 55, // Increased for tablet
              child: TextFormField(
                controller: _otpControllers[index],
                focusNode: _otpFocusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16), // Increased for tablet
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && index < 5) {
                    _otpFocusNodes[index + 1].requestFocus();
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
      ],
    );
  }

  Widget _buildNewPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Password',
          style: TextStyle(
            fontSize: 16, // Increased for tablet
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12), // Increased spacing
        TextFormField(
          controller: _newPasswordController,
          obscureText: _obscureNewPassword,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Enter your new password',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Colors.grey[600],
              size: 24, // Increased for tablet
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[600],
                size: 24, // Increased for tablet
              ),
              onPressed: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20, // Increased for tablet
              vertical: 16, // Increased for tablet
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'New password is required';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            if (!_hasUppercase || !_hasLowercase || !_hasNumber || !_hasSpecial) {
              return 'Password does not meet requirements';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        _buildPasswordStrengthBar(),
      ],
    );
  }

  Widget _buildPasswordStrengthBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _passwordStrength,
            child: Container(
              decoration: BoxDecoration(
                color: _strengthColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _strengthText,
          style: TextStyle(
            fontSize: 14, // Increased for tablet
            color: _strengthColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Password',
          style: TextStyle(
            fontSize: 16, // Increased for tablet
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12), // Increased spacing
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'Confirm your new password',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Colors.grey[600],
              size: 24, // Increased for tablet
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[600],
                size: 24, // Increased for tablet
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20, // Increased for tablet
              vertical: 16, // Increased for tablet
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: const EdgeInsets.all(20), // Increased for tablet
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12), // Increased radius for tablet
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password Requirements:',
            style: TextStyle(
              fontSize: 16, // Increased for tablet
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16), // Increased spacing
          _buildRequirementItem('At least 8 characters', _hasLength),
          _buildRequirementItem('One uppercase letter', _hasUppercase),
          _buildRequirementItem('One lowercase letter', _hasLowercase),
          _buildRequirementItem('One number', _hasNumber),
          _buildRequirementItem('One special character', _hasSpecial),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12), // Increased for tablet
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 20, // Increased for tablet
            color: isMet ? Colors.green : Colors.grey[400],
          ),
          const SizedBox(width: 12), // Increased spacing
          Text(
            text,
            style: TextStyle(
              fontSize: 14, // Increased for tablet
              color: isMet ? Colors.grey[800] : Colors.grey[600],
              fontWeight: isMet ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handlePasswordReset,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1976D2),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18), // Increased for tablet
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Increased radius for tablet
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
                'Reset Password',
                style: TextStyle(
                  fontSize: 18, // Increased for tablet
                  fontWeight: FontWeight.w600,
                ),
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
          borderRadius: BorderRadius.circular(4),
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

  void _checkPasswordStrength() {
    final password = _newPasswordController.text;
    
    // Check requirements
    _hasLength = password.length >= 8;
    _hasUppercase = password.contains(RegExp(r'[A-Z]'));
    _hasLowercase = password.contains(RegExp(r'[a-z]'));
    _hasNumber = password.contains(RegExp(r'[0-9]'));
    _hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    // Calculate strength
    int strength = 0;
    if (_hasLength) strength++;
    if (_hasUppercase) strength++;
    if (_hasLowercase) strength++;
    if (_hasNumber) strength++;
    if (_hasSpecial) strength++;

    _passwordStrength = strength / 5.0;

    // Update strength text and color
    if (_passwordStrength == 0) {
      _strengthText = 'Password strength';
      _strengthColor = Colors.grey;
    } else if (_passwordStrength <= 0.2) {
      _strengthText = 'Very weak';
      _strengthColor = Colors.red;
    } else if (_passwordStrength <= 0.4) {
      _strengthText = 'Weak';
      _strengthColor = Colors.orange;
    } else if (_passwordStrength <= 0.6) {
      _strengthText = 'Fair';
      _strengthColor = Colors.yellow[700]!;
    } else if (_passwordStrength <= 0.8) {
      _strengthText = 'Good';
      _strengthColor = Colors.lightGreen;
    } else {
      _strengthText = 'Strong';
      _strengthColor = Colors.green;
    }

    setState(() {});
  }

  Future<void> _handlePasswordReset() async {
    // Validate OTP
    final otp = _otpControllers.map((controller) => controller.text).join('');
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete verification code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
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
            content: Text('Password reset successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate to login page
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset failed: ${e.toString()}'),
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
}

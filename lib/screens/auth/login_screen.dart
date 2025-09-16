import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _secondEmailController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
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

    // Start animation after a brief delay
    Future.delayed(const Duration(milliseconds: 100), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _secondEmailController.dispose();
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
        child: Stack(
          children: [
            // Background pattern
            _buildBackgroundPattern(),
            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildLoginCard(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return CustomPaint(
      painter: BackgroundPatternPainter(),
      size: Size.infinite,
    );
  }

  Widget _buildLoginCard() {
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
                const SizedBox(height: 16), // Increased spacing
                _buildFormHeader(),
                const SizedBox(height: 32), // Increased spacing
                _buildLoginForm(),
                const SizedBox(height: 32), // Increased spacing
                _buildFooter(),
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

  Widget _buildFormHeader() {
    return Column(
      children: [
        Text(
          'Welcome',
          style: TextStyle(
            fontSize: 32, // Increased for tablet
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8), // Increased spacing
        Text(
          'Sign in to your account',
          style: TextStyle(
            fontSize: 18, // Increased for tablet
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildEmailField(),
          const SizedBox(height: 24), // Increased spacing for tablet
          _buildPasswordField(),
          const SizedBox(height: 24), // Increased spacing for tablet
          _buildFormOptions(),
          const SizedBox(height: 24), // Increased spacing for tablet
          _buildLoginButton(),
          const SizedBox(height: 24), // Increased spacing for tablet
          _buildSecondEmailField(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: TextStyle(
            fontSize: 16, // Increased for tablet
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12), // Increased spacing
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: Colors.grey[600],
              size: 24, // Increased for tablet
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
              return 'Email address is required';
            }
            if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontSize: 16, // Increased for tablet
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12), // Increased spacing
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Colors.grey[600],
              size: 24, // Increased for tablet
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[600],
                size: 24, // Increased for tablet
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
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
              return 'Password is required';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSecondEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter your email',
          style: TextStyle(
            fontSize: 16, // Increased for tablet
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12), // Increased spacing
        TextFormField(
          controller: _secondEmailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: Colors.grey[600],
              size: 24, // Increased for tablet
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
              return 'Email address is required';
            }
            if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildFormOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
              activeColor: const Color(0xFF1976D2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Text(
              'Remember me',
              style: TextStyle(
                fontSize: 16, // Increased for tablet
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            context.go('/forgot-password');
          },
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: 16, // Increased for tablet
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1976D2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
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
                'Sign In',
                style: TextStyle(
                  fontSize: 18, // Increased for tablet
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(
              fontSize: 16, // Increased for tablet
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
            children: [
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    context.go('/create-account');
                  },
                  child: Text(
                    'Create an account',
                    style: TextStyle(
                      fontSize: 16, // Increased for tablet
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1976D2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text.rich(
          TextSpan(
            text: 'By clicking Sign In, you agree to our ',
            style: TextStyle(
              fontSize: 14, // Increased for tablet
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
            children: [
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    // Show terms of service
                  },
                  child: Text(
                    'Terms of Service',
                    style: TextStyle(
                      fontSize: 14, // Increased for tablet
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1976D2),
                    ),
                  ),
                ),
              ),
              const TextSpan(text: ' and '),
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    // Show privacy policy
                  },
                  child: Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 14, // Increased for tablet
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1976D2),
                    ),
                  ),
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Column(
            children: [
              Text(
                'Powered by',
                style: TextStyle(
                  fontSize: 14, // Increased for tablet
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
                             Image.asset(
                 'assets/images/SOMOS IPA logo.png',
                 width: 150, // Increased for tablet
                 height: 50, // Increased for tablet
                 fit: BoxFit.contain,
                 errorBuilder: (context, error, stackTrace) {
                   return Container(
                     width: 150,
                     height: 50,
                     decoration: BoxDecoration(
                       color: Colors.grey[100],
                       borderRadius: BorderRadius.circular(8),
                     ),
                     child: const Center(
                       child: Text(
                         'SOMOS IPA',
                         style: TextStyle(
                           fontSize: 16, // Increased for tablet
                           fontWeight: FontWeight.w600,
                           color: Color(0xFF1976D2),
                         ),
                       ),
                     ),
                   );
                 },
               ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        // Navigate to dashboard
        context.go('/provider/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
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

class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    // Draw radial gradients for background pattern
    final gradient1 = RadialGradient(
      center: Alignment.topLeft,
      radius: 0.5,
      colors: [
        Colors.white.withOpacity(0.1),
        Colors.transparent,
      ],
    );

    final gradient2 = RadialGradient(
      center: Alignment.bottomRight,
      radius: 0.5,
      colors: [
        Colors.white.withOpacity(0.1),
        Colors.transparent,
      ],
    );

    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.25),
      size.width * 0.3,
      Paint()..shader = gradient1.createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.75),
      size.width * 0.3,
      Paint()..shader = gradient2.createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

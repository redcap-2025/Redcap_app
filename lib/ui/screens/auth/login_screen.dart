// File: lib/ui/screens/customer/login/login_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_constants.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isPasswordVisible = false;
  bool _isOtpMode = false;
  bool _isLoading = false;
  bool _otpSent = false;
  String? _errorMessage;
  int _otpResendCountdown = 0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _setLoading(bool loading) {
    if (!mounted) return;
    setState(() {
      _isLoading = loading;
    });
  }

  void _setError(String? error) {
    if (!mounted) return;
    setState(() {
      _errorMessage = error;
    });
    if (error != null) {
      HapticFeedback.lightImpact();
    }
  }

  void _clearError() {
    if (!mounted) return;
    setState(() {
      _errorMessage = null;
    });
  }

  void _showSuccessMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppConstants.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    _setLoading(true);
    _clearError();

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final success = await authService.login(
        _phoneController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        _showSuccessMessage('Login successful!');
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        _setError(authService.error ?? 'Login failed. Please try again.');
      }
    } catch (e) {
      _setError('Network error. Please check your connection.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _handleOtpLogin() async {
    if (!_formKey.currentState!.validate()) return;

    _setLoading(true);
    _clearError();

    try {
      final authService = Provider.of<AuthService>(context, listen: false);

      if (!_otpSent) {
        final otpSent = await authService.sendOtp(_phoneController.text.trim());
        if (otpSent && mounted) {
          setState(() {
            _otpSent = true;
          });
          _showSuccessMessage('OTP sent to ${_phoneController.text}');
          _startResendCountdown();
        } else {
          _setError(authService.error ?? 'Failed to send OTP. Please try again.');
        }
      } else {
        final success = await authService.verifyOtp(
          _phoneController.text.trim(),
          _otpController.text.trim(),
        );

        if (success && mounted) {
          _showSuccessMessage('OTP verified successfully!');
          await Future.delayed(const Duration(milliseconds: 500));
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          _setError(authService.error ?? 'Invalid OTP. Please try again.');
        }
      }
    } catch (e) {
      _setError('Network error. Please check your connection.');
    } finally {
      _setLoading(false);
    }
  }

  void _startResendCountdown() {
    setState(() {
      _otpResendCountdown = 60;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _otpResendCountdown--;
      });
      if (_otpResendCountdown <= 0) {
        timer.cancel();
      }
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _switchToOtpMode() {
    setState(() {
      _isOtpMode = true;
      _otpSent = false;
      _otpResendCountdown = 0;
      _passwordController.clear();
    });
    _clearError();
  }

  void _switchToPasswordMode() {
    setState(() {
      _isOtpMode = false;
      _otpSent = false;
      _otpResendCountdown = 0;
      _otpController.clear();
    });
    _clearError();
  }

  Future<void> _resendOtp() async {
    if (_otpResendCountdown > 0) return;

    _setLoading(true);
    _clearError();

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final otpSent = await authService.sendOtp(_phoneController.text.trim());

      if (otpSent && mounted) {
        _showSuccessMessage('OTP resent successfully!');
        _startResendCountdown();
      } else {
        _setError(authService.error ?? 'Failed to resend OTP.');
      }
    } catch (e) {
      _setError('Network error. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.padding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    _buildHeader(),
                    const SizedBox(height: 48),
                    _buildLoginForm(),
                    const SizedBox(height: 32),
                    _buildAdditionalOptions(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Hero(
            tag: 'app_logo',
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromRGBO(255, 255, 255, 1),
                    const Color.fromARGB(255, 246, 243, 243).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.primaryColor.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              // ✅ Fixed: Use Image.asset directly
              child: Image.asset(
                'assets/images/redcap_logo.png',
                width: 60,
                height: 60,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    size: 60,
                    color: Colors.white,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Welcome Back!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isOtpMode
                ? (_otpSent ? 'Enter the verification code' : 'Get OTP to continue')
                : 'Sign in to continue booking trucks',
            style: TextStyle(
              fontSize: 16,
              color: AppConstants.textSecondaryColor,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppConstants.secondaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: _phoneController,
            labelText: 'Phone Number',
            hintText: 'Enter your phone number',
            prefixIcon: Icons.phone,
            keyboardType: TextInputType.phone,
            enabled: !_isLoading,
            validator: _validatePhoneNumber,
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isOtpMode ? _buildOtpSection() : _buildPasswordSection(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_isOtpMode && _otpSent)
                TextButton.icon(
                  onPressed: _otpResendCountdown > 0 ? null : _resendOtp,
                  icon: Icon(
                    Icons.refresh,
                    size: 16,
                    color: _otpResendCountdown > 0
                        ? AppConstants.textSecondaryColor
                        : AppConstants.primaryColor,
                  ),
                  label: Text(
                    _otpResendCountdown > 0
                        ? 'Resend in ${_otpResendCountdown}s'
                        : 'Resend OTP',
                    style: TextStyle(
                      color: _otpResendCountdown > 0
                          ? AppConstants.textSecondaryColor
                          : AppConstants.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
              TextButton(
                onPressed: _isLoading ? null : (_isOtpMode ? _switchToPasswordMode : _switchToOtpMode),
                child: Text(
                  _isOtpMode ? 'Use Password' : 'Use OTP Instead',
                  style: const TextStyle(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _errorMessage != null ? 60 : 0,
            child: _errorMessage != null ? _buildErrorMessage() : null,
          ),
          if (_errorMessage != null) const SizedBox(height: 20),
          CustomButton(
            onPressed: _isLoading ? null : _getLoginButtonAction(),
            text: _getLoginButtonText(),
            isLoading: _isLoading,
            icon: _getLoginButtonIcon(),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordSection() {
    return CustomTextField(
      key: const ValueKey('password'),
      controller: _passwordController,
      labelText: 'Password',
      hintText: 'Enter your password',
      prefixIcon: Icons.lock,
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: AppConstants.textSecondaryColor,
        ),
        onPressed: _togglePasswordVisibility,
      ),
      obscureText: !_isPasswordVisible,
      enabled: !_isLoading,
      validator: _validatePassword,
    );
  }

  Widget _buildOtpSection() {
    return Column(
      key: const ValueKey('otp'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_otpSent)
          CustomTextField(
            controller: _otpController,
            labelText: 'Enter OTP',
            hintText: 'Enter 6-digit OTP',
            prefixIcon: Icons.security,
            keyboardType: TextInputType.number,
            maxLength: 6,
            enabled: !_isLoading,
            validator: _validateOtp,
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppConstants.primaryColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppConstants.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'We will send a 6-digit verification code to your phone number',
                    style: TextStyle(
                      color: AppConstants.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.errorColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppConstants.errorColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: AppConstants.errorColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalOptions() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'OR',
                style: TextStyle(
                  color: AppConstants.textSecondaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppConstants.secondaryColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppConstants.primaryColor.withOpacity(0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(
                  color: AppConstants.textSecondaryColor,
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: _isLoading ? null : () {
                  Navigator.of(context).pushNamed('/register');
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppConstants.primaryColor, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            icon: Icon(
              Icons.person_outline,
              color: AppConstants.primaryColor,
            ),
            label: const Text(
              'Continue as Guest',
              style: TextStyle(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return AppConstants.requiredField;
    if (value.length < 10) return AppConstants.invalidPhone;
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) return 'Please enter a valid 10-digit phone number';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return AppConstants.requiredField;
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateOtp(String? value) {
    if (value == null || value.isEmpty) return AppConstants.requiredField;
    if (value.length != 6) return AppConstants.invalidOtp;
    if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) return 'Please enter a valid 6-digit OTP';
    return null;
  }

  VoidCallback? _getLoginButtonAction() => _isOtpMode ? _handleOtpLogin : _handleLogin;

  String _getLoginButtonText() {
    if (_isLoading) return 'Please wait...';
    return _isOtpMode ? (_otpSent ? 'Verify OTP' : 'Send OTP') : 'Login';
  }

  IconData _getLoginButtonIcon() {
    if (_isOtpMode) return _otpSent ? Icons.verified_user : Icons.sms;
    return Icons.login;
  }
}
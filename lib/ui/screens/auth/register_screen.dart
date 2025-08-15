// File: lib/ui/screens/customer/register/register_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isOtpMode = false;
  bool _isLoading = false;
  bool _otpSent = false;
  bool _agreedToTerms = false;
  String? _errorMessage;
  int _otpResendCountdown = 0;
  int _currentStep = 0;
  double _passwordStrength = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _passwordController.addListener(_updatePasswordStrength);
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  void _updatePasswordStrength() {
    final password = _passwordController.text;
    double strength = 0.0;

    if (password.length >= 6) strength += 0.2;
    if (password.length >= 8) strength += 0.2;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.2;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.2;

    if (mounted) {
      setState(() {
        _passwordStrength = strength;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreedToTerms) {
      _setError('Please agree to the Terms of Service and Privacy Policy');
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final success = await authService.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _phoneController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        _showSuccessMessage('Account created successfully!');
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _setError(authService.error ?? 'Registration failed. Please try again.');
      }
    } catch (e) {
      _setError('Network error. Please check your connection.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _handleOtpRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    _setLoading(true);
    _clearError();

    try {
      final authService = Provider.of<AuthService>(context, listen: false);

      if (!_otpSent) {
        if (!_agreedToTerms) {
          _setError('Please agree to the Terms of Service and Privacy Policy');
          _setLoading(false);
          return;
        }

        final otpSent = await authService.sendOtp(_phoneController.text.trim());
        if (otpSent && mounted) {
          setState(() {
            _otpSent = true;
            _currentStep = 1;
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
          final profileSuccess = await authService.updateProfile({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
          });

          if (profileSuccess && mounted) {
            _showSuccessMessage('Account created successfully!');
            await Future.delayed(const Duration(milliseconds: 500));
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            _setError(authService.error ?? 'Failed to create profile.');
          }
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

  Future<void> _resendOtp() async {
    if (_otpResendCountdown > 0 || _isLoading) return;

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

  void _togglePasswordVisibility() {
    if (mounted) {
      setState(() {
        _isPasswordVisible = !_isPasswordVisible;
      });
    }
  }

  void _toggleConfirmPasswordVisibility() {
    if (mounted) {
      setState(() {
        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
      });
    }
  }

  void _switchToOtpMode() {
    setState(() {
      _isOtpMode = true;
      _otpSent = false;
      _currentStep = 0;
      _otpResendCountdown = 0;
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
    _clearError();
  }

  void _switchToPasswordMode() {
    setState(() {
      _isOtpMode = false;
      _otpSent = false;
      _currentStep = 0;
      _otpResendCountdown = 0;
      _otpController.clear();
    });
    _clearError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Create Account', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.padding),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 32),
                            if (_isOtpMode) _buildProgressIndicator(),
                            const SizedBox(height: 24),
                            Expanded(child: _buildRegistrationForm()),
                            const SizedBox(height: 24),
                            _buildAdditionalOptions(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
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
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 252, 247, 247),
                    const Color.fromARGB(255, 252, 251, 251).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.primaryColor.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              // ✅ Fixed: Correct Image.asset usage
              child: Image.asset(
                'assets/images/redcap_logo.png', // ✅ Fixed typo: .pmg → .png
                width: 50,
                height: 50,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.white,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Join RedCap Truck Booking',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _getCurrentStepDescription(),
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.textSecondaryColor,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getCurrentStepDescription() {
    if (_isOtpMode) {
      return _otpSent
          ? 'Enter the verification code sent to ${_phoneController.text}'
          : 'We’ll send a verification code to your phone';
    }
    return 'Create your account to start booking trucks';
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildStepIndicator(0, 'Details', _currentStep >= 0),
          Expanded(
            child: Container(
              height: 2,
              color: _currentStep >= 1
                  ? AppConstants.primaryColor
                  : AppConstants.textSecondaryColor.withOpacity(0.3),
            ),
          ),
          _buildStepIndicator(1, 'Verify', _currentStep >= 1),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppConstants.primaryColor : Colors.transparent,
            border: Border.all(
              color: isActive
                  ? AppConstants.primaryColor
                  : AppConstants.textSecondaryColor.withOpacity(0.3),
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isActive
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      color: AppConstants.textSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isActive
                ? AppConstants.primaryColor
                : AppConstants.textSecondaryColor,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.secondaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _isOtpMode && _otpSent
                ? _buildOtpSection()
                : _buildFormFields(),
          ),
          const SizedBox(height: 16),
          if (!(_isOtpMode && _otpSent)) _buildSwitchModeButton(),
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _errorMessage != null ? 60 : 0,
            child: _errorMessage != null ? _buildErrorMessage() : null,
          ),
          const SizedBox(height: 20),
          _buildRegisterButton(),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      key: const ValueKey('form_fields'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          controller: _nameController,
          labelText: 'Full Name',
          hintText: 'Enter your full name',
          prefixIcon: Icons.person,
          enabled: !_isLoading,
          validator: _validateName,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _emailController,
          labelText: 'Email Address',
          hintText: 'Enter your email',
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          enabled: !_isLoading,
          validator: _validateEmail,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _phoneController,
          labelText: 'Phone Number',
          hintText: 'Enter your phone',
          prefixIcon: Icons.phone,
          keyboardType: TextInputType.phone,
          enabled: !_isLoading,
          validator: _validatePhoneNumber,
        ),
        const SizedBox(height: 16),
        if (!_isOtpMode)
          ...[
            CustomTextField(
              controller: _passwordController,
              labelText: 'Password',
              hintText: 'Create a strong password',
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
            ),
            const SizedBox(height: 8),
            _buildPasswordStrengthIndicator(),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _confirmPasswordController,
              labelText: 'Confirm Password',
              hintText: 'Re-enter password',
              prefixIcon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: AppConstants.textSecondaryColor,
                ),
                onPressed: _toggleConfirmPasswordVisibility,
              ),
              obscureText: !_isConfirmPasswordVisible,
              enabled: !_isLoading,
              validator: _validateConfirmPassword,
            ),
          ],
        const SizedBox(height: 20),
        _buildTermsCheckbox(),
      ],
    );
  }

  Widget _buildOtpSection() {
    return Column(
      key: const ValueKey('otp_section'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          controller: _otpController,
          labelText: 'Enter OTP',
          hintText: 'Enter 6-digit code',
          prefixIcon: Icons.security,
          keyboardType: TextInputType.number,
          maxLength: 6,
          enabled: !_isLoading,
          validator: _validateOtp,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    Color getStrengthColor() {
      if (_passwordStrength < 0.3) return AppConstants.errorColor;
      if (_passwordStrength < 0.7) return AppConstants.warningColor;
      return AppConstants.successColor;
    }

    String getStrengthText() {
      if (_passwordStrength < 0.3) return 'Weak';
      if (_passwordStrength < 0.7) return 'Medium';
      return 'Strong';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppConstants.textSecondaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  widthFactor: _passwordStrength,
                  child: Container(
                    decoration: BoxDecoration(
                      color: getStrengthColor(),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              getStrengthText(),
              style: TextStyle(
                fontSize: 12,
                color: getStrengthColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Use 8+ chars with uppercase, numbers, symbols',
          style: TextStyle(
            fontSize: 11,
            color: AppConstants.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _agreedToTerms,
          onChanged: _isLoading
              ? null
              : (value) {
                  setState(() {
                    _agreedToTerms = value ?? false;
                  });
                },
          activeColor: AppConstants.primaryColor,
        ),
        Expanded(
          child: GestureDetector(
            onTap: _isLoading
                ? null
                : () {
                    setState(() {
                      _agreedToTerms = !_agreedToTerms;
                    });
                  },
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: AppConstants.textSecondaryColor),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchModeButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: _isLoading ? null : (_isOtpMode ? _switchToPasswordMode : _switchToOtpMode),
        icon: Icon(
          _isOtpMode ? Icons.lock : Icons.sms,
          size: 16,
          color: AppConstants.primaryColor,
        ),
        label: Text(
          _isOtpMode ? 'Use Password' : 'Use OTP Instead',
          style: const TextStyle(color: AppConstants.primaryColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.errorColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 18, color: AppConstants.errorColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: AppConstants.errorColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return CustomButton(
      onPressed: _isLoading ? null : _getRegisterButtonAction(),
      text: _getRegisterButtonText(),
      isLoading: _isLoading,
      icon: _getRegisterButtonIcon(),
    );
  }

  Widget _buildAdditionalOptions() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppConstants.secondaryColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppConstants.primaryColor.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: TextStyle(color: AppConstants.textSecondaryColor, fontSize: 14),
              ),
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.pop(context);
                      },
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // === VALIDATIONS ===
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return AppConstants.requiredField;
    if (value.length < 2) return 'Name too short';
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) return 'Letters and spaces only';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return AppConstants.requiredField;
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return AppConstants.invalidEmail;
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return AppConstants.requiredField;
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) return 'Enter valid 10-digit number';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return AppConstants.requiredField;
    if (value.length < 6) return 'At least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return AppConstants.requiredField;
    if (value != _passwordController.text) return AppConstants.passwordMismatch;
    return null;
  }

  String? _validateOtp(String? value) {
    if (value == null || value.isEmpty) return AppConstants.requiredField;
    if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) return 'Enter valid 6-digit OTP';
    return null;
  }

  // === BUTTON HELPERS ===
  VoidCallback? _getRegisterButtonAction() => _isOtpMode ? _handleOtpRegistration : _handleRegister;
  String _getRegisterButtonText() {
    if (_isLoading) return 'Please wait...';
    return _isOtpMode ? (_otpSent ? 'Verify & Register' : 'Send OTP') : 'Create Account';
  }

  IconData _getRegisterButtonIcon() {
    if (_isOtpMode) return _otpSent ? Icons.verified : Icons.sms;
    return Icons.person_add;
  }
}
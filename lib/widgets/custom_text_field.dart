import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool enabled;
  final int? maxLength;
  final int? maxLines;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onTap,
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
    this.readOnly = false,
    this.inputFormatters,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      enabled: enabled,
      maxLength: maxLength,
      maxLines: maxLines,
      readOnly: readOnly,
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
        counterText: '', // Hide character counter
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.padding,
          vertical: AppConstants.smallPadding,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(
            color: AppConstants.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: AppConstants.errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(
            color: AppConstants.errorColor,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        filled: true,
        fillColor: enabled
            ? AppConstants.secondaryColor
            : Colors.grey.withOpacity(0.1),
        labelStyle: TextStyle(
          color: enabled
              ? AppConstants.textPrimaryColor
              : AppConstants.textSecondaryColor,
        ),
        hintStyle: TextStyle(color: AppConstants.textSecondaryColor),
        errorStyle: const TextStyle(
          color: AppConstants.errorColor,
          fontSize: 12,
        ),
      ),
      style: TextStyle(
        color: enabled
            ? AppConstants.textPrimaryColor
            : AppConstants.textSecondaryColor,
        fontSize: 16,
      ),
    );
  }
}

// Specialized text field for phone numbers
class PhoneTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const PhoneTextField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: 'Phone Number',
      hintText: 'Enter your phone number',
      prefixIcon: Icons.phone,
      keyboardType: TextInputType.phone,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return AppConstants.requiredField;
            }
            if (value.length < 10) {
              return AppConstants.invalidPhone;
            }
            return null;
          },
      onChanged: onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }
}

// Specialized text field for email
class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const EmailTextField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: 'Email',
      hintText: 'Enter your email address',
      prefixIcon: Icons.email,
      keyboardType: TextInputType.emailAddress,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return AppConstants.requiredField;
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return AppConstants.invalidEmail;
            }
            return null;
          },
      onChanged: onChanged,
    );
  }
}

// Specialized text field for password
class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final String? labelText;
  final String? hintText;

  const PasswordTextField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
    this.labelText,
    this.hintText,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      labelText: widget.labelText ?? 'Password',
      hintText: widget.hintText ?? 'Enter your password',
      prefixIcon: Icons.lock,
      obscureText: !_isPasswordVisible,
      validator:
          widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return AppConstants.requiredField;
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
      onChanged: widget.onChanged,
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: AppConstants.textSecondaryColor,
        ),
        onPressed: _togglePasswordVisibility,
      ),
    );
  }
}

// Specialized text field for OTP
class OtpTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const OtpTextField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: 'OTP',
      hintText: 'Enter 6-digit OTP',
      prefixIcon: Icons.security,
      keyboardType: TextInputType.number,
      maxLength: 6,
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return AppConstants.requiredField;
            }
            if (value.length != 6) {
              return AppConstants.invalidOtp;
            }
            return null;
          },
      onChanged: onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
      ],
    );
  }
}

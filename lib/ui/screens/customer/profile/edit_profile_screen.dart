// lib/ui/screens/customer/profile/edit_profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../constants/app_constants.dart';
import '../../../../services/user_service.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedImagePath;
  bool _isLoading = false;
  UserModel? _user;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    await _userService.loadUser();
    final user = _userService.getCurrentUser();
    if (mounted && user != null) {
      setState(() {
        _user = user;
        _nameController.text = user.name;
        _emailController.text = user.email;
        _phoneController.text = user.phone;
        _addressController.text = user.address ?? '';
        _selectedImagePath = user.profileImage;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate() || _user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedUser = _user!.copyWith(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        profileImage: _selectedImagePath,
        updatedAt: DateTime.now(),
      );

      await _userService.updateUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: AppConstants.successColor,
          ),
        );
        Navigator.pop(context, true); // Return success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update: $e'),
            backgroundColor: AppConstants.errorColor,
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildProfileImageSection(),
                    const SizedBox(height: 32),
                    CustomTextField(
                      controller: _nameController,
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                      prefixIcon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Name is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Email is required';
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _phoneController,
                      labelText: 'Phone',
                      hintText: 'Enter your phone',
                      prefixIcon: Icons.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Phone is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _addressController,
                      labelText: 'Address',
                      hintText: 'Enter your address',
                      prefixIcon: Icons.location_on,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Address is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      onPressed: _isLoading ? null : _saveProfile,
                      text: _isLoading ? 'Saving...' : 'Save Changes',
                      icon: Icons.save,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
                  backgroundImage: _selectedImagePath != null
                      ? FileImage(File(_selectedImagePath!))
                      : null,
                  child: _selectedImagePath == null
                      ? Icon(
                          Icons.person,
                          size: 60,
                          color: AppConstants.primaryColor,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppConstants.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tap to change photo',
            style: TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
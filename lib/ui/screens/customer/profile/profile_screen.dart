// File: lib/ui/screens/customer/profile/profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:redcap/ui/screens/customer/profile/edit_profile_screen.dart';
import 'package:redcap/ui/screens/customer/profile/dashboard_screen.dart';
import 'package:redcap/ui/screens/customer/profile/about_screen.dart';
import 'package:redcap/ui/screens/customer/profile/notification_screen.dart';
import 'package:redcap/ui/screens/customer/profile/privacy_screen.dart';
import 'package:redcap/ui/screens/customer/profile/saved_addresses_screen.dart';

import 'package:redcap/services/user_service.dart';
import 'package:redcap/models/user_model.dart';
import 'package:redcap/constants/app_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    await _userService.loadUser();
    final user = _userService.getCurrentUser();
    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),

            // General Section
            _buildSection('General', [
              _buildOption(Icons.edit, 'Edit Profile', () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                );
                if (result == true && mounted) {
                  _loadUser(); // Refresh after edit
                }
              }),
              _buildOption(Icons.location_on, 'Saved Addresses', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SavedAddressesScreen()),
                );
              }),
              _buildOption(Icons.notifications, 'Notifications', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationScreen()),
                );
              }),
              _buildOption(Icons.privacy_tip, 'Privacy Policy', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyScreen()),
                );
              }),
            ]),

            const SizedBox(height: 24),

            // App Info Section
            _buildSection('App Information', [
              _buildOption(Icons.dashboard, 'Dashboard', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                );
              }),
              _buildOption(Icons.info, 'About', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              }),
            ]),

            const SizedBox(height: 24),

            // Logout Button
            ElevatedButton.icon(
              onPressed: () async {
                await _userService.logout();
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text('Logout', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.padding * 1.5),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: _user?.profileImage != null
                  ? FileImage(File(_user!.profileImage!))
                  : null,
              child: _user?.profileImage == null
                  ? Text(
                      _user!.name.isNotEmpty ? _user!.name[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _user!.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _user!.email,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                  Text(
                    _user!.phone,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.primaryColor),
      title: Text(
        title,
        style: const TextStyle(
          color: AppConstants.textPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppConstants.textSecondaryColor,
      ),
      onTap: onTap,
    );
  }
}
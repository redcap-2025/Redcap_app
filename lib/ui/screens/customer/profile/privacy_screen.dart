import 'package:flutter/material.dart';
import '../../../../constants/app_constants.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last updated: October 26, 2023',
              style: TextStyle(
                fontSize: 14,
                color: AppConstants.textSecondaryColor,
              ),
            ),
            SizedBox(height: 24),
            Text(
              '1. Introduction',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'RedCap ("we," "us," or "our") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application (the "App").',
              style: TextStyle(
                fontSize: 16,
                color: AppConstants.textPrimaryColor,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '2. Information We Collect',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.textPrimaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We may collect information about you in a variety of ways. The information we may collect via the App includes:',
              style: TextStyle(
                fontSize: 16,
                color: AppConstants.textPrimaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Personal Data: Personally identifiable information, such as your name, shipping address, email address, and telephone number, that you voluntarily give to us when you register with the App or choose to participate in various activities related to the App.',
              style: TextStyle(
                fontSize: 16,
                color: AppConstants.textPrimaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '• Derivative Data: Information our servers automatically collect when you access the App, such as your IP address, your browser type, your operating system, your access times, and the pages you have viewed directly before and after accessing the App.',
              style: TextStyle(
                fontSize: 16,
                color: AppConstants.textPrimaryColor,
              ),
            ),
            // Add more sections as needed
          ],
        ),
      ),
    );
  }
}

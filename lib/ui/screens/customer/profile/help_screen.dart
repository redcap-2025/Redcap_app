import 'package:flutter/material.dart';
import '../../../../constants/app_constants.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FAQ Section
            _buildSectionHeader('Frequently Asked Questions'),
            const SizedBox(height: 16),
            _buildFAQItem(
              'How do I book a truck?',
              'You can book a truck directly from the home screen. Select the type of truck you need and follow the on-screen instructions.',
            ),
            _buildFAQItem(
              'How can I track my booking?',
              'All your active and past bookings can be viewed in the "Bookings" tab. You can track your truck\'s location in real-time from there.',
            ),
            _buildFAQItem(
              'What payment methods are supported?',
              'We support various payment methods, including credit/debit cards, net banking, and popular digital wallets.',
            ),
            const SizedBox(height: 24),

            // Contact Support Section
            _buildSectionHeader('Contact Support'),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildContactOption(
                    icon: Icons.email,
                    title: 'Email Us',
                    subtitle: 'support@redcap.com',
                    onTap: () {
                      // TODO: Implement email launch
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildContactOption(
                    icon: Icons.phone,
                    title: 'Call Us',
                    subtitle: '+91 98765 43210',
                    onTap: () {
                      // TODO: Implement phone call launch
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildContactOption(
                    icon: Icons.chat,
                    title: 'Live Chat',
                    subtitle: 'Chat with a support agent',
                    onTap: () {
                      // TODO: Implement live chat functionality
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppConstants.textPrimaryColor,
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Q: $question',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'A: $answer',
            style: const TextStyle(
              fontSize: 16,
              color: AppConstants.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppConstants.primaryColor),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppConstants.textPrimaryColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppConstants.textSecondaryColor,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppConstants.textSecondaryColor),
      onTap: onTap,
    );
  }
}

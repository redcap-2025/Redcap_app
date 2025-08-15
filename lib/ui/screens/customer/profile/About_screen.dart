import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../constants/app_constants.dart';
import '../../../../widgets/custom_button.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'About RedCap',
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo and Version
            _buildAppHeader(),
            const SizedBox(height: 32),

            // Company Description
            _buildDescriptionCard(),
            const SizedBox(height: 24),

            // Core Services
            _buildServicesCard(),
            const SizedBox(height: 24),

            // App Information
            _buildAppInfoCard(),
            const SizedBox(height: 24),

            // Contact Information
            _buildContactCard(),
            const SizedBox(height: 24),

            // Social Media Links
            _buildSocialMediaCard(),
            const SizedBox(height: 32),

            // Action Buttons
            _buildActionButtons(context),
            const SizedBox(height: 24),

            // Copyright
            _buildCopyright(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppConstants.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // App Logo
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                AppConstants.appLogo,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.local_shipping,
                  size: 50,
                  color: AppConstants.primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // App Name and Tagline
          const Text(
            AppConstants.appName,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            AppConstants.companyTagline,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          
          // Version Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Version ${AppConstants.appVersion}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return _buildInfoCard(
      title: 'About RedCap',
      icon: Icons.info_outline,
      child: Text(
        AppConstants.companyDescription,
        style: TextStyle(
          fontSize: 16,
          color: AppConstants.textPrimaryColor,
          height: 1.6,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildServicesCard() {
    return _buildInfoCard(
      title: 'Our Services',
      icon: Icons.local_shipping,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: AppConstants.coreServices.map((service) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 8, right: 12),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  service,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppConstants.textPrimaryColor,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildAppInfoCard() {
    return _buildInfoCard(
      title: 'App Information',
      icon: Icons.mobile_friendly,
      child: Column(
        children: [
          _buildInfoRow('Version', AppConstants.appVersion),
          _buildInfoRow('Build Number', '${AppConstants.buildNumber}'),
          _buildInfoRow('Package', AppConstants.packageName),
          _buildInfoRow('Platform', 'Android & iOS'),
          _buildInfoRow('Last Updated', 'August 2024'),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return _buildInfoCard(
      title: 'Contact Information',
      icon: Icons.contact_support,
      child: Column(
        children: [
          _buildContactRow(
            icon: Icons.phone,
            title: 'Phone (Primary)',
            subtitle: '+91-${AppConstants.supportPhonePrimary}',
            onTap: () => _makePhoneCall('+91${AppConstants.supportPhonePrimary}'),
          ),
          _buildContactRow(
            icon: Icons.phone_android,
            title: 'Phone (Secondary)',
            subtitle: '+91-${AppConstants.supportPhoneSecondary}',
            onTap: () => _makePhoneCall('+91${AppConstants.supportPhoneSecondary}'),
          ),
          _buildContactRow(
            icon: Icons.email,
            title: 'Email Support',
            subtitle: AppConstants.supportEmail,
            onTap: () => _sendEmail(AppConstants.supportEmail),
          ),
          _buildContactRow(
            icon: Icons.message,
            title: 'WhatsApp',
            subtitle: '+91-${AppConstants.supportWhatsapp}',
            onTap: () => _openWhatsApp(AppConstants.supportWhatsapp),
          ),
          _buildContactRow(
            icon: Icons.schedule,
            title: 'Business Hours',
            subtitle: AppConstants.businessHours,
            onTap: null,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaCard() {
    return _buildInfoCard(
      title: 'Follow Us',
      icon: Icons.share,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSocialButton(
            icon: Icons.language,
            label: 'Website',
            onTap: () => _launchUrl(AppConstants.websiteUrl),
          ),
          _buildSocialButton(
            icon: Icons.facebook,
            label: 'Facebook',
            onTap: () => _launchUrl(AppConstants.facebookUrl),
          ),
          _buildSocialButton(
            icon: Icons.camera_alt,
            label: 'Instagram',
            onTap: () => _launchUrl(AppConstants.instagramUrl),
          ),
          _buildSocialButton(
            icon: Icons.business,
            label: 'LinkedIn',
            onTap: () => _launchUrl(AppConstants.linkedinUrl),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomButton(
                onPressed: () => _rateApp(),
                text: 'Rate App',
                icon: Icons.star,
                backgroundColor: AppConstants.warningColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                onPressed: () => _shareApp(),
                text: 'Share App',
                icon: Icons.share,
                backgroundColor: AppConstants.accentColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            onPressed: () => _sendFeedback(),
            text: 'Send Feedback',
            icon: Icons.feedback,
            backgroundColor: AppConstants.successColor,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.secondaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppConstants.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          // Card Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppConstants.textSecondaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  color: AppConstants.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppConstants.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null) 
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppConstants.textSecondaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: AppConstants.primaryColor.withOpacity(0.3),
              ),
            ),
            child: Icon(
              icon,
              color: AppConstants.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppConstants.textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyright() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '© 2024 ${AppConstants.companyName}. All rights reserved.',
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Made with ❤️ in India',
            style: TextStyle(
              fontSize: 12,
              color: AppConstants.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Action Methods
  Future<void> _makePhoneCall(String phoneNumber) async {
    final url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _sendEmail(String email) async {
    final url = Uri.parse('mailto:$email?subject=RedCap App Inquiry');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _openWhatsApp(String phone) async {
    final url = Uri.parse('https://wa.me/91$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _rateApp() {
    // TODO: Navigate to app store for rating
    _launchUrl(AppConstants.playStoreUrl);
  }

  void _shareApp() {
    // TODO: Implement share functionality
    Clipboard.setData(ClipboardData(
      text: 'Check out RedCap - On-demand truck booking app! Download from: ${AppConstants.playStoreUrl}',
    ));
  }

  void _sendFeedback() {
    _sendEmail(AppConstants.supportEmail);
  }
}

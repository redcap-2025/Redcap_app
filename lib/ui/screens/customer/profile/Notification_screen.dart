import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../constants/app_constants.dart';
import '../../../../widgets/custom_button.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Notification Settings State
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = true;
  bool _bookingUpdates = true;
  bool _paymentAlerts = true;
  bool _promotionalOffers = false;
  bool _driverUpdates = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _quietHoursStart = '22:00';
  String _quietHoursEnd = '07:00';
  bool _quietHoursEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Notification Settings',
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
            // Header Info
            _buildHeaderInfo(),
            const SizedBox(height: 24),

            // General Notification Settings
            _buildSectionCard(
              title: 'General Settings',
              icon: Icons.notifications,
              children: [
                _buildSwitchTile(
                  title: 'Push Notifications',
                  subtitle: 'Receive notifications on your device',
                  value: _pushNotifications,
                  onChanged: (value) => setState(() => _pushNotifications = value),
                ),
                _buildSwitchTile(
                  title: 'Email Notifications',
                  subtitle: 'Receive notifications via email',
                  value: _emailNotifications,
                  onChanged: (value) => setState(() => _emailNotifications = value),
                ),
                _buildSwitchTile(
                  title: 'SMS Notifications',
                  subtitle: 'Receive important updates via SMS',
                  value: _smsNotifications,
                  onChanged: (value) => setState(() => _smsNotifications = value),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Booking Notifications
            _buildSectionCard(
              title: 'Booking Notifications',
              icon: Icons.local_shipping,
              children: [
                _buildSwitchTile(
                  title: 'Booking Updates',
                  subtitle: 'Status changes, confirmations, and cancellations',
                  value: _bookingUpdates,
                  onChanged: (value) => setState(() => _bookingUpdates = value),
                ),
                _buildSwitchTile(
                  title: 'Driver Updates',
                  subtitle: 'Driver assignment and location updates',
                  value: _driverUpdates,
                  onChanged: (value) => setState(() => _driverUpdates = value),
                ),
                _buildSwitchTile(
                  title: 'Payment Alerts',
                  subtitle: 'Payment confirmations and receipts',
                  value: _paymentAlerts,
                  onChanged: (value) => setState(() => _paymentAlerts = value),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Marketing Notifications
            _buildSectionCard(
              title: 'Marketing & Offers',
              icon: Icons.local_offer,
              children: [
                _buildSwitchTile(
                  title: 'Promotional Offers',
                  subtitle: 'Discounts, coupons, and special deals',
                  value: _promotionalOffers,
                  onChanged: (value) => setState(() => _promotionalOffers = value),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Sound & Vibration Settings
            _buildSectionCard(
              title: 'Sound & Vibration',
              icon: Icons.volume_up,
              children: [
                _buildSwitchTile(
                  title: 'Sound',
                  subtitle: 'Play notification sounds',
                  value: _soundEnabled,
                  onChanged: (value) {
                    setState(() => _soundEnabled = value);
                    if (value) HapticFeedback.lightImpact();
                  },
                ),
                _buildSwitchTile(
                  title: 'Vibration',
                  subtitle: 'Vibrate on notifications',
                  value: _vibrationEnabled,
                  onChanged: (value) {
                    setState(() => _vibrationEnabled = value);
                    if (value) HapticFeedback.mediumImpact();
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Quiet Hours
            _buildSectionCard(
              title: 'Quiet Hours',
              icon: Icons.bedtime,
              children: [
                _buildSwitchTile(
                  title: 'Enable Quiet Hours',
                  subtitle: 'Reduce notifications during specified hours',
                  value: _quietHoursEnabled,
                  onChanged: (value) => setState(() => _quietHoursEnabled = value),
                ),
                if (_quietHoursEnabled) ...[
                  const SizedBox(height: 16),
                  _buildTimeSelector(
                    title: 'Start Time',
                    time: _quietHoursStart,
                    onTimeChanged: (time) => setState(() => _quietHoursStart = time),
                  ),
                  const SizedBox(height: 8),
                  _buildTimeSelector(
                    title: 'End Time',
                    time: _quietHoursEnd,
                    onTimeChanged: (time) => setState(() => _quietHoursEnd = time),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: _resetToDefaults,
                    text: 'Reset to Defaults',
                    backgroundColor: AppConstants.textSecondaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    onPressed: _saveSettings,
                    text: 'Save Settings',
                    icon: Icons.save,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryColor.withOpacity(0.1),
            AppConstants.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_active,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stay Updated',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Customize how you receive notifications from RedCap. You can change these settings anytime.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConstants.textSecondaryColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
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
          // Section Header
          Container(
            padding: const EdgeInsets.all(16),
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
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          // Section Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppConstants.textSecondaryColor,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppConstants.primaryColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector({
    required String title,
    required String time,
    required ValueChanged<String> onTimeChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppConstants.textPrimaryColor,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _selectTime(context, time, onTimeChanged),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppConstants.primaryColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppConstants.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectTime(
    BuildContext context,
    String currentTime,
    ValueChanged<String> onTimeChanged,
  ) async {
    final parts = currentTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (selectedTime != null) {
      final formattedTime = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      onTimeChanged(formattedTime);
    }
  }

  void _resetToDefaults() {
    setState(() {
      _pushNotifications = true;
      _emailNotifications = false;
      _smsNotifications = true;
      _bookingUpdates = true;
      _paymentAlerts = true;
      _promotionalOffers = false;
      _driverUpdates = true;
      _soundEnabled = true;
      _vibrationEnabled = true;
      _quietHoursEnabled = false;
      _quietHoursStart = '22:00';
      _quietHoursEnd = '07:00';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.refresh, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Settings reset to defaults'),
          ],
        ),
        backgroundColor: AppConstants.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _saveSettings() {
    // TODO: Implement save settings to backend/storage
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Notification settings saved successfully!'),
          ],
        ),
        backgroundColor: AppConstants.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    HapticFeedback.lightImpact();
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // <-- Added this import
import 'package:url_launcher/url_launcher.dart';
import '../../../../constants/app_constants.dart';
import '../../../../widgets/custom_text_field.dart';

class SupportTab extends StatefulWidget {
  const SupportTab({super.key});

  @override
  State<SupportTab> createState() => _SupportTabState();
}

class _SupportTabState extends State<SupportTab> with TickerProviderStateMixin {
  late TabController _tabController;
  final _messageController = TextEditingController();
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I book a truck?',
      'answer': 'To book a truck, simply select your preferred vehicle type from the home screen, choose your pickup and drop locations, and proceed with payment. Our system will automatically assign the nearest available truck to you.',
    },
    {
      'question': 'What payment methods are accepted?',
      'answer': 'We accept multiple payment methods including Cash on Delivery (COD), UPI payments, credit/debit cards, and net banking. All online payments are secure and encrypted.',
    },
    {
      'question': 'Can I track my booking in real-time?',
      'answer': 'Yes! Once your booking is confirmed and a driver is assigned, you can track your vehicle in real-time using our live tracking feature. You\'ll also receive regular updates on your booking status.',
    },
    {
      'question': 'What if I need to cancel my booking?',
      'answer': 'You can cancel your booking from the bookings tab. Cancellation policies vary based on the time remaining before pickup. Please check our cancellation policy for more details.',
    },
    {
      'question': 'How is the fare calculated?',
      'answer': 'Fare is calculated based on distance, vehicle type, and current demand. The base rate varies by vehicle type, and additional charges may apply for waiting time or special handling requirements.',
    },
    {
      'question': 'What types of goods can I transport?',
      'answer': 'We transport various types of goods including electronics, furniture, construction materials, textiles, machinery, and general goods. Some restrictions apply to hazardous materials.',
    },
    {
      'question': 'How do I contact customer support?',
      'answer': 'You can reach our customer support team through the in-app chat, phone call, WhatsApp, or email. Our support team is available 24/7 to assist you.',
    },
    {
      'question': 'What if there\'s damage to my goods?',
      'answer': 'We provide insurance coverage for all shipments. In case of damage, please report it immediately through the app or contact our support team. We\'ll investigate and process your claim.',
    },
  ];

  final List<Map<String, dynamic>> _chatMessages = [
    {
      'id': '1',
      'message': 'Hello! Welcome to RedCap support. How can I help you today?',
      'isFromUser': false,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
    },
  ];

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();
    setState(() {
      _chatMessages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'message': message,
        'isFromUser': true,
        'timestamp': DateTime.now(),
      });
      _isTyping = true;
    });

    _messageController.clear();

    // Simulate support response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _chatMessages.add({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'message': 'Thank you for your message. Our support team will get back to you shortly. Is there anything else I can help you with?',
            'isFromUser': false,
            'timestamp': DateTime.now(),
          });
        });
      }
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      // In a real app, this should be a custom dialog, not a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch phone dialer'),
          backgroundColor: AppConstants.errorColor,
        ),
      );
    }
  }

Future<void> _sendWhatsApp(String phoneNumber, {String message = ''}) async {
  // Ensure phone number is in international format without '+'
  final Uri whatsappUri = Uri.parse(
    'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}'
  );

  if (await canLaunchUrl(whatsappUri)) {
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not launch WhatsApp'),
        backgroundColor: AppConstants.errorColor,
      ),
    );
  }
}


  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=RedCap Support Request',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // In a real app, this should be a custom dialog, not a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch email client'),
          backgroundColor: AppConstants.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              color: AppConstants.primaryColor,
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppConstants.secondaryColor,
                labelColor: AppConstants.secondaryColor,
                unselectedLabelColor: AppConstants.secondaryColor.withOpacity(
                  0.7,
                ),
                tabs: const [
                  Tab(text: 'FAQ'),
                  Tab(text: 'Live Chat'),
                  Tab(text: 'Contact'),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildFAQTab(), _buildChatTab(), _buildContactTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.padding),
      itemCount: _faqs.length,
      itemBuilder: (context, index) {
        final faq = _faqs[index];
        return _buildFAQCard(faq);
      },
    );
  }

  Widget _buildFAQCard(Map<String, dynamic> faq) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: AppConstants.padding),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: AppConstants.padding, vertical: 8),
        title: Text(
          faq['question'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimaryColor,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding, vertical: 8),
            child: Text(
              faq['answer'],
              style: const TextStyle(
                fontSize: 14,
                color: AppConstants.textSecondaryColor,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        // Chat Messages
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConstants.padding),
            itemCount: _chatMessages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _chatMessages.length && _isTyping) {
                return _buildTypingIndicator();
              }
              final message = _chatMessages[index];
              return _buildChatMessage(message);
            },
          ),
        ),

        // Message Input
        Container(
          padding: const EdgeInsets.all(AppConstants.padding),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: _messageController,
                  hintText: 'Type your message...',
                  maxLines: 1,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatMessage(Map<String, dynamic> message) {
    final isFromUser = message['isFromUser'] as bool;
    final timestamp = message['timestamp'] as DateTime;
    final timeString = DateFormat('h:mm a').format(timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isFromUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.support_agent,
                color: AppConstants.primaryColor,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isFromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isFromUser ? AppConstants.primaryColor : AppConstants.secondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isFromUser ? const Radius.circular(16) : const Radius.circular(4),
                      bottomRight: isFromUser ? const Radius.circular(4) : const Radius.circular(16),
                    ),
                    border: !isFromUser
                        ? Border.all(
                            color: AppConstants.primaryColor.withOpacity(0.2),
                          )
                        : null,
                  ),
                  child: Text(
                    message['message'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isFromUser ? AppConstants.secondaryColor : AppConstants.textPrimaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeString,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppConstants.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          if (isFromUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.person,
                color: AppConstants.primaryColor,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
            child: Icon(
              Icons.support_agent,
              color: AppConstants.primaryColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppConstants.secondaryColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppConstants.primaryColor.withOpacity(0.2),
              ),
            ),
            child: const Text(
              'Typing...',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: AppConstants.textSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.padding),
      children: [
        // Contact Info Card
        Container(
          padding: const EdgeInsets.all(AppConstants.padding),
          decoration: BoxDecoration(
            color: AppConstants.secondaryColor,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(
              color: AppConstants.primaryColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              const Text(
                'Get in Touch',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Our support team is available 24/7 to help you with any questions or concerns.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Contact Options
        _buildContactOption(
          icon: Icons.phone,
          title: 'Call Us',
          subtitle: '987-654-3210',
          onTap: () => _makePhoneCall('918098835739'),
        ),
        _buildContactOption(
          icon: Icons.chat,
          title: 'WhatsApp',
          subtitle: 'Chat with us on WhatsApp',
          onTap: () => _sendWhatsApp('918098835739'),
        ),
        _buildContactOption(
          icon: Icons.email,
          title: 'Email',
          subtitle: 'support@redcap.com',
          onTap: () => _sendEmail('redcaptrack@gmail.com'),
        ),
        const SizedBox(height: 24),

        // Support Hours
        Container(
          padding: const EdgeInsets.all(AppConstants.padding),
          decoration: BoxDecoration(
            color: AppConstants.secondaryColor,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(
              color: AppConstants.primaryColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Support Hours',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 12),
              _buildSupportHour('Monday - Friday', '9:00 AM - 8:00 PM'),
              _buildSupportHour('Saturday', '9:00 AM - 6:00 PM'),
              _buildSupportHour('Sunday', '10:00 AM - 4:00 PM'),
              const SizedBox(height: 8),
              const Text(
                'Emergency support available 24/7',
                style: TextStyle(
                  fontSize: 12,
                  color: AppConstants.successColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppConstants.secondaryColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppConstants.primaryColor.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppConstants.primaryColor, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimaryColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: AppConstants.textSecondaryColor,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppConstants.textSecondaryColor,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSupportHour(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 14,
              color: AppConstants.textPrimaryColor,
            ),
          ),
          Text(
            hours,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppConstants.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// File: create_booking_screen.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For launching WhatsApp

import '../../../../constants/app_constants.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_text_field.dart';

class CreateBookingScreen extends StatefulWidget {
  const CreateBookingScreen({super.key});

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pickupController = TextEditingController();
  final _dropoffController = TextEditingController();
  final _goodsDescriptionController = TextEditingController();

  // ✅ Admin phone number in correct international format (without spaces)
  static const String _adminPhoneNumber = '919629333135'; // Replace with actual number

  String? _selectedTruckType;
  bool _isLoading = false;

  @override
  void dispose() {
    _pickupController.dispose();
    _dropoffController.dispose();
    _goodsDescriptionController.dispose();
    super.dispose();
  }

  // ✅ Launch WhatsApp with pre-filled message
  Future<void> _launchWhatsApp(String message) async {
    // ✅ Fixed: Removed extra spaces in URL
    final Uri url = Uri.parse('https://wa.me/$_adminPhoneNumber?text=${Uri.encodeComponent(message)}');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication); // Opens directly in WhatsApp
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open WhatsApp. Please check if it is installed.'),
              backgroundColor: AppConstants.errorColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    }
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // ✅ Construct clean booking message
      final message = '''
📦 *New Booking Request* 📦
───────────────────
📍 *Pickup*: ${_pickupController.text}
📍 *Drop-off*: ${_dropoffController.text}
🚚 *Truck Type*: ${_selectedTruckType ?? 'Not specified'}
📦 *Goods*: ${_goodsDescriptionController.text}
───────────────────
Thank you!
      ''';

      // Launch WhatsApp
      _launchWhatsApp(message);

      // Simulate network delay
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking request sent via WhatsApp!'),
            backgroundColor: AppConstants.successColor,
          ),
        );

        // Pop back after submission
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Create New Booking',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 16),

              // Pickup Location
              CustomTextField(
                controller: _pickupController,
                labelText: 'Pickup Location',
                hintText: 'Enter pickup address',
                prefixIcon: Icons.location_on,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a pickup location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Drop-off Location
              CustomTextField(
                controller: _dropoffController,
                labelText: 'Drop-off Location',
                hintText: 'Enter drop-off address',
                prefixIcon: Icons.location_on,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a drop-off location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Goods Description
              CustomTextField(
                controller: _goodsDescriptionController,
                labelText: 'Goods Description',
                hintText: 'e.g., Furniture, electronics, boxes',
                prefixIcon: Icons.inventory,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe the goods';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Truck Type Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedTruckType,
                decoration: const InputDecoration(
                  labelText: 'Truck Type',
                  prefixIcon: Icon(Icons.local_shipping),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                hint: const Text('Select a truck type'),
                items: const ['Mini Truck', 'Pickup Truck', 'Large Truck']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTruckType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a truck type';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              // Submit Button
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppConstants.primaryColor),
                    )
                  : CustomButton(
                      onPressed: _submitBooking,
                      text: 'Send Booking Request',
                      icon: Icons.send,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
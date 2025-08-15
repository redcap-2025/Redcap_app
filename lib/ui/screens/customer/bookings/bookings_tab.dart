import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../constants/app_constants.dart';
import '../../../../models/booking_model.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/booking_card.dart';

class BookingsTab extends StatefulWidget {
  const BookingsTab({super.key});

  @override
  State<BookingsTab> createState() => _BookingsTabState();
}

class _BookingsTabState extends State<BookingsTab>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<BookingModel> _bookings = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));
      final now = DateTime.now();

      final List<Map<String, dynamic>> mockBookings = [
        {
          'id': 'booking_001',
          'user_id': 'user_123',
          'truck_id': 'truck_A',
          'truck_type': 'Mini Truck',
          'pickup_location': '123 Main St, Bangalore',
          'drop_location': '456 Tech Park, Bangalore',
          'pickup_latitude': 12.9716,
          'pickup_longitude': 77.5946,
          'drop_latitude': 12.9818,
          'drop_longitude': 77.5936,
          'distance': 5.5,
          'fare': 250.0,
          'goods_type': 'Furniture',
          'weight': 100.0,
          'status': AppConstants.statusPending,
          'pickup_time': now.add(const Duration(hours: 2)).toIso8601String(),
          'created_at':
              now.subtract(const Duration(minutes: 30)).toIso8601String(),
          'updated_at':
              now.subtract(const Duration(minutes: 30)).toIso8601String(),
        },
        {
          'id': 'booking_002',
          'user_id': 'user_123',
          'truck_id': 'truck_B',
          'truck_type': 'Tata Ace',
          'pickup_location': '789 City Centre, Bangalore',
          'drop_location': '101 Whitefield, Bangalore',
          'pickup_latitude': 12.9876,
          'pickup_longitude': 77.6543,
          'drop_latitude': 12.9641,
          'drop_longitude': 77.5750,
          'distance': 15.0,
          'fare': 750.0,
          'goods_type': 'Electronics',
          'weight': 250.0,
          'status': AppConstants.statusConfirmed,
          'driver_id': 'driver_987',
          'driver_name': 'Ramesh Kumar',
          'driver_phone': '9876543210',
          'pickup_time': now.add(const Duration(days: 1)).toIso8601String(),
          'created_at':
              now.subtract(const Duration(hours: 5)).toIso8601String(),
          'updated_at':
              now.subtract(const Duration(hours: 5)).toIso8601String(),
        },
        {
          'id': 'booking_003',
          'user_id': 'user_123',
          'truck_id': 'truck_C',
          'truck_type': '14 ft truck',
          'pickup_location': '567 Industrial Area, Bangalore',
          'drop_location': 'MG Road, Bangalore',
          'pickup_latitude': 13.0,
          'pickup_longitude': 77.56,
          'drop_latitude': 12.97,
          'drop_longitude': 77.6,
          'distance': 12.8,
          'fare': 600.0,
          'goods_type': 'Machinery',
          'weight': 1500.0,
          'status': AppConstants.statusInProgress,
          'driver_id': 'driver_654',
          'driver_name': 'Suresh Reddy',
          'driver_phone': '9988776655',
          'pickup_time':
              now.subtract(const Duration(minutes: 10)).toIso8601String(),
          'created_at':
              now.subtract(const Duration(hours: 1)).toIso8601String(),
          'updated_at':
              now.subtract(const Duration(minutes: 5)).toIso8601String(),
          'current_latitude': 12.98,
          'current_longitude': 77.58,
        },
        {
          'id': 'booking_004',
          'user_id': 'user_123',
          'truck_id': 'truck_D',
          'truck_type': 'Mini Truck',
          'pickup_location': 'Jayanagar, Bangalore',
          'drop_location': 'Koramangala, Bangalore',
          'pickup_latitude': 12.9293,
          'pickup_longitude': 77.5843,
          'drop_latitude': 12.9352,
          'drop_longitude': 77.6245,
          'distance': 7.2,
          'fare': 350.0,
          'goods_type': 'Packages',
          'weight': 50.0,
          'status': AppConstants.statusCompleted,
          'driver_id': 'driver_321',
          'driver_name': 'Anil Sharma',
          'driver_phone': '8877665544',
          'pickup_time': now
              .subtract(const Duration(days: 2, hours: 1))
              .toIso8601String(),
          'created_at': now
              .subtract(const Duration(days: 2, hours: 3))
              .toIso8601String(),
          'updated_at':
              now.subtract(const Duration(days: 2)).toIso8601String(),
        },
      ];

      final bookings =
          mockBookings.map((json) => BookingModel.fromJson(json)).toList();

      if (!mounted) return;
      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load bookings. Please try again.';
        _isLoading = false;
      });
      print('Error loading bookings: $e');
    }
  }

  // ✅ Updated WhatsApp launcher to fixed number
  Future<void> _launchWhatsApp(String message) async {
    const String phoneNumber = '918098835739'; // Fixed number
    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}'
    );

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp is not installed or cannot be opened.')),
      );
    }
  }

  void _showBookingOptions(BookingModel booking) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Options for Booking #${booking.id}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Confirm via WhatsApp',
                icon: Icons.check_circle_outline,
                onPressed: () {
                  final message =
                      'Hi, this is to confirm my booking with ID #${booking.id} for the pickup at ${booking.pickupTime}. Thank you!';
                  _launchWhatsApp(message);
                  Navigator.pop(context);
                },
                backgroundColor: AppConstants.successColor,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Cancel via WhatsApp',
                icon: Icons.cancel_outlined,
                onPressed: () {
                  final message =
                      'Hi, I need to cancel my booking with ID #${booking.id}. Please acknowledge. Thank you.';
                  _launchWhatsApp(message);
                  Navigator.pop(context);
                },
                backgroundColor: AppConstants.errorColor,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Close',
                onPressed: () => Navigator.pop(context),
                backgroundColor: AppConstants.textSecondaryColor,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppConstants.secondaryColor,
          labelColor: AppConstants.secondaryColor,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'In Progress'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingsList(
            _bookings.where((b) => b.isPending || b.isConfirmed).toList(),
          ),
          _buildBookingsList(
            _bookings.where((b) => b.isInProgress).toList(),
          ),
          _buildBookingsList(
            _bookings.where((b) => b.isCompleted || b.isCancelled).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<BookingModel> bookings) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppConstants.primaryColor),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: const TextStyle(color: AppConstants.errorColor),
        ),
      );
    }

    if (bookings.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.padding),
          child: Text(
            'You don\'t have any bookings in this category yet.',
            style: TextStyle(fontSize: 16, color: AppConstants.textSecondaryColor),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.padding),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: BookingCard(
            bookingId: booking.id,
            pickupLocation: booking.pickupLocation,
            dropoffLocation: booking.dropoffLocation,
            date: DateFormat('MMM d, yyyy').format(booking.pickupTime),
            time: DateFormat('h:mm a').format(booking.pickupTime),
            status: booking.status,
            fare: booking.fare,
            distance: booking.distance,
            truckType: booking.truckType,
            onTap: () => _showBookingOptions(booking),
          ),
        );
      },
    );
  }
}

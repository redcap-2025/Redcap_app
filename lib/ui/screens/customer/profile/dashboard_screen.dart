import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../constants/app_constants.dart';
import '../../../../models/booking_model.dart';
import '../../../../widgets/booking_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // State variables
  bool _isLoading = false;
  String? _error;
  int _totalBookings = 0;
  double _totalEarnings = 0.0;
  int _completedBookings = 0;
  int _inProgressBookings = 0;
  List<BookingModel> _recentBookings = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      final List<BookingModel> fetchedBookings = _getMockBookings();

      // Calculate stats
      final totalBookings = fetchedBookings.length;
      final completedBookings = fetchedBookings
          .where((b) => b.status == AppConstants.statusCompleted)
          .length;
      final inProgressBookings = fetchedBookings
          .where((b) => b.status == AppConstants.statusInProgress)
          .length;
      final totalEarnings = fetchedBookings
          .where((b) => b.status == AppConstants.statusCompleted)
          .map((b) => b.fare)
          .fold(0.0, (sum, fare) => sum + fare);

      final recentBookings = fetchedBookings.take(3).toList();

      if (mounted) {
        setState(() {
          _totalBookings = totalBookings;
          _completedBookings = completedBookings;
          _inProgressBookings = inProgressBookings;
          _totalEarnings = totalEarnings;
          _recentBookings = recentBookings;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load dashboard data. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<BookingModel> _getMockBookings() {
    return [
      BookingModel(
        id: 'booking_001',
        userId: 'user_001',
        truckId: 'truck_001',
        truckType: 'Mini Truck',
        pickupLocation: '123 Main St, Bangalore',
        dropoffLocation: '456 Tech Park, Bangalore',
        pickupLatitude: 12.9716,
        pickupLongitude: 77.5946,
        dropLatitude: 12.9279,
        dropLongitude: 77.6271,
        distance: 5.5,
        fare: 250.0,
        goodsType: 'Furniture',
        weight: 150.0,
        status: AppConstants.statusCompleted,
        pickupTime: DateTime.now().subtract(const Duration(days: 5)),
        createdAt: DateTime.now().subtract(const Duration(days: 5, hours: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5, minutes: 30)),
      ),
      BookingModel(
        id: 'booking_002',
        userId: 'user_001',
        truckId: 'truck_002',
        truckType: 'Pickup Truck',
        pickupLocation: '789 City Centre, Bangalore',
        dropoffLocation: '101 Whitefield, Bangalore',
        pickupLatitude: 12.9716,
        pickupLongitude: 77.5946,
        dropLatitude: 12.9698,
        dropLongitude: 77.7500,
        distance: 15.0,
        fare: 750.0,
        goodsType: 'Electronics',
        weight: 300.0,
        status: AppConstants.statusCompleted,
        pickupTime: DateTime.now().subtract(const Duration(days: 3)),
        createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3, minutes: 30)),
      ),
      BookingModel(
        id: 'booking_003',
        userId: 'user_001',
        truckId: 'truck_003',
        truckType: 'Large Truck',
        pickupLocation: '555 Industrial Area, Bangalore',
        dropoffLocation: '222 Hebbal, Bangalore',
        pickupLatitude: 12.9716,
        pickupLongitude: 77.5946,
        dropLatitude: 13.0371,
        dropLongitude: 77.5945,
        distance: 25.0,
        fare: 1200.0,
        goodsType: 'Machinery',
        weight: 800.0,
        status: AppConstants.statusPending,
        pickupTime: DateTime.now().add(const Duration(days: 2)),
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 40)),
      ),
      BookingModel(
        id: 'booking_004',
        userId: 'user_001',
        truckId: 'truck_001',
        truckType: 'Mini Truck',
        pickupLocation: '246 Koramangala, Bangalore',
        dropoffLocation: '888 Bannerghatta Rd, Bangalore',
        pickupLatitude: 12.9345,
        pickupLongitude: 77.6186,
        dropLatitude: 12.9090,
        dropLongitude: 77.5945,
        distance: 10.2,
        fare: 450.0,
        goodsType: 'Small Boxes',
        weight: 50.0,
        status: AppConstants.statusConfirmed,
        pickupTime: DateTime.now().add(const Duration(hours: 4)),
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 50)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        color: AppConstants.primaryColor,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor))
            : _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: AppConstants.errorColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppConstants.padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Overview',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ✅ Stat Cards (Fixed overflow)
                        SizedBox(
                          height: 140,
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: AppConstants.spacing16,
                            mainAxisSpacing: AppConstants.spacing16,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 1.4, // Balanced width/height
                            children: [
                              _buildStatCard(
                                icon: Icons.assignment_turned_in_outlined,
                                title: 'Total Bookings',
                                value: _totalBookings.toString(),
                                color: AppConstants.primaryColor,
                              ),
                              _buildStatCard(
                                icon: Icons.monetization_on_outlined,
                                title: 'Total Earnings',
                                value: '₹${_totalEarnings.toStringAsFixed(2)}',
                                color: AppConstants.secondaryColor,
                              ),
                              _buildStatCard(
                                icon: Icons.check_circle_outline,
                                title: 'Completed',
                                value: _completedBookings.toString(),
                                color: Colors.green,
                              ),
                              _buildStatCard(
                                icon: Icons.local_shipping_outlined,
                                title: 'In Progress',
                                value: _inProgressBookings.toString(),
                                color: Colors.amber,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        const Text(
                          'Booking Trends',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildMonthlyStatsChart(),

                        const SizedBox(height: 24),
                        const Text(
                          'Recent Activity',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _recentBookings.isEmpty
                            ? const Text(
                                'No recent bookings.',
                                style: TextStyle(color: AppConstants.textSecondaryColor),
                              )
                            : Column(
                                children: _recentBookings.map((booking) {
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
                                      onTap: () {
                                        // Navigate to booking details
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                      ],
                    ),
                  ),
      ),
    );
  }

  // ✅ Fixed Stat Card (Prevents overflow)
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: AppConstants.elevation2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.textSecondaryColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textPrimaryColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Simple bar chart
  Widget _buildMonthlyStatsChart() {
    final List<Map<String, dynamic>> data = [
      {'month': 'Jan', 'value': 0.8},
      {'month': 'Feb', 'value': 0.6},
      {'month': 'Mar', 'value': 0.9},
      {'month': 'Apr', 'value': 0.7},
      {'month': 'May', 'value': 1.0},
      {'month': 'Jun', 'value': 0.5},
      {'month': 'Jul', 'value': 0.95},
    ];

    return Card(
      elevation: AppConstants.elevation2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadius)),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((d) => _buildBar(label: d['month'], heightRatio: d['value'])).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Monthly Booking Trends',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppConstants.textPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar({required String label, required double heightRatio}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 100 * heightRatio,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppConstants.textSecondaryColor),
        ),
      ],
    );
  }
}
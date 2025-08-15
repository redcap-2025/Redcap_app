// lib/ui/screens/customer/home_screen.dart
import 'dart:io'; // For FileImage
import 'package:flutter/material.dart'; // ✅ REQUIRED
import 'package:redcap/ui/screens/customer/profile/profile_screen.dart';
import 'package:redcap/services/user_service.dart';
import 'package:redcap/models/user_model.dart';

import '../../../constants/app_constants.dart';
import '../../../models/truck_model.dart';
import '../../../widgets/custom_button.dart';
import 'bookings/bookings_tab.dart';
import 'support/support_tab.dart';
import 'bookings/Create_booking_screen.dart';
import '../../../../widgets/booking_card.dart';
import '../../../../models/booking_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late PageController _pageController;
  UserModel? _user;
  final UserService _userService = UserService();

  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _pageController = PageController(initialPage: _currentIndex);
    _tabs = [
      _HomeTab(
        user: _user,
        onNavigateToBookings: () => _onTabTapped(1),
        onCreateBooking: () => _navigateToCreateBooking(),
      ),
      const BookingsTab(),
      const SupportTab(),
    ];
  }

  void _loadUser() async {
    await _userService.loadUser();
    final user = _userService.getCurrentUser();
    if (mounted) {
      setState(() {
        _user = user;
      });
      // Rebuild tab with new user data
      _tabs[0] = _HomeTab(
        user: _user,
        onNavigateToBookings: () => _onTabTapped(1),
        onCreateBooking: () => _navigateToCreateBooking(),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void _navigateToCreateBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateBookingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: AppConstants.textSecondaryColor,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: 'Support'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final UserModel? user;
  final VoidCallback onNavigateToBookings;
  final VoidCallback onCreateBooking;

  const _HomeTab({
    required this.user,
    required this.onNavigateToBookings,
    required this.onCreateBooking,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data
    final List<TruckModel> mockTrucks = [
      TruckModel(
        id: '1',
        name: 'Mini Truck',
        type: 'Mini Truck',
        capacity: '750kg',
        ratePerKm: 15.0,
        description: 'Small truck for light goods',
        image: 'assets/icons/mini_truck.png',
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      TruckModel(
        id: '2',
        name: 'Pickup Truck',
        type: 'Pickup Truck',
        capacity: '1500kg',
        ratePerKm: 20.0,
        description: 'Medium truck for medium loads',
        image: 'assets/icons/pickup_truck.ipeg',
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      TruckModel(
        id: '3',
        name: 'Large Truck',
        type: 'Large Truck',
        capacity: '3000kg',
        ratePerKm: 25.0,
        description: 'Large truck for heavy loads',
        image: 'assets/icons/large_truck.png',
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    final List<BookingModel> mockRecentBookings = [
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
        pickupTime: DateTime.now().subtract(const Duration(hours: 2)),
        createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 10)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            pinned: true,
            expandedHeight: 80,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/redcap_logo.png',
                          height: 40,
                          width: 40,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Red',
                          style: TextStyle(
                            color: AppConstants.primaryColor,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'cap',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: AppConstants.dividerColor,
                            backgroundImage: user?.profileImage != null
                                ? FileImage(File(user!.profileImage!))
                                : null,
                            child: user?.profileImage == null
                                ? Text(
                                    user?.name.isNotEmpty == true ? user!.name.substring(0, 1).toUpperCase() : 'U',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.padding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onPressed: onNavigateToBookings,
                        text: 'My Bookings',
                        icon: Icons.assignment,
                        backgroundColor: AppConstants.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        onPressed: onCreateBooking,
                        text: 'Create Booking',
                        icon: Icons.add_circle_outline,
                        backgroundColor: AppConstants.secondaryColor,
                        textColor: AppConstants.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Available Trucks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
  height: 130,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: mockTrucks.length,
    itemBuilder: (context, index) {
      final truck = mockTrucks[index];

      // 🔁 Map truck type to correct image asset
      String getImageAsset(String truckType) {
        switch (truckType) {
          case 'Mini Truck':
            return 'assets/icons/mini_truck.png';
          case 'Pickup Truck':
            return 'assets/icons/pickup_truck.jpeg';
          case 'Large Truck':
            return 'assets/icons/large_truck.png';
          default:
            return 'assets/icons/truck_icon.png'; // fallback
        }
      }
     return Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Use Image.asset with dynamic path
            Image.asset(
              getImageAsset(truck.type),
              height: 64,
              width: 64,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              truck.type,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppConstants.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${truck.capacity} • ₹${truck.ratePerKm}/km',
              style: const TextStyle(
                fontSize: 12,
                color: AppConstants.textSecondaryColor,
              ),
            ),
          ],
        ),
      );
    },
  ),
),
                const SizedBox(height: 32),
                const Text(
                  'Recent Bookings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                if (mockRecentBookings.isEmpty)
                  const Text(
                    'No recent bookings yet.',
                    style: TextStyle(color: AppConstants.textSecondaryColor),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: mockRecentBookings.length,
                    itemBuilder: (context, index) {
                      final booking = mockRecentBookings[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: BookingCard(
                          bookingId: booking.id,
                          pickupLocation: booking.pickupLocation,
                          dropoffLocation: booking.dropoffLocation,
                          date: 'Today',
                          time: '9:30 AM',
                          status: booking.status,
                          fare: booking.fare,
                          distance: booking.distance,
                          truckType: booking.truckType,
                          onTap: () {
                            // Navigate to booking details
                          },
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
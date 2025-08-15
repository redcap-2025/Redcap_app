import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppConstants {
  // App Colors - Enhanced with Material 3 support
  static const Color primaryColor = Color(0xFFE53935); // Red
  static const Color secondaryColor = Color(0xFFFFFFFF); // White
  static const Color accentColor = Color(0xFF1976D2); // Blue
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color infoColor = Color(0xFF2196F3);

  // Enhanced color variations
  static const Color primaryLightColor = Color(0xFFFF6659);
  static const Color primaryDarkColor = Color(0xFFAB000D);
  static const Color backgroundDarkColor = Color(0xFF121212);
  static const Color surfaceDarkColor = Color(0xFF1E1E1E);
  static const Color dividerColor = Color(0xFFE0E0E0);
  static const Color shadowColor = Color(0x1A000000);

  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFFE53935),
    Color(0xFFD32F2F),
  ];

  static const List<Color> successGradient = [
    Color(0xFF4CAF50),
    Color(0xFF388E3C),
  ];

  // Material 3 Color Scheme
  static ColorScheme get lightColorScheme => ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      );

  static ColorScheme get darkColorScheme => ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      );

  // API Configuration - Fixed URL spacing
  static const String baseUrl = 'https://api.redcap-truck.com'; // ✅ Trimmed
  static const String apiVersion = '/api/v1';
  static const int apiTimeout = 30000; // ms
  static const int retryAttempts = 3;
  static const int retryDelay = 2000; // ms
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Environment Configuration
  static const String environment =
      String.fromEnvironment('ENVIRONMENT', defaultValue: 'production');
  static const bool isProduction = environment == 'production';
  static const bool isDevelopment = environment == 'development';

  // Google Maps Keys
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: 'YOUR_GOOGLE_MAPS_API_KEY',
  );
  static const String googlePlacesApiKey = String.fromEnvironment(
    'GOOGLE_PLACES_API_KEY',
    defaultValue: 'YOUR_GOOGLE_PLACES_API_KEY',
  );

  // Payment Gateway Keys
  static const String razorpayKeyId = String.fromEnvironment(
    'RAZORPAY_KEY_ID',
    defaultValue: 'YOUR_RAZORPAY_KEY_ID',
  );
  static const String razorpayKeySecret = String.fromEnvironment(
    'RAZORPAY_KEY_SECRET',
    defaultValue: 'YOUR_RAZORPAY_KEY_SECRET',
  );

  // Firebase Configuration
  static const String firebaseProjectId = 'redcap-truck-booking';
  static const String firebaseMessagingSenderId = String.fromEnvironment(
    'FCM_SENDER_ID',
    defaultValue: 'YOUR_SENDER_ID',
  );
  static const String firebaseWebApiKey = String.fromEnvironment(
    'FIREBASE_WEB_API_KEY',
    defaultValue: 'YOUR_WEB_API_KEY',
  );

  // App Info
  static const String appName = 'RedCap';
  static const String appVersion = '1.1.1';
  static const int buildNumber = 1;
  static const String appDescription = 'Book trucks instantly in Namakkal';
  static const String packageName = 'com.redcap.truck_booking';

  // ✅ Use getters for dynamic URLs
  static String get appStoreUrl => 'https://apps.apple.com/app/redcap';
  static String get playStoreUrl => 'https://play.google.com/store/apps/details?id=$packageName';

  // App Assets
  static const String appLogo = 'assets/images/redcap_logo.png';
  static const String appLogoDark = 'assets/images/redcap_logo_dark.png';
  static const String splashLogo = 'assets/images/splash_logo.png';
 

  // ✅ Truck Types - Use int/const for colors in const maps
  static const List<Map<String, dynamic>> truckTypes = [
    {
      'id': '3_wheeler',
      'name': '3 Wheeler',
      'capacity': '500 kg',
      'ratePerKm': 15.0,
      'baseRate': 100.0,
      'image': 'assets/images/3_wheeler.png',
      'description': 'Perfect for small loads and quick deliveries',
      'dimensions': '6ft x 4ft x 4ft',
      'fuelType': 'Petrol/CNG',
      'availability': true,
      'popularFor': ['Documents', 'Small packages', 'Medicines'],
      'color': 0xFF4CAF50, // ✅ Use int instead of Color
    },
    {
      'id': '4_wheeler',
      'name': '4 Wheeler',
      'capacity': '1 ton',
      'ratePerKm': 25.0,
      'baseRate': 200.0,
      'image': 'assets/images/4_wheeler.png',
      'description': 'Ideal for medium-sized loads',
      'dimensions': '8ft x 5ft x 5ft',
      'fuelType': 'Diesel',
      'availability': true,
      'popularFor': ['Furniture', 'Electronics', 'Groceries'],
      'color': 0xFF2196F3,
    },
    {
      'id': '6_wheeler',
      'name': '6 Wheeler',
      'capacity': '3 tons',
      'ratePerKm': 35.0,
      'baseRate': 400.0,
      'image': 'assets/images/6_wheeler.png',
      'description': 'Suitable for heavy loads and construction materials',
      'dimensions': '12ft x 6ft x 6ft',
      'fuelType': 'Diesel',
      'availability': true,
      'popularFor': ['Construction materials', 'Bulk goods', 'Industrial equipment'],
      'color': 0xFFFF9800,
    },
    {
      'id': 'heavy_vehicle',
      'name': 'Heavy Vehicle',
      'capacity': '10 tons',
      'ratePerKm': 50.0,
      'baseRate': 800.0,
      'image': 'assets/images/heavy_vehicle.png',
      'description': 'For large-scale transportation needs',
      'dimensions': '20ft x 8ft x 8ft',
      'fuelType': 'Diesel',
      'availability': true,
      'popularFor': ['Heavy machinery', 'Large furniture', 'Bulk materials'],
      'color': 0xFFE53935,
    },
  ];

  // ✅ Goods Types - Fixed map structure
  static const Map<String, List<String>> goodsTypesByCategory = {
    'General': ['General Goods', 'Household Items', 'Personal Belongings'],
    'Construction': ['Construction Materials', 'Cement', 'Steel', 'Bricks'],
    'Electronics': ['Electronics', 'Appliances', 'Computers', 'Mobile Devices'],
    'Furniture': ['Furniture', 'Home Decor', 'Office Furniture'],
    'Food & Beverages': ['Food Items', 'Beverages', 'Perishables', 'Groceries'],
    'Textiles': ['Textiles', 'Clothing', 'Fabrics', 'Garments'],
    'Industrial': ['Machinery', 'Industrial Equipment', 'Tools'],
    'Medical': ['Medical Equipment', 'Medicines', 'Healthcare Supplies'],
    'Automotive': ['Auto Parts', 'Vehicles', 'Spare Parts'],
    'Others': ['Others', 'Miscellaneous'],
  };

  static List<String> get allGoodsTypes =>
      goodsTypesByCategory.values.expand((x) => x).toList();

  // ✅ Payment Methods - Use int for color
  static const List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'cod',
      'name': 'Cash on Delivery',
      'icon': 'assets/icons/cod.png',
      'description': 'Pay when your goods are delivered',
      'isAvailable': true,
      'processingTime': '0 minutes',
      'charges': 0.0,
      'color': 0xFF4CAF50,
      'priority': 1,
    },
    {
      'id': 'upi',
      'name': 'UPI Payment',
      'icon': 'assets/icons/upi.png',
      'description': 'Pay using UPI apps like Google Pay, PhonePe, Paytm',
      'isAvailable': true,
      'processingTime': 'Instant',
      'charges': 0.0,
      'color': 0xFF2196F3,
      'priority': 2,
    },
    {
      'id': 'online',
      'name': 'Online Payment',
      'icon': 'assets/icons/online_payment.png',
      'description': 'Pay securely online via cards or net banking',
      'isAvailable': true,
      'processingTime': '2-3 minutes',
      'charges': 2.0,
      'color': 0xFFFF9800,
      'priority': 3,
    },
    {
      'id': 'card',
      'name': 'Credit/Debit Card',
      'icon': 'assets/icons/card.png',
      'description': 'Pay using credit or debit cards',
      'isAvailable': true,
      'processingTime': '2-3 minutes',
      'charges': 2.0,
      'color': 0xFF9C27B0,
      'priority': 4,
    },
    {
      'id': 'netbanking',
      'name': 'Net Banking',
      'icon': 'assets/icons/netbanking.png',
      'description': 'Pay using your bank account',
      'isAvailable': true,
      'processingTime': '3-5 minutes',
      'charges': 1.0,
      'color': 0xFF607D8B,
      'priority': 5,
    },
  ];

  // Booking Status
  static const String statusPending = 'pending';
  static const String statusConfirmed = 'confirmed';
  static const String statusInProgress = 'in_progress';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';
  static const String statusExpired = 'expired';

  // ✅ Use int for color in const map
  static const Map<String, Map<String, dynamic>> statusDetails = {
    statusPending: {
      'name': 'Pending',
      'color': 0xFFFF9800,
      'icon': Icons.access_time,
      'description': 'Waiting for confirmation',
    },
    statusConfirmed: {
      'name': 'Confirmed',
      'color': 0xFF2196F3,
      'icon': Icons.check_circle,
      'description': 'Booking confirmed by driver',
    },
    statusInProgress: {
      'name': 'In Progress',
      'color': 0xFF4CAF50,
      'icon': Icons.local_shipping,
      'description': 'Delivery in progress',
    },
    statusCompleted: {
      'name': 'Completed',
      'color': 0xFF4CAF50,
      'icon': Icons.done_all,
      'description': 'Successfully delivered',
    },
    statusCancelled: {
      'name': 'Cancelled',
      'color': 0xFFF44336,
      'icon': Icons.cancel,
      'description': 'Booking cancelled',
    },
    statusExpired: {
      'name': 'Expired',
      'color': 0xFF9E9E9E,
      'icon': Icons.schedule,
      'description': 'Booking expired',
    },
  };

  // User Roles
  static const String roleCustomer = 'customer';
  static const String roleAdmin = 'admin';
  static const String roleDriver = 'driver';
  static const String roleSuperAdmin = 'super_admin';

  static const Map<String, List<String>> rolePermissions = {
    roleCustomer: ['book', 'track', 'pay', 'rate'],
    roleDriver: ['accept', 'track', 'update_status', 'navigate'],
    roleAdmin: ['manage_bookings', 'manage_users', 'view_analytics'],
    roleSuperAdmin: ['all'],
  };

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String userRoleKey = 'user_role';
  static const String languageKey = 'language';
  static const String themeKey = 'theme';
  static const String notificationKey = 'notifications_enabled';
  static const String locationPermissionKey = 'location_permission';
  static const String biometricKey = 'biometric_enabled';
  static const String cacheKey = 'app_cache';
  static const String onboardingKey = 'onboarding_completed';

  // Animation Durations & Curves
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  static const Duration pageTransition = Duration(milliseconds: 250);

  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bouncyCurve = Curves.elasticOut;
  static const Curve sharpCurve = Curves.easeInOutCubic;

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
    letterSpacing: 0.0,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    letterSpacing: 0.15,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimaryColor,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondaryColor,
    letterSpacing: 0.4,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.25,
  );

  static const TextStyle overlineStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textSecondaryColor,
    letterSpacing: 1.5,
  );

  // Responsive Design Constants
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Border Radius
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;
  static const double extraLargeBorderRadius = 24.0;
  static const double circularRadius = 50.0;

  // Spacing System
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;

  // Legacy support
  static const double padding = spacing16;
  static const double smallPadding = spacing8;
  static const double largePadding = spacing24;
  static const double margin = spacing16;
  static const double smallMargin = spacing8;
  static const double largeMargin = spacing24;

  // Button Specs
  static const double buttonHeight = 48.0;
  static const double smallButtonHeight = 36.0;
  static const double largeButtonHeight = 56.0;
  static const double fabSize = 56.0;
  static const double minButtonWidth = 88.0;

  // Input Specs
  static const double inputFieldHeight = 48.0;
  static const double textAreaHeight = 120.0;
  static const double inputBorderWidth = 1.0;
  static const double inputFocusBorderWidth = 2.0;

  // Elevation
  static const double elevation1 = 1.0;
  static const double elevation2 = 2.0;
  static const double elevation4 = 4.0;
  static const double elevation8 = 8.0;
  static const double elevation16 = 16.0;

  // Map Configuration
  static const double defaultZoom = 15.0;
  static const double minZoom = 10.0;
  static const double maxZoom = 20.0;
  static const double locationAccuracy = 100.0;
  static const int locationUpdateInterval = 5000;

  static const double defaultLatitude = 11.2189;
  static const double defaultLongitude = 78.1677;
  static const String defaultLocationName = 'Namakkal, Tamil Nadu';

  // Notifications
  static const String notificationChannelId = 'redcap_notifications';
  static const String notificationChannelName = 'RedCap Notifications';
  static const String notificationChannelDescription = 'Notifications for truck bookings';
  static const String bookingChannelId = 'booking_updates';
  static const String promotionChannelId = 'promotions';

  // Support & Contact
  static const String supportPhonePrimary = '9629333135';
  static const String supportPhoneSecondary = '7010344469';
  static const List<String> supportPhones = [supportPhonePrimary, supportPhoneSecondary];
  static const String supportEmail = 'support@redcap-truck.com';
  static const String supportWhatsapp = '9629333135';
  static const String businessHours = '6:00 AM - 10:00 PM';
  static const String emergencyContact = '7010344469';
  static const String supportHelpText = 'Need help? Our team is available to assist with bookings, payments, delivery tracking, and account issues.';

  // ✅ Backward compatibility
  static const String supportPhone = '+91-$supportPhonePrimary';

  // Social Media
  static const String websiteUrl = 'https://redcap-truck.com';
  static const String facebookUrl = 'https://facebook.com/redcaptrucks';
  static const String twitterUrl = 'https://twitter.com/redcaptrucks';
  static const String linkedinUrl = 'https://linkedin.com/company/redcap';
  static const String instagramUrl = 'https://instagram.com/redcaptrucks';

  // Company Info
  static const String companyName = 'Redcap';
  static const String companyTagline = 'On-demand logistics & intercity courier services';
  static const String companyDescription =
      'Redcap is a logistics company that provides on-demand transportation solutions for goods and intercity courier services, primarily in India. It connects individuals and businesses with a fleet of vehicles, including trucks and two-wheelers, enabling B2B and B2C deliveries with real-time visibility and supply chain support.';

  static const List<String> coreServices = [
    'On-demand transportation: mini-trucks, tempos, and two-wheelers for goods of all sizes.',
    'Enterprise logistics: bulk transportation, distribution, and supply chain management.',
    'Packers and movers: residential relocation including packing and moving.',
    'Intercity courier services for businesses and individuals.',
    'API integrations for businesses to manage deliveries programmatically.',
  ];

  // Business Logic
  static const double maxBookingDistance = 500.0;
  static const int maxAdvanceBookingDays = 30;
  static const int cancellationTimeLimit = 30;
  static const double serviceTaxRate = 0.18;
  static const double platformFee = 10.0;
  static const int ratingScale = 5;
  static const int minRatingForDriver = 3;

  // Cache
  static const int cacheMaxAge = 86400; // 24 hours
  static const int imagesCacheMaxAge = 604800; // 7 days
  static const int maxCacheSize = 104857600; // 100MB

  // Error Messages
  static const Map<String, String> networkErrors = {
    'no_connection': 'No internet connection available',
    'timeout': 'Request timed out. Please try again',
    'server_error': 'Server error occurred. Please try again later',
    'not_found': 'Requested resource not found',
    'unauthorized': 'Session expired. Please login again',
  };

  static const Map<String, String> locationErrors = {
    'permission_denied': 'Location permission denied',
    'service_disabled': 'Location services are disabled',
    'accuracy_low': 'Location accuracy is too low',
    'timeout': 'Location request timed out',
  };

  static const Map<String, String> paymentErrors = {
    'payment_failed': 'Payment processing failed',
    'insufficient_funds': 'Insufficient funds in account',
    'card_declined': 'Card was declined by bank',
    'payment_timeout': 'Payment request timed out',
  };

  static const String networkError = 'Please check your internet connection';
  static const String serverError = 'Something went wrong. Please try again';
  static const String authError = 'Authentication failed. Please login again';
  static const String locationError = 'Unable to get your location';
  static const String paymentError = 'Payment failed. Please try again';

  // Success Messages
  static const Map<String, String> successMessages = {
    'booking_created': 'Booking request sent successfully!',
    'booking_confirmed': 'Booking confirmed by driver!',
    'payment_completed': 'Payment completed successfully!',
    'profile_updated': 'Profile updated successfully!',
    'otp_sent': 'OTP sent to your phone number',
    'otp_verified': 'Phone number verified successfully',
    'password_reset': 'Password reset email sent',
  };

  static const String bookingSuccess = 'Booking confirmed successfully!';
  static const String paymentSuccess = 'Payment completed successfully!';
  static const String profileUpdateSuccess = 'Profile updated successfully!';

  // Validation
  static const Map<String, String> validationMessages = {
    'required_field': 'This field is required',
    'invalid_phone': 'Please enter a valid 10-digit phone number',
    'invalid_email': 'Please enter a valid email address',
    'invalid_otp': 'Please enter a valid 6-digit OTP',
    'password_mismatch': 'Passwords do not match',
    'password_weak': 'Password must be at least 8 characters with uppercase, lowercase, and numbers',
    'invalid_name': 'Name must contain only letters and spaces',
    'invalid_amount': 'Please enter a valid amount',
    'min_amount': 'Minimum booking amount is ₹100',
    'max_amount': 'Maximum booking amount is ₹50,000',
  };

  static const String requiredField = 'This field is required';
  static const String invalidPhone = 'Please enter a valid phone number';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidOtp = 'Please enter a valid OTP';
  static const String passwordMismatch = 'Passwords do not match';

  // Accessibility
  static const double minTouchTargetSize = 48.0;
  static const double accessibilityLargeTextScale = 1.3;
  static const Duration accessibilityAnnouncementDelay = Duration(milliseconds: 500);

  // Feature Flags
  static const bool enableBiometricAuth = true;
  static const bool enableDarkMode = true;
  static const bool enableNotifications = true;
  static const bool enableLocationTracking = true;
  static const bool enableAnalytics = !isDevelopment;
  static const bool enableCrashReporting = !isDevelopment;

  // Testing
  static const bool isTestMode = bool.fromEnvironment('TEST_MODE', defaultValue: false);
  static const String testPhoneNumber = '+91-9876543210';
  static const String testOtp = '123456';

  // Utility Methods
  static String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  static String formatDistance(double distance) {
    return distance < 1 ? '${(distance * 1000).toInt()}m' : '${distance.toStringAsFixed(1)}km';
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  // ✅ Convert color int to Color
  static Color getStatusColor(String status) {
    final colorValue = statusDetails[status]?['color'] as int?;
    return Color(colorValue ?? 0xFF757575);
  }

  static IconData getStatusIcon(String status) {
    return statusDetails[status]?['icon'] ?? Icons.help_outline;
  }

  // Haptic Feedback
  static void lightHaptic() => HapticFeedback.lightImpact();
  static void mediumHaptic() => HapticFeedback.mediumImpact();
  static void heavyHaptic() => HapticFeedback.heavyImpact();
  static void selectionHaptic() => HapticFeedback.selectionClick();
}
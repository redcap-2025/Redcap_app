# RedCap Truck Booking System

A complete, production-ready Flutter application for truck booking in Bangalore. This app allows customers to book trucks of various sizes, calculate fares, make payments, and track their bookings in real-time.

## Features

### Customer Features
- **Authentication**: Phone/email login with OTP verification
- **Vehicle Selection**: Browse available vehicles by type and capacity:
  - **3 Wheeler**: Perfect for small loads (500 kg capacity)
  - **4 Wheeler**: Ideal for medium loads (1 ton capacity)
  - **6 Wheeler**: Suitable for heavy loads (3 tons capacity)
  - **Heavy Vehicle**: For large-scale transportation (10 tons capacity)
- **Fare Calculation**: Automatic fare calculation based on distance and vehicle type
- **Booking Management**: Create, view, and track bookings
- **Payment Integration**: Multiple payment options:
  - Cash on Delivery (COD)
  - Online Payment
  - UPI Payment (Google Pay, PhonePe, Paytm)
  - Credit/Debit Cards
  - Net Banking
- **Real-time Tracking**: Live GPS tracking of assigned vehicles
- **Support**: In-app customer support and help

### Admin Features
- **Dashboard**: Analytics and overview of system performance
- **Booking Management**: View and manage all bookings
- **Truck Management**: Manage truck fleet and availability
- **User Management**: Manage customer accounts and permissions
- **Reports**: Generate reports and analytics

### Technical Features
- **Clean Architecture**: Well-structured codebase with separation of concerns
- **State Management**: Provider pattern for state management
- **API Integration**: RESTful API integration with error handling
- **Offline Support**: Basic offline caching and functionality
- **Multi-language Support**: English, Hindi, and Kannada support
- **Responsive Design**: Works on various screen sizes
- **Security**: Secure authentication and data handling

## Prerequisites

- Flutter 3.x or higher
- Dart 3.x or higher
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd redcap_truck_booking_system
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Keys**
   
   Create a `.env` file in the root directory and add your API keys:
   ```
   GOOGLE_MAPS_API_KEY=your_google_maps_api_key
   GOOGLE_PLACES_API_KEY=your_google_places_api_key
   RAZORPAY_KEY_ID=your_razorpay_key_id
   RAZORPAY_KEY_SECRET=your_razorpay_key_secret
   FIREBASE_PROJECT_ID=your_firebase_project_id
   FIREBASE_MESSAGING_SENDER_ID=your_sender_id
   ```

4. **Update API Configuration**
   
   Open `lib/constants/app_constants.dart` and update the following:
   ```dart
   static const String baseUrl = 'https://your-api-domain.com';
   static const String googleMapsApiKey = 'your_google_maps_api_key';
   static const String googlePlacesApiKey = 'your_google_places_api_key';
   static const String razorpayKeyId = 'your_razorpay_key_id';
   static const String razorpayKeySecret = 'your_razorpay_key_secret';
   ```

5. **Run the application**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── constants/
│   └── app_constants.dart          # App-wide constants and configuration
├── models/
│   ├── user_model.dart             # User data model
│   ├── truck_model.dart            # Truck data model
│   └── booking_model.dart          # Booking data model
├── services/
│   ├── api_service.dart            # API service for HTTP requests
│   └── auth_service.dart           # Authentication service
├── ui/
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart   # Login screen
│   │   │   └── register_screen.dart # Registration screen
│   │   ├── customer/
│   │   │   ├── home_screen.dart    # Customer home screen
│   │   │   └── screens/            # Customer tab screens
│   │   └── admin/
│   │       └── admin_dashboard_screen.dart # Admin dashboard
│   └── widgets/
│       ├── custom_button.dart      # Reusable button widget
│       └── custom_text_field.dart  # Reusable text field widget
├── utils/                          # Utility functions
└── main.dart                       # App entry point
```

## Configuration

### Google Maps Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable Maps SDK for Android and iOS
4. Create API keys for Maps and Places
5. Add the keys to your configuration

### Razorpay Setup

1. Sign up for a Razorpay account
2. Get your API keys from the dashboard
3. Add the keys to your configuration
4. Test the integration in sandbox mode

### Firebase Setup

1. Create a Firebase project
2. Add Android and iOS apps to the project
3. Download and add configuration files:
   - `google-services.json` for Android
   - `GoogleService-Info.plist` for iOS
4. Enable Authentication and Cloud Messaging

## API Endpoints

The app expects the following API endpoints:

### Authentication
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/send-otp` - Send OTP
- `POST /api/v1/auth/verify-otp` - Verify OTP
- `POST /api/v1/auth/logout` - User logout

### User Management
- `GET /api/v1/user/profile` - Get user profile
- `PUT /api/v1/user/profile` - Update user profile

### Trucks
- `GET /api/v1/trucks` - Get available trucks
- `GET /api/v1/trucks/{id}` - Get truck details

### Bookings
- `POST /api/v1/bookings/calculate-fare` - Calculate booking fare
- `POST /api/v1/bookings` - Create booking
- `GET /api/v1/bookings` - Get user bookings
- `GET /api/v1/bookings/{id}` - Get booking details
- `PUT /api/v1/bookings/{id}` - Update booking
- `DELETE /api/v1/bookings/{id}` - Cancel booking

### Payments
- `POST /api/v1/payments` - Create payment
- `POST /api/v1/payments/{id}/verify` - Verify payment

### Admin
- `GET /api/v1/admin/dashboard` - Get dashboard stats
- `GET /api/v1/admin/bookings` - Get all bookings

## Dependencies

### Core Dependencies
- `flutter` - Flutter framework
- `provider` - State management
- `dio` - HTTP client
- `shared_preferences` - Local storage
- `google_maps_flutter` - Maps integration
- `geolocator` - Location services
- `firebase_auth` - Firebase authentication
- `firebase_messaging` - Push notifications
- `razorpay_flutter` - Payment integration

### UI Dependencies
- `flutter_svg` - SVG support
- `cached_network_image` - Image caching
- `shimmer` - Loading animations
- `lottie` - Animation support

### Utility Dependencies
- `intl` - Internationalization
- `url_launcher` - URL handling
- `permission_handler` - Permission management
- `connectivity_plus` - Network connectivity

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Testing

Run tests using:
```bash
flutter test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Email: support@redcap-truck.com
- Phone: +91-9876543210
- WhatsApp: +91-9876543210

## Changelog

### Version 1.0.0
- Initial release
- Basic authentication and booking functionality
- Admin dashboard
- Payment integration
- Real-time tracking support

## Roadmap

### Version 1.1.0
- Advanced analytics and reporting
- Driver app integration
- Multi-language support
- Offline mode improvements

### Version 1.2.0
- AI-powered fare optimization
- Advanced booking features
- Enhanced security features
- Performance optimizations

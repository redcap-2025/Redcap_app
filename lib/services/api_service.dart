import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/truck_model.dart';
import '../models/booking_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  String? _authToken;

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl + AppConstants.apiVersion,
        connectTimeout: Duration(milliseconds: AppConstants.apiTimeout),
        receiveTimeout: Duration(milliseconds: AppConstants.apiTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Handle unauthorized access
            _clearAuthToken();
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<void> _loadAuthToken() async {
    if (_authToken == null) {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString(AppConstants.authTokenKey);
    }
  }

  Future<void> _saveAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.authTokenKey, token);
  }

  Future<void> _clearAuthToken() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.authTokenKey);
  }

  // Authentication APIs
  Future<Map<String, dynamic>> login(String phone, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'phone': phone, 'password': password},
      );

      if (response.data['token'] != null) {
        await _saveAuthToken(response.data['token']);
      }

      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );

      if (response.data['token'] != null) {
        await _saveAuthToken(response.data['token']);
      }

      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      final response = await _dio.post(
        '/auth/send-otp',
        data: {'phone': phone},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    try {
      final response = await _dio.post(
        '/auth/verify-otp',
        data: {'phone': phone, 'otp': otp},
      );

      if (response.data['token'] != null) {
        await _saveAuthToken(response.data['token']);
      }

      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
      await _clearAuthToken();
    } on DioException catch (e) {
      // Even if logout fails, clear local token
      await _clearAuthToken();
      throw _handleDioError(e);
    }
  }

  // User APIs
  Future<UserModel> getProfile() async {
    try {
      await _loadAuthToken();
      final response = await _dio.get('/user/profile');
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<UserModel> updateProfile(Map<String, dynamic> data) async {
    try {
      await _loadAuthToken();
      final response = await _dio.put('/user/profile', data: data);
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Truck APIs
  Future<List<TruckModel>> getTrucks({String? type, bool? available}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (type != null) queryParameters['type'] = type;
      if (available != null) queryParameters['available'] = available;

      final response = await _dio.get(
        '/trucks',
        queryParameters: queryParameters,
      );
      final List<dynamic> trucksData = response.data['data'];
      return trucksData.map((json) => TruckModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<TruckModel> getTruckById(String truckId) async {
    try {
      final response = await _dio.get('/trucks/$truckId');
      return TruckModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Booking APIs
  Future<Map<String, dynamic>> calculateFare({
    required String truckType,
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
    required String goodsType,
    required double weight,
  }) async {
    try {
      final response = await _dio.post(
        '/bookings/calculate-fare',
        data: {
          'truck_type': truckType,
          'pickup_latitude': pickupLat,
          'pickup_longitude': pickupLng,
          'drop_latitude': dropLat,
          'drop_longitude': dropLng,
          'goods_type': goodsType,
          'weight': weight,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<BookingModel> createBooking(Map<String, dynamic> bookingData) async {
    try {
      await _loadAuthToken();
      final response = await _dio.post('/bookings', data: bookingData);
      return BookingModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<BookingModel>> getBookings({String? status}) async {
    try {
      await _loadAuthToken();
      final queryParameters = <String, dynamic>{};
      if (status != null) queryParameters['status'] = status;

      final response = await _dio.get(
        '/bookings',
        queryParameters: queryParameters,
      );
      final List<dynamic> bookingsData = response.data['data'];
      return bookingsData.map((json) => BookingModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<BookingModel> getBookingById(String bookingId) async {
    try {
      await _loadAuthToken();
      final response = await _dio.get('/bookings/$bookingId');
      return BookingModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<BookingModel> updateBooking(
    String bookingId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _loadAuthToken();
      final response = await _dio.put('/bookings/$bookingId', data: data);
      return BookingModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await _loadAuthToken();
      await _dio.delete('/bookings/$bookingId');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Payment APIs
  Future<Map<String, dynamic>> createPayment(
    String bookingId,
    String paymentMethod,
  ) async {
    try {
      await _loadAuthToken();
      final response = await _dio.post(
        '/payments',
        data: {'booking_id': bookingId, 'payment_method': paymentMethod},
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Map<String, dynamic>> verifyPayment(String paymentId) async {
    try {
      await _loadAuthToken();
      final response = await _dio.post('/payments/$paymentId/verify');
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Location APIs
  Future<Map<String, dynamic>> getDriverLocation(String bookingId) async {
    try {
      await _loadAuthToken();
      final response = await _dio.get('/bookings/$bookingId/location');
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Support APIs
  Future<Map<String, dynamic>> createSupportTicket(
    Map<String, dynamic> ticketData,
  ) async {
    try {
      await _loadAuthToken();
      final response = await _dio.post('/support/tickets', data: ticketData);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getSupportTickets() async {
    try {
      await _loadAuthToken();
      final response = await _dio.get('/support/tickets');
      return List<Map<String, dynamic>>.from(response.data['data']);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Admin APIs
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      await _loadAuthToken();
      final response = await _dio.get('/admin/dashboard');
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<List<BookingModel>> getAllBookings({
    String? status,
    String? date,
  }) async {
    try {
      await _loadAuthToken();
      final queryParameters = <String, dynamic>{};
      if (status != null) queryParameters['status'] = status;
      if (date != null) queryParameters['date'] = date;

      final response = await _dio.get(
        '/admin/bookings',
        queryParameters: queryParameters,
      );
      final List<dynamic> bookingsData = response.data['data'];
      return bookingsData.map((json) => BookingModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Error handling
  String _handleDioError(DioException error) {
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;

      switch (statusCode) {
        case 400:
          return data['message'] ?? 'Bad request';
        case 401:
          return 'Authentication failed. Please login again.';
        case 403:
          return 'Access denied';
        case 404:
          return 'Resource not found';
        case 422:
          return data['message'] ?? 'Validation error';
        case 500:
          return 'Server error. Please try again later.';
        default:
          return 'Something went wrong';
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Request timeout. Please check your internet connection.';
    } else if (error.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please check your network.';
    } else {
      return 'Something went wrong';
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    await _loadAuthToken();
    return _authToken != null;
  }

  // Get current auth token
  String? get authToken => _authToken;
}

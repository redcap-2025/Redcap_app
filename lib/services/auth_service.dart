import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isCustomer => _currentUser?.isCustomer ?? false;
  bool get isDriver => _currentUser?.isDriver ?? false;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
  }

  // Initialize auth service
  Future<void> initialize() async {
    _setLoading(true);
    try {
      final isLoggedIn = await _apiService.isAuthenticated();
      if (isLoggedIn) {
        await _loadUserProfile();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Load user profile from API
  Future<void> _loadUserProfile() async {
    try {
      final user = await _apiService.getProfile();
      _setUser(user);
    } catch (e) {
      _setError(e.toString());
      await logout();
    }
  }

  // Login with phone and password
  Future<bool> login(String phone, String password) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final response = await _apiService.login(phone, password);
      
      if (response['user'] != null) {
        final user = UserModel.fromJson(response['user']);
        _setUser(user);
        
        // Save user data to local storage
        await _saveUserData(user);
        
        return true;
      } else {
        _setError('Login failed. Please try again.');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register new user
  Future<bool> register(String name, String email, String phone, String password) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final response = await _apiService.register(name, email, phone, password);
      
      if (response['user'] != null) {
        final user = UserModel.fromJson(response['user']);
        _setUser(user);
        
        // Save user data to local storage
        await _saveUserData(user);
        
        return true;
      } else {
        _setError('Registration failed. Please try again.');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Send OTP for phone verification
  Future<bool> sendOtp(String phone) async {
    _setLoading(true);
    _setError(null);
    
    try {
      await _apiService.sendOtp(phone);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Verify OTP
  Future<bool> verifyOtp(String phone, String otp) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final response = await _apiService.verifyOtp(phone, otp);
      
      if (response['user'] != null) {
        final user = UserModel.fromJson(response['user']);
        _setUser(user);
        
        // Save user data to local storage
        await _saveUserData(user);
        
        return true;
      } else {
        _setError('OTP verification failed. Please try again.');
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout user
  Future<void> logout() async {
    _setLoading(true);
    
    try {
      await _apiService.logout();
    } catch (e) {
      // Even if logout fails, clear local data
      print('Logout error: $e');
    } finally {
      _setUser(null);
      await _clearUserData();
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final updatedUser = await _apiService.updateProfile(data);
      _setUser(updatedUser);
      
      // Update local storage
      await _saveUserData(updatedUser);
      
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Save user data to local storage
  Future<void> _saveUserData(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userDataKey, user.toJson().toString());
      await prefs.setString(AppConstants.userRoleKey, user.role);
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Clear user data from local storage
  Future<void> _clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.userDataKey);
      await prefs.remove(AppConstants.userRoleKey);
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }

  // Load user data from local storage
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(AppConstants.userDataKey);
      
      if (userDataString != null) {
        final userData = Map<String, dynamic>.from(
          Map<String, dynamic>.from(userDataString as Map)
        );
        final user = UserModel.fromJson(userData);
        _setUser(user);
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Check if user has specific permission
  bool hasPermission(String permission) {
    if (!isAuthenticated) return false;
    
    // Admin has all permissions
    if (isAdmin) return true;
    
    // Define permission mappings
    const permissionMap = {
      'view_bookings': ['customer', 'admin'],
      'create_booking': ['customer', 'admin'],
      'cancel_booking': ['customer', 'admin'],
      'view_dashboard': ['admin'],
      'manage_trucks': ['admin'],
      'manage_users': ['admin'],
      'view_analytics': ['admin'],
    };
    
    final allowedRoles = permissionMap[permission];
    return allowedRoles?.contains(_currentUser?.role) ?? false;
  }

  // Refresh user session
  Future<bool> refreshSession() async {
    try {
      await _loadUserProfile();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Clear error
  void clearError() {
    _setError(null);
  }

  // Get user role
  String get userRole => _currentUser?.role ?? 'guest';

  // Get user name
  String get userName => _currentUser?.name ?? 'Guest';

  // Get user email
  String get userEmail => _currentUser?.email ?? '';

  // Get user phone
  String get userPhone => _currentUser?.phone ?? '';

  // Check if user is verified
  bool get isUserVerified => _currentUser?.isVerified ?? false;
}

// lib/services/user_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserService {
  static const String _userKey = 'user_data';
  UserModel? _currentUser;

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);

    if (userData != null) {
      // ✅ Fixed: Use 'jsonMap' instead of 'json'
      final Map<String, dynamic> jsonMap = json.decode(userData);
      _currentUser = UserModel.fromJson(jsonMap);
    } else {
      // Mock user
      _currentUser = UserModel(
        id: 'user_001',
        name: 'John Doe',
        email: 'john.doe@example.com',
        phone: '+91 98765 43210',
        role: 'customer',
        address: '123 Tech Park, Bangalore',
        isVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        profileImage: null,
      );
      await saveUser(_currentUser!);
    }
  }

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
    _currentUser = user;
  }

  UserModel? getCurrentUser() => _currentUser;

  Future<void> updateUser(UserModel user) async {
    await saveUser(user);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    _currentUser = null;
  }
}
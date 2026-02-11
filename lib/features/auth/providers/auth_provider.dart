import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId;
  String? _userEmail;
  String? _userName;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  String? get token => _token;

  Future<void> login(String email, String password) async {
    try {
      // TODO: 实现真实的API调用
      await Future.delayed(const Duration(seconds: 1));
      
      _isAuthenticated = true;
      _userId = 'user_123';
      _userEmail = email;
      _userName = email.split('@')[0];
      _token = 'fake_jwt_token';
      
      notifyListeners();
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      // TODO: 实现真实的API调用
      await Future.delayed(const Duration(seconds: 1));
      
      _isAuthenticated = true;
      _userId = 'user_123';
      _userEmail = email;
      _userName = name;
      _token = 'fake_jwt_token';
      
      notifyListeners();
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _userId = null;
    _userEmail = null;
    _userName = null;
    _token = null;
    
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    // TODO: 检查本地存储的token是否有效
    await Future.delayed(const Duration(seconds: 1));
  }
}
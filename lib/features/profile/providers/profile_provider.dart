import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  String? _userId;
  String? _userName;
  String? _userEmail;
  String? _userAvatar;
  Map<String, double> _bodyMeasurements = {};
  String? _preferredSize;
  List<String> _preferredColors = [];
  List<String> _preferredBrands = [];
  bool _isLoading = false;

  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userAvatar => _userAvatar;
  Map<String, double> get bodyMeasurements => _bodyMeasurements;
  String? get preferredSize => _preferredSize;
  List<String> get preferredColors => _preferredColors;
  List<String> get preferredBrands => _preferredBrands;
  bool get isLoading => _isLoading;

  void setUserInfo({
    String? userId,
    String? userName,
    String? userEmail,
    String? userAvatar,
  }) {
    _userId = userId ?? _userId;
    _userName = userName ?? _userName;
    _userEmail = userEmail ?? _userEmail;
    _userAvatar = userAvatar ?? _userAvatar;
    notifyListeners();
  }

  Future<void> updateBodyMeasurements(Map<String, double> measurements) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: 保存到服务器
      await Future.delayed(const Duration(seconds: 1));
      _bodyMeasurements = Map.from(measurements);
    } catch (e) {
      throw Exception('Failed to update measurements: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePreferences({
    String? preferredSize,
    List<String>? preferredColors,
    List<String>? preferredBrands,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: 保存到服务器
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (preferredSize != null) _preferredSize = preferredSize;
      if (preferredColors != null) _preferredColors = List.from(preferredColors);
      if (preferredBrands != null) _preferredBrands = List.from(preferredBrands);
      
    } catch (e) {
      throw Exception('Failed to update preferences: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserProfile(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: 从服务器加载用户资料
      await Future.delayed(const Duration(seconds: 1));
      
      // 模拟数据
      _userId = userId;
      _bodyMeasurements = {
        'height': 170.0,
        'weight': 65.0,
        'chest': 90.0,
        'waist': 75.0,
        'hips': 95.0,
      };
      _preferredSize = 'M';
      _preferredColors = ['Black', 'White', 'Blue'];
      _preferredBrands = ['Nike', 'Adidas'];
      
    } catch (e) {
      throw Exception('Failed to load user profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserAvatar(String avatarPath) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: 上传头像到服务器
      await Future.delayed(const Duration(seconds: 2));
      _userAvatar = avatarPath;
    } catch (e) {
      throw Exception('Failed to update avatar: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
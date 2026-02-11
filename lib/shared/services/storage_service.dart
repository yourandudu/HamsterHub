import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../constants/app_constants.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // String operations
  Future<bool> setString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  String? getString(String key) {
    return _prefs!.getString(key);
  }

  // Integer operations
  Future<bool> setInt(String key, int value) async {
    return await _prefs!.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs!.getInt(key);
  }

  // Boolean operations
  Future<bool> setBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs!.getBool(key);
  }

  // Double operations
  Future<bool> setDouble(String key, double value) async {
    return await _prefs!.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _prefs!.getDouble(key);
  }

  // List operations
  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs!.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _prefs!.getStringList(key);
  }

  // JSON operations
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    final jsonString = json.encode(value);
    return await setString(key, jsonString);
  }

  Map<String, dynamic>? getJson(String key) {
    final jsonString = getString(key);
    if (jsonString == null) return null;
    
    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  // Remove operations
  Future<bool> remove(String key) async {
    return await _prefs!.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs!.clear();
  }

  // Check if key exists
  bool containsKey(String key) {
    return _prefs!.containsKey(key);
  }

  // Get all keys
  Set<String> getKeys() {
    return _prefs!.getKeys();
  }

  // User-specific storage methods
  Future<void> saveUserData({
    required String token,
    required String userId,
    required String email,
    required String name,
  }) async {
    await Future.wait([
      setString(AppConstants.userTokenKey, token),
      setString(AppConstants.userIdKey, userId),
      setString(AppConstants.userEmailKey, email),
      setString(AppConstants.userNameKey, name),
    ]);
  }

  Map<String, String?> getUserData() {
    return {
      'token': getString(AppConstants.userTokenKey),
      'userId': getString(AppConstants.userIdKey),
      'email': getString(AppConstants.userEmailKey),
      'name': getString(AppConstants.userNameKey),
    };
  }

  Future<void> clearUserData() async {
    await Future.wait([
      remove(AppConstants.userTokenKey),
      remove(AppConstants.userIdKey),
      remove(AppConstants.userEmailKey),
      remove(AppConstants.userNameKey),
    ]);
  }

  // Body measurements storage
  Future<void> saveBodyMeasurements(Map<String, double> measurements) async {
    await setJson(AppConstants.measurementsKey, measurements);
  }

  Map<String, double> getBodyMeasurements() {
    final data = getJson(AppConstants.measurementsKey);
    if (data == null) return {};
    
    return data.map((key, value) => MapEntry(key, (value as num).toDouble()));
  }

  // User preferences storage
  Future<void> saveUserPreferences({
    String? preferredSize,
    List<String>? preferredColors,
    List<String>? preferredBrands,
  }) async {
    final preferences = <String, dynamic>{
      if (preferredSize != null) 'preferredSize': preferredSize,
      if (preferredColors != null) 'preferredColors': preferredColors,
      if (preferredBrands != null) 'preferredBrands': preferredBrands,
    };
    
    await setJson(AppConstants.preferencesKey, preferences);
  }

  Map<String, dynamic> getUserPreferences() {
    return getJson(AppConstants.preferencesKey) ?? {};
  }

  // App settings storage
  Future<void> saveAppSettings({
    bool? darkMode,
    bool? notifications,
    String? language,
  }) async {
    final settings = <String, dynamic>{
      if (darkMode != null) 'darkMode': darkMode,
      if (notifications != null) 'notifications': notifications,
      if (language != null) 'language': language,
    };
    
    await setJson('app_settings', settings);
  }

  Map<String, dynamic> getAppSettings() {
    return getJson('app_settings') ?? {};
  }

  // Cache management
  Future<void> setCacheData(String key, Map<String, dynamic> data, {Duration? ttl}) async {
    final cacheItem = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      if (ttl != null) 'ttl': ttl.inMilliseconds,
    };
    
    await setJson('cache_$key', cacheItem);
  }

  Map<String, dynamic>? getCacheData(String key) {
    final cacheItem = getJson('cache_$key');
    if (cacheItem == null) return null;
    
    final timestamp = cacheItem['timestamp'] as int;
    final ttl = cacheItem['ttl'] as int?;
    
    if (ttl != null) {
      final expiry = DateTime.fromMillisecondsSinceEpoch(timestamp + ttl);
      if (DateTime.now().isAfter(expiry)) {
        remove('cache_$key');
        return null;
      }
    }
    
    return cacheItem['data'] as Map<String, dynamic>;
  }

  Future<void> clearCache() async {
    final keys = getKeys().where((key) => key.startsWith('cache_')).toList();
    await Future.wait(keys.map((key) => remove(key)));
  }
}
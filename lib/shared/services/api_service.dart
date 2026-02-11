import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  String? _token;

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authorization token
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          _handleError(error);
          handler.next(error);
        },
      ),
    );

    // Add logging in debug mode
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  void _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        throw ApiException('Connection timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          _handleUnauthorized();
          throw ApiException('Session expired. Please login again.');
        } else if (statusCode == 403) {
          throw ApiException('Access denied.');
        } else if (statusCode == 404) {
          throw ApiException('Resource not found.');
        } else if (statusCode! >= 500) {
          throw ApiException('Server error. Please try again later.');
        }
        break;
      case DioExceptionType.cancel:
        throw ApiException('Request cancelled.');
      default:
        throw ApiException('Network error. Please check your connection.');
    }
  }

  void _handleUnauthorized() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.userTokenKey);
    // TODO: Navigate to login screen
  }

  Future<void> setAuthToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userTokenKey, token);
  }

  Future<void> loadStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(AppConstants.userTokenKey);
  }

  // Authentication APIs
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('${AppConstants.authEndpoint}/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  Future<Map<String, dynamic>> register(String email, String password, String name) async {
    try {
      final response = await _dio.post('${AppConstants.authEndpoint}/register', data: {
        'email': email,
        'password': password,
        'name': name,
      });
      return response.data;
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  // Clothing APIs
  Future<List<Map<String, dynamic>>> getClothingList({
    String? category,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(AppConstants.clothingEndpoint, queryParameters: {
        if (category != null) 'category': category,
        if (search != null) 'search': search,
        'page': page,
        'limit': limit,
      });
      return List<Map<String, dynamic>>.from(response.data['items']);
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  Future<Map<String, dynamic>> getClothingDetail(String id) async {
    try {
      final response = await _dio.get('${AppConstants.clothingEndpoint}/$id');
      return response.data;
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  Future<List<String>> getClothingCategories() async {
    try {
      final response = await _dio.get('${AppConstants.clothingEndpoint}/categories');
      return List<String>.from(response.data);
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  // Try-on APIs
  Future<Map<String, dynamic>> processTryOn(String imagePath, String clothingId) async {
    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
        'clothing_id': clothingId,
      });

      final response = await _dio.post(
        AppConstants.tryonEndpoint,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
      return response.data;
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  // User APIs
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await _dio.get('${AppConstants.userEndpoint}/profile');
      return response.data;
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('${AppConstants.userEndpoint}/profile', data: data);
      return response.data;
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  Future<String> uploadAvatar(String imagePath) async {
    try {
      FormData formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(
        '${AppConstants.userEndpoint}/avatar',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
      return response.data['avatar_url'];
    } catch (e) {
      throw _handleApiError(e);
    }
  }

  ApiException _handleApiError(dynamic error) {
    if (error is DioException) {
      return ApiException(_getErrorMessage(error));
    } else if (error is ApiException) {
      return error;
    } else {
      return ApiException('An unexpected error occurred');
    }
  }

  String _getErrorMessage(DioException error) {
    if (error.response?.data != null && error.response?.data['message'] != null) {
      return error.response?.data['message'];
    }
    return AppConstants.networkError;
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
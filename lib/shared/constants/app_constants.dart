class AppConstants {
  // API endpoints
  static const String baseUrl = 'https://api.example.com';
  static const String clothingEndpoint = '/api/clothing';
  static const String tryonEndpoint = '/api/tryon';
  static const String authEndpoint = '/api/auth';
  static const String userEndpoint = '/api/user';

  // Local storage keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
  static const String measurementsKey = 'body_measurements';
  static const String preferencesKey = 'user_preferences';

  // App settings
  static const int maxImageSize = 1024;
  static const int imageQuality = 85;
  static const int maxHistoryItems = 50;
  static const Duration tryonTimeout = Duration(seconds: 30);

  // UI constants
  static const double cardRadius = 12.0;
  static const double buttonRadius = 8.0;
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  
  // Try-on confidence thresholds
  static const double excellentThreshold = 0.8;
  static const double goodThreshold = 0.6;
}

class AppStrings {
  // App info
  static const String appName = 'Virtual Try-On';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'AI-powered virtual clothing try-on';

  // Error messages
  static const String networkError = 'Network connection error. Please check your internet connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unexpected error occurred.';
  static const String validationError = 'Please check your input and try again.';

  // Success messages
  static const String loginSuccess = 'Login successful!';
  static const String registerSuccess = 'Registration successful!';
  static const String measurementsSaved = 'Measurements saved successfully!';
  static const String profileUpdated = 'Profile updated successfully!';

  // Validation messages
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String passwordMismatch = 'Passwords do not match';
  static const String nameRequired = 'Name is required';

  // Feature messages
  static const String featureComingSoon = 'This feature is coming soon!';
  static const String shareFeatureComingSoon = 'Share feature coming soon!';
  static const String notificationFeatureComingSoon = 'Notification feature coming soon!';
}

class AppColors {
  // Primary colors
  static const primaryColor = 0xFF6366F1;
  static const primaryLight = 0xFF8B8CF1;
  static const primaryDark = 0xFF4F46E5;

  // Secondary colors
  static const secondaryColor = 0xFFF43F5E;
  static const secondaryLight = 0xFFF87B96;
  static const secondaryDark = 0xFFE11D48;

  // Neutral colors
  static const backgroundColor = 0xFFF8FAFC;
  static const surfaceColor = 0xFFFFFFFF;
  static const cardColor = 0xFFFFFFFF;
  static const dividerColor = 0xFFE2E8F0;

  // Text colors
  static const textPrimary = 0xFF1E293B;
  static const textSecondary = 0xFF64748B;
  static const textDisabled = 0xFF94A3B8;

  // Status colors
  static const successColor = 0xFF10B981;
  static const warningColor = 0xFFF59E0B;
  static const errorColor = 0xFFEF4444;
  static const infoColor = 0xFF3B82F6;
}
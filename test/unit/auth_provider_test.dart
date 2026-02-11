import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:tryon/features/auth/providers/auth_provider.dart';
import 'package:tryon/shared/services/api_service.dart';

// Generate mocks
@GenerateMocks([ApiService])
import 'auth_provider_test.mocks.dart';

void main() {
  group('AuthProvider Tests', () {
    late AuthProvider authProvider;
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
      authProvider = AuthProvider();
    });

    test('initial state is not authenticated', () {
      expect(authProvider.isAuthenticated, false);
      expect(authProvider.userId, null);
      expect(authProvider.userEmail, null);
    });

    test('login with valid credentials sets authenticated state', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';

      // Act
      await authProvider.login(email, password);

      // Assert
      expect(authProvider.isAuthenticated, true);
      expect(authProvider.userEmail, email);
      expect(authProvider.userId, isNotNull);
      expect(authProvider.token, isNotNull);
    });

    test('register with valid data sets authenticated state', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      const name = 'Test User';

      // Act
      await authProvider.register(email, password, name);

      // Assert
      expect(authProvider.isAuthenticated, true);
      expect(authProvider.userEmail, email);
      expect(authProvider.userName, name);
      expect(authProvider.userId, isNotNull);
    });

    test('logout clears authenticated state', () async {
      // Arrange - first login
      await authProvider.login('test@example.com', 'password123');
      expect(authProvider.isAuthenticated, true);

      // Act
      await authProvider.logout();

      // Assert
      expect(authProvider.isAuthenticated, false);
      expect(authProvider.userId, null);
      expect(authProvider.userEmail, null);
      expect(authProvider.userName, null);
      expect(authProvider.token, null);
    });

    test('login with empty credentials throws exception', () async {
      // Act & Assert
      expect(
        () => authProvider.login('', ''),
        throwsException,
      );
    });

    test('register with invalid email throws exception', () async {
      // Act & Assert
      expect(
        () => authProvider.register('invalid-email', 'password123', 'Test User'),
        throwsException,
      );
    });
  });
}
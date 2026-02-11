import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tryon/main.dart' as app;
import 'package:tryon/shared/services/storage_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    setUpAll(() async {
      // Initialize services for testing
      await StorageService().initialize();
    });

    testWidgets('App starts and shows splash screen', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify splash screen is shown
      expect(find.text('Virtual Try-On'), findsOneWidget);
      expect(find.text('Your Digital Wardrobe'), findsOneWidget);
      
      // Wait for navigation to login screen
      await tester.pumpAndSettle(const Duration(seconds: 4));
      
      // Verify we're on login screen
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
    });

    testWidgets('User can navigate through login flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Find email field and enter email
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');

      // Find password field and enter password
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, 'password123');

      // Tap sign in button
      final signInButton = find.text('Sign In');
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      // Verify we navigate to home screen
      expect(find.text('Virtual Try-On'), findsOneWidget);
      expect(find.text('Welcome Back!'), findsOneWidget);
    });

    testWidgets('Bottom navigation works correctly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Login first
      await _performLogin(tester);

      // Test navigation to clothing screen
      final clothingTab = find.text('Clothing');
      await tester.tap(clothingTab);
      await tester.pumpAndSettle();
      expect(find.text('Clothing'), findsWidgets);

      // Test navigation to try-on screen
      final tryOnTab = find.text('Try On');
      await tester.tap(tryOnTab);
      await tester.pumpAndSettle();
      expect(find.text('Virtual Try-On'), findsOneWidget);

      // Test navigation to favorites screen
      final favoritesTab = find.text('Favorites');
      await tester.tap(favoritesTab);
      await tester.pumpAndSettle();
      expect(find.text('Favorites'), findsOneWidget);

      // Test navigation to profile screen
      final profileTab = find.text('Profile');
      await tester.tap(profileTab);
      await tester.pumpAndSettle();
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Try-on flow works correctly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Login first
      await _performLogin(tester);

      // Navigate to try-on screen
      final tryOnTab = find.text('Try On');
      await tester.tap(tryOnTab);
      await tester.pumpAndSettle();

      // Verify try-on screen elements
      expect(find.text('How it works'), findsOneWidget);
      expect(find.text('Your Photo'), findsOneWidget);
      expect(find.text('Select Clothing'), findsOneWidget);

      // Verify start button is disabled initially
      final startButton = find.text('Start Virtual Try-On');
      expect(tester.widget<ElevatedButton>(startButton).onPressed, isNull);
    });

    testWidgets('Profile screen displays user information', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Login first
      await _performLogin(tester);

      // Navigate to profile screen
      final profileTab = find.text('Profile');
      await tester.tap(profileTab);
      await tester.pumpAndSettle();

      // Verify profile elements
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Body Measurements'), findsOneWidget);
      expect(find.text('Preferences'), findsOneWidget);
      expect(find.text('Try-On History'), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);
    });

    testWidgets('Clothing list loads and displays items', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Login first
      await _performLogin(tester);

      // Navigate to clothing screen
      final clothingTab = find.text('Clothing');
      await tester.tap(clothingTab);
      await tester.pumpAndSettle();

      // Wait for clothing items to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify search bar is present
      expect(find.byType(TextField), findsOneWidget);
      
      // Verify category filter is present
      expect(find.text('All'), findsOneWidget);
    });

    testWidgets('App handles network errors gracefully', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Login with invalid credentials should show error
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalid@example.com');

      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, 'wrongpassword');

      final signInButton = find.text('Sign In');
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      // Should show error message or remain on login screen
      expect(find.text('Welcome Back'), findsOneWidget);
    });
  });
}

// Helper function to perform login
Future<void> _performLogin(WidgetTester tester) async {
  final emailField = find.byType(TextFormField).first;
  await tester.enterText(emailField, 'test@example.com');

  final passwordField = find.byType(TextFormField).last;
  await tester.enterText(passwordField, 'password123');

  final signInButton = find.text('Sign In');
  await tester.tap(signInButton);
  await tester.pumpAndSettle();
}
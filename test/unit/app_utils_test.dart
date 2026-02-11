import 'package:flutter_test/flutter_test.dart';
import 'package:tryon/shared/utils/app_utils.dart';

void main() {
  group('AppUtils Tests', () {
    test('formatDateTime returns correct relative time', () {
      final now = DateTime.now();
      
      // Just now
      expect(AppUtils.formatDateTime(now), 'Just now');
      
      // Minutes ago
      final minutesAgo = now.subtract(const Duration(minutes: 5));
      expect(AppUtils.formatDateTime(minutesAgo), '5m ago');
      
      // Hours ago
      final hoursAgo = now.subtract(const Duration(hours: 2));
      expect(AppUtils.formatDateTime(hoursAgo), '2h ago');
      
      // Yesterday
      final yesterday = now.subtract(const Duration(days: 1));
      expect(AppUtils.formatDateTime(yesterday), 'Yesterday');
      
      // Days ago
      final daysAgo = now.subtract(const Duration(days: 3));
      expect(AppUtils.formatDateTime(daysAgo), '3 days ago');
    });

    test('formatFileSize returns correct format', () {
      expect(AppUtils.formatFileSize(512), '512 B');
      expect(AppUtils.formatFileSize(1024), '1.0 KB');
      expect(AppUtils.formatFileSize(1048576), '1.0 MB');
      expect(AppUtils.formatFileSize(1073741824), '1.0 GB');
    });

    test('isValidEmail validates email correctly', () {
      expect(AppUtils.isValidEmail('test@example.com'), true);
      expect(AppUtils.isValidEmail('user.name@domain.co.uk'), true);
      expect(AppUtils.isValidEmail('invalid-email'), false);
      expect(AppUtils.isValidEmail('test@'), false);
      expect(AppUtils.isValidEmail('@domain.com'), false);
    });

    test('getPasswordStrength returns correct strength', () {
      expect(AppUtils.getPasswordStrength('123'), PasswordStrength.weak);
      expect(AppUtils.getPasswordStrength('password'), PasswordStrength.weak);
      expect(AppUtils.getPasswordStrength('Password123'), PasswordStrength.medium);
      expect(AppUtils.getPasswordStrength('Password123!@#'), PasswordStrength.strong);
      expect(AppUtils.getPasswordStrength('VeryStrongPassword123!@#$'), PasswordStrength.strong);
    });

    test('capitalize returns correctly capitalized string', () {
      expect(AppUtils.capitalize('hello'), 'Hello');
      expect(AppUtils.capitalize('HELLO'), 'HELLO');
      expect(AppUtils.capitalize('h'), 'H');
      expect(AppUtils.capitalize(''), '');
    });

    test('generateRandomString returns string of correct length', () {
      expect(AppUtils.generateRandomString(10).length, 10);
      expect(AppUtils.generateRandomString(5).length, 5);
      expect(AppUtils.generateRandomString(0).length, 0);
    });

    test('getPermissionStatusText returns correct text', () {
      expect(AppUtils().getPermissionStatusText(PermissionStatus.granted), 'Granted');
      expect(AppUtils().getPermissionStatusText(PermissionStatus.denied), 'Denied');
      expect(AppUtils().getPermissionStatusText(PermissionStatus.restricted), 'Restricted');
      expect(AppUtils().getPermissionStatusText(PermissionStatus.limited), 'Limited');
      expect(AppUtils().getPermissionStatusText(PermissionStatus.permanentlyDenied), 'Permanently Denied');
    });
  });
}